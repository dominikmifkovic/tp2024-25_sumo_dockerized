#build
FROM python:3.9-alpine as build-stage
RUN apk add --no-cache \
    build-base \
    cmake \
    git \
    xerces-c-dev \
    proj-dev \
    gdal-dev \
    dos2unix \
    python3-dev \
    py3-pip
COPY sumo /sumo
WORKDIR /sumo
RUN mkdir -p build/cmake-build && \
    cd build/cmake-build && \
    cmake -DSUMO_BUILD_GUI=FALSE \
          -DSUMO_BUILD_NETEDIT=FALSE \
          -DSUMO_BUILD_WEBWIZARD=FALSE \
          -DSUMO_BUILD_TLCGUITOOL=FALSE \
          -DSUMO_BUILD_TESTS=FALSE \
          -DSUMO_BUILD_DOC=FALSE \
          -DSUMO_BUILD_EXAMPLES=FALSE \
          -DSUMO_BUILD_SUMOPY=FALSE \
          -DSUMO_BUILD_NETCONVERT=TRUE \
          -DSUMO_BUILD_NETGENERATE=TRUE \
          ../.. && \
    make -j$(nproc) && \
    make install
RUN find /sumo/bin -type f -executable -exec strip --strip-all {} + || true

#runtime
FROM python:3.9-alpine as runtime-stage
RUN apk add --no-cache \
    xerces-c-dev \
    proj-dev \
    gdal-dev \
    dos2unix \
    libstdc++
RUN pip install --no-cache-dir numpy traci==1.12.0
COPY --from=build-stage /sumo/bin /sumo/bin
COPY --from=build-stage /sumo/tools /sumo/tools
ENV SUMO_HOME=/sumo
ENV PYTHONPATH="/sumo/tools:${PYTHONPATH}"
ENV PATH="/sumo/bin:$PATH"
COPY ./simulations /simulations
COPY ./results /results
COPY datacollect.py /datacollect.py
EXPOSE 1337
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && dos2unix /entrypoint.sh
ENTRYPOINT ["sh", "/entrypoint.sh"]
