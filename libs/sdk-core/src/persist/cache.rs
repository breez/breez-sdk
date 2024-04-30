use crate::{models::NodeState, LspInformation};

use super::{db::SqliteStorage, error::PersistResult};

const KEY_GL_CREDENTIALS: &str = "gl_credentials";
const KEY_LAST_BACKUP_TIME: &str = "last_backup_time";
const KEY_LAST_SYNC_TIME: &str = "last_sync_time";
const KEY_LSP_INFORMATION: &str = "lsp_information";
const KEY_NODE_STATE: &str = "node_state";
const KEY_STATIC_BACKUP: &str = "static_backup";
const KEY_WEBHOOK_URL: &str = "webhook_url";
const KEY_MEMPOOLSPACE_BASE_URLS: &str = "mempoolspace_base_urls";

impl SqliteStorage {
    pub fn get_cached_item(&self, key: &str) -> PersistResult<Option<String>> {
        let res = self.get_connection()?.query_row(
            "SELECT value FROM cached_items WHERE key = ?1",
            [key],
            |row| row.get(0),
        );
        Ok(res.ok())
    }

    pub fn update_cached_item(&self, key: &str, value: String) -> PersistResult<()> {
        self.get_connection()?.execute(
            "INSERT OR REPLACE INTO cached_items (key, value) VALUES (?1,?2)",
            (key, value),
        )?;
        Ok(())
    }

    #[allow(dead_code)]
    pub fn delete_cached_item(&self, key: &str) -> PersistResult<()> {
        self.get_connection()?
            .execute("DELETE FROM cached_items WHERE key = ?1", [key])?;
        Ok(())
    }

    pub fn set_node_state(&self, state: &NodeState) -> PersistResult<()> {
        let serialized_state = serde_json::to_string(state)?;
        self.update_cached_item(KEY_NODE_STATE, serialized_state)
    }

    pub fn get_node_state(&self) -> PersistResult<Option<NodeState>> {
        let state_str = self.get_cached_item(KEY_NODE_STATE)?;
        Ok(match state_str {
            Some(str) => serde_json::from_str(str.as_str())?,
            None => None,
        })
    }

    pub fn remove_lsp_information(&self) -> PersistResult<()> {
        self.delete_cached_item(KEY_LSP_INFORMATION)
    }

    pub fn set_lsp_information(&self, lsp_info: &LspInformation) -> PersistResult<()> {
        let serialized_lsp_info = serde_json::to_string(lsp_info)?;
        self.update_cached_item(KEY_LSP_INFORMATION, serialized_lsp_info)
    }

    pub fn get_lsp_information(&self) -> PersistResult<Option<LspInformation>> {
        let lsp_info_str = self.get_cached_item(KEY_LSP_INFORMATION)?;
        Ok(match lsp_info_str {
            Some(str) => serde_json::from_str(str.as_str())?,
            None => None,
        })
    }

    pub fn set_last_backup_time(&self, t: u64) -> PersistResult<()> {
        self.update_cached_item(KEY_LAST_BACKUP_TIME, t.to_string())
    }

    pub fn get_last_backup_time(&self) -> PersistResult<Option<u64>> {
        let state_str = self.get_cached_item(KEY_LAST_BACKUP_TIME)?;
        Ok(match state_str {
            Some(str) => str.as_str().parse::<u64>().ok(),
            None => None,
        })
    }

    pub fn set_last_sync_time(&self, t: u64) -> PersistResult<()> {
        self.update_cached_item(KEY_LAST_SYNC_TIME, t.to_string())
    }

    pub fn get_last_sync_time(&self) -> PersistResult<Option<u64>> {
        let state_str = self.get_cached_item(KEY_LAST_SYNC_TIME)?;
        Ok(match state_str {
            Some(str) => str.as_str().parse::<u64>().ok(),
            None => None,
        })
    }

    pub fn set_gl_credentials(&self, creds: Vec<u8>) -> PersistResult<()> {
        self.update_cached_item(KEY_GL_CREDENTIALS, hex::encode(creds))
    }

    pub fn get_gl_credentials(&self) -> PersistResult<Option<Vec<u8>>> {
        match self.get_cached_item(KEY_GL_CREDENTIALS)? {
            Some(str) => Ok(Some(hex::decode(str)?)),
            None => Ok(None),
        }
    }

    pub fn set_static_backup(&self, backup: Vec<String>) -> PersistResult<()> {
        let serialized_state = serde_json::to_string(&backup)?;
        self.update_cached_item(KEY_STATIC_BACKUP, serialized_state)
    }

    pub fn get_static_backup(&self) -> PersistResult<Option<Vec<String>>> {
        let backup_str = self.get_cached_item(KEY_STATIC_BACKUP)?;
        Ok(match backup_str {
            Some(str) => serde_json::from_str(str.as_str())?,
            None => None,
        })
    }

    pub fn set_webhook_url(&self, webhook_url: String) -> PersistResult<()> {
        self.update_cached_item(KEY_WEBHOOK_URL, webhook_url)
    }

    #[allow(dead_code)]
    pub fn remove_webhook_url(&self) -> PersistResult<()> {
        self.delete_cached_item(KEY_WEBHOOK_URL)
    }

    #[allow(dead_code)]
    pub fn get_webhook_url(&self) -> PersistResult<Option<String>> {
        self.get_cached_item(KEY_WEBHOOK_URL)
    }

    pub fn set_mempoolspace_base_urls(
        &self,
        mempool_space_endpoints: Vec<String>,
    ) -> PersistResult<()> {
        let serialized = serde_json::to_string(&mempool_space_endpoints)?;
        self.update_cached_item(KEY_MEMPOOLSPACE_BASE_URLS, serialized)
    }

    pub fn get_mempoolspace_base_urls(&self) -> PersistResult<Vec<String>> {
        let res = match self.get_cached_item(KEY_MEMPOOLSPACE_BASE_URLS)? {
            Some(str) => serde_json::from_str(str.as_str())?,
            None => vec![],
        };

        Ok(res)
    }
}

#[test]
fn test_cached_items() {
    use crate::persist::test_utils;

    let storage = SqliteStorage::new(test_utils::create_test_sql_dir());

    storage.init().unwrap();
    storage
        .update_cached_item("key1", "val1".to_string())
        .unwrap();
    let item_value = storage.get_cached_item("key1").unwrap();
    assert_eq!(item_value, Some("val1".to_string()));

    storage.delete_cached_item("key1").unwrap();
    let item_value = storage.get_cached_item("key1").unwrap();
    assert_eq!(item_value, None);
}
