# Compile
FROM    alpine:3.10 AS compiler

RUN     apk update --quiet
RUN     apk add curl
RUN     apk add build-base
RUN     apk add musl-dev

RUN     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

WORKDIR /ruqqus-rust

COPY    . .

ENV     RUSTFLAGS="-C target-feature=-crt-static"

RUN     $HOME/.cargo/bin/cargo build

# Run
FROM    alpine:3.10

RUN     apk add -q --no-cache libgcc tini

COPY    --from=compiler /ruqqus-rust/target/debug/ruqqus .

ENV     RUQQUS_HTTP_ADDR 0.0.0.0:7700
EXPOSE  7700/tcp

ENTRYPOINT ["tini", "--"]
CMD     ./ruqqus