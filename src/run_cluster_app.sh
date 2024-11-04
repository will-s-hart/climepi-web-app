#!/bin/bash

# Start the first process
python -m climepi.app.cluster &

# Start the second process
python -m src.web_app

# # Wait for any process to exit
wait -n

# # Exit with status of process that exited first
exit $?