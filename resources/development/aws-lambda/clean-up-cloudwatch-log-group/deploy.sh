#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$REPO_ROOT" ]; then
    echo "Not a git repository or unable to determine repository root."
    exit 1
fi

check_install_zip() {
    if ! zip -v &> /dev/null; then
        echo "Zip is not installed. Installing now..."
        OS="`uname`"
        case $OS in
          'Linux')
            sudo apt update
            sudo apt install zip -y
            ;;
          'Darwin')
            if type brew &>/dev/null; then
                brew install zip
            else
                echo "Homebrew is not installed. Please install Homebrew first or install zip manually."
            fi
            ;;
          *)
            echo "Unsupported operating system."
            return 1
            ;;
        esac
    else
        echo "Zip is already installed."
    fi
}


zip_lambda() {
    cd $REPO_ROOT/resources/development/aws-lambda/clean-up-cloudwatch-log-group
    ZIP_FILE="lambda_function.zip"
    PYTHON_FILE="lambda_function.py"

    if [ -f "$ZIP_FILE" ]; then
        echo "$ZIP_FILE exists. Deleting it..."
        rm "$ZIP_FILE"
        echo "$ZIP_FILE has been deleted."
    fi
    if [ -f "$PYTHON_FILE" ]; then
        zip "$ZIP_FILE" "$PYTHON_FILE"

    else
        echo "$PYTHON_FILE not found in the current directory."
        exit 1
    fi
}

confirm_apply() {
    while true; do
        read -p "Do you want to proceed with 'terraform apply'? (yes/y to approve, no/n to cancel): " user_input
        user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]' | xargs)
        case $user_input in
            "yes" | "y")
                return 0
                ;;
            "no" | "n")
                return 1
                ;;
            *)
                echo "Invalid input. You must choose 'yes/y' to approve or 'no/n' to cancel."
                ;;
        esac
    done
}

main() {
    echo -e "\nRunning 'terraform init'..."
    terraform init
    if [ $? -ne 0 ]; then
        echo "Error: 'terraform init' failed. Exiting."
        exit 1
    fi
    echo -e "\nRunning 'terraform fmt'..."
    terraform fmt
    if [ $? -ne 0 ]; then
        echo "Error: 'terraform fmt' failed. Exiting."
        exit 1
    fi
    echo -e "\nRunning 'terraform plan'..."
    terraform plan
    if [ $? -ne 0 ]; then
        echo "Error: 'terraform plan' failed. Exiting."
        exit 1
    fi
    if confirm_apply; then
        echo -e "\nRunning 'terraform apply'..."
        terraform apply -auto-approve
        if [ $? -ne 0 ]; then
            echo "Error: 'terraform apply' failed. Exiting."
            exit 1
        fi
    else
        echo "Terraform apply canceled by the user."
    fi
}

check_install_zip
zip_lambda
main