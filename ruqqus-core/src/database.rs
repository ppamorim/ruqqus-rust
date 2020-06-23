use std::thread;
use log::info;

use postgres::{NoTls};
use r2d2_postgres::PostgresConnectionManager;
use uuid::Uuid;

use crate::{store, MResult, Error};
use crate::{Guild, Post, Comment};
use crate::models::User;
use crate::models::Vote;

use diesel::prelude::*;
use diesel::pg::PgConnection;
use dotenv::dotenv;
use std::env;
use diesel::r2d2::{ Pool, PooledConnection, ConnectionManager, PoolError };

pub struct Database {
    pool: r2d2::Pool<diesel::r2d2::ConnectionManager<PgConnection>>,
}

pub type PgPool = Pool<ConnectionManager<PgConnection>>;
pub type PgPooledConnection = PooledConnection<ConnectionManager<PgConnection>>;

fn init_pool(database_url: &str) -> Result<PgPool, PoolError> {
    let manager = ConnectionManager::<PgConnection>::new(database_url);
    Pool::builder().build(manager)
}

fn establish_connection() -> PgPool {
    dotenv().ok();

    let database_url = env::var("DATABASE_URL")
        .expect("DATABASE_URL must be set");
    init_pool(&database_url).expect("Failed to create pool")
}

impl Database {

    pub fn open_or_create(postgres_host: &str, postgres_user: &str) -> MResult<Database> {

        // let mut postgres_config = postgres::Config::default();
        // postgres_config.host(postgres_host);
        // postgres_config.user(postgres_user);

        // let manager = PostgresConnectionManager::new(postgres_config,  NoTls);
        // let pool = r2d2::Pool::new(manager).unwrap();
        let pool = establish_connection();

        Ok(Database { 
            pool,
        })

    }

    pub fn get_guild(&self, board_name: &str) -> MResult<Guild> {
        let mut conn = self.pool.get().unwrap();
        Err(Error::MissingPrimaryKey)
    }

    pub fn get_user(&self, user_name: &str) -> MResult<User> {
        // use crate::schema::users::dsl::*;
        // let mut conn = self.pool.get().unwrap();
        // let user: Vec<User> = users.filter(username.eq(user_name))
        //     .limit(1)
        //     .load::<User>(&conn)
        //     .expect("Error loading users");

        // match user.pop() {
        //     Some(user) => Ok(user),
        //     None => Err(Error::MissingPrimaryKey)
        // }
        Err(Error::MissingPrimaryKey)
    }

    pub fn get_post(&self, pid: i32) -> MResult<Post> {
        let mut conn = self.pool.get().unwrap();
        
        // print!("get_post, pid: {}", pid);
        // let sql = "SELECT * FROM post WHERE pid = $1;";
        // store::get(&mut conn, sql, &[&pid])
        Err(Error::MissingPrimaryKey)
    }

    pub fn get_comment(&self, cid: i32) -> MResult<Comment> {
        let mut conn = self.pool.get().unwrap();
        // print!("get_post, cid: {}", cid);
        // let sql = "SELECT * FROM comment WHERE cid = $1;";
        // store::get(&mut conn, sql, &[&cid])
        Err(Error::MissingPrimaryKey)
    }

    pub fn getVotes(&self, query_user_id: i32) -> MResult<Vec<Vote>> {
        use crate::schema::votes::dsl::*;
        let conn = self.pool.get().unwrap();
        let result: Vec<Vote> = votes
            .filter(user_id.eq(query_user_id))
            .load::<Vote>(&conn)
            .expect("Error loading votes");

        return Ok(result);
    }

}