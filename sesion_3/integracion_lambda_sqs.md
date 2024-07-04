### 3.1. Integración de AWS Lambda con SQS

---

## Integración de AWS Lambda con SQS

En esta sección, aprenderemos a configurar una integración entre AWS Lambda y Amazon SQS. Esta integración permite que las funciones Lambda se activen automáticamente en respuesta a mensajes entrantes en una cola SQS, lo que facilita la creación de aplicaciones asíncronas y desacopladas.

### Configuración de Triggers de SQS en Lambda

#### Paso 1: Crear una Cola SQS

**Objetivo:** Crear una cola SQS estándar que actuará como fuente de eventos para la función Lambda.

1. **Crear una Cola SQS con AWS CLI:**

   ```sh
   aws sqs create-queue --queue-name MyLambdaTriggerQueue
   ```

2. **Verificar la Creación de la Cola:**

   ```sh
   aws sqs list-queues
   ```

   - Deberías ver la URL de `MyLambdaTriggerQueue` en la lista de colas.

#### Paso 2: Implementar la Función Lambda

**Objetivo:** Crear una función Lambda que procese los mensajes de la cola SQS.

1. **Configurar el Proyecto Maven (`pom.xml`):**

   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>

       <groupId>com.example</groupId>
       <artifactId>lambda-sqs</artifactId>
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
                                       <mainClass>com.example.LambdaSQSHandler</mainClass>
                                   </transformers>
                               </configuration>
                       </execution>
                   </executions>
               </plugin>
           </plugins>
       </build>
   </project>
   ```

2. **Implementar la Clase Lambda:**

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;
   import com.amazonaws.services.lambda.runtime.events.SQSEvent;

   public class LambdaSQSHandler implements RequestHandler<SQSEvent, Void> {

       @Override
       public Void handleRequest(SQSEvent event, Context context) {
           for (SQSEvent.SQSMessage msg : event.getRecords()) {
               context.getLogger().log("Mensaje recibido: " + msg.getBody());
           }
           return null;
       }
   }
   ```

3. **Construir y Desplegar la Función Lambda:**

   ```sh
   mvn clean package

   aws lambda create-function --function-name LambdaSQSHandler \
       --runtime java11 --role arn:aws:iam::YOUR_ACCOUNT_ID:role/YOUR_LAMBDA_ROLE \
       --handler com.example.LambdaSQSHandler \
       --zip-file fileb://target/lambda-sqs-1.0-SNAPSHOT.jar
   ```

#### Paso 3: Configurar el Trigger de SQS en Lambda

**Objetivo:** Configurar la cola SQS para que desencadene la función Lambda cuando lleguen mensajes.

1. **Obtener la ARN de la Cola SQS:**

   ```sh
   aws sqs get-queue-attributes --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/MyLambdaTriggerQueue --attribute-names QueueArn
   ```

2. **Dar Permisos a SQS para Invocar la Función Lambda:**

   ```sh
   aws lambda add-permission --function-name LambdaSQSHandler --statement-id sqs-invoke --action "lambda:InvokeFunction" --principal sqs.amazonaws.com --source-arn arn:aws:sqs:us-east-1:123456789012:MyLambdaTriggerQueue
   ```

3. **Configurar el Trigger de SQS:**

   ```sh
   aws lambda create-event-source-mapping --function-name LambdaSQSHandler --event-source-arn arn:aws:sqs:us-east-1:123456789012:MyLambdaTriggerQueue --batch-size 10
   ```

#### Paso 4: Probar la Integración

**Objetivo:** Enviar mensajes a la cola SQS y verificar que la función Lambda se ejecuta automáticamente.

1. **Enviar un Mensaje a la Cola SQS:**

   ```sh
   aws sqs send-message --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/MyLambdaTriggerQueue --message-body "Hello, Lambda!"
   ```

2. **Verificar la Ejecución de la Función Lambda:**
   - Accede a la consola de CloudWatch Logs.
   - Encuentra el grupo de logs de la función `LambdaSQSHandler`.
   - Verifica que el mensaje "Hello, Lambda!" fue recibido y registrado.

### Resumen

En esta sección, aprendimos a integrar AWS Lambda con Amazon SQS configurando una cola SQS para que desencadene automáticamente una función Lambda. Este flujo de trabajo permite construir aplicaciones asíncronas y desacopladas, donde los mensajes en una cola SQS pueden procesarse automáticamente mediante funciones Lambda, mejorando la escalabilidad y la resiliencia de las aplicaciones.