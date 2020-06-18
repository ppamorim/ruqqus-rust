use actix_web as aweb;
use actix_web::{delete, get, post, put, web, HttpResponse};
use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

use crate::error::ResponseError;
use crate::routes::PostParam;
use crate::Data;

#[derive(Debug, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct PostResponse {
    id: i32
}

impl PostResponse {
    fn from(post: ruqqus_core::Post) -> PostResponse {
        PostResponse {
            id: post.id
        }
    }
}

#[get("/api/v1/post/{pid}")]
pub async fn post_info(
    data: web::Data<Data>, 
    req: web::HttpRequest,
    path: web::Path<PostParam>,
) -> aweb::Result<HttpResponse> {

    let post = web::block({
        move || data.db.find_post(path.pid)
    })
    .await
    .map_err(|err| ResponseError::Internal(err.to_string()))?;

    Ok(HttpResponse::Ok().json(PostResponse::from(post)))
}
