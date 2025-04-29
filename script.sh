#!/bin/bash

# ---------------------------
# Random Password Generator
# ---------------------------

# Function to display usage/help
usage() {
    echo "Usage: $0 [-l length] [-s] [-h]"
    echo "  -l length   Set the password length (minimum: 8, default: 16)"
    echo "  -s          Exclude similar characters (e.g., 1, I, l, O, 0)"
    echo "  -h          Display this help message"
    exit 1
}

# Default password length
PASSWORD_LENGTH=16
EXCLUDE_SIMILAR=false

# Parse command-line arguments
while getopts "l:sh" opt; do
    case "$opt" in
        l)
            PASSWORD_LENGTH=$OPTARG
            if [[ ! "$PASSWORD_LENGTH" =~ ^[0-9]+$ ]] || [ "$PASSWORD_LENGTH" -lt 8 ]; then
                echo "Error: Password length must be a number greater than or equal to 8."
                exit 1
            fi
            ;;
        s)
            EXCLUDE_SIMILAR=true
            ;;
        h)
            usage
            ;;
        *)
            usage
            ;;
    esac
done

# Define character set
ALL_CHARS='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+[]{}|;:,.<>?/'

# Characters to exclude if -s is used
SIMILAR_CHARS='lIO0'

# Remove similar characters if option is enabled
if $EXCLUDE_SIMILAR; then
    ALL_CHARS=$(echo "$ALL_CHARS" | tr -d "$SIMILAR_CHARS")
fi

# Check if character set is not empty
if [ -z "$ALL_CHARS" ]; then
    echo "Error: Character set is empty. Cannot generate password."
    exit 1
fi

# Function to generate a secure random password
generate_password() {
    local length=$1
    local chars=$2
    local password=""

    for ((i = 0; i < length; i++)); do
        rand_char=$(echo -n "$chars" | fold -w1 | shuf | head -n1)
        password+="$rand_char"
    done

    echo "$password"
}

# Generate and print the password
PASSWORD=$(generate_password "$PASSWORD_LENGTH" "$ALL_CHARS")
echo "Generated Password: $PASSWORD"
