#!/bin/bash

# Utility functions for MFA Fatigue Toolkit

# Function to generate random delay
generate_random_delay() {
    local min_delay=$1
    local max_delay=$2
    local random_delay=$((RANDOM % (max_delay - min_delay + 1) + min_delay))
    echo $random_delay
}

# Function to log attack details
log_attack_details() {
    local attack_type=$1
    local target=$2
    local user_count=$3
    local password_count=$4
    
    echo "Attack Type: $attack_type" >> "$LOG_FILE"
    echo "Target: $target" >> "$LOG_FILE"
    echo "Users: $user_count" >> "$LOG_FILE"
    echo "Passwords: $password_count" >> "$LOG_FILE"
    echo "Timestamp: $(date)" >> "$LOG_FILE"
    echo "---" >> "$LOG_FILE"
}

# Function to check if a user exists in a file
user_exists() {
    local user=$1
    local file=$2
    grep -q "^$user$" "$file" 2>/dev/null
}
