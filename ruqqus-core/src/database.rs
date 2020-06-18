use std::thread;
use log::info;

use postgres::{NoTls};
use r2d2_postgres::PostgresConnectionManager;
use uuid::Uuid;

use crate::{store, MResult, Error};
use crate::{Post};

pub struct Database {
    pool: r2d2::Pool<PostgresConnectionManager<NoTls>>,
}

impl Database {

    pub fn open_or_create(postgres_host: &str, postgres_user: &str) -> MResult<Database> {

        let mut postgres_config = postgres::Config::default();
        postgres_config.host(postgres_host);
        postgres_config.user(postgres_user);

        let manager = PostgresConnectionManager::new(postgres_config,  NoTls);
        let pool = r2d2::Pool::new(manager).unwrap();

        Ok(Database { 
            pool,
        })

    }

    pub fn find_post(&self, pid: i32) -> MResult<Post> {
        let mut conn = self.pool.get().unwrap();
        let sql = "SELECT id FROM post WHERE pid = $1;";
        store::get(&mut conn, sql, &[&pid])
    }

}