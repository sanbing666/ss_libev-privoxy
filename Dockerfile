# Dockerfile for shadowsocks-libev based alpine
# Copyright (C) 2018 - 2021 Teddysun <i@teddysun.com>
# Reference URL:
# https://github.com/shadowsocks/shadowsocks-libev
# https://github.com/shadowsocks/v2ray-plugin
# https://github.com/teddysun/v2ray-plugin
# https://github.com/teddysun/xray-plugin
# https://www.privoxy.org/

FROM --platform=${TARGETPLATFORM} alpine:latest
LABEL maintainer="Teddysun <i@teddysun.com>"

ARG TARGETPLATFORM
WORKDIR /root
COPY ./root /root

RUN set -ex \
	&& runDeps="git build-base c-ares-dev autoconf automake libev-dev libtool libsodium-dev linux-headers mbedtls-dev pcre-dev" \
	&& apk add --no-cache --virtual .build-deps ${runDeps} \
	&& mkdir -p /root/libev \
	&& cd /root/libev \
	&& git clone --depth=1 https://github.com/shadowsocks/shadowsocks-libev.git . \
	&& git submodule update --init --recursive \
	&& ./autogen.sh \
	&& ./configure --prefix=/usr --disable-documentation \
	&& make install \
	&& apk add --no-cache \
	    privoxy \
		tzdata \
		rng-tools \
		ca-certificates \
		$(scanelf --needed --nobanner /usr/bin/ss-* \
		| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
		| xargs -r apk info --installed \
		| sort -u) \
	&& apk del .build-deps \
	&& cd /root \
	&& rm -rf /root/libev \
	&& mv privoxy/* /etc/privoxy/ \
	&& chmod +x /root/v2ray-plugin.sh /root/xray-plugin.sh /root/docker_entrypoint.sh \
	&& /root/v2ray-plugin.sh "${TARGETPLATFORM}" \
	&& /root/xray-plugin.sh "${TARGETPLATFORM}" \
	&& rm -f /root/v2ray-plugin.sh /root/xray-plugin.sh

VOLUME /etc/shadowsocks-libev
ENV TZ=Asia/Shanghai
ENTRYPOINT ["/root/docker_entrypoint.sh"]
