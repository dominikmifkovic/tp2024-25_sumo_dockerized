import traci
import json

SUMO_PORT = 1337
SUMO_IP = 'sumo'
try:
    traci.init(port=SUMO_PORT, host=SUMO_IP)
    print("Connected to SUMO.")
    steps = 1
    all_data = []
    
    while traci.simulation.getMinExpectedNumber() > 0:
        step_data = []
        vehicle_ids = traci.vehicle.getIDList()
        for veh_id in vehicle_ids:
            position = traci.vehicle.getPosition(veh_id)
            speed = traci.vehicle.getSpeed(veh_id)
            lane_id = traci.vehicle.getLaneID(veh_id)
            acceleration = traci.vehicle.getAcceleration(veh_id)
            vehicle_data = {
                "Vehicle ID": veh_id,
                "Position X": position[0],
                "Position Y": position[1],
                "Speed": f"{speed:.2f}",
                "Acceleration": acceleration,
                "Lane ID": lane_id
            }
            step_data.append(vehicle_data)
        all_data.append({"Step": steps, "Vehicles": step_data})
        print(f"Step {steps} completed")
        steps += 1
        traci.simulationStep()
    with open("/results/vehicle_data.json", mode="w", newline="") as file:
        json.dump(all_data, file)
except traci.exceptions.FatalTraCIError as e:
    print(f"Fatal error during TraCI operation: {e}")
except Exception as e:
    print(f"Connection failed: {e}")
finally:
    traci.close()
    exit(0)
