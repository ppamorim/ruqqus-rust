--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3 (Ubuntu 12.3-1.pgdg16.04+1)
-- Dumped by pg_dump version 12.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', 'public', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    author_id integer,
    created_utc integer NOT NULL,
    parent_submission integer,
    is_banned boolean DEFAULT false,
    body character varying(10000),
    parent_fullname character varying(255),
    body_html character varying(20000),
    distinguish_level integer DEFAULT 0,
    edited_utc integer DEFAULT 0,
    is_deleted boolean DEFAULT false NOT NULL,
    is_approved integer DEFAULT 0 NOT NULL,
    author_name character varying(64),
    approved_utc integer DEFAULT 0,
    ban_reason character varying(128) DEFAULT ''::character varying,
    creation_ip character varying(64) DEFAULT ''::character varying NOT NULL,
    score_disputed double precision DEFAULT 0,
    score_hot double precision DEFAULT 0,
    score_top integer DEFAULT 0,
    level integer DEFAULT 0,
    parent_comment_id integer,
    title_id integer,
    over_18 boolean DEFAULT false,
    is_op boolean DEFAULT false,
    is_offensive boolean,
    is_nsfl boolean DEFAULT false
);


--
-- Name: age(public.comments); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.age(public.comments) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
      SELECT CAST( EXTRACT( EPOCH FROM CURRENT_TIMESTAMP) AS int) - $1.created_utc
      $_$;


--
-- Name: submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.submissions (
    id integer NOT NULL,
    author_id integer,
    title character varying(500) NOT NULL,
    url character varying(255),
    created_utc integer NOT NULL,
    is_banned boolean DEFAULT false,
    over_18 boolean DEFAULT false,
    distinguish_level integer DEFAULT 0,
    created_str character varying(255),
    stickied boolean DEFAULT false,
    body character varying(10000) DEFAULT ''::character varying,
    body_html character varying(20000) DEFAULT ''::character varying,
    board_id integer DEFAULT 1,
    embed_url character varying(256) DEFAULT ''::character varying,
    is_deleted boolean DEFAULT false NOT NULL,
    domain_ref integer,
    is_approved integer DEFAULT 0 NOT NULL,
    author_name character varying(64),
    approved_utc integer DEFAULT 0,
    original_board_id integer,
    edited_utc integer,
    ban_reason character varying(128) DEFAULT ''::character varying,
    creation_ip character varying(64) DEFAULT ''::character varying NOT NULL,
    mod_approved integer,
    is_image boolean DEFAULT false,
    has_thumb boolean DEFAULT false,
    accepted_utc integer DEFAULT 0,
    post_public boolean DEFAULT true,
    score_hot double precision DEFAULT 0,
    score_top integer DEFAULT 0,
    score_activity double precision DEFAULT 0,
    score_disputed double precision DEFAULT 0,
    guild_name character varying(64),
    is_offensive boolean,
    is_pinned boolean DEFAULT false,
    is_nsfl boolean DEFAULT false,
    repost_id integer DEFAULT 0
);


--
-- Name: age(public.submissions); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.age(public.submissions) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
      SELECT CAST( EXTRACT( EPOCH FROM CURRENT_TIMESTAMP) AS int) - $1.created_utc
      $_$;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255),
    passhash character varying(255) NOT NULL,
    created_utc integer NOT NULL,
    admin_level integer DEFAULT 0,
    over_18 boolean DEFAULT false,
    creation_ip character varying(255),
    hide_offensive boolean DEFAULT false,
    is_activated boolean DEFAULT false,
    reddit_username character varying(64) DEFAULT NULL::character varying,
    bio character varying(256) DEFAULT ''::character varying,
    bio_html character varying(300),
    real_id character varying,
    referred_by integer,
    is_banned integer DEFAULT 0,
    ban_reason character varying(128) DEFAULT ''::character varying,
    ban_state integer DEFAULT 0,
    login_nonce integer DEFAULT 0,
    title_id integer,
    has_banner boolean DEFAULT false NOT NULL,
    has_profile boolean DEFAULT false NOT NULL,
    reserved character varying(256) DEFAULT NULL::character varying,
    is_nsfw boolean DEFAULT false NOT NULL,
    tos_agreed_utc integer DEFAULT 0,
    profile_nonce integer DEFAULT 0 NOT NULL,
    banner_nonce integer DEFAULT 0 NOT NULL,
    last_siege_utc integer DEFAULT 0,
    mfa_secret character varying(32) DEFAULT NULL::character varying,
    has_earned_darkmode boolean,
    is_private boolean DEFAULT false,
    read_announcement_utc integer DEFAULT 0,
    feed_nonce integer DEFAULT 1,
    discord_id integer,
    show_nsfl boolean DEFAULT false,
    karma integer DEFAULT 0,
    comment_karma integer DEFAULT 0,
    unban_utc integer DEFAULT 0,
    is_deleted boolean DEFAULT false,
    delete_reason character varying(1000) DEFAULT ''::character varying
);


--
-- Name: age(public.users); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.age(public.users) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
      SELECT CAST( EXTRACT( EPOCH FROM CURRENT_TIMESTAMP) AS int) - $1.created_utc
      $_$;


