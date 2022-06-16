FROM alpine:3.15 as certbuilder
RUN apk add openssl
WORKDIR /certs
RUN openssl req -nodes -new -x509 -subj="/C=US/ST=Denial/L=springfield/O=Dis/CN=localhost" -keyout server.key -out server.cert && cat server.key server.cert > cert.pem

FROM python:3.10.5-slim-buster
RUN pip install jupyterlab scipy numpy poetry numba torch tensorflow transformers huggingface-hub
COPY --from=certbuilder /certs /certs
