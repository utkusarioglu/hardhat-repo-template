#!/bin/bash

# Creates an "*.example" file for the given ".env" by stripping out
# The values and the comments.

# This script is very barebones. It does not check whether the .env
# file actually exists. It also doesn't check whether there are more than
# one `.env` file of different flavors such as `.env.local`

env_file=".env"

awk -F'=' '{print $1}' $env_file | \
  awk -F'#' '{print $1}' | \
  awk NF > \
  "$env_file.example"
