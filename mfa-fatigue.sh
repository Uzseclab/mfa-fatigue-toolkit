#!/bin/bash

# MFA Fatigue Toolkit
# Author: Red Team Operator
# Description: Smart password spraying with MFA fatigue capabilities

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CONFIG_FILE="config/config.conf"
TARGETS_FILE="config/targets.conf"

# Load configuration
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    echo -e "${RED}Error: Configuration file not found!${NC}"
    exit 1
fi

# Load targets
if [[ -f "$TARGETS_FILE" ]]; then
    source "$TARGETS_FILE"
else
    echo -e "${RED}Error: Targets file not found!${NC}"
    exit 1
fi

# Function to display help
show_help() {
    echo "MFA Fatigue Toolkit"
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -m, --mode MODE        Specify MFA provider (azure, okta, duo)"
    echo "  -t, --target TARGET    Target URL or domain"
    echo "  -u, --users USERS      Users file path"
    echo "  -p, --passwords PASS   Passwords file path"
    echo "  -r, --rate RATE        Requests per second (default: 1)"
    echo "  -d, --delay DELAY      Delay between requests (default: 0)"
    echo "  -l, --log LOG          Log file path"
    echo "  -h, --help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 -m azure -t 'contoso.onmicrosoft.com' -u users.txt -p passwords.txt"
    echo "  $0 -m okta -t 'contoso.okta.com' -u users.txt -p passwords.txt -r 2 -d 5"
}

# Function to log messages
log_message() {
    local level=$1
    local message=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

# Function to validate inputs
validate_inputs() {
    if [[ -z "$TARGET" ]]; then
        log_message "ERROR" "Target not specified"
        show_help
        exit 1
    fi
    
    if [[ -z "$USERS_FILE" ]]; then
        log_message "ERROR" "Users file not specified"
        show_help
        exit 1
    fi
    
    if [[ -z "$PASSWORDS_FILE" ]]; then
        log_message "ERROR" "Passwords file not specified"
        show_help
        exit 1
    fi
    
    if [[ ! -f "$USERS_FILE" ]]; then
        log_message "ERROR" "Users file not found: $USERS_FILE"
        exit 1
    fi
    
    if [[ ! -f "$PASSWORDS_FILE" ]]; then
        log_message "ERROR" "Passwords file not found: $PASSWORDS_FILE"
        exit 1
    fi
}

# Function to check if a user exists in the targets list
user_exists() {
    local user=$1
    grep -q "^$user$" "$USERS_FILE" 2>/dev/null
}

# Function to randomize timing
randomize_delay() {
    local min_delay=$1
    local max_delay=$2
    local random_delay=$((RANDOM % (max_delay - min_delay + 1) + min_delay))
    sleep "$random_delay"
}

# Function to simulate MFA fatigue
simulate_mfa_fatigue() {
    local mode=$1
    local target=$2
    local users_file=$3
    local passwords_file=$4
    local rate=$5
    local delay=$6
    
    log_message "INFO" "Starting MFA fatigue attack on $target using $mode mode"
    
    # Get number of users
    local user_count=$(wc -l < "$users_file")
    local pass_count=$(wc -l < "$passwords_file")
    
    log_message "INFO" "Targeting $user_count users with $pass_count passwords"
    
    # Initialize counters
    local success_count=0
    local fail_count=0
    local mfa_count=0
    
    # Process users and passwords
    while IFS= read -r user; do
        # Skip empty lines
        [[ -z "$user" ]] && continue
        
        # Randomize delay between user attempts
        if [[ $delay -gt 0 ]]; then
            randomize_delay 0 $delay
        fi
        
        # Process each password
        while IFS= read -r password; do
            # Skip empty lines
            [[ -z "$password" ]] && continue
            
            # Randomize timing between password attempts
            if [[ $rate -gt 0 ]]; then
                randomize_delay 0 $((1000 / rate))
            fi
            
            # Perform authentication attempt
            local result=$(perform_authentication "$mode" "$target" "$user" "$password")
            
            # Parse result
            local status=$(echo "$result" | cut -d'|' -f1)
            local mfa_detected=$(echo "$result" | cut -d'|' -f2)
            local details=$(echo "$result" | cut -d'|' -f3-)
            
            # Log result
            if [[ "$status" == "success" ]]; then
                log_message "SUCCESS" "Authentication successful for $user: $details"
                ((success_count++))
            elif [[ "$status" == "mfa" ]]; then
                log_message "MFA" "MFA required for $user: $details"
                ((mfa_count++))
                ((success_count++))
            else
                log_message "FAILED" "Authentication failed for $user: $details"
                ((fail_count++))
            fi
            
            # Randomize delay after each attempt
            randomize_delay 1 3
        done < "$passwords_file"
        
        # Simulate MFA fatigue (random delay between users)
        randomize_delay 2 5
    done < "$users_file"
    
    # Final report
    log_message "INFO" "Attack completed"
    log_message "INFO" "Successful authentications: $success_count"
    log_message "INFO" "MFA required: $mfa_count"
    log_message "INFO" "Failed attempts: $fail_count"
}

# Function to perform authentication based on mode
perform_authentication() {
    local mode=$1
    local target=$2
    local user=$3
    local password=$4
    
    # This would normally call the appropriate module
    case "$mode" in
        azure)
            # Simulate Azure AD authentication
            echo "mfa|true|Azure AD MFA required"
            ;;
        okta)
            # Simulate Okta authentication
            echo "mfa|true|Okta MFA required"
            ;;
        duo)
            # Simulate Duo authentication
            echo "mfa|true|Duo MFA required"
            ;;
        *)
            # Default to generic
            echo "success|false|Generic authentication successful"
            ;;
    esac
}

