### 3.7. Automatización de Implementaciones con AWS SAM

---

## Automatización de Implementaciones con AWS SAM

AWS Serverless Application Model (SAM) es un framework que facilita la construcción y despliegue de aplicaciones sin servidor en AWS. Proporciona una sintaxis simplificada para expresar funciones, APIs, bases de datos y mapeos de eventos. SAM extiende AWS CloudFormation, por lo que puedes usar todos los recursos de AWS a través de SAM.

### Conceptos Básicos de SAM

#### Definición y Uso

AWS SAM es una especificación abierta que define los recursos de Amazon API Gateway, AWS Lambda y Amazon DynamoDB necesarios para construir aplicaciones sin servidor. Con SAM, puedes definir tu infraestructura utilizando archivos de plantilla YAML y luego desplegar tu aplicación utilizando la CLI de SAM.

**Ventajas de usar SAM:**

1. **Simplicidad:** SAM proporciona una sintaxis simplificada para definir los recursos de la aplicación sin servidor.
2. **Despliegue Rápido:** Facilita el despliegue y la administración de aplicaciones sin servidor.
3. **Pruebas Locales:** Permite probar las funciones Lambda localmente antes de desplegarlas en AWS.
4. **Ampliación:** Extiende AWS CloudFormation, por lo que puedes usar todos los recursos de AWS en tus plantillas SAM.

### Plantillas de SAM

#### Estructura de una Plantilla SAM

Una plantilla SAM utiliza sintaxis YAML para definir los recursos de la aplicación. A continuación se muestra un ejemplo básico de una plantilla SAM:

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Transform: 'AWS::Serverless-2016-10-31'
Resources:
  MyLambdaFunction:
    Type: 'AWS::Serverless::Function'
    Properties:
      Handler: com.example.MyLambdaHandler
      Runtime: java11
      CodeUri: ./target/lambda-app.jar
      MemorySize: 512
      Timeout: 10
      Policies:
        - AWSLambdaBasicExecutionRole
      Events:
        MySQSEvent:
          Type: SQS
          Properties:
            Queue: !GetAtt MyQueue.Arn

  MyQueue:
    Type: 'AWS::SQS::Queue'
```

**Componentes Clave:**

- **Transform:** Especifica la transformación SAM que se aplicará a la plantilla.
- **Resources:** Define los recursos de AWS, como funciones Lambda, colas SQS, APIs, etc.

### Ejemplo de Implementación con SAM

#### Paso 1: Configurar el Proyecto Maven

1. **Crear un Proyecto Maven (`pom.xml`):**

   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>

       <groupId>com.example</groupId>
       <artifactId>lambda-sam-app</artifactId>
       <version>1.0-SNAPSHOT</version>

       <dependencies>
           <dependency>
               <groupId>com.amazonaws</groupId>
               <artifactId>aws-lambda-java-core</artifactId>
               <version>1.2.1</version>
           </dependency>
           <dependency>
               <groupId>com.amazonaws</groupId>
               <artifactId>aws-lambda-java-events</artifactId>
               <version>3.9.0</version>
           </dependency>
       </dependencies>

       <build>
           <plugins>
               <plugin>
                   <groupId>org.apache.maven.plugins</groupId>
                   <artifactId>maven-compiler-plugin</artifactId>
                   <version>3.8.0</version>
                   <configuration>
                       <source>1.8</source>
                       <target>1.8</target>
                   </configuration>
               </plugin>
               <plugin>
                   <groupId>org.apache.maven.plugins</groupId>
                   <artifactId>maven-shade-plugin</artifactId>
                   <version>3.2.1</version>
                   <executions>
                       <execution>
                           <phase>package</phase>
                           <goals>
                               <goal>shade</goal>
                           </goals>
                           <configuration>
                               <createDependencyReducedPom>false</createDependencyReducedPom>
                               <transformers>
                                   <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                       <mainClass>com.example.MyLambdaHandler</mainClass>
                                   </transformers>
                               </configuration>
                       </execution>
                   </executions>
               </plugin>
           </plugins>
       </build>
   </project>
   ```

2. **Implementar la Clase MyLambdaHandler:**

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;
   import com.amazonaws.services.lambda.runtime.events.SQSEvent;

   public class MyLambdaHandler implements RequestHandler<SQSEvent, Void> {

       @Override
       public Void handleRequest(SQSEvent event, Context context) {
           for (SQSEvent.SQSMessage msg : event.getRecords()) {
               context.getLogger().log("Mensaje recibido de SQS: " + msg.getBody());
               // Aquí puedes agregar lógica adicional para procesar el mensaje
           }
           return null;
       }
   }
   ```

3. **Construir el Proyecto:**

   ```sh
   mvn clean package
   ```

#### Paso 2: Crear la Plantilla SAM

1. **Crear un Archivo de Plantilla SAM (`template.yaml`):**

   ```yaml
   AWSTemplateFormatVersion: '2010-09-09'
   Transform: 'AWS::Serverless-2016-10-31'
   Resources:
     MyLambdaFunction:
       Type: 'AWS::Serverless::Function'
       Properties:
         Handler: com.example.MyLambdaHandler
         Runtime: java11
         CodeUri: ./target/lambda-sam-app-1.0-SNAPSHOT.jar
         MemorySize: 512
         Timeout: 10
         Policies:
           - AWSLambdaBasicExecutionRole
         Events:
           MySQSEvent:
             Type: SQS
             Properties:
               Queue: !GetAtt MyQueue.Arn

     MyQueue:
       Type: 'AWS::SQS::Queue'
   ```

#### Paso 3: Desplegar la Aplicación con SAM CLI

1. **Instalar SAM CLI:**
   - Sigue las instrucciones de instalación de [SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html).

2. **Inicializar el Proyecto SAM:**

   ```sh
   sam init
   ```

   - Selecciona las opciones para un proyecto Hello World en Java.

3. **Construir y Empaquetar la Aplicación:**

   ```sh
   sam build
   ```

4. **Desplegar la Aplicación:**

   ```sh
   sam deploy --guided
   ```

   - Sigue las instrucciones y proporciona los detalles necesarios para el despliegue.

#### Paso 4: Probar la Aplicación

**Objetivo:** Verificar que la función Lambda se ejecute correctamente al recibir mensajes de la cola SQS.

1. **Enviar un Mensaje a la Cola SQS:**

   ```sh
   aws sqs send-message --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/MyQueue --message-body "Mensaje de prueba para Lambda a través de SAM"
   ```

2. **Verificar la Ejecución de la Función Lambda:**
   - Accede a la consola de CloudWatch Logs.
   - Encuentra el grupo de logs de la función `MyLambdaFunction`.
   - Verifica que el mensaje "Mensaje de prueba para Lambda a través de SAM" fue recibido y registrado.

### Resumen

En esta sección, aprendimos a utilizar AWS SAM para automatizar la implementación de una aplicación sin servidor. Configuramos una plantilla SAM para definir una función Lambda y una cola SQS, construimos y desplegamos la aplicación utilizando SAM CLI, y verificamos que la función Lambda procesó correctamente los mensajes de la cola SQS. Esta automatización facilita la gestión y el despliegue de aplicaciones sin servidor en AWS.