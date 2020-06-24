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
    id: i32,
    author_id: Option<i32>,
    created_utc: i32,
    parent_submission: Option<i32>,
    is_banned: Option<bool>,
    body: Option<String>,
    parent_fullname: Option<String>,
    body_html: Option<String>,
    distinguish_level: Option<i32>,
    edited_utc: Option<i32>,
    is_deleted: bool,
    is_approved: i32,
    author_name: Option<String>,
    approved_utc: Option<i32>,
    ban_reason: Option<String>,
    creation_ip: String,
    score_disputed: Option<f64>,
    score_hot: Option<f64>,
    score_top: Option<i32>,
    level: Option<i32>,
    parent_comment_id: Option<i32>,
    title_id: Option<i32>,
    over_18: Option<bool>,
    is_op: Option<bool>,
    is_offensive: Option<bool>,
    is_nsfl: Option<bool>,
}

impl CommentResponse {
    fn from(comment: ruqqus_core::models::Comment) -> CommentResponse {
        CommentResponse {
            id: comment.id,
            author_id: comment.author_id,
            created_utc: comment.id,
            parent_submission: comment.parent_submission,
            is_banned: comment.is_banned,
            body: comment.body,
            parent_fullname: comment.parent_fullname,
            body_html: comment.body_html,
            distinguish_level: comment.distinguish_level,
            edited_utc: comment.edited_utc,
            is_deleted: comment.is_deleted,
            is_approved: comment.is_approved,
            author_name: comment.author_name,
            approved_utc: comment.approved_utc,
            ban_reason: comment.ban_reason,
            creation_ip: comment.creation_ip,
            score_disputed: comment.score_disputed,
            score_hot: comment.score_hot,
            score_top: comment.score_top,
            level: comment.level,
            parent_comment_id: comment.parent_comment_id,
            title_id: comment.title_id,
            over_18: comment.over_18,
            is_op: comment.is_op,
            is_offensive: comment.is_offensive,
            is_nsfl: comment.is_nsfl,
        }
    }
}

#[get("/api/v1/comment/{cid}")]
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
