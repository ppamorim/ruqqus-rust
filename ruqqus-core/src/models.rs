
use diesel::prelude::*;

use crate::schema::users;

#[derive(Queryable)]
pub struct User {
    pub id: i32,
    pub username: String,
    pub email: Option<String>,
    pub passhash: String,
    pub created_utc: i32,
    pub admin_level: Option<i32>,
    pub over_18: Option<bool>,
    pub creation_ip: Option<String>,
    pub hide_offensive: Option<bool>,
    pub is_activated: Option<bool>,
    pub reddit_username: Option<String>,
    pub bio: Option<String>,
    pub bio_html: Option<String>,
    pub real_id: Option<String>,
    pub referred_by: Option<i32>,
    pub is_banned: Option<i32>,
    pub ban_reason: Option<String>,
    pub ban_state: Option<i32>,
    pub login_nonce: Option<i32>,
    pub title_id: Option<i32>,
    pub has_banner: bool,
    pub has_profile: bool,
    pub reserved: Option<String>,
    pub is_nsfw: bool,
    pub tos_agreed_utc: Option<i32>,
    pub profile_nonce: i32,
    pub banner_nonce: i32,
    pub last_siege_utc: Option<i32>,
    pub mfa_secret: Option<String>,
    pub has_earned_darkmode: Option<bool>,
    pub is_private: Option<bool>,
    pub read_announcement_utc: Option<i32>,
    pub feed_nonce: Option<i32>,
    pub discord_id: Option<i32>,
    pub show_nsfl: Option<bool>,
    pub karma: Option<i32>,
    pub comment_karma: Option<i32>,
    pub unban_utc: Option<i32>,
    pub is_deleted: Option<bool>,
    pub delete_reason: Option<String>,
}

use crate::schema::votes;

#[derive(Queryable)]
pub struct Vote {
    pub id: i32,
    pub user_id: i32,
    pub submission_id: Option<i32>,
    pub created_utc: i32,
    pub vote_type: Option<i32>,
}

use crate::schema::submissions;

#[derive(Queryable)]
pub struct Submission {
    pub id: i32,
    pub author_id: Option<i32>,
    pub title: String,
    pub url: Option<String>,
    pub created_utc: i32,
    pub is_banned: Option<bool>,
    pub over_18: Option<bool>,
    pub distinguish_level: Option<i32>,
    pub created_str: Option<String>,
    pub stickied: Option<bool>,
    pub body: Option<String>,
    pub body_html: Option<String>,
    pub board_id: Option<i32>,
    pub embed_url: Option<String>,
    pub is_deleted: bool,
    pub domain_ref: Option<i32>,
    pub is_approved: i32,
    pub author_name: Option<String>,
    pub approved_utc: Option<i32>,
    pub original_board_id: Option<i32>,
    pub edited_utc: Option<i32>,
    pub ban_reason: Option<String>,
    pub creation_ip: String,
    pub mod_approved: Option<i32>,
    pub is_image: Option<bool>,
    pub has_thumb: Option<bool>,
    pub accepted_utc: Option<i32>,
    pub post_public: Option<bool>,
    pub score_hot: Option<f64>,
    pub score_top: Option<i32>,
    pub score_activity: Option<f64>,
    pub score_disputed: Option<f64>,
    pub guild_name: Option<String>,
    pub is_offensive: Option<bool>,
    pub is_pinned: Option<bool>,
    pub is_nsfl: Option<bool>,
    pub repost_id: Option<i32>,
}

use crate::schema::boards;

#[derive(Queryable)]
pub struct Board {
    pub id: i32,
    pub name: Option<String>,
    pub is_banned: Option<bool>,
    pub created_utc: Option<i32>,
    pub description: Option<String>,
    pub description_html: Option<String>,
    pub over_18: Option<bool>,
    pub creator_id: Option<i32>,
    pub has_banner: bool,
    pub has_profile: bool,
    pub ban_reason: Option<String>,
    pub color: Option<String>,
    pub downvotes_disabled: Option<bool>,
    pub restricted_posting: Option<bool>,
    pub hide_banner_data: Option<bool>,
    pub profile_nonce: i32,
    pub banner_nonce: i32,
    pub is_private: Option<bool>,
    pub color_nonce: Option<i32>,
    pub is_nsfl: Option<bool>,
}

use crate::schema::commentflags;

#[derive(Queryable)]
pub struct CommentFlag {
    pub id: i32,
    pub user_id: Option<i32>,
    pub comment_id: Option<i32>,
    pub created_utc: i32,
}

use crate::schema::comments;

#[derive(Queryable)]
pub struct Comment {
    pub id: i32,
    pub author_id: Option<i32>,
    pub created_utc: i32,
    pub parent_submission: Option<i32>,
    pub is_banned: Option<bool>,
    pub body: Option<String>,
    pub parent_fullname: Option<String>,
    pub body_html: Option<String>,
    pub distinguish_level: Option<i32>,
    pub edited_utc: Option<i32>,
    pub is_deleted: bool,
    pub is_approved: i32,
    pub author_name: Option<String>,
    pub approved_utc: Option<i32>,
    pub ban_reason: Option<String>,
    pub creation_ip: String,
    pub score_disputed: Option<f64>,
    pub score_hot: Option<f64>,
    pub score_top: Option<i32>,
    pub level: Option<i32>,
    pub parent_comment_id: Option<i32>,
    pub title_id: Option<i32>,
    pub over_18: Option<bool>,
    pub is_op: Option<bool>,
    pub is_offensive: Option<bool>,
    pub is_nsfl: Option<bool>,
}

use crate::schema::commentvotes;

#[derive(Queryable)]
pub struct CommentVote {
    pub id: i32,
    pub comment_id: Option<i32>,
    pub vote_type: Option<i32>,
    pub user_id: Option<i32>,
    pub created_utc: Option<i32>,
}

use crate::schema::contributors;

#[derive(Queryable)]
pub struct Contributor {
    pub id: i32,
    pub user_id: Option<i32>,
    pub board_id: Option<i32>,
    pub created_utc: Option<i32>,
    pub is_active: Option<bool>,
    pub approving_mod_id: Option<i32>,
}