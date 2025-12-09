# Changelog

## 3.0.0 (2024-12-09)

### Initial Release

- **CUPS 3.x built from OpenPrinting source code**
- Native IPP Everywhere support (no PPD files)
- Automatic printer discovery via Zeroconf/mDNS
- Web-based administration interface
- Support for USB and network printers
- Integration with Home Assistant CUPS custom integration
- Multi-architecture support (amd64, aarch64, armv7, armhf, i386)

### Features

- **Source Build**: Built directly from OpenPrinting CUPS GitHub repository
- **Latest Features**: Access to cutting-edge CUPS 3.x improvements
- **IPP-Only**: Modern IPP-based printing (no legacy PPD support)
- **AirPrint and Mopria**: Full compatibility
- **Configurable**: Remote access, logging, printer sharing
- **Automatic Service Management**: Startup and monitoring

### Build Details

- Source: `https://github.com/OpenPrinting/cups`
- Version: CUPS 3.0.0 (or latest master branch)
- Build time: ~5-10 minutes (first installation)
- Dependencies: OpenSSL, Avahi, libusb

### Known Limitations

- **Legacy printers** requiring PPD files are not supported (CUPS 3 design)
- **Build time**: First installation takes longer due to source compilation
- **Disk space**: Requires ~500MB for build process
- **Old USB printers**: Some very old models may not work
- **Beta software**: CUPS 3.x is still in active development

### Migration from CUPS 2.x

If migrating from CUPS 2.x add-ons:
- IPP Everywhere printers will work seamlessly
- Legacy printers with PPD files will need replacement or CUPS 2.x
- Configuration is compatible
- Printer settings may need to be recreated
