ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.22
FROM ${BUILD_FROM}

# Setup base
ARG BUILD_ARCH

# ==============================================================================
# CUPS 3.0 New Architecture Build
# Components: libcups v3 -> PAPPL -> cups-local -> cups-sharing
# ==============================================================================

# Path settings for locally built libraries
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/lib/pkgconfig
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Install runtime and build dependencies
RUN echo "https://dl-cdn.alpinelinux.org/alpine/v3.22/community" >> /etc/apk/repositories \
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
    gnutls \
    zlib \
    libpng \
    libjpeg-turbo \
    tiff \
    linux-pam \
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
    pkgconf \
    openssl-dev \
    gnutls-dev \
    avahi-dev \
    libusb-dev \
    zlib-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    tiff-dev \
    linux-pam-dev \
    dbus-dev

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /tmp

# ==============================================================================
# Step 1: Build libcups v3 (Foundation library)
# ==============================================================================
RUN echo "=== Building libcups v3 ===" \
    && git clone --recurse-submodules https://github.com/OpenPrinting/libcups.git \
    && cd libcups \
    && echo "Configuring libcups..." \
    && ./configure \
        --prefix=/usr/local \
        --sysconfdir=/etc \
        --localstatedir=/var \
        --enable-debug \
    && echo "Building libcups..." \
    && make -j$(nproc) \
    && echo "Installing libcups..." \
    && make install \
    && cd /tmp \
    && rm -rf libcups \
    && echo "libcups build complete" \
    && ldconfig /usr/local/lib 2>/dev/null || true

# ==============================================================================
# Step 2: Build PAPPL (Printer Application Framework)
# Required by cups-local and cups-sharing
# ==============================================================================
RUN echo "=== Building PAPPL ===" \
    && git clone https://github.com/michaelrsweet/pappl.git \
    && cd pappl \
    && echo "Configuring PAPPL..." \
    && ./configure \
        --prefix=/usr/local \
        --sysconfdir=/etc \
        --localstatedir=/var \
    && echo "Building PAPPL..." \
    && make -j$(nproc) \
    && echo "Installing PAPPL..." \
    && make install \
    && cd /tmp \
    && rm -rf pappl \
    && echo "PAPPL build complete" \
    && ldconfig /usr/local/lib 2>/dev/null || true

# ==============================================================================
# Step 3: Build cups-local (Local printing commands and spooler)
# Provides: lp, lpr, lpstat, cancel, etc.
# ==============================================================================
RUN echo "=== Building cups-local ===" \
    && git clone https://github.com/OpenPrinting/cups-local.git \
    && cd cups-local \
    && echo "Configuring cups-local..." \
    && ./configure \
        --prefix=/usr/local \
        --sysconfdir=/etc \
        --localstatedir=/var \
    && echo "Building cups-local..." \
    && make -j$(nproc) \
    && echo "Installing cups-local..." \
    && make install \
    && cd /tmp \
    && rm -rf cups-local \
    && echo "cups-local build complete"

# ==============================================================================
# Step 4: Build cups-sharing (Network sharing server)
# Provides: Printer sharing, web interface, job history
# ==============================================================================
RUN echo "=== Building cups-sharing ===" \
    && git clone https://github.com/OpenPrinting/cups-sharing.git \
    && cd cups-sharing \
    && echo "Configuring cups-sharing..." \
    && ./configure \
        --prefix=/usr/local \
        --sysconfdir=/etc \
        --localstatedir=/var \
    && echo "Building cups-sharing..." \
    && make -j$(nproc) \
    && echo "Installing cups-sharing..." \
    && make install \
    && cd /tmp \
    && rm -rf cups-sharing \
    && echo "cups-sharing build complete"

# ==============================================================================
# Verify Installation
# ==============================================================================
RUN echo "=== Verifying CUPS 3.0 Installation ===" \
    && echo "Checking ipptool..." \
    && ipptool --version || echo "ipptool not found" \
    && echo "Checking ippfind..." \
    && ippfind --version || echo "ippfind not found" \
    && echo "Checking for cups-sharing binary..." \
    && ls -la /usr/local/sbin/ 2>/dev/null || true \
    && echo "Checking for cups-local commands..." \
    && ls -la /usr/local/bin/lp* 2>/dev/null || true \
    && echo "Installed libraries:" \
    && ls -la /usr/local/lib/libcups* 2>/dev/null || true \
    && ls -la /usr/local/lib/libpappl* 2>/dev/null || true

# Copy root filesystem
COPY rootfs /

# Make scripts executable
RUN chmod a+x /etc/services.d/*/run 2>/dev/null || true \
    && chmod a+x /etc/services.d/*/finish 2>/dev/null || true \
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

# Cleanup build dependencies to reduce image size
RUN apk del --no-cache \
    git \
    gcc \
    g++ \
    make \
    automake \
    autoconf \
    libtool \
    pkgconf \
    openssl-dev \
    gnutls-dev \
    avahi-dev \
    libusb-dev \
    zlib-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    tiff-dev \
    linux-pam-dev \
    dbus-dev \
    && rm -rf /tmp/* /var/cache/apk/*

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="CUPS 3.0 (New Architecture)" \
    io.hass.description="CUPS 3.0 with libcups v3, PAPPL, cups-local, cups-sharing - Experimental" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}" \
    maintainer="98kuwa036" \
    org.opencontainers.image.title="CUPS 3.0 (New Architecture)" \
    org.opencontainers.image.description="CUPS 3.0 Experimental - Built from libcups, PAPPL, cups-local, cups-sharing" \
    org.opencontainers.image.vendor="Home Assistant Add-ons" \
    org.opencontainers.image.authors="98kuwa036" \
    org.opencontainers.image.licenses="Apache-2.0" \
    org.opencontainers.image.url="https://github.com/98kuwa036/cups3-addon" \
    org.opencontainers.image.source="https://github.com/98kuwa036/cups3-addon" \
    org.opencontainers.image.documentation="https://github.com/98kuwa036/cups3-addon/blob/main/README.md" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.revision="${BUILD_REF}" \
    org.opencontainers.image.version="${BUILD_VERSION}"
