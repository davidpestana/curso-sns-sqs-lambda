# Dockerfile

```
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

```



# docker-compose.yaml

```
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
```


# .env

```
AWS_ACCESS_KEY_ID=XXX
AWS_SECRET_ACCESS_KEY=XXX
AWS_DEFAULT_REGION=eu-west-1
´´´

# REPARTO 

### Reparto de Regiones y VPCs para los Alumnos

| Alumno  | Región     | VPC Name |
|---------|------------|----------|
| Alumno 1| eu-west-1  | alumno1  |
| Alumno 2| eu-west-1  | alumno2  |
| Alumno 3| eu-west-1  | alumno3  |
| Alumno 4| eu-west-1  | alumno4  |
| Alumno 5| eu-west-2  | alumno5  |
| Alumno 6| eu-west-2  | alumno6  |
| Alumno 7| eu-west-2  | alumno7  |
| Alumno 8| eu-west-2  | alumno8  |
| Alumno 9| eu-central-1| alumno9  |
| Alumno 10| eu-central-1| alumno10 |
| Alumno 11| eu-central-1| alumno11 |
| Alumno 12| eu-central-1| alumno12 |
| Alumno 13| eu-north-1 | alumno13 |
| Alumno 14| eu-north-1 | alumno14 |
| Alumno 15| eu-north-1 | alumno15 |
| Alumno 16| eu-north-1 | alumno16 |

### Detalles de las Regiones

- **eu-west-1**: Irlanda
- **eu-west-2**: Londres
- **eu-central-1**: Fráncfort
- **eu-north-1**: Estocolmo

Cada alumno tendrá su propia VPC nombrada según el esquema "alumnoX", donde X es su número de alumno. Esto asegura que cada región europea tendrá exactamente 4 VPCs distribuidas entre los alumnos.




# CREAR INSTANCIA
```
docker compose run -it --rm aws
```