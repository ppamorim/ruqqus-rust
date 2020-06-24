use std::thread;
use log::info;
use std::char;

use postgres::{NoTls};
use r2d2_postgres::PostgresConnectionManager;
use uuid::Uuid;

use crate::{store, MResult, Error};
use crate::models::{User, Vote, Submission, Board, Comment};

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

    pub fn get_user(&self, user_name: &str) -> MResult<User> {
        use crate::schema::users::dsl;

        let user_name = user_name.replace("\\", "");
        let user_name = user_name.replace("_", "\\_");

        let conn = self.pool.get().unwrap();

        let users: Vec<User> = dsl::users
            .filter(dsl::username.eq(user_name))
            .limit(1)
            .load::<User>(&conn)
            .expect("Error loading submission");

        match users.into_iter().next() {
            Some(user) => Ok(user),
            None => Err(Error::NotFound)
        }
    }

    pub fn get_submission(&self, pid: i32) -> MResult<Submission> {

        use crate::schema::submissions::dsl as submissions_dsl;
        use crate::schema::votes::dsl as votes_dsl;

        let submission_id = base36decode(pid);

        let mut conn = self.pool.get().unwrap();

        let submissions_vote = votes_dsl::votes
            .filter(votes_dsl::user_id.eq(submission_id))
            .filter(votes_dsl::submission_id.eq(submission_id));

        use diesel::debug_query;
        use diesel::*;
        // let debug = debug_query::<DB, _>(&submissions_vote);
        // print!("{}", debug.to_string());

        let submissions: Vec<Submission> = submissions_dsl::submissions
            // .select([submissions_dsl::table, votes_dsl::vote_type])
            .filter(submissions_dsl::id.eq(submission_id))
            .limit(1)
            // .left_outer_join(submissions_vote)
            .load::<Submission>(&conn)
            .expect("Error loading submission");

        match submissions.into_iter().next() {
            Some(submission) => Ok(submission),
            None => Err(Error::NotFound)
        }

        // if v:
            // vt=session.query(Vote).filter_by(user_id=v.id, submission_id=i).subquery()
            // items= session.query(Submission, vt.c.vote_type).filter(Submission.id==i).join(vt, isouter=True).first()
            
        //     if not items:
        //         abort(404)
            
        //     x=items[0]
        //     x._voted=items[1] if items[1] else 0

        // else:
        //     x=session.query(Submission).filter_by(id=i).first()

        // if not x:
        //     abort(404)
        // return x
    }

    pub fn get_board(&self, bid: i32) -> MResult<Board> {

        use crate::schema::boards::dsl;

        let bid = base36decode(bid);
        let conn = self.pool.get().unwrap();

        let boards: Vec<Board> = dsl::boards
            .filter(dsl::id.eq(bid))
            .limit(1)
            .load::<Board>(&conn)
            .expect("Error loading users");

        match boards.into_iter().next() {
            Some(board) => Ok(board),
            None => Err(Error::NotFound)
        }
    }

    pub fn get_guild(&self, name: &str) -> MResult<Board> {

        use crate::schema::boards::dsl;

        let name = name.trim_start_matches('+');
        let name = name.replace("\\", "");
        let name = name.replace("_", "\\_");

        let conn = self.pool.get().unwrap();

        let boards: Vec<Board> = dsl::boards
            .filter(dsl::name.ilike(name))
            .limit(1)
            .load::<Board>(&conn)
            .expect("Error loading users");

        match boards.into_iter().next() {
            Some(board) => Ok(board),
            None => Err(Error::NotFound)
        }
    }

    pub fn get_comment(&self, cid: i32) -> MResult<Comment> {

        use crate::schema::comments::dsl;

        let cid = base36decode(cid);
        let conn = self.pool.get().unwrap();

        let comments: Vec<Comment> = dsl::comments
            .filter(dsl::id.eq(cid))
            .limit(1)
            .load::<Comment>(&conn)
            .expect("Error loading comment");

        match comments.into_iter().next() {
            Some(comment) => Ok(comment),
            None => Err(Error::NotFound)
        }
    }

    pub fn get_comments(&self, cid: i32, sort_type: SortType) -> MResult<Comment> {

        match sort_type {
            SortType::Activity => {
                return Err(Error::NotFound);
            },
            _ => {},
        }

        use crate::schema::comments::dsl;

        let cid = base36decode(cid);
        let conn = self.pool.get().unwrap();

        let comments: Vec<Comment> = dsl::comments
            .filter(dsl::id.eq(cid))
            .limit(1)
            .load::<Comment>(&conn)
            .expect("Error loading comment");

        match comments.into_iter().next() {
            Some(comment) => Ok(comment),
            None => Err(Error::NotFound)
        }
    }

    pub fn get_votes(&self, user_id: i32) -> MResult<Vec<Vote>> {
        use crate::schema::votes::dsl;
        let conn = self.pool.get().unwrap();
        let votes: Vec<Vote> = dsl::votes
            .filter(dsl::user_id.eq(user_id))
            .load::<Vote>(&conn)
            .expect("Error loading votes");
        Ok(votes)
    }

}

fn base36decode(x: i32) -> i32 {
    format_radix(x as u32, 36).parse::<i32>().unwrap()
}

fn format_radix(mut x: u32, radix: u32) -> String {
    let mut result = vec![];

    loop {
        let m = x % radix;
        x = x / radix;

        // will panic if you use a bad radix (< 2 or > 36).
        result.push(std::char::from_digit(m, radix).unwrap());
        if x == 0 {
            break;
        }
    }
    result.into_iter().rev().collect()
}

pub enum SortType {
    Top,
    New,
    Disputed,
    Activity,
}