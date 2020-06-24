use actix_web as aweb;
use actix_web::{delete, get, post, put, web, HttpResponse};
use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

use crate::error::ResponseError;
use crate::routes::PostParam;
use crate::routes::SearchQuery;
use crate::Data;

#[get("/api/v1/post/{pid}")]
pub async fn post_info(
    data: web::Data<Data>,
    path: web::Path<PostParam>,
) -> aweb::Result<HttpResponse> {

    let post = web::block({
        move || data.db.get_post(path.pid)
    })
    .await
    .map_err(|err| ResponseError::Internal(err.to_string()))?;

    Ok(HttpResponse::Ok().json(PostResponse::from(post)))
}

#[get("/api/v1/posts")]
pub async fn posts_info(
    data: web::Data<Data>,
    params: web::Query<SearchQuery>,
) -> aweb::Result<HttpResponse> {

    let posts = web::block({
        move || data.db.get_posts(0, params.offset, params.limit)
    })
    .await
    .map_err(|err| ResponseError::Internal(err.to_string()))?;

    Ok(HttpResponse::Ok().json(PostResponse::from_vec(posts)))
}

#[derive(Debug, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct PostResponse {
    id: i32,
    author_id: Option<i32>,
    title: String,
    url: Option<String>,
    created_utc: i32,
    is_banned: Option<bool>,
    over_18: Option<bool>,
    distinguish_level: Option<i32>,
    created_str: Option<String>,
    stickied: Option<bool>,
    body: Option<String>,
    body_html: Option<String>,
    board_id: Option<i32>,
    embed_url: Option<String>,
    is_deleted: bool,
    domain_ref: Option<i32>,
    is_approved: i32,
    author_name: Option<String>,
    approved_utc: Option<i32>,
    original_board_id: Option<i32>,
    edited_utc: Option<i32>,
    ban_reason: Option<String>,
    creation_ip: String,
    mod_approved: Option<i32>,
    is_image: Option<bool>,
    has_thumb: Option<bool>,
    accepted_utc: Option<i32>,
    post_public: Option<bool>,
    score_hot: Option<f64>,
    score_top: Option<i32>,
    score_activity: Option<f64>,
    score_disputed: Option<f64>,
    guild_name: Option<String>,
    is_offensive: Option<bool>,
    is_pinned: Option<bool>,
    is_nsfl: Option<bool>,
    repost_id: Option<i32>,
}

impl PostResponse {
    fn from(submission: ruqqus_core::models::Submission) -> PostResponse {
        PostResponse {
            id: submission.id,
            author_id: submission.author_id,
            title: submission.title,
            url: submission.url,
            created_utc: submission.created_utc,
            is_banned: submission.is_banned,
            over_18: submission.over_18,
            distinguish_level: submission.distinguish_level,
            created_str: submission.created_str,
            stickied: submission.stickied,
            body: submission.body,
            body_html: submission.body_html,
            board_id: submission.board_id,
            embed_url: submission.embed_url,
            is_deleted: submission.is_deleted,
            domain_ref: submission.domain_ref,
            is_approved: submission.is_approved,
            author_name: submission.author_name,
            approved_utc: submission.approved_utc,
            original_board_id: submission.original_board_id,
            edited_utc: submission.edited_utc,
            ban_reason: submission.ban_reason,
            creation_ip: submission.creation_ip,
            mod_approved: submission.mod_approved,
            is_image: submission.is_image,
            has_thumb: submission.has_thumb,
            accepted_utc: submission.accepted_utc,
            post_public: submission.post_public,
            score_hot: submission.score_hot,
            score_top: submission.score_top,
            score_activity: submission.score_activity,
            score_disputed: submission.score_disputed,
            guild_name: submission.guild_name,
            is_offensive: submission.is_offensive,
            is_pinned: submission.is_pinned,
            is_nsfl: submission.is_nsfl,
            repost_id: submission.repost_id,
        }
    }

    fn from_vec(submissions: Vec<ruqqus_core::models::Submission>) -> Vec<PostResponse> {
        submissions.into_iter().map(|row| {
            Self::from(row)
        }).collect()
    }

}
