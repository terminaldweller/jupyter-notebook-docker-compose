FROM alpine:3.15 as certbuilder
RUN apk add openssl
WORKDIR /certs
RUN openssl req -nodes -new -x509 -subj="/C=US/ST=Denial/L=springfield/O=Dis/CN=localhost" -keyout server.key -out server.cert && cat server.key server.cert > cert.pem

FROM nvidia/cuda:11.7.0-runtime-ubuntu20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update &&\
      apt-get install -y software-properties-common &&\
      add-apt-repository ppa:deadsnakes/ppa &&\
      apt-get update &&\
      apt-get install -y python3.10 python3-pip
RUN pip install pysocks
ENV HTTP_PROXY=socks5://172.17.0.1:9995
ENV HTTPS_PROXY=socks5://172.17.0.1:9995
RUN pip install jupyterlab scipy numpy poetry numba torch tensorflow transformers huggingface-hub ipywidgets pandas
RUN apt-get update  && apt-get install -y curl wget unzip
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get -y install nodejs
# RUN pip install ipywidgets pandas pysocks
# RUN jupyter labextension install jupyterlab_vim
COPY --from=certbuilder /certs /certs
