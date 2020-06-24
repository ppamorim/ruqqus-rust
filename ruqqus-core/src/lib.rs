#[macro_use]
extern crate diesel;
extern crate dotenv;

mod database;
mod error;
pub mod models;
pub mod schema;
pub mod store;

pub use self::database::Database;
pub use self::error::{Error, RResult};