# Function to initialize the toolkit
initialize_toolkit() {
    # Create necessary directories
    mkdir -p logs config payloads
    
    # Create default configuration
    if [[ ! -f "$CONFIG_FILE" ]]; then
        cat > "$CONFIG_FILE" << EOF
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
    fi
    
    # Create default targets file
    if [[ ! -f "$TARGETS_FILE" ]]; then
        cat > "$TARGETS_FILE" << EOF
# Target configuration file

# Target URL or domain
TARGET=""

# Users file
USERS_FILE="payloads/users.txt"

# Passwords file
PASSWORDS_FILE="payloads/passwords.txt"
EOF
    fi
    
    # Create default payloads
    if [[ ! -f "payloads/users.txt" ]]; then
        cat > "payloads/users.txt" << EOF
admin@contoso.com
user1@contoso.com
user2@contoso.com
user3@contoso.com
EOF
    fi
    
    if [[ ! -f "payloads/passwords.txt" ]]; then
        cat > "payloads/passwords.txt" << EOF
Password123!
Welcome123!
Admin123!
Test123!
Passw0rd!
EOF
    fi
    
    log_message "INFO" "Toolkit initialized successfully"
}

# Main execution
main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -m|--mode)
                MODE="$2"
                shift 2
                ;;
            -t|--target)
                TARGET="$2"
                shift 2
                ;;
            -u|--users)
                USERS_FILE="$2"
                shift 2
                ;;
            -p|--passwords)
                PASSWORDS_FILE="$2"
                shift 2
                ;;
            -r|--rate)
                RATE="$2"
                shift 2
                ;;
            -d|--delay)
                DELAY="$2"
                shift 2
                ;;
            -l|--log)
                LOG_FILE="$2"
                shift 2
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                echo "Unknown option $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Initialize toolkit if needed
    initialize_toolkit
    
    # Set defaults
    : ${MODE:=$DEFAULT_MODE}
    : ${TARGET:=$TARGET}
    : ${USERS_FILE:=$USERS_FILE}
    : ${PASSWORDS_FILE:=$PASSWORDS_FILE}
    : ${RATE:=$DEFAULT_RATE}
    : ${DELAY:=$DEFAULT_DELAY}
    : ${LOG_FILE:=$LOG_FILE}
    
    # Validate inputs
    validate_inputs
    
    # Run the attack
    simulate_mfa_fatigue "$MODE" "$TARGET" "$USERS_FILE" "$PASSWORDS_FILE" "$RATE" "$DELAY"
}

# Run main function with all arguments
main "$@"
