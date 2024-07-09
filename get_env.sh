#!/bin/bash

# Read JSON string from stdin into a variable
read -r json_string

# Use awk to parse the JSON string
value=$(echo "$json_string" | awk -F'[":,]' '/"name"/ {print $(NF-1)}')

echo "{\"value\": \"${!value}\"}"
