#![allow(clippy::or_fun_call)]

pub mod data;
pub mod error;
pub mod option;
pub mod routes;

pub use self::data::Data;
use actix_http::Error;
use actix_service::ServiceFactory;
use actix_web::{dev, web, App};

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
    App::new()
        .app_data(web::Data::new(data.clone()))
        .app_data(web::JsonConfig::default().limit(1024 * 1024 * 10)) // Json Limit of 10Mb
        .service(routes::post::post_info)

}