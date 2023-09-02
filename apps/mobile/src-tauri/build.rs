fn main() {
    /*if let Err(error) = tauri_build::mobile::PluginBuilder::new()
        //.android_path("android")
        .ios_path("ios")
        .run()
    {
        use std::process::exit;
        println!("{error:#}");
        exit(1);
    }*/

    tauri_build::build()
}
