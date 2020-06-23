use crate::schema::users;
use diesel::prelude::*;

#[derive(Queryable)]
pub struct User {
    pub id: i32,
    pub username: String,
    pub email: String,
    pub passhash: String,
    pub created_utc: i32,
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