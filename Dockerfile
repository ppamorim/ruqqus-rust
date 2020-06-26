# Compile
FROM    alpine:3.10 AS compiler

RUN     apk update --quiet && \ 
        apk add curl build-base musl-dev postgresql-dev redis

RUN     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

WORKDIR /ruqqus-rust

COPY    . .

ENV     RUSTFLAGS="-C target-feature=-crt-static"

RUN     $HOME/.cargo/bin/cargo build

# Run
FROM    postgres:13-alpine

RUN     apk add -q --no-cache libgcc tini musl-dev postgresql-dev redis perl openrc

COPY    --from=compiler /ruqqus-rust/target/debug/ruqqus .
COPY    /scripts ./scripts
COPY    schema.sql schema.sql

ENV     RUQQUS_HTTP_ADDR 0.0.0.0:5432
EXPOSE  5432/tcp

ENTRYPOINT ["tini", "--"]

RUN ["chmod", "+x", "./scripts/docker/start_docker_ruqqus.sh"]

USER postgres
CMD sh scripts/docker/start_docker_ruqqus.sh