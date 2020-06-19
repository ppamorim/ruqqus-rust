use actix_web as aweb;
use actix_web::{delete, get, post, put, web, HttpResponse};
use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

use crate::error::ResponseError;
use crate::routes::CommentParam;
use crate::Data;

#[derive(Debug, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct CommentResponse {
    cid: i32
}

impl CommentResponse {
    fn from(comment: ruqqus_core::Comment) -> CommentResponse {
        CommentResponse {
            cid: comment.cid
        }
    }
}

#[get("/api/v1/comment{cid}")]
pub async fn comment_info(
    data: web::Data<Data>, 
    req: web::HttpRequest,
    path: web::Path<CommentParam>,
) -> aweb::Result<HttpResponse> {

    let comment = web::block({
        move || data.db.get_comment(path.cid)
    })
    .await
    .map_err(|err| ResponseError::Internal(err.to_string()))?;

    Ok(HttpResponse::Ok().json(CommentResponse::from(comment)))
}
