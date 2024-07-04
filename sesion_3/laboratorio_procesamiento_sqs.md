### 3.2. Laboratorio: Procesamiento de Mensajes de SQS con Lambda

---

## Laboratorio: Procesamiento de Mensajes de SQS con Lambda

### Descripción del Laboratorio

En este laboratorio, implementaremos una función Lambda que procese mensajes de una cola SQS y registre los eventos en CloudWatch. Aprenderás a configurar triggers de SQS, implementar la lógica de procesamiento de mensajes en Lambda y a verificar los logs en CloudWatch.

### Recursos Necesarios

- AWS CLI
- SDK de AWS para Java
- IDE (Eclipse, IntelliJ, etc.)
- AWS Management Console

### Ejercicio Práctico

#### Paso 1: Configurar el Proyecto Maven

**Objetivo:** Configurar un proyecto Maven con las dependencias necesarias para AWS Lambda y SQS.

1. **Crear un nuevo proyecto Maven en tu IDE:**
   - Abre tu IDE y crea un nuevo proyecto Maven.
   - Configura el `pom.xml` con las dependencias necesarias.

   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>

       <groupId>com.example</groupId>
       <artifactId>lambda-sqs-processing</artifactId>
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
                                       <mainClass>com.example.LambdaSQSProcessor</mainClass>
                                   </transformers>
                               </configuration>
                       </execution>
                   </executions>
               </plugin>
           </plugins>
       </build>
   </project>
   ```

#### Paso 2: Implementar la Función Lambda

**Objetivo:** Escribir la función Lambda que procese mensajes de la cola SQS y registre los eventos en CloudWatch.

1. **Implementar la Clase LambdaSQSProcessor:**

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;
   import com.amazonaws.services.lambda.runtime.events.SQSEvent;

   public class LambdaSQSProcessor implements RequestHandler<SQSEvent, Void> {

       @Override
       public Void handleRequest(SQSEvent event, Context context) {
           for (SQSEvent.SQSMessage msg : event.getRecords()) {
               context.getLogger().log("Mensaje recibido: " + msg.getBody());
               // Aquí puedes agregar lógica adicional para procesar el mensaje
           }
           return null;
       }
   }
   ```

#### Paso 3: Construir y Desplegar la Función Lambda

**Objetivo:** Empaquetar y desplegar la función Lambda en AWS.

1. **Construir el Proyecto:**
   - Ejecuta el siguiente comando para empaquetar el proyecto en un archivo JAR:

   ```sh
   mvn clean package
   ```

2. **Desplegar la Función Lambda:**
   - Usa AWS CLI para desplegar el archivo JAR en AWS Lambda:

   ```sh
   aws lambda create-function --function-name LambdaSQSProcessor \
       --runtime java11 --role arn:aws:iam::YOUR_ACCOUNT_ID:role/YOUR_LAMBDA_ROLE \
       --handler com.example.LambdaSQSProcessor \
       --zip-file fileb://target/lambda-sqs-processing-1.0-SNAPSHOT.jar
   ```

#### Paso 4: Configurar el Trigger de SQS

**Objetivo:** Configurar la cola SQS para que desencadene la función Lambda.

1. **Crear una Cola SQS:**

   ```sh
   aws sqs create-queue --queue-name MyProcessingQueue
   ```

2. **Obtener la ARN de la Cola SQS:**

   ```sh
   aws sqs get-queue-attributes --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/MyProcessingQueue --attribute-names QueueArn
   ```

3. **Dar Permisos a SQS para Invocar la Función Lambda:**

   ```sh
   aws lambda add-permission --function-name LambdaSQSProcessor --statement-id sqs-invoke --action "lambda:InvokeFunction" --principal sqs.amazonaws.com --source-arn arn:aws:sqs:us-east-1:123456789012:MyProcessingQueue
   ```

4. **Configurar el Trigger de SQS:**

   ```sh
   aws lambda create-event-source-mapping --function-name LambdaSQSProcessor --event-source-arn arn:aws:sqs:us-east-1:123456789012:MyProcessingQueue --batch-size 10
   ```

#### Paso 5: Probar la Integración

**Objetivo:** Enviar mensajes a la cola SQS y verificar que la función Lambda se ejecuta automáticamente.

1. **Enviar un Mensaje a la Cola SQS:**

   ```sh
   aws sqs send-message --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/MyProcessingQueue --message-body "Mensaje de prueba para Lambda!"
   ```

2. **Verificar la Ejecución de la Función Lambda:**
   - Accede a la consola de CloudWatch Logs.
   - Encuentra el grupo de logs de la función `LambdaSQSProcessor`.
   - Verifica que el mensaje "Mensaje de prueba para Lambda!" fue recibido y registrado.

### Resumen

En este laboratorio, hemos configurado una integración entre AWS Lambda y Amazon SQS para procesar mensajes de manera automática. Implementamos una función Lambda que procesa los mensajes de la cola SQS y registra los eventos en CloudWatch. Este flujo de trabajo facilita la creación de aplicaciones asíncronas y desacopladas, mejorando la escalabilidad y la resiliencia de las aplicaciones.