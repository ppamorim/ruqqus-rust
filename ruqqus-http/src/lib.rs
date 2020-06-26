#![allow(clippy::or_fun_call)]

pub mod data;
pub mod error;
pub mod option;
pub mod routes;

pub use self::data::Data;
use actix_http::Error;
use actix_service::ServiceFactory;
use actix_web::{dev, web, HttpResponse, App};
use actix_identity::Identity;
use actix_identity::{CookieIdentityPolicy, IdentityService};
use rand::Rng;

async fn index(id: Identity) -> String {
    format!(
        "Hello {}",
        id.identity().unwrap_or_else(|| "Anonymous".to_owned())
    )
}

async fn login(id: Identity) -> HttpResponse {
    id.remember("user1".to_owned());
    HttpResponse::Found().header("location", "/").finish()
}

async fn logout(id: Identity) -> HttpResponse {
    id.forget();
    HttpResponse::Found().header("location", "/").finish()
}

pub fn create_app(
    data: &Data,
) -> App<
    impl ServiceFactory<
        Config = (),
        Request = dev::ServiceRequest,
        Response = dev::ServiceResponse<actix_http::body::Body>,
        Error = Error,
        InitError = (),
    >,
    actix_http::body::Body,
> {
    let private_key = rand::thread_rng().gen::<[u8; 32]>();
    App::new()
        .wrap(IdentityService::new(
            CookieIdentityPolicy::new(&private_key)
                .name("auth-example")
                .secure(false),
        ))
        .app_data(web::Data::new(data.clone()))
        .app_data(web::JsonConfig::default().limit(1024 * 1024 * 10)) // Json Limit of 10Mb
        
        .service(web::resource("/login").route(web::post().to(login)))
        .service(web::resource("/logout").to(logout))
        .service(web::resource("/").route(web::get().to(index)))
        
        .service(routes::guild::guild_info)
        .service(routes::guild::guilds_info)
        .service(routes::user::user_info)
        .service(routes::post::post_info)
        .service(routes::post::posts_info)
        .service(routes::comment::comment_info)

}