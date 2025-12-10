# CUPS 3 (OpenPrinting) Enhanced Add-on for Home Assistant

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg

## About

**Advanced CUPS 3.x print server for Home Assistant**, built directly from OpenPrinting CUPS source code with extensive enhancements for seamless integration with the [CUPS Custom Integration](https://github.com/98kuwa036/hacs_cups).

### Key Features

- **CUPS 3.x from Source** - Latest OpenPrinting CUPS repository
- **Auto-Discovery** - Automatic IPP Everywhere printer detection
- **Backup/Restore** - Automated configuration backup and recovery
- **IPP/IPPS Support** - Secure printing with SSL/TLS
- **Management Tools** - Built-in printer management utilities
- **Home Assistant Integration** - Perfect companion for CUPS integration
- **Multi-arch Support** - Pre-built images for all architectures
- **Professional CI/CD** - Automated builds via GitHub Actions

## Installation

1. Add this repository to your Home Assistant Add-on Store:
   ```
   https://github.com/98kuwa036/cups3-addon
   ```
2. Install the "CUPS 3 (OpenPrinting) Enhanced" add-on
3. Configure the add-on (see Configuration section)
4. Start the add-on
5. Access web interface: `http://homeassistant.local:631`

## Configuration

### Basic Configuration

```yaml
admin_user: "admin"
admin_password: "changeme"  # IMPORTANT: Change this!
log_level: "info"
share_printers: true
browsing: true
allow_remote_admin: true
```

### Auto-Discovery (New!)

Automatically detect and configure IPP Everywhere printers on your network:

```yaml
auto_discovery: true
broadcast_interval: 30  # Discovery scan interval in seconds
```

### IPP/IPPS Security

Enable secure printing with SSL/TLS:

```yaml
enable_ipps: false
ssl_cert: "/ssl/fullchain.pem"
ssl_key: "/ssl/privkey.pem"
require_encryption: false
```

### Performance & Limits

```yaml
max_jobs: 500
max_jobs_per_printer: 100
job_history: true
preserve_job_history: true
preserve_job_files: "1d"  # 1h, 6h, 1d, 7d, 30d, forever
```

### Backup & Maintenance

```yaml
auto_backup: true
backup_retention_days: 7
cleanup_temp_files: true
```

### Security

Restrict access to specific networks:

```yaml
allowed_networks:
  - "192.168.1.0/24"
  - "10.0.0.0/8"
```

### Advanced Options

```yaml
access_log: true
page_log: true
max_log_size: "10m"  # 1m, 5m, 10m, 50m, 100m, unlimited
debug_logging: false
raw_printing: true
legacy_printer_support: false
```

### Integration Support

```yaml
enable_api: true
api_polling_interval: 30
publish_printer_info: true
```

## Complete Configuration Example

```yaml
# Basic
admin_user: "admin"
admin_password: "MySecurePassword123!"
log_level: "info"

# Printer Sharing
share_printers: true
browsing: true
allow_remote_admin: true
auto_discovery: true
broadcast_interval: 30

# Security (IPPS)
enable_ipps: true
ssl_cert: "/ssl/fullchain.pem"
ssl_key: "/ssl/privkey.pem"
require_encryption: false

# Performance
max_jobs: 1000
max_jobs_per_printer: 200
job_history: true
preserve_job_history: true
preserve_job_files: "7d"

# Security & Access
access_log: true
page_log: true
max_log_size: "50m"
allowed_networks:
  - "192.168.1.0/24"

# Backup
auto_backup: true
backup_retention_days: 14
cleanup_temp_files: true

# Integration
enable_api: true
api_polling_interval: 30
publish_printer_info: true

# Advanced
debug_logging: false
raw_printing: true
legacy_printer_support: false
```

## Management Utilities

The addon includes powerful command-line utilities accessible via SSH/Terminal:

### Printer Management

```bash
# List all printers
cups-manage list

# Show printer details
cups-manage show <printer>

# Send test page
cups-manage test <printer>

# Enable/disable printer
cups-manage enable <printer>
cups-manage disable <printer>

# Pause/resume printer
cups-manage pause <printer>
cups-manage resume <printer>

# View print queue
cups-manage queue [printer]

# Cancel jobs
cups-manage cancel [printer]

# Show printer statistics
cups-manage stats <printer>
```

### Backup & Restore

```bash
# Create manual backup
cups-backup backup

# List available backups
cups-backup list

# Restore from backup
cups-backup restore /config/cups-backups/cups_backup_YYYYMMDD_HHMMSS.tar.gz

# Cleanup old backups
cups-backup cleanup
```

### Auto-Discovery

Auto-discovery runs automatically based on your configuration. Printers are:
- Detected via mDNS/Zeroconf
- Automatically configured using IPP Everywhere (driverless)
- Enabled and ready to print

## Using with CUPS Integration

This addon is the perfect companion for the [CUPS Custom Integration](https://github.com/98kuwa036/hacs_cups).

### Installation

1. **Install this addon** and configure it
2. **Install CUPS Integration** via HACS:
   - Add custom repository: `https://github.com/98kuwa036/hacs_cups`
   - Install "CUPS" integration
3. **Configure integration** in Home Assistant:
   - Host: `core-cups3` or `localhost`
   - Port: `631`
   - SSL: `false` (or `true` if using IPPS)

### What You Get

The integration provides:
- **Sensors** - Printer status, ink/toner levels, queue length
- **Binary Sensors** - Printer connectivity
- **Device Info** - Model, manufacturer, firmware, serial number
- **Services** - Pause/resume printers, cancel jobs, manage queue

### Example Automation

```yaml
automation:
  - alias: "Low Ink Alert"
    trigger:
      - platform: numeric_state
        entity_id: sensor.hp_laserjet_black_toner
        below: 20
    action:
      - service: notify.mobile_app
        data:
          message: "Printer ink below 20%!"
```

## Features Comparison

| Feature | Basic CUPS | This Addon |
|---------|-----------|------------|
| CUPS 3.x from Source | ✓ | ✓ |
| IPP Everywhere | ✓ | ✓ |
| Web Interface | ✓ | ✓ |
| Auto-Discovery | ✗ | ✓ |
| Backup/Restore | ✗ | ✓ |
| Management Tools | ✗ | ✓ |
| IPPS (SSL/TLS) | ✗ | ✓ |
| Network Restrictions | ✗ | ✓ |
| Job Limits | ✗ | ✓ |
| Enhanced Logging | ✗ | ✓ |
| HA Integration Ready | ✗ | ✓ |

## Troubleshooting

### Printers Not Auto-Discovered

1. Ensure `auto_discovery: true` in configuration
2. Check that printers support IPP Everywhere
3. Verify network connectivity
4. Enable `debug_logging: true` for detailed logs

### IPPS Not Working

1. Ensure valid SSL certificates exist at configured paths
2. Use Let's Encrypt certificates from Home Assistant
3. Check `enable_ipps: true` in configuration
4. Verify certificate permissions

### Backup Restore Failed

1. Stop the addon before restoring
2. Ensure backup file exists in `/config/cups-backups/`
3. Check backup file integrity
4. Review addon logs for specific errors

### Integration Not Finding Printers

1. Verify addon is running
2. Check host setting (`core-cups3` or `localhost`)
3. Ensure port 631 is accessible
4. Enable `enable_api: true` in addon configuration

## Development

### Building Locally

```bash
git clone https://github.com/98kuwa036/cups3-addon.git
cd cups3-addon

docker build \
  --build-arg BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.19 \
  --build-arg BUILD_ARCH=amd64 \
  --build-arg CUPS_VERSION=3.0.0 \
  -t cups3-addon:local \
  .
```

### GitHub Actions

Automated workflows:
- **Build on push** - All architectures on push to main
- **Release on tag** - GitHub release when version tag is pushed
- **Pull request** - Build tests on PRs

Images published to:
```
ghcr.io/98kuwa036/cups3-addon-aarch64
ghcr.io/98kuwa036/cups3-addon-amd64
ghcr.io/98kuwa036/cups3-addon-armhf
ghcr.io/98kuwa036/cups3-addon-armv7
```

## Support

- **Issues**: [GitHub Issues](https://github.com/98kuwa036/cups3-addon/issues)
- **CUPS Integration**: [hacs_cups](https://github.com/98kuwa036/hacs_cups)
- **OpenPrinting CUPS**: [GitHub](https://github.com/OpenPrinting/cups)
- **Home Assistant Community**: [Forum](https://community.home-assistant.io/)

## License

Apache License 2.0 - Copyright (c) 2024 98kuwa036

## Credits

- OpenPrinting CUPS Project
- Home Assistant Team
- pyipp Library Contributors
