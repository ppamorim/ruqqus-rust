use std::ops::Deref;
use std::sync::Arc;

use ruqqus_core::Database;
use sha2::Digest;
use sysinfo::Pid;

use crate::option::Opt;

const LAST_UPDATE_KEY: &str = "last-update";

#[derive(Clone)]
pub struct Data {
    inner: Arc<DataInner>,
}

impl Deref for Data {
    type Target = DataInner;

    fn deref(&self) -> &Self::Target {
        &self.inner
    }
}

#[derive(Clone)]
pub struct DataInner {
    pub db: Arc<Database>,
    pub api_keys: ApiKeys,
    pub server_pid: Pid,
}

#[derive(Default, Clone)]
pub struct ApiKeys {
    pub public: Option<String>,
    pub private: Option<String>,
    pub master: Option<String>,
}

impl ApiKeys {
    pub fn generate_missing_api_keys(&mut self) {
        if let Some(master_key) = &self.master {
            if self.private.is_none() {
                let key = format!("{}-private", master_key);
                let sha = sha2::Sha256::digest(key.as_bytes());
                self.private = Some(format!("{:x}", sha));
            }
            if self.public.is_none() {
                let key = format!("{}-public", master_key);
                let sha = sha2::Sha256::digest(key.as_bytes());
                self.public = Some(format!("{:x}", sha));
            }
        }
    }
}

impl Data {
    pub fn new(opt: Opt) -> Data {

        let server_pid = sysinfo::get_current_pid().unwrap();

        let db = Arc::new(Database::open_or_create(
            &opt.postgres_host, 
            &opt.postgres_user
        ).unwrap());

        let mut api_keys = ApiKeys {
            master: opt.master_key,
            private: None,
            public: None,
        };

        api_keys.generate_missing_api_keys();

        let inner_data = DataInner {
            db,
            api_keys,
            server_pid,
        };

        Data {
            inner: Arc::new(inner_data),
        }
    }
}
