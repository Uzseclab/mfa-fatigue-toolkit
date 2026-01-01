#!/bin/bash

# MFA Fatigue Toolkit Installation Script

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}This script should not be run as root${NC}"
   exit 1
fi

# Create directories
echo -e "${BLUE}Creating directories...${NC}"
mkdir -p logs config payloads modules

# Make main script executable
echo -e "${BLUE}Setting up executable permissions...${NC}"
chmod +x mfa-fatigue.sh

# Create sample files
echo -e "${BLUE}Creating sample payload files...${NC}"

# Sample users file
cat > payloads/users.txt << EOF
admin@contoso.com
user1@contoso.com
user2@contoso.com
user3@contoso.com
user4@contoso.com
user5@contoso.com
EOF

# Sample passwords file
cat > payloads/passwords.txt << EOF
Password123!
Welcome123!
Admin123!
Test123!
Passw0rd!
Summer2023!
Winter2023!
Spring2023!
Fall2023!
Default123!
EOF

# Create default config files
echo -e "${BLUE}Creating configuration files...${NC}"

# Configuration file
cat > config/config.conf << EOF
# MFA Fatigue Toolkit Configuration

# Default rate (requests per second)
DEFAULT_RATE=1

# Default delay between requests (seconds)
DEFAULT_DELAY=0

# Log file location
LOG_FILE="logs/mfa-fatigue.log"

# Default MFA provider
DEFAULT_MODE="azure"

# Default targets file
DEFAULT_TARGETS="config/targets.conf"
EOF

# Targets file
cat > config/targets.conf << EOF
# Target configuration file

# Target URL or domain
TARGET=""

# Users file
USERS_FILE="payloads/users.txt"

# Passwords file
PASSWORDS_FILE="payloads/passwords.txt"
EOF

# Create log directory
mkdir -p logs

# Print success message
echo -e "${GREEN}MFA Fatigue Toolkit installation complete!${NC}"
echo -e "${YELLOW}Usage examples:${NC}"
echo -e "  ${BLUE}./mfa-fatigue.sh -m azure -t 'contoso.onmicrosoft.com' -u payloads/users.txt -p payloads/passwords.txt${NC}"
echo -e "  ${BLUE}./mfa-fatigue.sh -m okta -t 'contoso.okta.com' -u payloads/users.txt -p payloads/passwords.txt -r 2 -d 5${NC}"
echo -e "${YELLOW}For more information, run:${NC}"
echo -e "  ${BLUE}./mfa-fatigue.sh --help${NC}"
