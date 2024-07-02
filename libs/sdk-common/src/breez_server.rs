use anyhow::Result;
use log::trace;
use tonic::codegen::InterceptedService;
use tonic::metadata::errors::InvalidMetadataValue;
use tonic::metadata::{Ascii, MetadataValue};
use tonic::service::Interceptor;
use tonic::transport::{Channel, Endpoint};
use tonic::{Request, Status};

use crate::grpc::channel_opener_client::ChannelOpenerClient;
use crate::grpc::information_client::InformationClient;
use crate::grpc::payment_notifier_client::PaymentNotifierClient;
use crate::grpc::signer_client::SignerClient;
use crate::grpc::support_client::SupportClient;
use crate::grpc::swapper_client::SwapperClient;
use crate::grpc::{ChainApiServersRequest, PingRequest};
use crate::prelude::{ServiceConnectivityError, ServiceConnectivityErrorKind};

pub static PRODUCTION_BREEZSERVER_URL: &str = "https://bs1.breez.technology:443";
pub static STAGING_BREEZSERVER_URL: &str = "https://bs1-st.breez.technology:443";

pub struct BreezServer {
    grpc_channel: Channel,
    api_key: Option<String>,
}

impl BreezServer {
    pub fn new(server_url: String, api_key: Option<String>) -> Result<Self> {
        Ok(Self {
            grpc_channel: Endpoint::from_shared(server_url)?.connect_lazy(),
            api_key,
        })
    }

    fn api_key_metadata(&self) -> Result<Option<MetadataValue<Ascii>>, ServiceConnectivityError> {
        match &self.api_key {
            Some(key) => Ok(Some(format!("Bearer {key}").parse().map_err(
                |e: InvalidMetadataValue| {
                    ServiceConnectivityError::new(
                        ServiceConnectivityErrorKind::Other,
                        format!("(Breez: {:?}) Failed parse API key: {e}", self.api_key),
                    )
                },
            )?)),
            _ => Ok(None),
        }
    }

    pub async fn get_channel_opener_client(
        &self,
    ) -> Result<
        ChannelOpenerClient<InterceptedService<Channel, ApiKeyInterceptor>>,
        ServiceConnectivityError,
    > {
        let api_key_metadata = self.api_key_metadata()?;
        let with_interceptor = ChannelOpenerClient::with_interceptor(
            self.grpc_channel.clone(),
            ApiKeyInterceptor { api_key_metadata },
        );
        Ok(with_interceptor)
    }

    pub async fn get_payment_notifier_client(&self) -> PaymentNotifierClient<Channel> {
        PaymentNotifierClient::new(self.grpc_channel.clone())
    }

    pub async fn get_information_client(&self) -> InformationClient<Channel> {
        InformationClient::new(self.grpc_channel.clone())
    }

    pub async fn get_signer_client(&self) -> SignerClient<Channel> {
        SignerClient::new(self.grpc_channel.clone())
    }

    pub async fn get_support_client(
        &self,
    ) -> Result<
        SupportClient<InterceptedService<Channel, ApiKeyInterceptor>>,
        ServiceConnectivityError,
    > {
        let api_key_metadata = self.api_key_metadata()?;
        Ok(SupportClient::with_interceptor(
            self.grpc_channel.clone(),
            ApiKeyInterceptor { api_key_metadata },
        ))
    }

    pub async fn get_swapper_client(&self) -> SwapperClient<Channel> {
        SwapperClient::new(self.grpc_channel.clone())
    }

    pub async fn ping(&self) -> Result<String> {
        let request = Request::new(PingRequest {});
        let response = self
            .get_information_client()
            .await
            .ping(request)
            .await?
            .into_inner()
            .version;
        Ok(response)
    }

    pub async fn fetch_mempoolspace_urls(&self) -> Result<Vec<String>, ServiceConnectivityError> {
        let mut client = self.get_information_client().await;

        let chain_api_servers = client
            .chain_api_servers(ChainApiServersRequest {})
            .await
            .map_err(|e| {
                ServiceConnectivityError::new(
                    ServiceConnectivityErrorKind::Other,
                    format!("(Breez: {e:?}) Failed to fetch ChainApiServers"),
                )
            })?
            .into_inner()
            .servers;
        trace!("Received chain_api_servers: {chain_api_servers:?}");

        let mempoolspace_urls = chain_api_servers
            .iter()
            .filter(|s| s.server_type == "MEMPOOL_SPACE")
            .map(|s| s.server_base_url.clone())
            .collect();
        trace!("Received mempoolspace_urls: {mempoolspace_urls:?}");

        Ok(mempoolspace_urls)
    }

    pub async fn fetch_boltz_swapper_urls(&self) -> Result<Vec<String>, ServiceConnectivityError> {
        let mut client = self.get_information_client().await;

        let chain_api_servers = client
            .chain_api_servers(ChainApiServersRequest {})
            .await
            .map_err(|e| {
                ServiceConnectivityError::new(
                    ServiceConnectivityErrorKind::Other,
                    format!("(Breez: {e:?}) Failed to fetch ChainApiServers"),
                )
            })?
            .into_inner()
            .servers;
        trace!("Received chain_api_servers: {chain_api_servers:?}");

        let boltz_swapper_urls = chain_api_servers
            .iter()
            .filter(|s| s.server_type == "BOLTZ_SWAPPER")
            .map(|s| s.server_base_url.clone())
            .collect();
        trace!("Received boltz_swapper_urls: {boltz_swapper_urls:?}");

        Ok(boltz_swapper_urls)
    }
}

pub struct ApiKeyInterceptor {
    api_key_metadata: Option<MetadataValue<Ascii>>,
}

impl Interceptor for ApiKeyInterceptor {
    fn call(&mut self, mut req: Request<()>) -> Result<Request<()>, Status> {
        if self.api_key_metadata.clone().is_some() {
            req.metadata_mut()
                .insert("authorization", self.api_key_metadata.clone().unwrap());
        }
        Ok(req)
    }
}
