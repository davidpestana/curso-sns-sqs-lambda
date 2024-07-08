# Dockerfile

´´´
FROM amazon/aws-cli
ENV HOME /workspace

# INSTALL WGET AND UTILS
RUN yum install -y wget openssl jq tar gzip which unzip
RUN yum install -y yum-utils

# INSTALL GIT
RUN yum -y install git


# INSTALL OpenJDK 11
RUN wget https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.16.1+1/OpenJDK11U-jdk_x64_linux_hotspot_11.0.16.1_1.tar.gz && \
    tar -xvzf OpenJDK11U-jdk_x64_linux_hotspot_11.0.16.1_1.tar.gz -C /opt && \
    ln -s /opt/jdk-11.0.16.1+1 /opt/jdk-11 && \
    rm OpenJDK11U-jdk_x64_linux_hotspot_11.0.16.1_1.tar.gz

# Set JAVA_HOME environment variable
ENV JAVA_HOME /opt/jdk-11
ENV PATH $JAVA_HOME/bin:$PATH

# INSTALL TERRAFORM
RUN yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo && yum -y install terraform

# INSTALL KUBECTL
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" && \
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# FLUX
RUN curl -s https://fluxcd.io/install.sh | FLUX_VERSION=2.2.3 bash

# INSTALL MAVEN
RUN wget https://archive.apache.org/dist/maven/maven-3/3.8.1/binaries/apache-maven-3.8.1-bin.tar.gz && \
    tar -xvzf apache-maven-3.8.1-bin.tar.gz -C /opt && \
    ln -s /opt/apache-maven-3.8.1 /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME=/opt/maven
ENV PATH=${MAVEN_HOME}/bin:${PATH}

# SAM CLI
RUN curl -Lo /tmp/aws-sam-cli-linux-x86_64.zip https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip && \
    unzip /tmp/aws-sam-cli-linux-x86_64.zip -d /tmp/sam-installation && \
    /tmp/sam-installation/install && \
    rm -rf /tmp/aws-sam-cli-linux-x86_64.zip /tmp/sam-installation

# Crear usuario 'operador' con UID 1000
RUN useradd -m -u 1000 operador

# Configura el directorio de trabajo
WORKDIR /workspace

# Cambiar al usuario 'operador'
USER operador
# Comando predeterminado para ejecutar al iniciar el contenedor
ENTRYPOINT [ "/bin/bash" ]

´´´



# docker-compose.yaml

´´´
services:
  aws:
    build: 
      context: ./
    restart: always
    volumes:
      - ./:/workspace
      - ~/.ssh:/workspace/.ssh
    env_file:
      - .env
´´´


# .env

´´´
AWS_ACCESS_KEY_ID=XXX
AWS_SECRET_ACCESS_XXX
AWS_DEFAULT_REGION=eu-west-1
´´´