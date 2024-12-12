FROM ghcr.io/prefix-dev/pixi:latest AS build

WORKDIR /app
COPY . .
RUN pixi install --locked -e prod
RUN pixi shell-hook -e prod -s bash > /shell-hook
RUN echo "#!/bin/bash" > /app/entrypoint.sh
RUN cat /shell-hook >> /app/entrypoint.sh
RUN echo 'exec "$@"' >> /app/entrypoint.sh

RUN pixi r python -m src.get_data

FROM ubuntu:latest AS production
WORKDIR /app
COPY --from=build /app/.pixi/envs/prod /app/.pixi/envs/prod
COPY --from=build --chmod=0755 /app/entrypoint.sh /app/entrypoint.sh
COPY --from=build --chmod=0755 /app/data /app/data
COPY ./src /app/src

RUN mkdir /.cache
RUN chmod 777 /.cache
RUN mkdir .chroma
RUN chmod 777 .chroma

ENTRYPOINT [ "/app/entrypoint.sh" ]
CMD ["sh","/app/src/run_cluster_app.sh"]