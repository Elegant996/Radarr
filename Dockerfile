FROM scratch AS source

ADD ./radarr.tar.gz /

FROM alpine:3.20 AS build-sysroot

# Prepare sysroot
RUN mkdir -p /sysroot/etc/apk && cp -r /etc/apk/* /sysroot/etc/apk/

# Fetch runtime dependencies
RUN apk add --no-cache --initdb -p /sysroot \
    alpine-baselayout \
    busybox \
    gettext-libs \
    icu-libs \
    libcurl \
    libmediainfo \
    sqlite-libs \
    tzdata
RUN rm -rf /sysroot/etc/apk /sysroot/lib/apk /sysroot/var/cache

# Install Radarr to new system root
RUN mkdir -p /sysroot/opt/Radarr
COPY --from=source /Radarr /sysroot/opt/Radarr
RUN rm -rf /sysroot/opt/Radarr/Radarr.Update

# Install entrypoint
COPY --chmod 755 ./entrypoint.sh /sysroot/entrypoint.sh

# Build image
FROM scratch
COPY --from=build-sysroot /sysroot/ /

EXPOSE 7878 8787
VOLUME [ "/data" ]
ENV HOME=/data
WORKDIR $HOME
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/opt/Radarr/Radarr", "-nobrowser", "-data=/data"]

ARG VERSION

LABEL org.opencontainers.image.description="A fork of Sonarr to work with movies à la Couchpotato."
LABEL org.opencontainers.image.licenses="GPL-3.0-only"
LABEL org.opencontainers.image.source="https://github.com/Radarr/Radarr"
LABEL org.opencontainers.image.title="Radarr"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.url="https://radarr.video/"