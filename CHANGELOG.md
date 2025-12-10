# Changelog

## 3.1.0 (2024-12-10) - Enhanced Edition

### Major Features

- **Auto-Discovery** - Automatic IPP Everywhere printer detection and configuration
- **Backup/Restore** - Automated configuration backup and restore functionality
- **Management Utilities** - Built-in command-line tools for printer management
- **IPP/IPPS Support** - Secure printing with SSL/TLS encryption
- **Enhanced Configuration** - Extensive configuration options for advanced users

### New Configuration Options

**Printer Sharing & Discovery:**
- `auto_discovery` - Enable automatic printer detection
- `broadcast_interval` - Set discovery scan interval (10-300 seconds)

**IPP/IPPS Configuration:**
- `enable_ipps` - Enable secure IPP over SSL/TLS
- `ssl_cert` - Path to SSL certificate
- `ssl_key` - Path to SSL private key
- `require_encryption` - Force encrypted connections

**Performance & Limits:**
- `max_jobs` - Maximum total jobs (50-10000)
- `max_jobs_per_printer` - Maximum jobs per printer (10-1000)
- `job_history` - Enable job history tracking
- `preserve_job_history` - Keep completed job history
- `preserve_job_files` - Job file retention period

**Security:**
- `access_log` - Enable access logging
- `page_log` - Enable page logging
- `max_log_size` - Maximum log file size
- `allowed_networks` - Network access restrictions

**Backup & Maintenance:**
- `auto_backup` - Enable automatic backups
- `backup_retention_days` - Backup retention period (1-90 days)
- `cleanup_temp_files` - Automatic temporary file cleanup

**Integration Support:**
- `enable_api` - Enable API for Home Assistant integration
- `api_polling_interval` - Integration polling interval
- `publish_printer_info` - Publish printer information to HA

**Advanced Options:**
- `debug_logging` - Enable detailed debug logs
- `raw_printing` - Enable raw printer access
- `legacy_printer_support` - Enable legacy printer compatibility

### New Management Utilities

**cups-manage** - Printer management tool:
- List all printers
- Show printer details
- Send test pages
- Enable/disable/pause/resume printers
- View print queues
- Cancel jobs
- Show printer statistics

**cups-backup** - Backup and restore tool:
- Create backups manually or automatically
- List available backups
- Restore from backup
- Cleanup old backups
- Preserve printer configurations and job history

**cups-auto-discover** - Auto-discovery service:
- Automatic IPP/IPPS printer detection via mDNS
- Driverless printer configuration
- Continuous background scanning
- Integration with Home Assistant

### Enhanced Features

- **Home Assistant API Integration** - Full API access for custom integration
- **Network Security** - IP-based access restrictions
- **SSL/TLS Support** - Secure printing with IPPS
- **Job Management** - Advanced job limits and history preservation
- **Log Management** - Configurable log levels and sizes
- **Automated Maintenance** - Background cleanup and backup tasks

### Technical Improvements

- Enhanced cupsd.conf generation with all new options
- Improved error handling and logging
- Better resource management
- Optimized for Home Assistant integration compatibility
- Additional runtime utilities (curl, wget, tar, gzip, findutils)

### Integration Compatibility

Designed for seamless integration with [CUPS Custom Integration](https://github.com/98kuwa036/hacs_cups):
- Automatic printer discovery support
- Enhanced IPP protocol compatibility
- API endpoints for integration polling
- Printer information publishing
- Job status tracking

### Breaking Changes

- Version bumped to 3.1.0
- New configuration options (all have sensible defaults)
- `homeassistant_api: true` now enabled by default
- Volume mappings added for config and SSL

### Upgrade Notes

- All new configuration options have defaults; existing configurations will continue to work
- Consider enabling `auto_discovery` for automatic printer setup
- Review new security options (`allowed_networks`, `enable_ipps`)
- Enable `auto_backup` for configuration protection

---

## 3.0.0 (2024-12-09)

### Initial Release

- CUPS 3.x built from OpenPrinting source
- Automated multi-architecture builds via GitHub Actions
- Pre-built Docker images on GitHub Container Registry
- IPP Everywhere native support
- Full Home Assistant integration

### CI/CD

- GitHub Actions workflow for automated builds
- Multi-architecture support (amd64, aarch64, armv7, armhf, i386)
- Automatic image publishing to ghcr.io
- Release automation on version tags

### Features

- Fast installation (pre-built images)
- Latest CUPS 3.x from source
- Professional CI/CD pipeline
- Versioned releases
