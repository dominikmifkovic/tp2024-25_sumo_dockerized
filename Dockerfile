FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    python3 \
    python3-pip \
    wget \
    git \
    libxerces-c-dev \
    libproj-dev \
    libfox-1.6-dev \
    libgdal-dev \
    dos2unix && apt-get clean
RUN pip3 install numpy scipy traci==1.12.0
COPY sumo /sumo
ENV SUMO_HOME=/sumo
RUN ls /sumo && ls /sumo/CMakeLists.txt
WORKDIR /sumo
RUN mkdir -p build/cmake-build && \
    cd build/cmake-build && \
    cmake ../.. && \
    make -j$(nproc) && \
    make install
ENV PYTHONPATH="/sumo/tools:${PYTHONPATH}"
ENV PATH="/usr/local/bin:$PATH"
WORKDIR /
COPY ./simulations /simulations
RUN mkdir results
COPY ./results /results
COPY datacollect.py /datacollect.py
EXPOSE 1337
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN dos2unix /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
