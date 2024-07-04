### 4.6. Laboratorio: Seguridad y Permisos

---

## Laboratorio: Seguridad y Permisos

### Descripción del Laboratorio

En este laboratorio, configuraremos roles y políticas de IAM para una función Lambda, un tópico SNS y una cola SQS. Aprenderemos a crear y asignar permisos para asegurar que solo los recursos autorizados puedan acceder y ejecutar nuestras funciones y servicios.

### Recursos Necesarios

- AWS CLI
- AWS Management Console
- SDK de AWS para Java (opcional)
- IDE (Eclipse, IntelliJ, etc.)

### Ejercicio Práctico

#### Paso 1: Crear Roles de IAM

**Objetivo:** Crear roles de IAM que otorgan permisos a una función Lambda para interactuar con SNS y SQS.

1. **Crear un Rol de IAM para Lambda:**

   ```sh
   aws iam create-role --role-name LambdaExecutionRole --assume-role-policy-document file://trust-policy.json
   ```

   Contenido de `trust-policy.json`:

   ```json
   {
       "Version": "2012-10-17",
       "Statement": [
           {
               "Effect": "Allow",
               "Principal": {
                   "Service": "lambda.amazonaws.com"
               },
               "Action": "sts:AssumeRole"
           }
       ]
   }
   ```

2. **Adjuntar la Política de Ejecución Básica para Lambda:**

   ```sh
   aws iam attach-role-policy --role-name LambdaExecutionRole --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
   ```

3. **Crear un Rol de IAM para SNS:**

   ```sh
   aws iam create-role --role-name SNSExecutionRole --assume-role-policy-document file://trust-policy-sns.json
   ```

   Contenido de `trust-policy-sns.json`:

   ```json
   {
       "Version": "2012-10-17",
       "Statement": [
           {
               "Effect": "Allow",
               "Principal": {
                   "Service": "sns.amazonaws.com"
               },
               "Action": "sts:AssumeRole"
           }
       ]
   }
   ```

4. **Adjuntar una Política para SNS:**

   ```sh
   aws iam attach-role-policy --role-name SNSExecutionRole --policy-arn arn:aws:iam::aws:policy/AmazonSNSFullAccess
   ```

5. **Crear un Rol de IAM para SQS:**

   ```sh
   aws iam create-role --role-name SQSExecutionRole --assume-role-policy-document file://trust-policy-sqs.json
   ```

   Contenido de `trust-policy-sqs.json`:

   ```json
   {
       "Version": "2012-10-17",
       "Statement": [
           {
               "Effect": "Allow",
               "Principal": {
                   "Service": "sqs.amazonaws.com"
               },
               "Action": "sts:AssumeRole"
           }
       ]
   }
   ```

6. **Adjuntar una Política para SQS:**

   ```sh
   aws iam attach-role-policy --role-name SQSExecutionRole --policy-arn arn:aws:iam::aws:policy/AmazonSQSFullAccess
   ```

#### Paso 2: Crear y Configurar una Función Lambda

**Objetivo:** Crear una función Lambda que procese mensajes de una cola SQS.

1. **Configurar el Proyecto Maven (`pom.xml`):**

   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>

       <groupId>com.example</groupId>
       <artifactId>secure-lambda</artifactId>
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
           <dependency>
               <groupId>com.amazonaws</groupId>
               <artifactId>aws-java-sdk-sns</artifactId>
               <version>1.12.118</version>
           </dependency>
           <dependency>
               <groupId>com.amazonaws</groupId>
               <artifactId>aws-java-sdk-sqs</artifactId>
               <version>1.12.118</version>
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
                                       <mainClass>com.example.SecureLambdaHandler</mainClass>
                                   </transformers>
                               </configuration>
                       </execution>
                   </executions>
               </plugin>
           </plugins>
       </build>
   </project>
   ```

2. **Implementar la Clase SecureLambdaHandler:**

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;
   import com.amazonaws.services.lambda.runtime.events.SQSEvent;

   public class SecureLambdaHandler implements RequestHandler<SQSEvent, String> {

       @Override
       public String handleRequest(SQSEvent event, Context context) {
           context.getLogger().log("Procesando evento SQS...");
           for (SQSEvent.SQSMessage msg : event.getRecords()) {
               context.getLogger().log("Mensaje recibido: " + msg.getBody());
               // Procesar el mensaje
           }
           return "Procesado correctamente.";
       }
   }
   ```

