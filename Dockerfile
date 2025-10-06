
ARG DOCKER_DEBIAN_FLAVOR=bookworm
ARG DOCKER_NGINX_VERSION=${NGINX_VERSION}


FROM debian:${DOCKER_DEBIAN_FLAVOR}-slim AS builder

ENV NGINX_VERSION ${DOCKER_NGINX_VERSION}


RUN apt update && \
    apt install -y \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libpcre3-dev \
    curl  

RUN curl http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -o /tmp/nginx-${NGINX_VERSION}.tar.gz && \
    cd /tmp && \
    tar xvzf nginx-${NGINX_VERSION}.tar.gz

RUN cd /tmp/nginx-${NGINX_VERSION} && \
    ls -latr

RUN ls -latr
RUN cd /tmp/nginx-${NGINX_VERSION} &&  ./configure --with-compat --with-http_ssl_module --with-ipv6 --with-threads --with-stream --with-stream_ssl_module && \
    make && make install


FROM nginx:${DOCKER_NGINX_VERSION}-${DEBIAN_FLAVOR} AS build

COPY --from=builder /usr/local/nginx /usr/local/nginx
