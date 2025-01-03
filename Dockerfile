FROM alpine:latest

# 环境变量
ENV LANG="C.UTF-8" \
    TZ="Asia/Shanghai" \
    NGINX_PORT="8080" \
    NGINX_SSL_PORT="2096" \
    REPO_URL="https://github.com/shixiaolong777/embyExternalUrl" \
    SSL_ENABLE="false" \
    SSL_CRON="0 /2   " \
    SSL_DOMAIN="" \
    AUTO_UPDATE="true" \
    SERVER="emby"

# 安装git
RUN apk --no-cache add nginx nginx-mod-http-js curl busybox git openssl logrotate tzdata && \
    cp /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo "$TZ" > /etc/timezone && \
    mkdir -p /var/cache/nginx/emby/image /opt && \
    git clone $REPO_URL /embyExternalUrl && \
    curl -L -o /tmp/lego_latest.tar.gz "https://github.com/go-acme/lego/releases/download/v3.7.0/lego_v3.7.0_linux_amd64.tar.gz" && \
    tar zxvf /tmp/lego_latest.tar.gz -C /tmp && \
    chmod 755 /tmp/lego && \
    mv /tmp/lego / && \
    rm -rf /tmp/*

COPY entrypoint /entrypoint
COPY start_server /start_server
COPY check_certificate /check_certificate
COPY config/logrotate.conf /etc/logrotate.d/medialinker

RUN chmod +x /entrypoint /start_server /check_certificate

ENTRYPOINT ["/bin/sh", "/entrypoint"]
