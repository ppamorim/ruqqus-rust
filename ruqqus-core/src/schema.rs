table! {
    alts (id) {
        id -> Int4,
        user1 -> Int4,
        user2 -> Int4,
    }
}

table! {
    badge_defs (id) {
        id -> Int4,
        name -> Nullable<Varchar>,
        description -> Nullable<Varchar>,
        icon -> Nullable<Varchar>,
        kind -> Nullable<Int4>,
        rank -> Nullable<Int4>,
        qualification_expr -> Nullable<Varchar>,
    }
}

table! {
    badges (id) {
        id -> Int4,
        badge_id -> Nullable<Int4>,
        user_id -> Nullable<Int4>,
        description -> Nullable<Varchar>,
        url -> Nullable<Varchar>,
        created_utc -> Nullable<Int4>,
    }
}

table! {
    badpics (id) {
        id -> Int4,
        description -> Nullable<Varchar>,
        phash -> Nullable<Varchar>,
    }
}

table! {
    badwords (id) {
        id -> Int4,
        keyword -> Nullable<Varchar>,
        regex -> Nullable<Varchar>,
    }
}

table! {
    bans (id) {
        id -> Int4,
        user_id -> Nullable<Int4>,
        board_id -> Nullable<Int4>,
        created_utc -> Nullable<Int4>,
        banning_mod_id -> Nullable<Int4>,
        is_active -> Bool,
        mod_note -> Nullable<Varchar>,
    }
}

table! {
    boards (id) {
        id -> Int4,
        name -> Nullable<Varchar>,
        is_banned -> Nullable<Bool>,
        created_utc -> Nullable<Int4>,
        description -> Nullable<Varchar>,
        description_html -> Nullable<Varchar>,
        over_18 -> Nullable<Bool>,
        creator_id -> Nullable<Int4>,
        has_banner -> Bool,
        has_profile -> Bool,
        ban_reason -> Nullable<Varchar>,
        color -> Nullable<Varchar>,
        downvotes_disabled -> Nullable<Bool>,
        restricted_posting -> Nullable<Bool>,
        hide_banner_data -> Nullable<Bool>,
        profile_nonce -> Int4,
        banner_nonce -> Int4,
        is_private -> Nullable<Bool>,
        color_nonce -> Nullable<Int4>,
        is_nsfl -> Nullable<Bool>,
    }
}

table! {
    commentflags (id) {
        id -> Int4,
        user_id -> Nullable<Int4>,
        comment_id -> Nullable<Int4>,
        created_utc -> Int4,
    }
}

table! {
    comments (id) {
        id -> Int4,
        author_id -> Nullable<Int4>,
        created_utc -> Int4,
        parent_submission -> Nullable<Int4>,
        is_banned -> Nullable<Bool>,
        body -> Nullable<Varchar>,
        parent_fullname -> Nullable<Varchar>,
        body_html -> Nullable<Varchar>,
        distinguish_level -> Nullable<Int4>,
        edited_utc -> Nullable<Int4>,
        is_deleted -> Bool,
        is_approved -> Int4,
        author_name -> Nullable<Varchar>,
        approved_utc -> Nullable<Int4>,
        ban_reason -> Nullable<Varchar>,
        creation_ip -> Varchar,
        score_disputed -> Nullable<Float8>,
        score_hot -> Nullable<Float8>,
        score_top -> Nullable<Int4>,
        level -> Nullable<Int4>,
        parent_comment_id -> Nullable<Int4>,
        title_id -> Nullable<Int4>,
        over_18 -> Nullable<Bool>,
        is_op -> Nullable<Bool>,
        is_offensive -> Nullable<Bool>,
        is_nsfl -> Nullable<Bool>,
    }
}

table! {
    commentvotes (id) {
        id -> Int4,
        comment_id -> Nullable<Int4>,
        vote_type -> Nullable<Int4>,
        user_id -> Nullable<Int4>,
        created_utc -> Nullable<Int4>,
    }
}

table! {
    contributors (id) {
        id -> Int4,
        user_id -> Nullable<Int4>,
        board_id -> Nullable<Int4>,
        created_utc -> Nullable<Int4>,
        is_active -> Nullable<Bool>,
        approving_mod_id -> Nullable<Int4>,
    }
}

