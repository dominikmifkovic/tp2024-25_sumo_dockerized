#!/bin/bash
echo "Starting the SUMO server..."
sumo --remote-port 1337 -c /simulations/sim1/osm.sumocfg &
sleep 1
echo "Running the data collection script..."
python3 /datacollect.py
