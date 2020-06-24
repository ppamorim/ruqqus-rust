use actix_web as aweb;
use actix_web::{delete, get, post, put, web, HttpResponse};
use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

use crate::error::ResponseError;
use crate::routes::GuildParam;
use crate::Data;

#[derive(Debug, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct GuildResponse {
    id: i32,
    name: Option<String>,
    is_banned: Option<bool>,
    created_utc: Option<i32>,
    description: Option<String>,
    description_html: Option<String>,
    over_18: Option<bool>,
    creator_id: Option<i32>,
    has_banner: bool,
    has_profile: bool,
    ban_reason: Option<String>,
    color: Option<String>,
    downvotes_disabled: Option<bool>,
    restricted_posting: Option<bool>,
    hide_banner_data: Option<bool>,
    profile_nonce: i32,
    banner_nonce: i32,
    is_private: Option<bool>,
    color_nonce: Option<i32>,
    is_nsfl: Option<bool>,
}

impl GuildResponse {
    fn from(user: ruqqus_core::models::Board) -> GuildResponse {
        GuildResponse {
            id: user.id,
            name: user.name,
            is_banned: user.is_banned,
            created_utc: user.created_utc,
            description: user.description,
            description_html: user.description_html,
            over_18: user.over_18,
            creator_id: user.creator_id,
            has_banner: user.has_banner,
            has_profile: user.has_profile,
            ban_reason: user.ban_reason,
            color: user.color,
            downvotes_disabled: user.downvotes_disabled,
            restricted_posting: user.restricted_posting,
            hide_banner_data: user.hide_banner_data,
            profile_nonce: user.profile_nonce,
            banner_nonce: user.banner_nonce,
            is_private: user.is_private,
            color_nonce: user.color_nonce,
            is_nsfl: user.is_nsfl,
        }
    }
}

#[get("/api/v1/guild/{board_name}")]
pub async fn guild_info(
    data: web::Data<Data>, 
    req: web::HttpRequest,
    path: web::Path<GuildParam>,
) -> aweb::Result<HttpResponse> {

    let guild = web::block({
        move || data.db.get_guild(&path.board_name)
    })
    .await
    .map_err(|err| ResponseError::Internal(err.to_string()))?;

    Ok(HttpResponse::Ok().json(GuildResponse::from(guild)))
}
