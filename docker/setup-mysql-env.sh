#!/usr/bin/env bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

show_help() {
    cat <<EOF
Usage:  ./setup-mysql-env.sh
                Interactively configure database parameters to .env file.
        ./setup-mysql-env.sh [options]
                Call the function corresponding to option.

Options:
    -h, --help Display this help message
    -t, --test Use parameters in .env to test the database connection
EOF
}

print_message() {
    local type=$1
    local message=$2
    case $type in
    "info")
        echo -e "${BLUE}$message${NC}"
        ;;
    "success")
        echo -e "${GREEN}$message${NC}"
        ;;
    "error")
        echo -e "${RED}$message${NC}"
        ;;
    *)
        echo -e "${BLUE}$message${NC}"
        ;;
    esac
}

get_env_value() {
    local key=$1
    local default=$2
    local value=""

    if [ -f ".env" ]; then
        value=$(grep "^${key}=" .env | cut -d '=' -f2-)
    fi

    echo "${value:-$default}"
}

get_user_input() {
    local prompt="$1"
    local default="$2"
    local user_input

    if [ -n "$default" ]; then
        read -p "$(echo -e $BLUE"$prompt [Current: $default]: "$NC)" user_input
        echo "${user_input:-$default}"
    else
        read -p "$(echo -e $BLUE"$prompt: "$NC)" user_input
        echo "$user_input"
    fi
}

if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        cp .env.example .env
        print_message "success" "Copied .env.example into .env successfully"
    else
        print_message "error" "ERROR: .env.example not found"
        exit 1
    fi
fi

update_env() {
    local key=$1
    local value=$2
    local file=".env"

    if grep -q "^${key}=" "$file"; then
        if [ "$(uname)" == "Darwin" ]; then
            sed -i '' "s|^${key}=.*|${key}=${value}|" "$file"
        else
            sed -i "s|^${key}=.*|${key}=${value}|" "$file"
        fi
        if [ $? -ne 0 ]; then
            if [ "$(uname)" == "Darwin" ]; then
                sed -i '' "s|^${key}=.*|#${key}=|" "$file" 2&1 >/dev/null
            else
                sed -i "s|^${key}=.*|#${key}=|" "$file" 2&1 >/dev/null
            fi
            echo "${key}=${value}" >>"$file"
        fi
    else
        echo "${key}=${value}" >>"$file"
    fi
}

current_db_host=$(get_env_value "DB_HOST" "localhost")
current_db_port=$(get_env_value "DB_PORT" "3306")
current_db_user=$(get_env_value "DB_USERNAME" "root")
current_db_password=$(get_env_value "DB_PASSWORD" "")
current_db_name=$(get_env_value "DB_DATABASE" "dify")
current_plugin_db_name=$(get_env_value "DB_PLUGIN_DATABASE" "dify_plugin")

function test_connection() {
    local host=$1
    local port=$2
    local user=$3
    local password=$4
    local db=$5

    mysql -h "$host" -P "$port" -u "$user" -p"$password" -D"$db" -e "SHOW TABLES" 2>&1 >/dev/null

    if [[ $? != 0 ]]; then
        print_message "error" "Connection to database failed, database name: $db \n"
    else
        print_message "success" "Connection to database success, database name: $db \n"
    fi
}

while [[ $# -gt 0 ]]; do
    case $1 in
    -h | --help)
        show_help
        exit 0
        ;;
    -t | --test)
        print_message "info" "Check database connection:\n"
        test_connection "$current_db_host" "$current_db_port" "$current_db_user" "$current_db_password" "$current_db_name"
        exit 0
        ;;
    *)
        echo "Unrecognized option: $1"
        echo "Use '-h' or '--help' to view help message"
        exit 1
        ;;
    esac
done

print_message "info" "Please fill in the database parameters:"
DB_HOST=$(get_user_input "Database Host" "$current_db_host")
DB_PORT=$(get_user_input "Database Port" "$current_db_port")
DB_USERNAME=$(get_user_input "Database Username" "$current_db_user")
DB_PASSWORD=$(get_user_input "Database Password" "$current_db_password")
DB_DATABASE=$(get_user_input "Database Name" "$current_db_name")
DB_PLUGIN_DATABASE=$(get_user_input "Plugin Database Name" "$current_plugin_db_name")

update_env "SQLALCHEMY_DATABASE_URI_SCHEME" "mysql+pymysql"
update_env "DB_HOST" "$DB_HOST"
update_env "DB_PORT" "$DB_PORT"
update_env "DB_USERNAME" "$DB_USERNAME"
update_env "DB_PASSWORD" "$DB_PASSWORD"
update_env "DB_DATABASE" "$DB_DATABASE"

update_env "DB_PLUGIN_DATABASE" "$DB_PLUGIN_DATABASE"

update_env "VECTOR_STORE" "oceanbase"

print_message "success" "\nDatabase parameters are written into .env successfully."

print_message "info" "\nCheck database connection:\n"

test_connection "$DB_HOST" "$DB_PORT" "$DB_USERNAME" "$DB_PASSWORD" "$DB_DATABASE"
