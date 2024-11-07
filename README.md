
# TP2024-25 SUMO Dockerized

This repository provides a Dockerized setup to run a headless SUMO (Simulation of Urban MObility) instance alongside a Python data collection service. 
## Prerequisites

- [Docker](https://www.docker.com/get-started) and [Docker Compose](https://docs.docker.com/compose/install/) installed on your system.

## Usage

You can either build and run the setup directly from this repository or pull the pre-built image from GitHub Container Registry.

### Option 1: Build and Run with Docker Compose

Clone the repository and navigate to its directory:

```bash
git clone https://github.com/dominikmifkovic/tp2024-25_sumo_dockerized.git
cd tp2024-25_sumo_dockerized
```

Then, use Docker Compose to build and start the containers:

```bash
docker-compose up --build
```


### Option 2: Run with Pre-Built Docker Image

If you prefer not to build the image locally, you can pull the pre-built Docker image from GitHub Container Registry and run it.

#### Pull the Image

```bash
docker pull ghcr.io/dominikmifkovic/tp2024-25_sumo_dockerized:latest
```

#### Run the Container

```bash
docker run -d -v ./simulations:/simulations -v ./results:/results --name sumo_dockerized ghcr.io/dominikmifkovic/tp2024-25_sumo_dockerized:latest
```

- The results will be located in the `results` volume inside the container.

### Accessing Simulation Results

Simulation data is saved in JSON format in the `results` directory. Each JSON file will contain detailed information about each simulation step, including vehicle position, speed, and other metrics.

## Notes

- Ensure the `simulations` directory contains the required SUMO configuration files (`.sumocfg`) before running.
- Modify the SUMO configuration file path in `docker-compose.yml` or as per your specific setup.
