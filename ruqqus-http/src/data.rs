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

impl DataInner {
    // pub fn is_indexing(&self, reader: &heed::RoTxn<UpdateT>, index: &str) -> RResult<Option<bool>> {
    //     match self.db.open_index(&index) {
    //         Some(index) => index.current_update_id(&reader).map(|u| Some(u.is_some())),
    //         None => Ok(None),
    //     }
    // }

    // pub fn last_update(&self, reader: &heed::RoTxn<MainT>) -> RResult<Option<DateTime<Utc>>> {
    //     match self
    //         .db
    //         .common_store()
    //         .get::<_, Str, SerdeDatetime>(reader, LAST_UPDATE_KEY)?
    //     {
    //         Some(datetime) => Ok(Some(datetime)),
    //         None => Ok(None),
    //     }
    // }

    // pub fn set_last_update(&self, writer: &mut heed::RwTxn<MainT>) -> RResult<()> {
    //     self.db
    //         .common_store()
    //         .put::<_, Str, SerdeDatetime>(writer, LAST_UPDATE_KEY, &Utc::now())
    //         .map_err(Into::into)
    // }

    // pub fn compute_stats(&self, writer: &mut heed::RwTxn<MainT>, index_uid: &str) -> RResult<()> {
    //     let index = match self.db.open_index(&index_uid) {
    //         Some(index) => index,
    //         None => {
    //             error!("Impossible to retrieve index {}", index_uid);
    //             return Ok(());
    //         }
    //     };

    //     let schema = match index.main.schema(&writer)? {
    //         Some(schema) => schema,
    //         None => return Ok(()),
    //     };

    //     let all_documents_fields = index
    //         .documents_fields_counts
    //         .all_documents_fields_counts(&writer)?;

    //     // count fields frequencies
    //     let mut fields_frequency = HashMap::<_, usize>::new();
    //     for result in all_documents_fields {
    //         let (_, attr, _) = result?;
    //         if let Some(field_id) = schema.indexed_pos_to_field_id(attr) {
    //             *fields_frequency.entry(field_id).or_default() += 1;
    //         }
    //     }

    //     // convert attributes to their names
    //     let frequency: HashMap<_, _> = fields_frequency
    //         .into_iter()
    //         .filter_map(|(a, c)| schema.name(a).map(|name| (name.to_string(), c)))
    //         .collect();

    //     index
    //         .main
    //         .put_fields_frequency(writer, &frequency)
    //         .map_err(MError::Zlmdb)
    // }
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