table! {
    dms (id) {
        id -> Int4,
        created_utc -> Nullable<Int4>,
        to_user_id -> Nullable<Int4>,
        from_user_id -> Nullable<Int4>,
        body_html -> Nullable<Varchar>,
        is_banned -> Nullable<Bool>,
    }
}

table! {
    domains (id) {
        id -> Int4,
        domain -> Nullable<Varchar>,
        can_submit -> Nullable<Bool>,
        can_comment -> Nullable<Bool>,
        reason -> Nullable<Int4>,
        show_thumbnail -> Nullable<Bool>,
        embed_function -> Nullable<Varchar>,
    }
}

table! {
    flags (id) {
        id -> Int4,
        user_id -> Nullable<Int4>,
        post_id -> Nullable<Int4>,
        created_utc -> Int4,
    }
}

table! {
    follows (id) {
        id -> Int4,
        user_id -> Nullable<Int4>,
        target_id -> Nullable<Int4>,
        created_utc -> Nullable<Int4>,
    }
}

table! {
    images (id) {
        id -> Int4,
        state -> Nullable<Varchar>,
        text -> Nullable<Varchar>,
        number -> Nullable<Int4>,
    }
}

table! {
    ips (id) {
        id -> Int4,
        addr -> Nullable<Varchar>,
        reason -> Nullable<Varchar>,
        banned_by -> Nullable<Int4>,
    }
}

table! {
    mods (id) {
        id -> Int4,
        user_id -> Nullable<Int4>,
        board_id -> Nullable<Int4>,
        created_utc -> Nullable<Int4>,
        accepted -> Nullable<Bool>,
        invite_rescinded -> Nullable<Bool>,
    }
}

table! {
    notifications (id) {
        id -> Int4,
        user_id -> Nullable<Int4>,
        comment_id -> Nullable<Int4>,
        read -> Bool,
    }
}

table! {
    postrels (id) {
        id -> Int4,
        post_id -> Nullable<Int4>,
        board_id -> Nullable<Int4>,
    }
}

table! {
    reports (id) {
        id -> Int4,
        post_id -> Nullable<Int4>,
        user_id -> Nullable<Int4>,
        created_utc -> Nullable<Int4>,
    }
}

table! {
    submissions (id) {
        id -> Int4,
        author_id -> Nullable<Int4>,
        title -> Varchar,
        url -> Nullable<Varchar>,
        created_utc -> Int4,
        is_banned -> Nullable<Bool>,
        over_18 -> Nullable<Bool>,
        distinguish_level -> Nullable<Int4>,
        created_str -> Nullable<Varchar>,
        stickied -> Nullable<Bool>,
        body -> Nullable<Varchar>,
        body_html -> Nullable<Varchar>,
        board_id -> Nullable<Int4>,
        embed_url -> Nullable<Varchar>,
        is_deleted -> Bool,
        domain_ref -> Nullable<Int4>,
        is_approved -> Int4,
        author_name -> Nullable<Varchar>,
        approved_utc -> Nullable<Int4>,
        original_board_id -> Nullable<Int4>,
        edited_utc -> Nullable<Int4>,
        ban_reason -> Nullable<Varchar>,
        creation_ip -> Varchar,
        mod_approved -> Nullable<Int4>,
        is_image -> Nullable<Bool>,
        has_thumb -> Nullable<Bool>,
        accepted_utc -> Nullable<Int4>,
        post_public -> Nullable<Bool>,
        score_hot -> Nullable<Float8>,
        score_top -> Nullable<Int4>,
        score_activity -> Nullable<Float8>,
        score_disputed -> Nullable<Float8>,
        guild_name -> Nullable<Varchar>,
        is_offensive -> Nullable<Bool>,
        is_pinned -> Nullable<Bool>,
        is_nsfl -> Nullable<Bool>,
        repost_id -> Nullable<Int4>,
    }
}

table! {
    subscriptions (id) {
        id -> Int4,
        user_id -> Nullable<Int4>,
        board_id -> Nullable<Int4>,
        created_utc -> Int4,
        is_active -> Nullable<Bool>,
    }
}

table! {
    titles (id) {
        id -> Int4,
        is_before -> Bool,
        text -> Nullable<Varchar>,
        qualification_expr -> Nullable<Varchar>,
        requirement_string -> Nullable<Varchar>,
        color -> Nullable<Varchar>,
        kind -> Nullable<Int4>,
    }
}

