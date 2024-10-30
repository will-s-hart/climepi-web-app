FROM daskdev/dask:latest

USER root

RUN /opt/conda/bin/mamba install -c conda-forge \
    bottleneck \
    dask \
    flox \
    geopy \
    geoviews \
    hvplot \
    intake \
    intake-esm \
    nc-time-axis \
    numpy \
    pandas \
    panel \
    param \
    pooch \
    requests \
    s3fs \
    urllib3 \
    xarray!=2024.10.0 \
    xcdat
RUN /opt/conda/bin/pip install --no-deps git+https://github.com/will-s-hart/climate-epidemics.git

WORKDIR /code
COPY . .

CMD ["panel", "serve", "/code/src/web_app.py", "--address", "0.0.0.0", "--port", "7860",  "--allow-websocket-origin", "*"]

RUN mkdir /.cache
RUN chmod 777 /.cache
RUN mkdir .chroma
RUN chmod 777 .chroma