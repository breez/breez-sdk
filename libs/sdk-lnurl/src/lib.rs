mod error;
pub mod model;
mod specs;

pub mod prelude {
    pub use crate::error::*;
    pub use crate::model::*;
    pub use crate::specs::auth::*;
    pub use crate::*;
}
