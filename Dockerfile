FROM mambaorg/micromamba:1.5.8

WORKDIR /code

USER root
RUN apt-get update && apt-get install -y git && apt-get clean && rm -rf /var/lib/apt/lists/*
USER mambauser

COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yml /code/environment.yml
RUN micromamba install -y -n base -f /code/environment.yml && \
    micromamba clean --all --yes

COPY . .

CMD ["panel", "serve", "/code/src/web_app.py", "--address", "0.0.0.0", "--port", "7860",  "--allow-websocket-origin", "*"]

# RUN mkdir /.cache
# RUN chmod 777 /.cache
# RUN mkdir .chroma
# RUN chmod 777 .chroma