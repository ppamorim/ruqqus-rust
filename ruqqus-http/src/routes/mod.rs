use actix_web::{get, web, HttpResponse};
use actix_http::http::header;
use serde::{Deserialize, Serialize};
use crate::error::ResponseError;

pub mod post;

#[derive(Default, Deserialize)]
pub struct PostParam {
    pid: i32,
}
