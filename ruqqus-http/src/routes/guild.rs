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
    id: i32
}

impl GuildResponse {
    fn from(user: ruqqus_core::models::Board) -> GuildResponse {
        GuildResponse {
            id: user.id
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
        move || data.db.get_board(&path.board_name)
    })
    .await
    .map_err(|err| ResponseError::Internal(err.to_string()))?;

    Ok(HttpResponse::Ok().json(GuildResponse::from(guild)))
}
