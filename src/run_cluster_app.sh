#!/bin/bash

# Start the first process
python -m src.cluster &

# Start the second process
panel serve /code/src/web_app.py --address 0.0.0.0 --port 7860 --allow-websocket-origin "*"

# # Wait for any process to exit
# wait -n

# # Exit with status of process that exited first
# exit $?