--
-- Name: board_id(public.comments); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.board_id(public.comments) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
      SELECT submissions.board_id
      FROM submissions
      WHERE submissions.id=$1.parent_submission
      $_$;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reports (
    id integer NOT NULL,
    post_id integer,
    user_id integer,
    created_utc integer DEFAULT 0
);


--
-- Name: board_id(public.reports); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.board_id(public.reports) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
      SELECT submissions.board_id
      FROM submissions
      WHERE submissions.id=$1.post_id
      $_$;


--
-- Name: comment_count(public.submissions); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.comment_count(public.submissions) RETURNS bigint
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
      SELECT COUNT(*)
      FROM comments
      WHERE is_banned=false
        AND is_deleted=false
        AND parent_submission = $1.id
      $_$;


--
-- Name: comment_energy(public.users); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.comment_energy(public.users) RETURNS numeric
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
     SELECT COALESCE(
     (
      SELECT SUM(comments.score)
      FROM comments
      WHERE comments.author_id=$1.id
        AND comments.is_banned=false
      ),
      0
      )
    $_$;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    user_id integer,
    comment_id integer,
    read boolean DEFAULT false NOT NULL
);


--
-- Name: created_utc(public.notifications); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.created_utc(public.notifications) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
select created_utc from comments
where comments.id=$1.comment_id
$_$;


--
-- Name: downs(public.comments); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.downs(public.comments) RETURNS bigint
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$

select (

(
  SELECT count(*)
  from (
    select * from commentvotes
    where comment_id=$1.id
    and vote_type=-1
  ) as v1
  left join users
    on users.id=v1.user_id
  where users.is_banned=0
)-(
  SELECT count(distinct v1.id)
  from (
    select * from commentvotes
    where comment_id=$1.id
    and vote_type=-1
  ) as v1
  left join (select * from users) as u1
    on u1.id=v1.user_id
  left join (select * from alts) as a1
    on a1.user1=v1.user_id
  left join (select * from alts) as a2
    on a2.user2=v1.user_id
  left join (
      select * from commentvotes
      where comment_id=$1.id
      and vote_type=-1
  ) as v2
    on (v2.user_id=a1.user2 or v2.user_id=a2.user1)
  left join (select * from users) as u2
    on u2.id=v2.user_id
  where u1.is_banned=0
  and u2.is_banned=0
  and v1.id is not null
  and v2.id is not null
))

      $_$;


--
-- Name: downs(public.submissions); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.downs(public.submissions) RETURNS bigint
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$

select (

(
  SELECT count(*)
  from (
    select * from votes
    where submission_id=$1.id
    and vote_type=-1
  ) as v1
  left join users
    on users.id=v1.user_id
  where users.is_banned=0
)-(
  SELECT count(distinct v1.id)
  from (
    select * from votes
    where submission_id=$1.id
    and vote_type=-1
  ) as v1
  left join (select * from users) as u1
    on u1.id=v1.user_id
  left join (select * from alts) as a1
    on a1.user1=v1.user_id
  left join (select * from alts) as a2
    on a2.user2=v1.user_id
  left join (
      select * from votes
      where submission_id=$1.id
      and vote_type=-1
  ) as v2
    on (v2.user_id=a1.user2 or v2.user_id=a2.user1)
  left join (select * from users) as u2
    on u2.id=v2.user_id
  where u1.is_banned=0
  and u2.is_banned=0
  and v1.id is not null
  and v2.id is not null
))

      $_$;


--
-- Name: energy(public.users); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.energy(public.users) RETURNS numeric
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
     SELECT COALESCE(
     (
      SELECT SUM(submissions.score)
      FROM submissions
      WHERE submissions.author_id=$1.id
        AND submissions.is_banned=false
      ),
      0
      )
    $_$;


--
-- Name: flag_count(public.comments); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.flag_count(public.comments) RETURNS bigint
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
      SELECT COUNT(*)
      FROM commentflags
      JOIN users ON commentflags.user_id=users.id
      WHERE comment_id=$1.id
      AND users.is_banned=0
      $_$;


--
-- Name: flag_count(public.submissions); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.flag_count(public.submissions) RETURNS bigint
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
      SELECT COUNT(*)
      FROM flags
      JOIN users ON flags.user_id=users.id
      WHERE post_id=$1.id
      AND users.is_banned=0
      $_$;


--
-- Name: follower_count(public.users); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.follower_count(public.users) RETURNS bigint
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
         select count(*)
         from follows
         left join users
         on follows.target_id=users.id
         where follows.target_id=$1.id
         and users.is_banned=0
        $_$;


--
-- Name: is_banned(public.notifications); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_banned(public.notifications) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
select is_banned from comments
where comments.id=$1.comment_id
$_$;


--
-- Name: is_deleted(public.notifications); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_deleted(public.notifications) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
select is_deleted from comments
where comments.id=$1.comment_id
$_$;


--
-- Name: is_public(public.comments); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_public(public.comments) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
      SELECT submissions.is_public
      FROM submissions
      WHERE submissions.id=$1.parent_submission
      $_$;


--
-- Name: is_public(public.submissions); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_public(public.submissions) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
select
	case
		when $1.post_public=true
			then true
		when (select (is_private)
			from boards
			where id=$1.board_id
			)=true
			then false
		else
			true
	end
      
      
      $_$;


