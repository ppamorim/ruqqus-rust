use chrono::{DateTime, Utc};
use postgres::NoTls;
use r2d2_postgres::PostgresConnectionManager;
use postgres::types::ToSql;
use uuid::Uuid;

use crate::{MResult, Error};

pub trait PostgresDecoder {
    fn decode(row: postgres::Row) -> Self;
    fn decode_vec(rows: Vec<postgres::Row>) -> Vec<Self> where Self: std::marker::Sized {
        rows.into_iter().map(|row| {
            Self::decode(row)
        }).collect()
    }
}

#[derive(Clone)]
pub struct Guild {
    pub id: i32
}

impl PostgresDecoder for Guild {
    fn decode(row: postgres::Row) -> Self {
        let id: i32 = row.get(0);
        Guild {
            id
        }
    }
}

#[derive(Clone)]
pub struct User {
    pub id: i32,
    pub username: String,
    pub email: String,
    pub passhash: String,
    pub created_utc: i32,
}

impl PostgresDecoder for User {
    fn decode(row: postgres::Row) -> Self {
        let id: i32 = row.get(0);
        let username: String = row.get(1);
        let email: String = row.get(2);
        let passhash: String = row.get(3);
        let created_utc: i32 = row.get(4);
        User {
            id,
            username,
            email,
            passhash,
            created_utc,
        }
    }
}

#[derive(Clone)]
pub struct Post {
    pub id: i32
}

impl PostgresDecoder for Post {
    fn decode(row: postgres::Row) -> Self {
        let id: i32 = row.get(0);
        Post {
            id
        }
    }
}


#[derive(Clone)]
pub struct Comment {
    pub id: i32,
    pub author_id: i32,
    pub body: String,
    pub parent_submission: i32, //Column(Integer, ForeignKey("submissions.id"))
    pub parent_fullname: i32,
    pub created_utc: i32,
    pub edited_utc: i32,
    pub is_banned: bool,
    // pub body_html = Column(String(20000))
    // pub distinguish_level=Column(Integer, default=0)
    // pub is_deleted = Column(Boolean, default=False)
    // pub is_approved = Column(Integer, default=0)
    // pub approved_utc=Column(Integer, default=0)
    // pub ban_reason=Column(String(256), default='')
    // pub creation_ip=Column(String(64), default='')
    // pub score_disputed=Column(Float, default=0)
    // pub score_hot=Column(Float, default=0)
    // pub score_top=Column(Integer, default=1)
    // pub level=Column(Integer, default=0)
    // pub parent_comment_id=Column(Integer, ForeignKey("comments.id"))
    // pub author_name=Column(String(64), default="")
    // pub id: i32,
}

impl PostgresDecoder for Comment {
    fn decode(row: postgres::Row) -> Self {
        let id: i32 = row.get(0);
        let author_id: i32 = row.get(1);
        let body: String = row.get(2);
        let parent_submission: i32 = row.get(3);
        let parent_fullname: i32 = row.get(4);
        let created_utc: i32 = row.get(5);
        let edited_utc: i32 = row.get(6);
        let is_banned: bool = row.get(7);
        Comment {
            id,
            author_id,
            body,
            parent_submission,
            parent_fullname,
            created_utc,
            edited_utc,
            is_banned,
        }
    }
}

type Connection = r2d2::PooledConnection<PostgresConnectionManager<NoTls>>;
type ConnectionParams<'a,'b> = &'a[&'b(dyn ToSql + Sync)];

pub fn get<T: PostgresDecoder>(
    conn: &mut Connection,
    sql_str: &str,
    params: ConnectionParams,
) -> MResult<T> {
    let row = conn.query_one(sql_str, params)?;
    Ok(T::decode(row))
}