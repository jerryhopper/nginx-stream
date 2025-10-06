FROM debian:bookworm-slim AS builder

ENV NGINX_VERSION 1.29.1

RUN apt update && \
    apt install -y \
    build-essential \
    curl \
    git \
    libpcre++-dev \
    zlib1g-dev

RUN curl http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -o /tmp/nginx-${NGINX_VERSION}.tar.gz && \
    cd /tmp && \
    tar xvzf nginx-${NGINX_VERSION}.tar.gz


RUN cd /tmp/nginx-${NGINX_VERSION} && \
    ./configure --with-compat --with-stream && \
    make modules

FROM nginx:1.29.1

COPY --from=builder /tmp/nginx-${NGINX_VERSION}/objs/* /etc/nginx/modules/

COPY --from=builder /usr/local/lib/* /lib/x86_64-linux-gnu/
