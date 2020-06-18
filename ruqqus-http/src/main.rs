use std::{env, thread};

use actix_cors::Cors;
use actix_web::{middleware, HttpServer};
use log::info;
use main_error::MainError;
use ruqqus_http::data::Data;
use ruqqus_http::option::Opt;
use ruqqus_http::{create_app};
use structopt::StructOpt;

mod analytics;

#[cfg(target_os = "linux")]
#[global_allocator]
static ALLOC: jemallocator::Jemalloc = jemallocator::Jemalloc;

#[tokio::main]
async fn main() -> Result<(), MainError> {
    
    let opt = Opt::from_args();
    let local = tokio::task::LocalSet::new();
    let _sys = actix_rt::System::run_in_tokio("server", &local);

    match opt.env.as_ref() {
        "production" => {
            if opt.master_key.is_none() {
                return Err(
                    "In production mode, the environment variable RUQQUS_MASTER_KEY is mandatory"
                        .into(),
                );
            }
        }
        "development" => {
            env_logger::from_env(env_logger::Env::default().default_filter_or("info")).init();
        }
        _ => unreachable!(),
    }

    if !opt.no_analytics {
        thread::spawn(analytics::analytics_sender);
    }

    let data = Data::new(opt.clone());

    print_launch_resume(&opt, &data);

    HttpServer::new(move || {
        create_app(&data)
            .wrap(
                Cors::new()
                    .send_wildcard()
                    .allowed_header("x-ruqqus-api-key")
                    .finish(),
            )
            .wrap(middleware::Logger::default())
            .wrap(middleware::Compress::default())
    })
    .bind(opt.http_addr)?
    .run()
    .await?;

    Ok(())
}

pub fn print_launch_resume(opt: &Opt, data: &Data) {

    //http://patorjk.com/software/taag/#p=display&v=0&f=Colossal&t=Ruqqus
    let ascii_name = r#"
    8888888b.                                               
    888   Y88b                                              
    888    888                                              
    888   d88P 888  888  .d88888  .d88888 888  888 .d8888b  
    8888888P"  888  888 d88" 888 d88" 888 888  888 88K      
    888 T88b   888  888 888  888 888  888 888  888 "Y8888b. 
    888  T88b  Y88b 888 Y88b 888 Y88b 888 Y88b 888      X88 
    888   T88b  "Y88888  "Y88888  "Y88888  "Y88888  88888P' 
                            888      888                   
                            888      888                   
                            888      888                   
    "#;

    info!("{}", ascii_name);

    info!("Start server on: {:?}", opt.http_addr);
    info!("Environment: {:?}", opt.env);
    info!("Commit SHA: {:?}", env!("VERGEN_SHA").to_string());
    info!(
        "Build date: {:?}",
        env!("VERGEN_BUILD_TIMESTAMP").to_string()
    );
    info!(
        "Package version: {:?}",
        env!("CARGO_PKG_VERSION").to_string()
    );

    if let Some(master_key) = &data.api_keys.master {
        info!("Master Key: {:?}", master_key);

        if let Some(private_key) = &data.api_keys.private {
            info!("Private Key: {:?}", private_key);
        }

        if let Some(public_key) = &data.api_keys.public {
            info!("Public Key: {:?}", public_key);
        }
    } else {
        info!("No master key found; The server will have no securities.\
            If you need some protection in development mode, please export a key. export RUQQUS_MASTER_KEY=xxx");
    }

    info!("If you need extra information; Please refer to the documentation: XXXXX");
    info!("If you want to support us or help us; Please consult our Github repo: XXXXX");
    info!("If you want to contact us; Please chat with us on XXXXX or by email to XXXXX");
}