table! {
    useragents (id) {
        id -> Int4,
        kwd -> Nullable<Varchar>,
        banned_by -> Nullable<Int4>,
        reason -> Nullable<Varchar>,
        mock -> Nullable<Varchar>,
        status_code -> Nullable<Int4>,
    }
}

table! {
    userblocks (id) {
        id -> Int4,
        user_id -> Nullable<Int4>,
        target_id -> Nullable<Int4>,
        created_utc -> Nullable<Int4>,
    }
}

table! {
    userflags (id) {
        id -> Int4,
        user_id -> Nullable<Int4>,
        target_id -> Nullable<Int4>,
        resolved -> Nullable<Bool>,
    }
}

table! {
    users (id) {
        id -> Int4,
        username -> Varchar,
        email -> Nullable<Varchar>,
        passhash -> Varchar,
        created_utc -> Int4,
        admin_level -> Nullable<Int4>,
        over_18 -> Nullable<Bool>,
        creation_ip -> Nullable<Varchar>,
        hide_offensive -> Nullable<Bool>,
        is_activated -> Nullable<Bool>,
        reddit_username -> Nullable<Varchar>,
        bio -> Nullable<Varchar>,
        bio_html -> Nullable<Varchar>,
        real_id -> Nullable<Varchar>,
        referred_by -> Nullable<Int4>,
        is_banned -> Nullable<Int4>,
        ban_reason -> Nullable<Varchar>,
        ban_state -> Nullable<Int4>,
        login_nonce -> Nullable<Int4>,
        title_id -> Nullable<Int4>,
        has_banner -> Bool,
        has_profile -> Bool,
        reserved -> Nullable<Varchar>,
        is_nsfw -> Bool,
        tos_agreed_utc -> Nullable<Int4>,
        profile_nonce -> Int4,
        banner_nonce -> Int4,
        last_siege_utc -> Nullable<Int4>,
        mfa_secret -> Nullable<Varchar>,
        has_earned_darkmode -> Nullable<Bool>,
        is_private -> Nullable<Bool>,
        read_announcement_utc -> Nullable<Int4>,
        feed_nonce -> Nullable<Int4>,
        discord_id -> Nullable<Int4>,
        show_nsfl -> Nullable<Bool>,
        karma -> Nullable<Int4>,
        comment_karma -> Nullable<Int4>,
        unban_utc -> Nullable<Int4>,
        is_deleted -> Nullable<Bool>,
        delete_reason -> Nullable<Varchar>,
    }
}

table! {
    votes (id) {
        id -> Int4,
        user_id -> Int4,
        submission_id -> Nullable<Int4>,
        created_utc -> Int4,
        vote_type -> Nullable<Int4>,
    }
}

joinable!(badges -> badge_defs (badge_id));
joinable!(badges -> users (user_id));
joinable!(bans -> boards (board_id));
joinable!(boards -> users (creator_id));
joinable!(commentflags -> comments (comment_id));
joinable!(commentflags -> users (user_id));
joinable!(comments -> submissions (parent_submission));
joinable!(commentvotes -> comments (comment_id));
joinable!(commentvotes -> users (user_id));
joinable!(contributors -> boards (board_id));
joinable!(flags -> submissions (post_id));
joinable!(flags -> users (user_id));
joinable!(ips -> users (banned_by));
joinable!(mods -> boards (board_id));
joinable!(mods -> users (user_id));
joinable!(notifications -> comments (comment_id));
joinable!(notifications -> users (user_id));
joinable!(postrels -> boards (board_id));
joinable!(postrels -> submissions (post_id));
joinable!(reports -> submissions (post_id));
joinable!(reports -> users (user_id));
joinable!(submissions -> domains (domain_ref));
joinable!(subscriptions -> boards (board_id));
joinable!(subscriptions -> users (user_id));
joinable!(useragents -> users (banned_by));
joinable!(users -> titles (title_id));
joinable!(votes -> submissions (submission_id));

allow_tables_to_appear_in_same_query!(
    alts,
    badge_defs,
    badges,
    badpics,
    badwords,
    bans,
    boards,
    commentflags,
    comments,
    commentvotes,
    contributors,
    dms,
    domains,
    flags,
    follows,
    images,
    ips,
    mods,
    notifications,
    postrels,
    reports,
    submissions,
    subscriptions,
    titles,
    useragents,
    userblocks,
    userflags,
    users,
    votes,
);
