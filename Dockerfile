FROM openjdk:11


RUN apt update && \
    apt install -y zip unzip gnupg curl jq less wget


# Install Node
ENV NODE_VERSION=v14.16.0
ENV DISTRO=linux-x64
RUN wget -q https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-${DISTRO}.tar.xz
RUN mkdir -p /usr/local/lib/nodejs
RUN cd /usr/local/
RUN tar -xJvf /node-${NODE_VERSION}-${DISTRO}.tar.xz -C /usr/local/lib/nodejs

RUN ln -s /usr/local/lib/nodejs/node-${NODE_VERSION}-${DISTRO}/bin/node /usr/bin/node
RUN ln -s /usr/local/lib/nodejs/node-${NODE_VERSION}-${DISTRO}/bin/npm /usr/bin/npm
RUN ln -s /usr/local/lib/nodejs/node-${NODE_VERSION}-${DISTRO}/bin/npx /usr/bin/npx

RUN export PATH=/usr/local/lib/nodejs/node-${NODE_VERSION}-${DISTRO}/bin:$PATH
RUN . ~/.profile
RUN npm config set unsafe-perm true
RUN rm -rf /node-${NODE_VERSION}-${DISTRO}.tar.xz

#Install aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN rm -rf /node-${NODE_VERSION}-${DISTRO}.tar.xz
RUN rm -rf /awscliv2.zip
RUN rm -rf /aws

# Install python 3

RUN apt-get update \
    && apt-get install -y python3-pip python3-dev \
    && cd /usr/local/bin \
    && ln -s /usr/bin/python3 python \
    && pip3 --no-cache-dir install --upgrade pip \
    && rm -rf /var/lib/apt/lists/*

# Install aws eb cli
RUN pip install awsebcli==3.19.4

RUN apt-get clean autoclean
