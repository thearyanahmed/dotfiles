#!/bin/bash

# Define the URL
URL="http://localhost:3000"

# Call the routes without waiting for responses
curl "$URL/first" &
curl "$URL/second" &
curl "$URL/third" &

# Optional: Wait for the background processes to finish (if needed)
# wait
