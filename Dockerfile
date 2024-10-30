FROM mambaorg/micromamba:latest

USER root
WORKDIR /code

COPY environment.yml /tmp/environment.yml
RUN micromamba install -y -n base -f /tmp/environment.yml && \
    micromamba clean --all --yes

RUN apt-get update && apt-get install -y git && apt-get clean && rm -rf /var/lib/apt/lists/*

ARG MAMBA_DOCKERFILE_ACTIVATE=1
RUN python -m pip install --no-deps git+https://github.com/will-s-hart/climate-epidemics.git

RUN mkdir /.cache
RUN chmod 777 /.cache
RUN mkdir .chroma
RUN chmod 777 .chroma

COPY . .
RUN python -c "from climepi import climdata; climdata.get_example_dataset('isimip_cities', base_dir='/code/data')"
RUN chmod  -R 755 /code/data

CMD sh /code/src/run_cluster_app.sh