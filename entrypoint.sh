#!/bin/bash
echo "Starting the SUMO server..."
/sumo/bin/sumo --remote-port 1337 -c /simulations/sim1/osm.sumocfg &
SUMO_PID=$!
if [ $? -ne 0 ]; then
    echo "Failed to start SUMO server!"
    exit 1
fi
echo "SUMO server started with PID: $SUMO_PID"
echo "Running the data collection script..."
python3 /datacollect.py
if [ $? -ne 0 ]; then
    echo "Data collection script failed!"
    kill $SUMO_PID
    exit 1
fi
wait $SUMO_PID
echo "Completed successfully."