--
-- Name: rank_activity(public.submissions); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.rank_activity(public.submissions) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
      SELECT CAST($1.comment_count AS float)/((CAST(($1.age+5000) AS FLOAT)/100.0)^(1.1))
    $_$;


--
-- Name: rank_fiery(public.comments); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.rank_fiery(public.comments) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT SQRT(CAST(($1.ups * $1.downs) AS float))/((CAST(($1.age+100000) AS FLOAT)/6.0)^(1.0/3.0))
  $_$;


--
-- Name: rank_fiery(public.submissions); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.rank_fiery(public.submissions) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
      SELECT SQRT(CAST(($1.ups * $1.downs) AS float))/((CAST(($1.age+5000) AS FLOAT)/100.0)^(1.1))
      $_$;


--
-- Name: rank_hot(public.comments); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.rank_hot(public.comments) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT CAST(($1.ups - $1.downs) AS float)/((CAST(($1.age+100000) AS FLOAT)/6.0)^(1.0/3.0))
  $_$;


--
-- Name: rank_hot(public.submissions); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.rank_hot(public.submissions) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
      SELECT CAST(($1.ups - $1.downs) AS float)/((CAST(($1.age+5000) AS FLOAT)/100.0)^(1.1))
      $_$;


--
-- Name: boards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.boards (
    id integer NOT NULL,
    name character varying(64),
    is_banned boolean,
    created_utc integer,
    description character varying(1500) DEFAULT ''::character varying,
    description_html character varying(2500) DEFAULT ''::character varying,
    over_18 boolean DEFAULT false,
    creator_id integer,
    has_banner boolean DEFAULT false NOT NULL,
    has_profile boolean DEFAULT false NOT NULL,
    ban_reason character varying(256) DEFAULT NULL::character varying,
    color character varying(8) DEFAULT '603abb'::character varying,
    downvotes_disabled boolean DEFAULT false,
    restricted_posting boolean DEFAULT false,
    hide_banner_data boolean DEFAULT false,
    profile_nonce integer DEFAULT 0 NOT NULL,
    banner_nonce integer DEFAULT 0 NOT NULL,
    is_private boolean DEFAULT false,
    color_nonce integer DEFAULT 0,
    is_nsfl boolean DEFAULT false
);


--
-- Name: recent_subscriptions(public.boards); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.recent_subscriptions(public.boards) RETURNS bigint
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
         select count(*)
         from subscriptions
         left join users
         on subscriptions.user_id=users.id
         where subscriptions.board_id=$1.id
         and subscriptions.is_active=true
         and subscriptions.created_utc > CAST( EXTRACT( EPOCH FROM CURRENT_TIMESTAMP) AS int) - 60*60*24
         and users.is_banned=0
        $_$;


--
-- Name: referral_count(public.users); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.referral_count(public.users) RETURNS bigint
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
        SELECT COUNT(*)
        FROM USERS
        WHERE users.is_banned=0
        AND users.referred_by=$1.id
    $_$;


--
-- Name: report_count(public.submissions); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.report_count(public.submissions) RETURNS bigint
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
      SELECT COUNT(*)
      FROM reports
      JOIN users ON reports.user_id=users.id
      WHERE post_id=$1.id
      AND users.is_banned=0
      and reports.created_utc >= $1.edited_utc
      $_$;


--
-- Name: score(public.comments); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.score(public.comments) RETURNS bigint
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT ($1.ups - $1.downs)
  $_$;


--
-- Name: score(public.submissions); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.score(public.submissions) RETURNS bigint
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
      SELECT ($1.ups - $1.downs)
      $_$;


--
-- Name: images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.images (
    id integer NOT NULL,
    state character varying(8),
    text character varying(255),
    number integer
);


