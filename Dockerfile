FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

RUN apt-get update \
 && apt-get install -y tzdata \
 && apt-get clean \
 && rm -rf /var/cache/apt*

WORKDIR /opt/vim-builder
COPY . .

CMD ["/bin/bash"]
