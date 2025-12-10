ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.19
FROM ${BUILD_FROM}

# Setup base
ARG BUILD_ARCH
ARG CUPS_VERSION=3.0.0

# Install build dependencies and runtime dependencies
RUN echo "https://dl-cdn.alpinelinux.org/alpine/v3.23/community" >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
    # Runtime dependencies
    avahi \
    avahi-tools \
    dbus \
    nss-mdns \
    libusb \
    bash \
    jq \
    openssl \
    zlib \
    curl \
    wget \
    tar \
    gzip \
    findutils \
    coreutils \
    # Build dependencies
    git \
    gcc \
    g++ \
    make \
    automake \
    autoconf \
    libtool \
    pkgconfig \
    openssl-dev \
    avahi-dev \
    libusb-dev \
    zlib-dev
    
# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Build CUPS 3 from OpenPrinting source
RUN echo "Building CUPS ${CUPS_VERSION} from OpenPrinting source..." \
    && git clone --depth 1 --branch v${CUPS_VERSION} https://github.com/OpenPrinting/cups.git /tmp/cups \
    || git clone https://github.com/OpenPrinting/cups.git /tmp/cups \
    && cd /tmp/cups \
    && git checkout master \
    && echo "Configuring CUPS..." \
    && ./configure \
        --prefix=/usr \
        --sysconfdir=/etc \
        --localstatedir=/var \
        --with-tls=openssl \
        --enable-avahi \
        --enable-dbus \
        --enable-libusb \
        --disable-systemd \
        --with-dbusdir=/usr/share/dbus-1 \
        --with-rcdir=/tmp/init.d \
    && echo "Building CUPS..." \
    && make -j$(nproc) \
    && echo "Installing CUPS..." \
    && make install \
    && cd / \
    && rm -rf /tmp/cups \
    && echo "CUPS build complete"

# Verify CUPS installation
RUN cupsd --version || echo "CUPS version check failed"

# Copy root filesystem
COPY rootfs /

# Make scripts executable
RUN chmod a+x /etc/services.d/*/run \
    && chmod a+x /etc/services.d/*/finish \
    && chmod a+x /usr/local/bin/cups-* 2>/dev/null || true

# Create necessary directories
RUN mkdir -p /var/cache/cups \
    && mkdir -p /var/spool/cups/tmp \
    && mkdir -p /var/run/cups \
    && mkdir -p /etc/cups \
    && mkdir -p /config/cups-backups \
    && mkdir -p /var/run/dbus \
    && mkdir -p /var/lib/dbus

# Create lpadmin group if it doesn't exist
RUN addgroup -g 11 lpadmin 2>/dev/null || true

# Initialize D-Bus machine ID
RUN dbus-uuidgen > /var/lib/dbus/machine-id

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="CUPS 3 (OpenPrinting) Enhanced" \
    io.hass.description="Advanced CUPS 3.x with IPP Everywhere, auto-discovery, backup, and Home Assistant integration" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}" \
    maintainer="98kuwa036" \
    org.opencontainers.image.title="CUPS 3 (OpenPrinting) Enhanced" \
    org.opencontainers.image.description="Advanced CUPS 3.x with IPP Everywhere, auto-discovery, backup, and Home Assistant integration" \
    org.opencontainers.image.vendor="Home Assistant Add-ons" \
    org.opencontainers.image.authors="98kuwa036" \
    org.opencontainers.image.licenses="Apache-2.0" \
    org.opencontainers.image.url="https://github.com/98kuwa036/cups3-addon" \
    org.opencontainers.image.source="https://github.com/98kuwa036/cups3-addon" \
    org.opencontainers.image.documentation="https://github.com/98kuwa036/cups3-addon/blob/main/README.md" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.revision="${BUILD_REF}" \
    org.opencontainers.image.version="${BUILD_VERSION}"
