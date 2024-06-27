# Configuración de Entorno de Desarrollo

Para comenzar a desarrollar con AWS Lambda en Java, es esencial configurar adecuadamente el entorno de desarrollo. Esta sección detalla los pasos necesarios para instalar y configurar las herramientas necesarias, incluyendo AWS CLI, el SDK de AWS para Java, y el entorno de desarrollo integrado (IDE).

#### Instalación y configuración de AWS CLI

AWS Command Line Interface (CLI) es una herramienta unificada para gestionar sus servicios de AWS. Con AWS CLI, puedes controlar múltiples servicios de AWS desde la línea de comandos y automatizar tareas mediante scripts.

**Pasos para la instalación:**

1. **Descarga e instalación:**
   - **Windows:**
     - Descarga el instalador de AWS CLI desde la [página oficial de AWS](https://aws.amazon.com/cli/).
     - Ejecuta el instalador y sigue las instrucciones.
   - **macOS:**
     - Utiliza Homebrew para instalar AWS CLI:
       ```sh
       brew install awscli
       ```
   - **Linux:**
     - Usa `curl` para descargar e instalar AWS CLI:
       ```sh
       curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
       unzip awscliv2.zip
       sudo ./aws/install
       ```

2. **Verificar la instalación:**
   - Abre una terminal o línea de comandos y ejecuta:
     ```sh
     aws --version
     ```
   - Deberías ver algo similar a `aws-cli/2.x.x Python/3.x.x`.

3. **Configuración básica:**
   - Configura AWS CLI con tus credenciales de AWS:
     ```sh
     aws configure
     ```
   - Introduce tu Access Key ID, Secret Access Key, región por defecto (por ejemplo, `us-east-1`) y formato de salida (`json`).

**Configuración avanzada:**

- **Configuración de perfiles:**
  - Puedes configurar múltiples perfiles para diferentes cuentas de AWS.
  - Para crear un nuevo perfil, usa:
    ```sh
    aws configure --profile myprofile
    ```
  - Usa el perfil configurado especificándolo en tus comandos:
    ```sh
    aws s3 ls --profile myprofile
    ```

#### Configuración de entorno para desarrollo en Java

Para desarrollar funciones Lambda en Java, necesitas el JDK, un IDE adecuado, y el SDK de AWS para Java.

**SDK de AWS para Java:**

El SDK de AWS para Java facilita la integración de aplicaciones con los servicios de AWS como Amazon S3, Amazon EC2, DynamoDB, y más.

1. **Instalación del JDK:**
   - **Windows y macOS:**
     - Descarga e instala el JDK desde la [página oficial de Oracle](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html).
   - **Linux:**
     - Instala OpenJDK usando el gestor de paquetes de tu distribución:
       ```sh
       sudo apt-get install openjdk-11-jdk
       ```

2. **Configuración del IDE:**
   - **Eclipse:**
     - Descarga e instala Eclipse desde la [página oficial](https://www.eclipse.org/downloads/).
     - Instala el plugin de AWS Toolkit para Eclipse:
       - Ve a `Help > Eclipse Marketplace`.
       - Busca `AWS Toolkit` e instálalo.
   - **IntelliJ IDEA:**
     - Descarga e instala IntelliJ IDEA desde la [página oficial](https://www.jetbrains.com/idea/download/).
     - Instala el plugin de AWS Toolkit para IntelliJ:
       - Ve a `File > Settings > Plugins`.
       - Busca `AWS Toolkit` e instálalo.

3. **Agregar el SDK de AWS a tu proyecto:**
   - **Maven:**
     - Si usas Maven, agrega la dependencia del SDK de AWS en tu archivo `pom.xml`:
       ```xml
       <dependency>
         <groupId>com.amazonaws</groupId>
         <artifactId>aws-java-sdk</artifactId>
         <version>1.11.1000</version>
       </dependency>
       ```
   - **Gradle:**
     - Si usas Gradle, agrega la dependencia en tu archivo `build.gradle`:
       ```groovy
       dependencies {
         implementation 'com.amazonaws:aws-java-sdk:1.11.1000'
       }
       ```

#### Ejemplo guiado: Crear una función Lambda simple en Java

Vamos a crear una función Lambda simple en Java que recibe una cadena de texto, la convierte a mayúsculas y la devuelve.

1. **Implementar la función Lambda en Java:**

   Crea una nueva clase Java para tu función Lambda:
   ```java
   package example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;

   public class UpperCaseFunction implements RequestHandler<String, String> {
       @Override
       public String handleRequest(String input, Context context) {
           return input.toUpperCase();
       }
   }
   ```

2. **Compilar y empaquetar tu proyecto:**

   Si usas Maven, ejecuta:
   ```sh
   mvn clean package
   ```

   Esto generará un archivo JAR en el directorio `target`.

3. **Desplegar la función en AWS Lambda:**

   Usa AWS CLI para crear una función Lambda:
   ```sh
   aws lambda create-function --function-name UpperCaseFunction \
     --runtime java11 --role arn:aws:iam::your-account-id:role/your-lambda-role \
     --handler example.UpperCaseFunction::handleRequest \
     --zip-file fileb://target/your-project-name-1.0-SNAPSHOT.jar
   ```

4. **Probar la función desde la consola de AWS:**

   - Ve a la consola de AWS Lambda.
   - Selecciona tu función `UpperCaseFunction`.
   - Usa el cuadro de prueba para enviar una cadena de texto y observa la respuesta en mayúsculas.

### Conclusión

Configurar el entorno de desarrollo para AWS Lambda en Java es un paso fundamental para comenzar a crear aplicaciones sin servidor. Con AWS CLI, el SDK de AWS para Java y un IDE adecuado, puedes desarrollar, desplegar y gestionar funciones Lambda de manera eficiente. Este ejemplo guiado proporciona una base sólida para explorar más capacidades avanzadas de AWS Lambda y sus integraciones con otros servicios de AWS.
