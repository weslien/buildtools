FROM rust:alpine as base

RUN apk add musl-dev figlet
RUN cargo install lcat



