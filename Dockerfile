FROM alpine:3.19 as stage

ARG BRANCH
ARG VERSION

RUN apk add --no-cache \
    curl \
    xz
RUN mkdir -p /opt/Radarr
RUN curl -o /tmp/radarr.tar.gz -sL "https://radarr.servarr.com/v1/update/${BRANCH}/updatefile?version=${VERSION}&os=linuxmusl&runtime=netcore&arch=x64"
RUN tar xzf /tmp/radarr.tar.gz -C /opt/Radarr --strip-components=1
RUN rm -rf /opt/Radarr/Radarr.Update /tmp/*

FROM alpine:3.19 as mirror

RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk add --no-cache --initdb -p /out \
    alpine-baselayout \
    busybox \
    gettext-libs \
    icu-libs \
    libcurl \
    libmediainfo \
    sqlite-libs \
    tzdata
RUN rm -rf /out/etc/apk /out/lib/apk /out/var/cache

FROM scratch
ENTRYPOINT []
CMD []
WORKDIR /
COPY --from=mirror /out/ /
COPY --from=stage /opt/Radarr /opt/Radarr/

EXPOSE 7878 8787
VOLUME [ "/data" ]
ENV HOME /data
WORKDIR $HOME
CMD ["/opt/Radarr/Radarr", "-nobrowser", "-data=/data"]

LABEL org.opencontainers.image.source="https://github.com/Radarr/Radarr"
LABEL org.opencontainers.image.description="A fork of Sonarr to work with movies à la Couchpotato."
LABEL org.opencontainers.image.licenses="GPL-3.0-only"