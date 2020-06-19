use actix_web as aweb;
use actix_web::{delete, get, post, put, web, HttpResponse};
use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

use crate::error::ResponseError;
use crate::routes::UserParam;
use crate::Data;

#[derive(Debug, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct UserResponse {
    id: i32
}

impl UserResponse {
    fn from(user: ruqqus_core::User) -> UserResponse {
        UserResponse {
            id: user.id
        }
    }
}

#[get("/api/v1/user/{username}")]
pub async fn user_info(
    data: web::Data<Data>, 
    req: web::HttpRequest,
    path: web::Path<UserParam>,
) -> aweb::Result<HttpResponse> {

    let user = web::block({
        move || data.db.get_user(&path.user_name)
    })
    .await
    .map_err(|err| ResponseError::Internal(err.to_string()))?;

    Ok(HttpResponse::Ok().json(UserResponse::from(user)))
}
