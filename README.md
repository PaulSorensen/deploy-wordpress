# Deploy WordPress

## Overview
**Deploy WordPress** is a Bash script that automates the deployment of the latest WordPress release. It downloads, extracts, configures, and sets up the necessary permissions, making WordPress ready to use in seconds.

## Features
- Automatically downloads the latest stable version of WordPress.
- Deploys WordPress to the specified directory.
- Configures file ownership and permissions for security.
- Creates necessary writable directories for caching and uploads.
- Generates and secures the `wp-config.php` file with user-provided database credentials.

## Requirements
Before running the script, ensure that:
- You have `curl` installed for downloading WordPress.
- You have `tar` installed for extracting files.
- You have `sudo` privileges (required for setting ownership and permissions).
- You have a **MariaDB/MySQL database and user** ready.

## Usage
Run the script with the deployment directory as an argument:
   ```bash
   ./deploy-wordpress.sh -d <deployment_directory>
   ```
   Example:
   ```bash
   ./deploy-wordpress.sh -d /var/www/domain.com/wwwroot/
   ```
## Configuration
During execution, the script will ask for:
- **Database Name**
- **Username**
- **Password** (entered securely)

These values will be written to `wp-config.php`, which will then be secured with restrictive permissions.

## Important Notes
- Ensure the specified deployment directory exists or can be created by the script.
- The webserver user (`www-data` by default) must have the correct permissions to access the WordPress files.
- `wp-config.php` is secured with `chmod 400` to prevent unauthorized access.

## Enjoying This Script?
**If you found this script useful, a small tip is appreciated ❤️**
[https://buymeacoffee.com/paulsorensen](https://buymeacoffee.com/paulsorensen)

## License
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.

**Legal Notice:** If you edit and redistribute this code, you must mention the original author, **Paul Sørensen** ([paulsorensen.io](https://paulsorensen.io)), in the redistributed code or documentation.

**Copyright (C) 2025 Paul Sørensen ([paulsorensen.io](https://paulsorensen.io))**

See the LICENSE file in this repository for the full text of the GNU General Public License v3.0, or visit [https://www.gnu.org/licenses/gpl-3.0.txt](https://www.gnu.org/licenses/gpl-3.0.txt).