3. **Construir el Proyecto:**

   ```sh
   mvn clean package
   ```

4. **Desplegar la Función Lambda:**

   ```sh
   aws lambda create-function --function-name SecureLambdaHandler \
       --runtime java11 --role arn:aws:iam::YOUR_ACCOUNT_ID:role/LambdaExecutionRole \
       --handler com.example.SecureLambdaHandler \
       --zip-file fileb://target/secure-lambda-1.0-SNAPSHOT.jar
   ```

#### Paso 3: Configurar SNS y SQS

**Objetivo:** Crear un tópico SNS y una cola SQS, y configurar sus permisos.

1. **Crear un Tópico SNS:**

   ```sh
   aws sns create-topic --name SecureSNSTopic
   ```

2. **Crear una Cola SQS:**

   ```sh
   aws sqs create-queue --queue-name SecureSQSQueue
   ```

3. **Obtener la URL y ARN de la Cola SQS:**

   ```sh
   aws sqs get-queue-url --queue-name SecureSQSQueue
   aws sqs get-queue-attributes --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/SecureSQSQueue --attribute-names QueueArn
   ```

4. **Suscribir la Cola SQS al Tópico SNS:**

   ```sh
   aws sns subscribe --topic-arn arn:aws:sns:us-east-1:123456789012:SecureSNSTopic --protocol sqs --notification-endpoint arn:aws:sqs:us-east-1:123456789012:SecureSQSQueue
   ```

5. **Configurar la Política de la Cola SQS:**

   ```sh
   aws sqs set-queue-attributes --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/SecureSQSQueue --attributes '{"Policy":"{\"Version\":\"2012-10-17\",\"Id\":\"SQSPolicy\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"sns.amazonaws.com\"},\"Action\":\"sqs:SendMessage\",\"Resource\":\"arn:aws:sqs:us-east-1:123456789012:SecureSQSQueue\",\"Condition\":{\"ArnEquals\":{\"aws:SourceArn\":\"arn:aws:sns:us-east-1:123456789012:SecureSNSTopic\"}}}]"}"}'
   ```

#### Paso 4: Configurar el Trigger de SQS para Lambda

**Objetivo:** Configurar la cola SQS para que desencadene la función Lambda cuando lleguen mensajes.

1. **Configurar el Trigger de la Cola SQS:**

   ```sh
   aws lambda create-event-source-mapping --function-name SecureLambdaHandler --event-source-arn arn:aws:sqs:us-east-1

:123456789012:SecureSQSQueue --batch-size 10
   ```

2. **Dar Permisos a SQS para Invocar la Función Lambda:**

   ```sh
   aws lambda add-permission --function-name SecureLambdaHandler --statement-id sqs-invoke --action "lambda:InvokeFunction" --principal sqs.amazonaws.com --source-arn arn:aws:sqs:us-east-1:123456789012:SecureSQSQueue
   ```

#### Paso 5: Probar la Configuración

**Objetivo:** Publicar mensajes en el tópico SNS y verificar que se procesan automáticamente por la función Lambda a través de SQS.

1. **Publicar un Mensaje en el Tópico SNS:**

   ```sh
   aws sns publish --topic-arn arn:aws:sns:us-east-1:123456789012:SecureSNSTopic --message "Mensaje de prueba para Lambda a través de SQS"
   ```

2. **Verificar la Ejecución de la Función Lambda:**
   - Accede a la consola de CloudWatch Logs.
   - Encuentra el grupo de logs de la función `SecureLambdaHandler`.
   - Verifica que el mensaje "Mensaje de prueba para Lambda a través de SQS" fue recibido y registrado.

### Resumen

En este laboratorio, configuramos roles y políticas de IAM para asegurar que solo los recursos autorizados puedan acceder y ejecutar nuestras funciones y servicios. Creamos y configuramos una función Lambda, un tópico SNS y una cola SQS, y verificamos que la configuración de seguridad funciona correctamente al procesar mensajes de manera automática. Estas prácticas son esenciales para asegurar la integridad y la seguridad de las aplicaciones en AWS.