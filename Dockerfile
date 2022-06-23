FROM alpine:3.15 as certbuilder
RUN apk add openssl
WORKDIR /certs
RUN openssl req -nodes -new -x509 -subj="/C=US/ST=Denial/L=springfield/O=Dis/CN=localhost" -keyout server.key -out server.cert && cat server.key server.cert > cert.pem

FROM python:3.10.5-slim-buster
RUN pip install jupyterlab scipy numpy poetry numba torch tensorflow transformers huggingface-hub
RUN apt-get update  && apt-get install -y curl wget unzip
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get -y install nodejs
RUN pip install ipywidgets pandas pysocks
# RUN jupyter labextension install jupyterlab_vim
COPY --from=certbuilder /certs /certs
