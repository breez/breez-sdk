use camino::Utf8Path;
use uniffi_bindgen_kotlin_multiplatform::KotlinBindingGenerator;

fn main() {
    uniffi::uniffi_bindgen_main();

    let udl_file = "./src/breez_sdk.udl";
    let out_dir = Utf8Path::new("ffi/kmm");
    let config = Utf8Path::new("uniffi.toml");
    uniffi_bindgen::generate_external_bindings(
        KotlinBindingGenerator {},
        udl_file,
        // None::<&Utf8Path>,
        Some(config),
        Some(out_dir),
        None::<&Utf8Path>,
        None,
    )
    .unwrap();
}
