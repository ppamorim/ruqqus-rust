#!/bin/bash

# echo "Starting redis server..."
# redis-server /etc/redis.conf --daemonize yes

echo "Starting postgresql server.."
chmod 0700 /var/lib/postgresql/data &&\
    initdb /var/lib/postgresql/data &&\
    echo "host all  all    0.0.0.0/0  md5" >> /var/lib/postgresql/data/pg_hba.conf &&\
    echo "listen_addresses='*'" >> /var/lib/postgresql/data/postgresql.conf &&\
    pg_ctl start 

echo "Configuring postgresql database"
psql postgres -a -f schema.sql

echo "Configuring local ruqqus postgres user"
RANDOM_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
psql postgres -c \"create user ruqqus password '$RANDOM_PASSWORD';\"

echo "Initializing database"
psql postgres -a -f scripts/docker/initialize_db.sql

export domain=ruqqus.localhost:8000
export REDIS_URL=redis://localhost:6379
export DATABASE_URL=postgres://ruqqus:$RANDOM_PASSWORD@localhost:5432/postgres
# export PYTHONPATH="/app"
# export MASTER_KEY=$(openssl rand -base64 32)
# export SESSION_COOKIE_SECURE="false"

./ruqqus