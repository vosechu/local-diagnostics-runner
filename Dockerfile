FROM ubuntu AS core

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.utf8

RUN rm -rf /var/lib/apt/lists/*
RUN apt-get update \
    && apt-get -y install --no-install-recommends curl ca-certificates locales iproute2 \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && /usr/sbin/update-ca-certificates

# install s6-overlay; see: https://github.com/just-containers/s6-overlay
# this installation procedure is for Ubuntu 20.04 (with symlinked /sbin)
# see: https://github.com/just-containers/s6-overlay#bin-and-sbin-are-symlinks
ENV S6_OVERLAY_VERSION=v1.22.1.0
RUN set -ex \
    && curl -o /tmp/s6-overlay.tgz -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-armhf.tar.gz \
    && tar xzf /tmp/s6-overlay.tgz -C / --exclude="./bin" \
    && tar xzf /tmp/s6-overlay.tgz -C /usr ./bin \
    && rm -fv /tmp/s6-overlay.tgz

ENTRYPOINT ["/init"]
CMD []

FROM core AS build

ENV DEV_DEPENDENCIES="coreutils util-linux info diffutils" \
    SEARCH_PKGS="findutils grep" \
    ZIP_PKGS="gzip" \
    NETWORK_PKGS="dnsutils iputils-ping" \
    MISC_PKGS=""

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
      ${DEV_DEPENDENCIES} \
      ${ZIP_PKGS} \
      ${SEARCH_PKGS} \
      ${NETWORK_PKGS} \
      ${MISC_PKGS} \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* # Remove extra apt indexes that arent needed anymore

FROM build AS diagnostics-runner

ADD etc/services.d /etc/services.d
