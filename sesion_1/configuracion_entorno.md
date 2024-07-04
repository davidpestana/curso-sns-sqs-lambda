### 1.3. Configuración de Entorno de Desarrollo

#### Instalación y configuración de AWS CLI

**AWS CLI (Command Line Interface)** es una herramienta que permite interactuar con los servicios de AWS desde la línea de comandos. Es muy útil para automatizar tareas y gestionar recursos de AWS.

##### Pasos para la instalación

1. **Windows:**
   - Descarga el instalador desde [AWS CLI for Windows](https://aws.amazon.com/cli/).
   - Ejecuta el instalador y sigue las instrucciones.

2. **macOS:**
   - Usar Homebrew:
     ```sh
     brew install awscli
     ```

3. **Linux:**
   - Usar el gestor de paquetes correspondiente:
     ```sh
     sudo apt-get install awscli  # Para Debian/Ubuntu
     sudo yum install awscli      # Para Amazon Linux/CentOS
     ```

##### Configuración básica y avanzada

1. **Configurar AWS CLI:**
   - Ejecuta el siguiente comando para configurar AWS CLI:
     ```sh
     aws configure
     ```
   - Proporciona tu AWS Access Key ID, AWS Secret Access Key, región predeterminada y formato de salida preferido (json, text, table).

2. **Archivos de configuración:**
   - **~/.aws/config:** Contiene configuraciones de perfil y región predeterminada.
   - **~/.aws/credentials:** Contiene las credenciales de acceso.

   Ejemplo de configuración básica:
   ```ini
   [default]
   region = us-west-2
   output = json
   ```

   Ejemplo de configuración avanzada:
   ```ini
   [profile myprofile]
   region = us-west-2
   output = json
   ```

#### Configuración de entorno para desarrollo en Java

##### SDK de AWS para Java

AWS SDK para Java proporciona bibliotecas y herramientas para integrar aplicaciones Java con los servicios de AWS.

1. **Agregar dependencias en Maven:**
   - Añade las siguientes dependencias en el archivo `pom.xml` de tu proyecto Maven:
     ```xml
     <dependencies>
         <dependency>
             <groupId>com.amazonaws</groupId>
             <artifactId>aws-java-sdk-bom</artifactId>
             <version>1.11.1000</version>
             <type>pom</type>
             <scope>import</scope>
         </dependency>
         <dependency>
             <groupId>com.amazonaws</groupId>
             <artifactId>aws-java-sdk-core</artifactId>
         </dependency>
         <dependency>
             <groupId>com.amazonaws</groupId>
             <artifactId>aws-java-sdk-s3</artifactId>
         </dependency>
         <dependency>
             <groupId>com.amazonaws</groupId>
             <artifactId>aws-java-sdk-dynamodb</artifactId>
         </dependency>
     </dependencies>
     ```

##### Configuración del IDE (Eclipse, IntelliJ, etc.)

1. **Instalar el SDK de AWS:**
   - Descarga el SDK desde el [sitio web de AWS](https://aws.amazon.com/sdk-for-java/).

2. **Configurar el IDE:**
   - **Eclipse:**
     - Instala el plugin de AWS Toolkit desde el Eclipse Marketplace.
     - Configura el SDK en las preferencias del proyecto.
   - **IntelliJ:**
     - Configura el SDK en el proyecto desde la configuración del IDE.
     - Añade las dependencias necesarias en el archivo `pom.xml`.

#### Gestión de Usuarios, Permisos, Políticas y Roles en AWS

##### Usuarios y Políticas

1. **Crear un usuario IAM:**
   - Accede a la consola de IAM.
   - Haz clic en "Users" y luego en "Add user".
   - Proporciona un nombre de usuario y selecciona el tipo de acceso (programático, consola).

2. **Asignar políticas:**
   - Selecciona "Attach existing policies directly".
   - Asigna políticas como `AmazonS3FullAccess` o `AdministratorAccess`.

##### Access Keys

1. **Crear claves de acceso:**
   - En la consola de IAM, selecciona el usuario creado.
   - En la pestaña "Security credentials", haz clic en "Create access key".
   - Descarga las claves de acceso y configúralas usando `aws configure`.

##### Roles

1. **Crear un rol IAM:**
   - En la consola de IAM, haz clic en "Roles" y luego en "Create role".
   - Selecciona el tipo de entidad confiable (por ejemplo, AWS service).
   - Asigna las políticas necesarias y completa la creación del rol.

#### Crear un Entorno Docker con Todas las Herramientas Necesarias

**Motivación:**
Crear un entorno Docker garantiza que todos los desarrolladores trabajen con la misma configuración y dependencias, eliminando problemas de "funciona en mi máquina".

**Objetivo:**
Configurar un contenedor Docker que tenga todas las herramientas necesarias para el desarrollo con AWS.

##### Dockerfile

1. **Crear un Dockerfile:**
   - Crea un archivo llamado `Dockerfile` en tu proyecto con el siguiente contenido:
     ```Dockerfile
     # Utiliza una imagen base de Amazon Linux 2
     FROM amazonlinux:2

     # Instala actualizaciones y herramientas necesarias
     RUN yum update -y && \
         yum install -y python3 git java-11-openjdk-devel sudo && \
         yum clean all

     # Instala AWS CLI
     RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
         unzip awscliv2.zip && \
         ./aws/install

     # Instala Maven
     RUN curl -O https://apache.osuosl.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz && \
         tar xzf apache-maven-3.6.3-bin.tar.gz -C /opt && \
         ln -s /opt/apache-maven-3.6.3 /opt/maven && \
         ln -s /opt/maven/bin/mvn /usr/bin/mvn

     # Configura variables de entorno para Java y Maven
     ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk
     ENV MAVEN_HOME /opt/maven

     # Establece el directorio de trabajo
     WORKDIR /app

     # Copia el archivo de requerimientos y los instala
     COPY . /app

     # Comando para ejecutar el contenedor
     CMD ["/bin/bash"]
     ```

##### Construcción y Ejecución del Contenedor

1. **Construir la imagen Docker:**
   - En el terminal, navega al directorio que contiene el Dockerfile y ejecuta:
     ```sh
     docker build -t aws-java-dev-env .
     ```

2. **Ejecutar el contenedor Docker:**
   - Inicia un contenedor con la imagen creada:
     ```sh
     docker run -it aws-java-dev-env
     ```

### Resumen

Hemos cubierto la configuración de AWS CLI, la preparación del entorno de desarrollo en Java, la gestión de usuarios y roles de IAM, y la creación de un entorno Docker con todas las herramientas necesarias. Esta configuración asegura que los desarrolladores puedan trabajar de manera eficiente y consistente en un entorno controlado, facilitando la integración y el despliegue de aplicaciones en AWS.



### Estrategia para Desarrollar y Probar Funciones Lambda en Local

Desarrollar y probar funciones Lambda en un entorno local es crucial para asegurar una alta calidad antes de desplegarlas en AWS. A continuación, se presenta una estrategia detallada que incluye herramientas y pasos específicos para desarrollar y probar funciones Lambda en local.

#### Herramientas Necesarias

1. **AWS SAM (Serverless Application Model):**
   - SAM es una herramienta de código abierto que permite definir y desplegar aplicaciones sin servidor usando plantillas.
   - Proporciona un entorno local para probar funciones Lambda.

2. **Docker:**
   - SAM utiliza Docker para simular el entorno Lambda en local.

3. **IDE (Eclipse, IntelliJ, VSCode, etc.):**
   - Un entorno de desarrollo integrado facilita la edición, el debugging y la gestión del código.

#### Pasos para Desarrollar y Probar Funciones Lambda en Local

##### Paso 1: Configurar el Entorno de Desarrollo

1. **Instalar AWS CLI:**
   - Asegúrate de tener instalada y configurada la AWS CLI en tu máquina.

2. **Instalar AWS SAM CLI:**
   - Sigue las instrucciones de instalación en [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html).

3. **Instalar Docker:**
   - Descarga e instala Docker desde [Docker](https://www.docker.com/products/docker-desktop).

##### Paso 2: Crear una Plantilla SAM

1. **Iniciar un Proyecto SAM:**
   - Crea un nuevo directorio para tu proyecto y navega a él en la terminal.
   - Ejecuta el siguiente comando para iniciar un nuevo proyecto SAM:
     ```sh
     sam init
     ```
   - Selecciona las opciones apropiadas para tu lenguaje de programación (por ejemplo, Java) y el tipo de aplicación.

2. **Estructura del Proyecto:**
   - SAM creará una estructura de proyecto con los siguientes componentes:
     ```
     ├── README.md
     ├── template.yaml
     ├── src
     │   └── main
     │       └── java
     │           └── com
     │               └── example
     │                   └── App.java
     ├── events
     │   └── event.json
     └── src
         └── test
             └── java
                 └── com
                     └── example
                         └── AppTest.java
     ```

##### Paso 3: Escribir la Función Lambda

1. **Escribir el Código de la Función:**
   - Edita el archivo `App.java` para implementar la lógica de tu función Lambda.
   - Ejemplo de una función Lambda simple que procesa un evento:

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;

   public class App implements RequestHandler<Object, String> {

       @Override
       public String handleRequest(Object input, Context context) {
           context.getLogger().log("Input: " + input);
           return "Hello from Lambda!";
       }
   }
   ```

2. **Escribir Pruebas Unitarias:**
   - Añade pruebas unitarias en el archivo `AppTest.java` para asegurarte de que la lógica de tu función sea correcta.

   ```java
   package com.example;

   import static org.junit.Assert.assertEquals;
   import org.junit.Test;

   public class AppTest {

       @Test
       public void testHandleRequest() {
           App app = new App();
           String result = app.handleRequest("Test Input", null);
           assertEquals("Hello from Lambda!", result);
       }
   }
   ```

##### Paso 4: Probar la Función en Local

1. **Actualizar la Plantilla SAM:**
   - Edita el archivo `template.yaml` para definir tu función Lambda.
   
   ```yaml
   AWSTemplateFormatVersion: '2010-09-09'
   Transform: AWS::Serverless-2016-10-31
   Resources:
     HelloWorldFunction:
       Type: AWS::Serverless::Function
       Properties:
         Handler: com.example.App::handleRequest
         Runtime: java11
         CodeUri: .
         MemorySize: 512
         Timeout: 10
         Events:
           HelloWorld:
             Type: Api
             Properties:
               Path: /hello
               Method: get
   ```

2. **Probar con SAM CLI:**
   - Utiliza el comando SAM CLI para iniciar el entorno local y probar la función.
   - Navega a tu directorio de proyecto y ejecuta:
     ```sh
     sam local invoke "HelloWorldFunction" -e events/event.json
     ```
   - Esto ejecutará tu función Lambda en un contenedor Docker local utilizando el evento definido en `event.json`.

3. **Depuración:**
   - Puedes depurar tu función Lambda utilizando el siguiente comando:
     ```sh
     sam local invoke "HelloWorldFunction" -e events/event.json --debug-port 5858
     ```
   - Configura tu IDE para conectarse al puerto de depuración y establece puntos de interrupción en tu código.

##### Paso 5: Desplegar la Función a AWS

1. **Construir el Proyecto:**
   - Ejecuta el siguiente comando para construir tu proyecto SAM:
     ```sh
     sam build
     ```

2. **Desplegar a AWS:**
   - Ejecuta el siguiente comando para desplegar tu aplicación:
     ```sh
     sam deploy --guided
     ```
   - Sigue las instrucciones para configurar los parámetros de despliegue, como el nombre del stack, la región de AWS y las configuraciones de IAM.

### Resumen

Desarrollar y probar funciones Lambda en local utilizando AWS SAM y Docker proporciona un entorno de desarrollo robusto y eficiente. Esta estrategia asegura que tu código se ejecute correctamente antes de desplegarlo en AWS, reduciendo errores y mejorando la calidad del software. La combinación de SAM para la simulación local y Docker para el aislamiento del entorno es ideal para crear y probar aplicaciones sin servidor.
