// use crate::schema::users;
use crate::schema::votes;
use diesel::prelude::*;

// #[derive(Queryable)]
pub struct User {
    pub id: i32,
    pub username: String,
    pub email: Option<String>,
    pub passhash: String,
    pub created_utc: i32,
    pub admin_level: Option<i32>,
    pub over_18: Option<bool>,
    pub creation_ip: Option<String>,
    pub hide_offensive: Option<bool>,
    pub is_activated: Option<bool>,
}

// impl PostgresDecoder for User {
//     fn decode(row: postgres::Row) -> Self {
//         let id: i32 = row.get(0);
//         let username: String = row.get(1);
//         let email: String = row.get(2);
//         let passhash: String = row.get(3);
//         let created_utc: i32 = row.get(4);
//         User {
//             id,
//             username,
//             email,
//             passhash,
//             created_utc,
//         }
//     }
// }

#[derive(Queryable)]
pub struct Vote {
    pub id: i32,
    pub user_id: i32,
    pub submission_id: Option<i32>,
    pub created_utc: i32,
    pub vote_type: Option<i32>,
}