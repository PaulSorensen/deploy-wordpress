#!/bin/bash
################################################################################
#  Script Name : Deploy Wordpress
#  Author      : Paul Sørensen
#  Website     : https://paulsorensen.io
#  GitHub      : https://github.com/paulsorensen
#  Version     : 1.0
#  Last Update : 25.02.2025
#
#  Description:
#  Downloads the latest Wordpress, deploys and configures it, ready to use!
#
#  Usage:
#  Create MariaDB/MySQL user and database first, then run:
#  ./deploy-wordpress.sh -d <deployment_directory>
#
#  If you found this script useful, a small tip is appreciated ❤️
#  https://buymeacoffee.com/paulsorensen
################################################################################

# Exit immediately if a command exits with a non-zero status
set -e

BLUE='\033[38;5;81m'
NC='\033[0m'
echo -e "${BLUE}Deploy WordPress by paulsorensen.io${NC}"
echo ""

# Parse command-line arguments
while getopts "d:" opt; do
    case "$opt" in
        d) WP_DIR="$OPTARG" ;;
        *) echo "Usage: $0 -d <deployment_directory>"; exit 1 ;;
    esac
done

# Ensure the directory is provided
if [ -z "$WP_DIR" ]; then
    echo "Error: Deployment directory not specified."
    echo "Use -d <deployment_directory>."
    echo "Example: ./deploy-wordpress.sh -d /var/www/domain.com/wwwroot/"
    exit 1
fi

# Ensure the directory exists or create it
mkdir -p "$WP_DIR"

# Change to the deployment directory
cd "$WP_DIR"

# Download the latest stable WordPress using curl
echo "Downloading the latest WordPress..."
curl -sL https://wordpress.org/latest.tar.gz -o latest.tar.gz

# Extract WordPress files
echo "Extracting WordPress..."
tar -xzf latest.tar.gz --strip-components=1

# Remove the downloaded tar file
rm -f latest.tar.gz

# Set correct ownership (change 'www-data' to the webserver user if different)
echo "Setting correct file ownership..."
sudo chown -R www-data:www-data "$WP_DIR"

# Ensure required writable directories exist
mkdir -p "$WP_DIR/wp-content/cache"
mkdir -p "$WP_DIR/wp-content/uploads"
sudo chown -R www-data:www-data "$WP_DIR/wp-content/cache"
sudo chown -R www-data:www-data "$WP_DIR/wp-content/uploads"

# Set secure permissions
echo "Setting secure file permissions..."
find "$WP_DIR" -type d -exec chmod 750 {} \;  # Directories: Read & execute for owner/group, no access for others
find "$WP_DIR" -type f -exec chmod 640 {} \;  # Files: Read & write for owner, read-only for group, no access for others

# Set permissions for writable directories
echo "Setting permissions for writable directories..."
chmod 755 "$WP_DIR/wp-content"
chmod 755 "$WP_DIR/wp-content/cache"
chmod 755 "$WP_DIR/wp-content/uploads"

# Configure wp-config.php
echo "Configuring wp-config.php..."
if [ -f "$WP_DIR/wp-config-sample.php" ]; then
    read -p "Enter database name: " DB_NAME
    read -p "Enter database username: " DB_USER
    read -s -p "Enter database password: " DB_PASS
    echo
    
    DB_PASS_ESCAPED=$(printf "%q" "$DB_PASS")
    
    sed -i "s/define( 'DB_NAME', 'database_name_here' );/define( 'DB_NAME', '$DB_NAME' );/g" "$WP_DIR/wp-config-sample.php"
    sed -i "s/define( 'DB_USER', 'username_here' );/define( 'DB_USER', '$DB_USER' );/g" "$WP_DIR/wp-config-sample.php"
    sed -i "s/define( 'DB_PASSWORD', 'password_here' );/define( 'DB_PASSWORD', '$DB_PASS_ESCAPED' );/g" "$WP_DIR/wp-config-sample.php"
    
    mv "$WP_DIR/wp-config-sample.php" "$WP_DIR/wp-config.php"
    chmod 400 "$WP_DIR/wp-config.php"
    echo "wp-config.php successfully created and secured."
else
    echo "Error: wp-config-sample.php not found. Skipping configuration."
fi

echo -e "${BLUE}WordPress successfully deployed to: $WP_DIR${NC}"