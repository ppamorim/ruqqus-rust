GRANT ALL PRIVILEGES ON DATABASE postgres TO ruqqus;
GRANT ALL ON SCHEMA public TO ruqqus;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ruqqus;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO ruqqus;
INSERT INTO users (id, username, email, passhash, created_utc, creation_ip, tos_agreed_utc, login_nonce, admin_level) VALUES (NEXTVAL('users_id_seq'), 'ruqqie', 'ruqqie@ruqqus.com', 'pbkdf2:sha512:150000$vmPzuBFj$24cde8a6305b7c528b0428b1e87f256c65741bb035b4356549c13e745cc0581701431d5a2297d98501fcf20367791b4334dcd19cf063a6e60195abe8214f91e8', 1592672337, '127.0.0.1', 1592672337, 1, 1);
INSERT INTO boards(name, is_banned, created_utc, description, description_html, creator_id, color) VALUES('general', 'false', 1592984412, 'board description', '<p>general description</p>+', 1, '805ad5');