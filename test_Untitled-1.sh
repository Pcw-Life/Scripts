#!/bin/sh

# Test script for Untitled-1

# Function to check if a file exists
check_file_exists() {
      if [ ! -f "$1" ]; then
            echo "Test failed: $1 does not exist."
            exit 1
      fi
}

# Function to check if a file is a valid zip
check_valid_zip() {
      if ! unzip -t "$1" > /dev/null 2>&1; then
            echo "Test failed: $1 is not a valid zip file."
            exit 1
      fi
}

# Create a temporary .unf file for testing
TEST_UNF=$(mktemp)
echo "This is a test file." > "${TEST_UNF}"

# Create a temporary output file
TEST_ZIP=$(mktemp).zip

# Run the script with the test files
'/Users/pcwprops/Library/Mobile Documents/com~apple~CloudDocs/_PCWProps/_PCW|Integrates/Jeff Young/unifi_os_backup_1725634484897_45ea0f88-1c0a-45ac-8a4f-dcb08f94dccc.unifi' "${TEST_UNF}" "${TEST_ZIP}"

# Check if the output file was created
check_file_exists "${TEST_ZIP}"

# Check if the output file is a valid zip file
check_valid_zip "${TEST_ZIP}"

# Clean up
rm -f "${TEST_UNF}" "${TEST_ZIP}"

echo "All tests passed."