
# CUPS 3 (OpenPrinting) Add-on for Home Assistant

 

![Supports aarch64 Architecture][aarch64-shield]

![Supports amd64 Architecture][amd64-shield]

![Supports armhf Architecture][armhf-shield]

![Supports armv7 Architecture][armv7-shield]

![Supports i386 Architecture][i386-shield]

 

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg

[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg

[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg

[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg

[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg

 

## About

 

CUPS 3.x (OpenPrinting) print server for Home Assistant, **built directly from OpenPrinting CUPS source code**. Docker images are automatically built via GitHub Actions and published to GitHub Container Registry.

 

### Key Features

 

- **CUPS 3.x from Source** - Built from OpenPrinting CUPS repository

- **Automated Builds** - CI/CD via GitHub Actions

- **Multi-arch Support** - Pre-built images for all architectures

- **IPP Everywhere Native** - True driverless printing

- **Container Registry** - Fast downloads from ghcr.io

 

## Installation

 

1. Add this repository to your Home Assistant Add-on Store:

   ```

   https://github.com/98kuwa036/cups3-addon

   ```

2. Install the "CUPS 3 (OpenPrinting)" add-on

3. Configure and start the add-on

4. Access web interface: `http://homeassistant.local:631`

 

### First Installation

 

- Images are pulled from GitHub Container Registry (ghcr.io)

- Much faster than building from source locally

- Pre-built for all supported architectures

 

## Configuration

 

```yaml

admin_user: "admin"

admin_password: "changeme"  # Change this!

log_level: "info"

share_printers: true

browsing: true

allow_remote_admin: true

```

 

## Development

 

### Building Locally

 

If you want to build the image yourself instead of using pre-built images:

 

```bash

# Clone repository

git clone https://github.com/98kuwa036/cups3-addon.git

cd cups3-addon

 

# Build for your architecture

docker build \

  --build-arg BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.19 \

  --build-arg BUILD_ARCH=amd64 \

  -t cups3-addon:local \

  .

```

 

### GitHub Actions

 

The repository includes automated workflows:

- **Build on push**: Builds all architectures on push to main

- **Release on tag**: Creates GitHub release when version tag is pushed

- **Pull request**: Tests builds on PRs

 

Images are published to:

```

ghcr.io/98kuwa036/cups3-addon-aarch64

ghcr.io/98kuwa036/cups3-addon-amd64

ghcr.io/98kuwa036/cups3-addon-armhf

ghcr.io/98kuwa036/cups3-addon-armv7

ghcr.io/98kuwa036/cups3-addon-i386

```

 

## Support

 

- **Issues**: [GitHub Issues](https://github.com/98kuwa036/cups3-addon/issues)

- **CUPS Integration**: [hacs_cups](https://github.com/98kuwa036/hacs_cups)

- **OpenPrinting CUPS**: [GitHub](https://github.com/OpenPrinting/cups)

 

## License

 

Apache License 2.0 - Copyright (c) 2024 98kuwa036

