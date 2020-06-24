use actix_web::{get, web, HttpResponse};
use actix_http::http::header;
use serde::{Deserialize, Serialize};
use crate::error::ResponseError;

pub mod guild;
pub mod user;
pub mod post;
pub mod comment;

#[derive(Default, Deserialize)]
pub struct GuildParam {
    board_name: String,
}

#[derive(Default, Deserialize)]
pub struct UserParam {
    user_name: String,
}

#[derive(Default, Deserialize)]
pub struct PostParam {
    pid: i32,
}

#[derive(Default, Deserialize)]
pub struct CommentParam {
    cid: i32,
}

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "camelCase", deny_unknown_fields)]
pub struct SearchQuery {
    offset: i64,
    limit: i64,
}