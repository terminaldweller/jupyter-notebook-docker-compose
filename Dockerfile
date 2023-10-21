FROM alpine:3.18 as certbuilder
RUN apk add openssl
WORKDIR /certs
RUN openssl req -nodes -new -x509 -subj="/C=US/ST=Denial/L=springfield/O=Dis/CN=localhost" -keyout server.key -out server.cert && cat server.key server.cert > cert.pem

FROM nvidia/cuda:12.2.2-runtime-ubuntu20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update &&\
      apt-get install -y software-properties-common &&\
      add-apt-repository ppa:deadsnakes/ppa &&\
      apt-get update &&\
      apt-get install -y python3.10 python3-pip curl wget unzip
RUN pip install pysocks scapy scikit-learn matplotlib jupyterlab scipy numpy poetry numba torch tensorflow transformers huggingface-hub ipywidgets pandas 'python-lsp-server[all]'
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
COPY --from=certbuilder /certs /certs
# RUN pip install ipywidgets pandas pysocks
# RUN jupyter labextension install jupyterlab_vim
# RUN pip install scaPY MATPLOTlib
# RUN pip install --upgrade torch
# RUN apt update && apt install -y tcpdump tshark
# RUN pip install 'python-lsp-server[all]'
# RUN pip install sklearn
