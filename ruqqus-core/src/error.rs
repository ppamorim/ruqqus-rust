use std::{error, fmt, io};

pub type MResult<T> = Result<T, Error>;

#[derive(Debug)]
pub enum Error {
    Io(io::Error),
    Postgres(postgres::Error),
    NotFound,
    MissingReturnInsertId,
    IndexAlreadyExists,
    MissingPrimaryKey,
    SchemaMissing,
    WordIndexMissing,
    MissingDocumentId,
    MaxFieldsLimitExceeded,

    InvalidBearerAuthentication,
    UnsupportedOperation(UnsupportedOperation),
}

impl From<io::Error> for Error {
    fn from(error: io::Error) -> Error {
        Error::Io(error)
    }
}

impl From<postgres::Error> for Error {
    fn from(error: postgres::Error) -> Error {
        Error::Postgres(error)
    }
}

impl From<UnsupportedOperation> for Error {
    fn from(op: UnsupportedOperation) -> Error {
        Error::UnsupportedOperation(op)
    }
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        use self::Error::*;
        match self {
            Io(e) => write!(f, "{}", e),
            Postgres(e) => write!(f, "{}", e),
            NotFound => write!(f, "Not found"),
            MissingReturnInsertId  => write!(f, "The data has been inserted but no ID returned"),
            IndexAlreadyExists => write!(f, "index already exists"),
            MissingPrimaryKey => write!(f, "schema cannot be built without a primary key"),
            SchemaMissing => write!(f, "this index does not have a schema"),
            WordIndexMissing => write!(f, "this index does not have a word index"),
            MissingDocumentId => write!(f, "document id is missing"),
            MaxFieldsLimitExceeded => write!(f, "maximum number of fields in a document exceeded"),

            InvalidBearerAuthentication => write!(f, "Invalid Bearer Authentication"),
            UnsupportedOperation(op) => write!(f, "unsupported operation; {}", op),
        }
    }
}

impl error::Error for Error {}

#[derive(Debug)]
pub enum UnsupportedOperation {
    SchemaAlreadyExists,
    CannotUpdateSchemaPrimaryKey,
    CannotReorderSchemaAttribute,
    CanOnlyIntroduceNewSchemaAttributesAtEnd,
    CannotRemoveSchemaAttribute,
}

impl fmt::Display for UnsupportedOperation {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        use self::UnsupportedOperation::*;
        match self {
            SchemaAlreadyExists => write!(f, "Cannot update index which already have a schema"),
            CannotUpdateSchemaPrimaryKey => write!(f, "Cannot update the primary key of a schema"),
            CannotReorderSchemaAttribute => write!(f, "Cannot reorder the attributes of a schema"),
            CanOnlyIntroduceNewSchemaAttributesAtEnd => {
                write!(f, "Can only introduce new attributes at end of a schema")
            }
            CannotRemoveSchemaAttribute => write!(f, "Cannot remove attributes from a schema"),
        }
    }
}