--
-- Name: splash(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.splash(text) RETURNS SETOF public.images
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
      SELECT *
      FROM images
      WHERE state=$1
      ORDER BY random()
      LIMIT 1
    $_$;


--
-- Name: subscriber_count(public.boards); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.subscriber_count(public.boards) RETURNS bigint
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$

	select
		case 
		when $1.is_private=false
		then
	         (select count(*)
	         from subscriptions
	         left join users
	         on subscriptions.user_id=users.id
	         where subscriptions.board_id=$1.id
	         and users.is_banned=0)
	    when $1.is_private=true
	    then
	         (select count(*)
	         from subscriptions
	         left join users
	         	on subscriptions.user_id=users.id
	         left join (
	         	select * from contributors
	         	where contributors.board_id=$1.id
	         )as contribs
	         	on contribs.user_id=users.id
	         where subscriptions.board_id=$1.id
	         and users.is_banned=0
	         and contribs.user_id is not null)
	    end
         
         
$_$;


--
-- Name: trending_rank(public.boards); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.trending_rank(public.boards) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$


select
	case 
		when $1.subscriber_count<10 then 0
		when $1.subscriber_count>=9 then cast($1.recent_subscriptions as float) / log(cast($1.subscriber_count as float))
	end
$_$;


--
-- Name: ups(public.comments); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ups(public.comments) RETURNS bigint
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$

select (

(
  SELECT count(*)
  from (
    select * from commentvotes
    where comment_id=$1.id
    and vote_type=1
  ) as v1
  left join users
    on users.id=v1.user_id
  where users.is_banned=0
)-(
  SELECT count(distinct v1.id)
  from (
    select * from commentvotes
    where comment_id=$1.id
    and vote_type=1
  ) as v1
  left join (select * from users) as u1
    on u1.id=v1.user_id
  left join (select * from alts) as a1
    on a1.user1=v1.user_id
  left join (select * from alts) as a2
    on a2.user2=v1.user_id
  left join (
      select * from commentvotes
      where comment_id=$1.id
      and vote_type=1
  ) as v2
    on (v2.user_id=a1.user2 or v2.user_id=a2.user1)
  left join (select * from users) as u2
    on u2.id=v2.user_id
  where u1.is_banned=0
  and u2.is_banned=0
  and v1.id is not null
  and v2.id is not null
))

      $_$;


--
-- Name: ups(public.submissions); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ups(public.submissions) RETURNS bigint
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$


select (

(
  SELECT count(*)
  from (
    select * from votes
    where submission_id=$1.id
    and vote_type=1
  ) as v1
  left join users
    on users.id=v1.user_id
  where users.is_banned=0
)-(
  SELECT count(distinct v1.id)
  from (
    select * from votes
    where submission_id=$1.id
    and vote_type=1
  ) as v1
  left join (select * from users) as u1
    on u1.id=v1.user_id
  left join (select * from alts) as a1
    on a1.user1=v1.user_id
  left join (select * from alts) as a2
    on a2.user2=v1.user_id
  left join (
      select * from votes
      where submission_id=$1.id
      and vote_type=1
  ) as v2
    on (v2.user_id=a1.user2 or v2.user_id=a2.user1)
  left join (select * from users) as u2
    on u2.id=v2.user_id
  where u1.is_banned=0
  and u2.is_banned=0
  and v1.id is not null
  and v2.id is not null
))

      $_$;


--
-- Name: alts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alts (
    id integer NOT NULL,
    user1 integer NOT NULL,
    user2 integer NOT NULL
);


--
-- Name: alts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.alts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: alts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.alts_id_seq OWNED BY public.alts.id;


--
-- Name: badge_defs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.badge_defs (
    id integer NOT NULL,
    name character varying(64),
    description character varying(256),
    icon character varying(64),
    kind integer DEFAULT 1,
    rank integer DEFAULT 1,
    qualification_expr character varying(128)
);


--
-- Name: badge_list_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.badge_list_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: badge_list_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.badge_list_id_seq OWNED BY public.badge_defs.id;


--
-- Name: badges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.badges (
    id integer NOT NULL,
    badge_id integer,
    user_id integer,
    description character varying(256) DEFAULT ''::character varying,
    url character varying(256) DEFAULT ''::character varying,
    created_utc integer
);


--
-- Name: badges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.badges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: badges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.badges_id_seq OWNED BY public.badges.id;


--
-- Name: badpics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.badpics (
    id integer NOT NULL,
    description character varying(255) DEFAULT ''::character varying,
    phash character varying(255)
);


--
-- Name: badpics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.badpics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: badpics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.badpics_id_seq OWNED BY public.badpics.id;


--
-- Name: badwords; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.badwords (
    id integer NOT NULL,
    keyword character varying(64),
    regex character varying(256)
);


--
-- Name: badwords_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.badwords_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: badwords_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.badwords_id_seq OWNED BY public.badwords.id;


--
-- Name: bans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bans (
    id integer NOT NULL,
    user_id integer,
    board_id integer,
    created_utc integer,
    banning_mod_id integer,
    is_active boolean DEFAULT true NOT NULL,
    mod_note character varying(128)
);


--
-- Name: bans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bans_id_seq OWNED BY public.bans.id;


--
-- Name: boards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.boards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: boards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.boards_id_seq OWNED BY public.boards.id;


--
-- Name: commentflags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.commentflags (
    id integer NOT NULL,
    user_id integer,
    comment_id integer,
    created_utc integer NOT NULL
);


--
-- Name: commentflags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.commentflags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commentflags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.commentflags_id_seq OWNED BY public.commentflags.id;


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: commentvotes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.commentvotes (
    id integer NOT NULL,
    comment_id integer,
    vote_type integer,
    user_id integer,
    created_utc integer
);


--
-- Name: commentvotes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.commentvotes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commentvotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.commentvotes_id_seq OWNED BY public.commentvotes.id;


--
-- Name: contributors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contributors (
    id integer NOT NULL,
    user_id integer,
    board_id integer,
    created_utc integer,
    is_active boolean DEFAULT true,
    approving_mod_id integer
);


--
-- Name: contributors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contributors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contributors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contributors_id_seq OWNED BY public.contributors.id;


--
-- Name: dms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dms (
    id integer NOT NULL,
    created_utc integer,
    to_user_id integer,
    from_user_id integer,
    body_html character varying(300),
    is_banned boolean
);


--
-- Name: dms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dms_id_seq OWNED BY public.dms.id;


--
-- Name: domains; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.domains (
    id integer NOT NULL,
    domain character varying(100),
    can_submit boolean DEFAULT false,
    can_comment boolean DEFAULT false,
    reason integer,
    show_thumbnail boolean DEFAULT false,
    embed_function character varying(64) DEFAULT NULL::character varying
);


--
-- Name: domains_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.domains_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: domains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.domains_id_seq OWNED BY public.domains.id;


--
-- Name: flags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flags (
    id integer NOT NULL,
    user_id integer,
    post_id integer,
    created_utc integer NOT NULL
);


--
-- Name: flags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.flags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.flags_id_seq OWNED BY public.flags.id;


--
-- Name: follows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.follows (
    id integer NOT NULL,
    user_id integer,
    target_id integer,
    created_utc integer
);


--
-- Name: follows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.follows_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: follows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.follows_id_seq OWNED BY public.follows.id;


--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.images_id_seq OWNED BY public.images.id;


--
-- Name: ips; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ips (
    id integer NOT NULL,
    addr character varying(64),
    reason character varying(256) DEFAULT ''::character varying,
    banned_by integer
);


--
-- Name: ips_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ips_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ips_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ips_id_seq OWNED BY public.ips.id;


--
-- Name: mods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mods (
    id integer NOT NULL,
    user_id integer,
    board_id integer,
    created_utc integer,
    accepted boolean DEFAULT false,
    invite_rescinded boolean DEFAULT false
);


--
-- Name: mods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mods_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mods_id_seq OWNED BY public.mods.id;


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: postrels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.postrels (
    id integer NOT NULL,
    post_id integer,
    board_id integer
);


--
-- Name: postrels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.postrels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: postrels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.postrels_id_seq OWNED BY public.postrels.id;


--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reports_id_seq OWNED BY public.reports.id;


--
-- Name: submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.submissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.submissions_id_seq OWNED BY public.submissions.id;


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscriptions (
    id integer NOT NULL,
    user_id integer,
    board_id integer,
    created_utc integer NOT NULL,
    is_active boolean DEFAULT true
);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subscriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;


--
-- Name: titles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.titles (
    id integer NOT NULL,
    is_before boolean DEFAULT true NOT NULL,
    text character varying(64),
    qualification_expr character varying(256),
    requirement_string character varying(512),
    color character varying(6) DEFAULT '000000'::character varying,
    kind integer DEFAULT 1
);


--
-- Name: titles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.titles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: titles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.titles_id_seq OWNED BY public.titles.id;


--
-- Name: useragents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.useragents (
    id integer NOT NULL,
    kwd character varying(128),
    banned_by integer,
    reason character varying(256),
    mock character varying(256) DEFAULT ''::character varying,
    status_code integer DEFAULT 418
);


--
-- Name: useragents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.useragents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: useragents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.useragents_id_seq OWNED BY public.useragents.id;


--
-- Name: userblocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.userblocks (
    id integer NOT NULL,
    user_id integer,
    target_id integer,
    created_utc integer
);


--
-- Name: userblocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.userblocks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: userblocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.userblocks_id_seq OWNED BY public.userblocks.id;


--
-- Name: userflags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.userflags (
    id integer NOT NULL,
    user_id integer,
    target_id integer,
    resolved boolean DEFAULT false
);


--
-- Name: userflags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.userflags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: userflags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.userflags_id_seq OWNED BY public.userflags.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: votes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.votes (
    id integer NOT NULL,
    user_id integer NOT NULL,
    submission_id integer,
    created_utc integer DEFAULT 0 NOT NULL,
    vote_type integer DEFAULT 0
);


--
-- Name: votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.votes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.votes_id_seq OWNED BY public.votes.id;


--
-- Name: alts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alts ALTER COLUMN id SET DEFAULT nextval('public.alts_id_seq'::regclass);


--
-- Name: badge_defs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badge_defs ALTER COLUMN id SET DEFAULT nextval('public.badge_list_id_seq'::regclass);


--
-- Name: badges id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badges ALTER COLUMN id SET DEFAULT nextval('public.badges_id_seq'::regclass);


--
-- Name: badpics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badpics ALTER COLUMN id SET DEFAULT nextval('public.badpics_id_seq'::regclass);


--
-- Name: badwords id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badwords ALTER COLUMN id SET DEFAULT nextval('public.badwords_id_seq'::regclass);


--
-- Name: bans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bans ALTER COLUMN id SET DEFAULT nextval('public.bans_id_seq'::regclass);


--
-- Name: boards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boards ALTER COLUMN id SET DEFAULT nextval('public.boards_id_seq'::regclass);


--
-- Name: commentflags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commentflags ALTER COLUMN id SET DEFAULT nextval('public.commentflags_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: commentvotes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commentvotes ALTER COLUMN id SET DEFAULT nextval('public.commentvotes_id_seq'::regclass);


--
-- Name: contributors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contributors ALTER COLUMN id SET DEFAULT nextval('public.contributors_id_seq'::regclass);


--
-- Name: dms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dms ALTER COLUMN id SET DEFAULT nextval('public.dms_id_seq'::regclass);


--
-- Name: domains id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.domains ALTER COLUMN id SET DEFAULT nextval('public.domains_id_seq'::regclass);


--
-- Name: flags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flags ALTER COLUMN id SET DEFAULT nextval('public.flags_id_seq'::regclass);


--
-- Name: follows id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follows ALTER COLUMN id SET DEFAULT nextval('public.follows_id_seq'::regclass);


--
-- Name: images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images ALTER COLUMN id SET DEFAULT nextval('public.images_id_seq'::regclass);


--
-- Name: ips id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ips ALTER COLUMN id SET DEFAULT nextval('public.ips_id_seq'::regclass);


--
-- Name: mods id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mods ALTER COLUMN id SET DEFAULT nextval('public.mods_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: postrels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.postrels ALTER COLUMN id SET DEFAULT nextval('public.postrels_id_seq'::regclass);


--
-- Name: reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports ALTER COLUMN id SET DEFAULT nextval('public.reports_id_seq'::regclass);


--
-- Name: submissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions ALTER COLUMN id SET DEFAULT nextval('public.submissions_id_seq'::regclass);


--
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);


--
-- Name: titles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.titles ALTER COLUMN id SET DEFAULT nextval('public.titles_id_seq'::regclass);


--
-- Name: useragents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.useragents ALTER COLUMN id SET DEFAULT nextval('public.useragents_id_seq'::regclass);


--
-- Name: userblocks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userblocks ALTER COLUMN id SET DEFAULT nextval('public.userblocks_id_seq'::regclass);


--
-- Name: userflags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userflags ALTER COLUMN id SET DEFAULT nextval('public.userflags_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: votes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votes ALTER COLUMN id SET DEFAULT nextval('public.votes_id_seq'::regclass);


--
-- Name: alts alts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alts
    ADD CONSTRAINT alts_pkey PRIMARY KEY (id);


--
-- Name: badge_defs badge_list_icon_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badge_defs
    ADD CONSTRAINT badge_list_icon_key UNIQUE (icon);


--
-- Name: badge_defs badge_list_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badge_defs
    ADD CONSTRAINT badge_list_pkey PRIMARY KEY (id);


--
-- Name: badges badges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badges
    ADD CONSTRAINT badges_pkey PRIMARY KEY (id);


--
-- Name: badpics badpics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badpics
    ADD CONSTRAINT badpics_pkey PRIMARY KEY (id);


--
-- Name: badwords badwords_keyword_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badwords
    ADD CONSTRAINT badwords_keyword_key UNIQUE (keyword);


--
-- Name: badwords badwords_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badwords
    ADD CONSTRAINT badwords_pkey PRIMARY KEY (id);


--
-- Name: bans bans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bans
    ADD CONSTRAINT bans_pkey PRIMARY KEY (id);


--
-- Name: boards boards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boards
    ADD CONSTRAINT boards_pkey PRIMARY KEY (id);


--
-- Name: commentflags commentflags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commentflags
    ADD CONSTRAINT commentflags_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: commentvotes commentvotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commentvotes
    ADD CONSTRAINT commentvotes_pkey PRIMARY KEY (id);


--
-- Name: contributors contributors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contributors
    ADD CONSTRAINT contributors_pkey PRIMARY KEY (id);


--
-- Name: dms dms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dms
    ADD CONSTRAINT dms_pkey PRIMARY KEY (id);


--
-- Name: domains domains_domain_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.domains
    ADD CONSTRAINT domains_domain_key UNIQUE (domain);


--
-- Name: domains domains_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.domains
    ADD CONSTRAINT domains_pkey PRIMARY KEY (id);


--
-- Name: flags flags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flags
    ADD CONSTRAINT flags_pkey PRIMARY KEY (id);


--
-- Name: follows follows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (id);


--
-- Name: boards guild_names_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boards
    ADD CONSTRAINT guild_names_unique UNIQUE (name);


--
-- Name: ips ips_addr_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ips
    ADD CONSTRAINT ips_addr_key UNIQUE (addr);


--
-- Name: ips ips_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ips
    ADD CONSTRAINT ips_pkey PRIMARY KEY (id);


--
-- Name: images images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);

--
-- Name: mods mods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mods
    ADD CONSTRAINT mods_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: postrels postrels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.postrels
    ADD CONSTRAINT postrels_pkey PRIMARY KEY (id);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: submissions submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT submissions_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: titles titles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.titles
    ADD CONSTRAINT titles_pkey PRIMARY KEY (id);


--
-- Name: useragents useragents_kwd_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.useragents
    ADD CONSTRAINT useragents_kwd_key UNIQUE (kwd);


--
-- Name: useragents useragents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.useragents
    ADD CONSTRAINT useragents_pkey PRIMARY KEY (id);


--
-- Name: userblocks userblocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userblocks
    ADD CONSTRAINT userblocks_pkey PRIMARY KEY (id);


--
-- Name: userflags userflags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userflags
    ADD CONSTRAINT userflags_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_reddit_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_reddit_username_key UNIQUE (reddit_username);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: votes votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: badges_user_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX badges_user_index ON public.badges USING btree (user_id);


--
-- Name: badpics_phash_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX badpics_phash_index ON public.badpics USING gin (phash public.gin_trgm_ops);


--
-- Name: ban_board_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ban_board_index ON public.bans USING btree (board_id);


--
-- Name: ban_user_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ban_user_index ON public.bans USING btree (user_id);


--
-- Name: block_target_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX block_target_idx ON public.userblocks USING btree (target_id);


--
-- Name: block_user_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX block_user_idx ON public.userblocks USING btree (user_id);


--
-- Name: cflag_user_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cflag_user_idx ON public.commentflags USING btree (user_id);


--
-- Name: comment_level_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX comment_level_index ON public.comments USING btree (level);


--
-- Name: comment_parent_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX comment_parent_index ON public.comments USING btree (parent_comment_id);


--
-- Name: comment_post_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX comment_post_id_index ON public.comments USING btree (parent_submission);


--
-- Name: commentflag_comment_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX commentflag_comment_index ON public.commentflags USING btree (comment_id);


--
-- Name: comments_user_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX comments_user_index ON public.comments USING btree (author_id);


--
-- Name: commentvotes_comments_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX commentvotes_comments_id_index ON public.commentvotes USING btree (comment_id);


--
-- Name: commentvotes_comments_type_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX commentvotes_comments_type_index ON public.commentvotes USING btree (vote_type);


--
-- Name: contrib_active_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contrib_active_index ON public.contributors USING btree (is_active);


--
-- Name: contrib_board_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contrib_board_index ON public.contributors USING btree (board_id);


--
-- Name: contributors_board_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contributors_board_index ON public.contributors USING btree (board_id);


--
-- Name: contributors_user_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contributors_user_index ON public.contributors USING btree (user_id);


--
-- Name: cvote_user_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cvote_user_index ON public.commentvotes USING btree (user_id);


--
-- Name: domain_ref_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX domain_ref_idx ON public.submissions USING btree (domain_ref);


--
-- Name: flag_user_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX flag_user_idx ON public.flags USING btree (user_id);


--
-- Name: flags_post_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX flags_post_index ON public.flags USING btree (post_id);


--
-- Name: follow_target_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX follow_target_id_index ON public.follows USING btree (target_id);


--
-- Name: follow_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX follow_user_id_index ON public.follows USING btree (user_id);


--
-- Name: iruqqus_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX iruqqus_idx ON public.submissions USING btree (url varchar_pattern_ops);


--
-- Name: mod_board_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mod_board_index ON public.mods USING btree (board_id);


--
-- Name: mod_rescind_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mod_rescind_index ON public.mods USING btree (invite_rescinded);


--
-- Name: mod_user_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mod_user_index ON public.mods USING btree (user_id);


--
-- Name: notifications_user_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_user_index ON public.notifications USING btree (user_id);


--
-- Name: post_18_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_18_index ON public.submissions USING btree (over_18);


--
-- Name: post_author_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_author_index ON public.submissions USING btree (author_id);


--
-- Name: post_offensive_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_offensive_index ON public.submissions USING btree (is_offensive);


--
-- Name: post_title_trgm_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX post_title_trgm_index ON public.submissions USING gin (title public.gin_trgm_ops);


--
-- Name: reports_post_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reports_post_index ON public.reports USING btree (post_id);


--
-- Name: sub_active_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sub_active_index ON public.subscriptions USING btree (is_active);


--
-- Name: sub_user_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sub_user_index ON public.subscriptions USING btree (user_id);


--
-- Name: submission_created_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX submission_created_index ON public.submissions USING btree (created_utc);


--
-- Name: submission_domainref_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX submission_domainref_index ON public.submissions USING btree (domain_ref);


--
-- Name: submission_pinned_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX submission_pinned_idx ON public.submissions USING btree (is_pinned);


--
-- Name: submissions_author_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX submissions_author_index ON public.submissions USING btree (author_id);


--
-- Name: submissions_board_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX submissions_board_index ON public.submissions USING btree (board_id);


--
-- Name: submissions_offensive_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX submissions_offensive_index ON public.submissions USING btree (is_offensive);


--
-- Name: submissions_over18_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX submissions_over18_index ON public.submissions USING btree (over_18);


--
-- Name: submissions_sticky_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX submissions_sticky_index ON public.submissions USING btree (stickied);


--
-- Name: submissions_url_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX submissions_url_index ON public.submissions USING btree (url);


--
-- Name: subscription_board_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX subscription_board_index ON public.subscriptions USING btree (board_id);


--
-- Name: subscription_user_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX subscription_user_index ON public.subscriptions USING btree (user_id);


--
-- Name: user_del_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_del_idx ON public.users USING btree (is_deleted);


--
-- Name: users_created_utc_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_created_utc_index ON public.users USING btree (created_utc);


--
-- Name: vote_user_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX vote_user_index ON public.votes USING btree (user_id);


--
-- Name: votes_submission_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX votes_submission_id_index ON public.votes USING btree (submission_id);


--
-- Name: votes_type_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX votes_type_index ON public.votes USING btree (vote_type);


--
-- Name: alts alts_user1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alts
    ADD CONSTRAINT alts_user1_fkey FOREIGN KEY (user1) REFERENCES public.users(id);


--
-- Name: alts alts_user2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alts
    ADD CONSTRAINT alts_user2_fkey FOREIGN KEY (user2) REFERENCES public.users(id);


--
-- Name: badges badges_badge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badges
    ADD CONSTRAINT badges_badge_id_fkey FOREIGN KEY (badge_id) REFERENCES public.badge_defs(id);


--
-- Name: badges badges_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badges
    ADD CONSTRAINT badges_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: bans bans_banning_mod_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bans
    ADD CONSTRAINT bans_banning_mod_id_fkey FOREIGN KEY (banning_mod_id) REFERENCES public.users(id);


--
-- Name: bans bans_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bans
    ADD CONSTRAINT bans_board_id_fkey FOREIGN KEY (board_id) REFERENCES public.boards(id);


--
-- Name: bans bans_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bans
    ADD CONSTRAINT bans_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: contributors board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contributors
    ADD CONSTRAINT board_id_fkey FOREIGN KEY (board_id) REFERENCES public.boards(id);


--
-- Name: boards boards_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boards
    ADD CONSTRAINT boards_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.users(id);


--
-- Name: commentflags commentflags_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commentflags
    ADD CONSTRAINT commentflags_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES public.comments(id);


--
-- Name: commentflags commentflags_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commentflags
    ADD CONSTRAINT commentflags_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: comments comments_parent_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_parent_comment_id_fkey FOREIGN KEY (parent_comment_id) REFERENCES public.comments(id);


--
-- Name: comments comments_parent_post_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_parent_post_fkey FOREIGN KEY (parent_submission) REFERENCES public.submissions(id);


--
-- Name: commentvotes commentvotes_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commentvotes
    ADD CONSTRAINT commentvotes_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES public.comments(id);


--
-- Name: commentvotes commentvotes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commentvotes
    ADD CONSTRAINT commentvotes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: contributors contributors_approving_mod_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contributors
    ADD CONSTRAINT contributors_approving_mod_id_fkey FOREIGN KEY (approving_mod_id) REFERENCES public.users(id);


--
-- Name: dms dms_from_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dms
    ADD CONSTRAINT dms_from_user_id_fkey FOREIGN KEY (from_user_id) REFERENCES public.users(id);


--
-- Name: dms dms_to_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dms
    ADD CONSTRAINT dms_to_user_id_fkey FOREIGN KEY (to_user_id) REFERENCES public.users(id);


--
-- Name: comments f1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT f1 FOREIGN KEY (author_id) REFERENCES public.users(id);


--
-- Name: votes f1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT f1 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: flags flags_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flags
    ADD CONSTRAINT flags_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.submissions(id);


--
-- Name: flags flags_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flags
    ADD CONSTRAINT flags_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: follows follows_target_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_target_id_fkey FOREIGN KEY (target_id) REFERENCES public.users(id);


--
-- Name: follows follows_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: ips ips_banned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ips
    ADD CONSTRAINT ips_banned_by_fkey FOREIGN KEY (banned_by) REFERENCES public.users(id);


--
-- Name: mods mods_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mods
    ADD CONSTRAINT mods_board_id_fkey FOREIGN KEY (board_id) REFERENCES public.boards(id);


--
-- Name: mods mods_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mods
    ADD CONSTRAINT mods_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: notifications notifications_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES public.comments(id);


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: postrels postrels_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.postrels
    ADD CONSTRAINT postrels_board_id_fkey FOREIGN KEY (board_id) REFERENCES public.boards(id);


--
-- Name: postrels postrels_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.postrels
    ADD CONSTRAINT postrels_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.submissions(id);


--
-- Name: reports reports_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.submissions(id);


--
-- Name: reports reports_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: submissions submissions_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT submissions_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id);


--
-- Name: submissions submissions_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT submissions_board_id_fkey FOREIGN KEY (board_id) REFERENCES public.boards(id);


--
-- Name: submissions submissions_domain_ref_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT submissions_domain_ref_fkey FOREIGN KEY (domain_ref) REFERENCES public.domains(id);


--
-- Name: submissions submissions_mod_approved_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT submissions_mod_approved_fkey FOREIGN KEY (mod_approved) REFERENCES public.users(id);


--
-- Name: submissions submissions_original_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT submissions_original_board_id_fkey FOREIGN KEY (original_board_id) REFERENCES public.boards(id);


--
-- Name: subscriptions subscriptions_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_board_id_fkey FOREIGN KEY (board_id) REFERENCES public.boards(id);


--
-- Name: subscriptions subscriptions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: contributors user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contributors
    ADD CONSTRAINT user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: useragents useragents_banned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.useragents
    ADD CONSTRAINT useragents_banned_by_fkey FOREIGN KEY (banned_by) REFERENCES public.users(id);


--
-- Name: userblocks userblocks_target_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userblocks
    ADD CONSTRAINT userblocks_target_id_fkey FOREIGN KEY (target_id) REFERENCES public.users(id);


--
-- Name: userblocks userblocks_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userblocks
    ADD CONSTRAINT userblocks_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: userflags userflags_target_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userflags
    ADD CONSTRAINT userflags_target_id_fkey FOREIGN KEY (target_id) REFERENCES public.users(id);


--
-- Name: userflags userflags_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userflags
    ADD CONSTRAINT userflags_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: users users_referred_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_referred_by_fkey FOREIGN KEY (referred_by) REFERENCES public.users(id);


--
-- Name: users users_title_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_title_fkey FOREIGN KEY (title_id) REFERENCES public.titles(id);


--
-- Name: votes votes_submission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_submission_id_fkey FOREIGN KEY (submission_id) REFERENCES public.submissions(id);


--
-- PostgreSQL database dump complete
--

