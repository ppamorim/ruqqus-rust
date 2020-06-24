use chrono::{DateTime, Utc};
use postgres::NoTls;
use r2d2_postgres::PostgresConnectionManager;
use postgres::types::ToSql;
use uuid::Uuid;

use crate::{RResult, Error};

pub trait PostgresDecoder {
    fn decode(row: postgres::Row) -> Self;
    fn decode_vec(rows: Vec<postgres::Row>) -> Vec<Self> where Self: std::marker::Sized {
        rows.into_iter().map(|row| {
            Self::decode(row)
        }).collect()
    }
}

type Connection = r2d2::PooledConnection<PostgresConnectionManager<NoTls>>;
type ConnectionParams<'a,'b> = &'a[&'b(dyn ToSql + Sync)];

pub fn get<T: PostgresDecoder>(
    conn: &mut Connection,
    sql_str: &str,
    params: ConnectionParams,
) -> RResult<T> {
    let row = conn.query_one(sql_str, params)?;
    Ok(T::decode(row))
}