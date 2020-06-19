use std::thread;
use log::info;

use postgres::{NoTls};
use r2d2_postgres::PostgresConnectionManager;
use uuid::Uuid;

use crate::{store, MResult, Error};
use crate::{Guild, User, Post, Comment};

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

    pub fn get_guild(&self, board_name: &str) -> MResult<Guild> {
        let mut conn = self.pool.get().unwrap();
        print!("get_guild, board_name: {}", board_name);
        let sql = "SELECT * FROM guild WHERE board_name = $1;";
        store::get(&mut conn, sql, &[&board_name])
    }

    pub fn get_user(&self, user_name: &str) -> MResult<User> {
        let mut conn = self.pool.get().unwrap();
        print!("get_user, user_name: {}", user_name);
        let sql = "SELECT * FROM user WHERE username = $1;";
        store::get(&mut conn, sql, &[&user_name])
    }

    pub fn get_post(&self, pid: i32) -> MResult<Post> {
        let mut conn = self.pool.get().unwrap();
        print!("get_post, pid: {}", pid);
        let sql = "SELECT * FROM post WHERE pid = $1;";
        store::get(&mut conn, sql, &[&pid])
    }

    pub fn get_comment(&self, cid: i32) -> MResult<Comment> {
        let mut conn = self.pool.get().unwrap();
        print!("get_post, cid: {}", cid);
        let sql = "SELECT * FROM comment WHERE cid = $1;";
        store::get(&mut conn, sql, &[&cid])
    }

}