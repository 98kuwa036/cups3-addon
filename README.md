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

CUPS 3.x (OpenPrinting) print server for Home Assistant, **built directly from OpenPrinting CUPS source code**. This add-on provides the latest CUPS 3.x features with full IPP Everywhere support.

### Key Features

- **CUPS 3.x from Source** - Latest OpenPrinting CUPS built from source
- **IPP Everywhere Native** - True driverless printing
- **Zeroconf/mDNS** - Automatic printer discovery
- **Web Interface** - Full CUPS admin interface
- **USB & Network Printers** - Support for both connection types
- **Remote Access** - Configurable remote administration
- **HASS Integration** - Works with CUPS custom integration

### Why Build from Source?

- ✅ Latest CUPS 3.x features and improvements
- ✅ Native IPP Everywhere support (no legacy PPD files)
- ✅ Enhanced security and performance
- ✅ Direct from OpenPrinting Foundation
- ✅ Cutting-edge printer compatibility

## Installation

1. Add this repository to your Home Assistant Add-on Store:
   ```
   https://github.com/98kuwa036/cups3-addon
   ```
2. Install the "CUPS 3 (OpenPrinting)" add-on
3. **Note**: First build may take 5-10 minutes (building from source)
4. Configure the add-on (see Configuration section)
5. Start the add-on
6. Access the CUPS web interface at: `http://homeassistant.local:631`

## Configuration

### Options

```yaml
admin_user: "admin"
admin_password: "changeme"
log_level: "info"
share_printers: true
browsing: true
allow_remote_admin: true
```

### Option Details

| Option | Description | Default |
|--------|-------------|---------|
| `admin_user` | CUPS admin username | `admin` |
| `admin_password` | CUPS admin password | `changeme` |
| `log_level` | Logging level (debug, info, warning, error) | `info` |
| `share_printers` | Share printers on the network | `true` |
| `browsing` | Enable printer browsing/discovery | `true` |
| `allow_remote_admin` | Allow remote web interface access | `true` |

**Important:** Change the default password before exposing to your network!

## Usage

### Adding a Printer

1. Open the CUPS web interface: `http://homeassistant.local:631`
2. Go to **Administration** tab
3. Click **Add Printer**
4. Enter credentials (default: admin/changeme)
5. Select your printer from the list (IPP Everywhere printers auto-detected)
6. Follow the wizard to complete setup

### IPP Everywhere Printers

CUPS 3.x excels at IPP Everywhere printers - they're automatically detected and require no drivers:

```bash
# List discovered printers (from add-on console)
lpstat -e

# Add an IPP Everywhere printer
lpadmin -p MyPrinter -E -v ipp://192.168.1.10/ipp/print -m everywhere
```

### Using with CUPS Integration

After adding printers to CUPS, install the CUPS custom integration:

1. Install via HACS: `https://github.com/98kuwa036/hacs_cups`
2. Add integration in Home Assistant
3. Configure:
   - Host: `core-cups3` or `localhost`
   - Port: `631`
   - SSL: `false`

The integration will automatically discover your printers and create sensors for:
- Printer status
- Ink/toner levels
- Page counts
- Job status

## Supported Printers

### ✅ Fully Supported

- **IPP Everywhere** compatible printers (native support)
- **AirPrint** enabled printers
- **Mopria** certified printers
- Modern printers from:
  - HP (2012+)
  - Canon (2014+)
  - Epson (2014+)
  - Brother (2012+)

### ❌ Not Supported

- Legacy printers requiring PPD files (CUPS 3 removed PPD support)
- Printers needing proprietary drivers
- Very old models (pre-2012)

### Checking Compatibility

```bash
# Discover IPP printers on network
ippfind

# Or using avahi
avahi-browse -rt _ipp._tcp
avahi-browse -rt _ipps._tcp
```

## Differences from CUPS 2.x

This add-on uses genuine CUPS 3.x from OpenPrinting:

| Feature | CUPS 2.x | CUPS 3.x (This Add-on) |
|---------|----------|------------------------|
| Source | Package/Alpine | OpenPrinting source |
| PPD Files | ✅ Supported | ❌ Removed |
| IPP Everywhere | ⚠️ Partial | ✅ Native |
| Driver Installation | Required | Never needed |
| Legacy Printers | ✅ Supported | ❌ Not supported |
| Performance | Standard | Optimized |
| Memory Usage | Higher | Lower |
| Build Time | Seconds | 5-10 minutes (first time) |

## Troubleshooting

### First Installation Takes Long

- This is normal! Building CUPS from source takes 5-10 minutes
- Subsequent updates are faster
- Check logs to see build progress

### Printer Not Found

1. Ensure printer supports IPP Everywhere
2. Check if printer is on same network
3. Try `ippfind` from add-on console
4. Verify firewall allows port 631

### Build Fails

If the build fails during installation:
1. Check add-on logs
2. Ensure sufficient disk space (at least 500MB free)
3. Try rebuilding: Stop add-on → Rebuild → Start

## Advanced

### Checking CUPS Version

From add-on logs or console:
```bash
cupsd --version
```

### Custom Configuration

The generated `/etc/cups/cupsd.conf` can be modified for advanced setups. Changes persist until add-on restart.

## Support

- **Issues**: [GitHub Issues](https://github.com/98kuwa036/cups3-addon/issues)
- **CUPS Integration**: [hacs_cups](https://github.com/98kuwa036/hacs_cups)
- **OpenPrinting CUPS**: [OpenPrinting GitHub](https://github.com/OpenPrinting/cups)

## Credits

- **OpenPrinting CUPS**: [OpenPrinting Foundation](https://openprinting.github.io/)
- **CUPS 3 Source**: [GitHub](https://github.com/OpenPrinting/cups)
- **Home Assistant**: [Home Assistant](https://www.home-assistant.io/)

## License

Apache License 2.0

Copyright (c) 2024 98kuwa036

CUPS is licensed under Apache License 2.0 by OpenPrinting
