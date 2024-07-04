### 3.5. Integración de SNS con SQS y Lambda

---

## Integración de SNS con SQS y Lambda

En esta sección, aprenderemos a integrar Amazon SNS con SQS y Lambda para crear una solución que permita enviar mensajes desde SNS a SQS y procesarlos con una función Lambda. Esta configuración es útil para crear aplicaciones asíncronas y desacopladas que pueden escalar fácilmente.

### Enviar Mensajes desde SNS a SQS

#### Paso 1: Crear una Cola SQS

**Objetivo:** Crear una cola SQS que reciba los mensajes enviados a un tópico SNS.

1. **Crear una Cola SQS con AWS CLI:**

   ```sh
   aws sqs create-queue --queue-name MySQSQueue
   ```

2. **Obtener la URL y ARN de la Cola SQS:**

   ```sh
   aws sqs get-queue-url --queue-name MySQSQueue
   aws sqs get-queue-attributes --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/MySQSQueue --attribute-names QueueArn
   ```

#### Paso 2: Crear un Tópico SNS

**Objetivo:** Crear un tópico SNS que enviará mensajes a la cola SQS.

1. **Crear un Tópico SNS con AWS CLI:**

   ```sh
   aws sns create-topic --name MySNSTopic
   ```

2. **Obtener el ARN del Tópico SNS:**

   ```sh
   aws sns list-topics
   ```

#### Paso 3: Suscribir la Cola SQS al Tópico SNS

**Objetivo:** Configurar el tópico SNS para enviar mensajes a la cola SQS.

1. **Suscribir la Cola SQS al Tópico SNS:**

   ```sh
   aws sns subscribe --topic-arn arn:aws:sns:us-east-1:123456789012:MySNSTopic --protocol sqs --notification-endpoint arn:aws:sqs:us-east-1:123456789012:MySQSQueue
   ```

2. **Configurar Permisos de Política de la Cola SQS:**
   - Actualiza la política de la cola SQS para permitir que SNS envíe mensajes a la cola.

   ```sh
   aws sqs set-queue-attributes --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/MySQSQueue --attributes '{"Policy":"{\"Version\":\"2012-10-17\",\"Id\":\"SQSPolicy\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"sns.amazonaws.com\"},\"Action\":\"sqs:SendMessage\",\"Resource\":\"arn:aws:sqs:us-east-1:123456789012:MySQSQueue\",\"Condition\":{\"ArnEquals\":{\"aws:SourceArn\":\"arn:aws:sns:us-east-1:123456789012:MySNSTopic\"}}}]"}"}'
   ```

#### Paso 4: Probar la Integración SNS-SQS

**Objetivo:** Publicar mensajes en el tópico SNS y verificar que se entregan a la cola SQS.

1. **Publicar un Mensaje en el Tópico SNS:**

   ```sh
   aws sns publish --topic-arn arn:aws:sns:us-east-1:123456789012:MySNSTopic --message "Mensaje de prueba a SQS desde SNS"
   ```

2. **Verificar la Recepción del Mensaje en la Cola SQS:**

   ```sh
   aws sqs receive-message --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/MySQSQueue
   ```

### Configurar Lambda para Procesar Mensajes de SQS

#### Paso 5: Implementar la Función Lambda

**Objetivo:** Crear una función Lambda que procese mensajes de la cola SQS.

1. **Configurar el Proyecto Maven (`pom.xml`):**

   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>

       <groupId>com.example</groupId>
       <artifactId>lambda-sqs-processor</artifactId>
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

2. **Implementar la Clase LambdaSQSProcessor:**

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;
   import com.amazonaws.services.lambda.runtime.events.SQSEvent;

   public class LambdaSQSProcessor implements RequestHandler<SQSEvent, Void> {

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

3. **Construir y Desplegar la Función Lambda:**

   ```sh
   mvn clean package

   aws lambda create-function --function-name LambdaSQSProcessor \
       --runtime java11 --role arn:aws:iam::YOUR_ACCOUNT_ID:role/YOUR_LAMBDA_ROLE \
       --handler com.example.LambdaSQSProcessor \
       --zip-file fileb://target/lambda-sqs-processor-1.0-SNAPSHOT.jar
   ```

#### Paso 6: Configurar el Trigger de SQS para Lambda

**Objetivo:** Configurar la cola SQS para que desencadene la función Lambda cuando lleguen mensajes.

1. **Dar Permisos a SQS para Invocar la Función Lambda:**

   ```sh
   aws lambda add-permission --function-name LambdaSQSProcessor --statement-id sqs-invoke --action "lambda:InvokeFunction" --principal sqs.amazonaws.com --source-arn arn:aws:sqs:us-east-1:123456789012:MySQSQueue
   ```

2. **Configurar el Trigger de SQS:**

   ```sh
   aws lambda create-event-source-mapping --function-name LambdaSQSProcessor --event-source-arn arn:aws:sqs:us-east-1:123456789012:MySQSQueue --batch-size 10
   ```

#### Paso 7: Probar la Integración Completa

**Objetivo:** Publicar mensajes en el tópico SNS y verificar que se procesan automáticamente por la función Lambda a través de SQS.

1. **Publicar un Mensaje en el Tópico SNS:**

   ```sh
   aws sns publish --topic-arn arn:aws:sns:us-east-1:123456789012:MySNSTopic --message "Mensaje de prueba para Lambda a través de SQS"
   ```

2. **Verificar la Ejecución de la Función Lambda:**
   - Accede a la consola de CloudWatch Logs.
   - Encuentra el grupo de logs de la función `LambdaSQSProcessor`.
   - Verifica que el mensaje "Mensaje de prueba para Lambda a través de SQS" fue recibido y registrado.

### Resumen

En esta sección, aprendimos a integrar Amazon SNS con SQS y Lambda para crear una solución que permite enviar mensajes desde SNS a SQS y procesarlos con una función Lambda. Este flujo de trabajo facilita la creación de aplicaciones asíncronas y desacopladas, mejorando la escalabilidad y la resiliencia de las aplicaciones.