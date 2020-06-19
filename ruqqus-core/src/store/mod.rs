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
pub struct User {
    pub id: i32
}

impl PostgresDecoder for User {

    fn decode(row: postgres::Row) -> Self {
        let id: i32 = row.get(0);
        User {
            id
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