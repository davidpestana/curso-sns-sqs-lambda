### 4.2. Laboratorio: Implementación de Arquitectura de Eventos

---

## Laboratorio: Implementación de Arquitectura de Eventos

### Descripción del Laboratorio

En este laboratorio, diseñarás e implementarás una arquitectura orientada a eventos utilizando Amazon SNS, SQS y Lambda. El objetivo es crear un sistema que procese pedidos en una tienda online, donde los eventos de pedidos desencadenen flujos de trabajo que incluyan la verificación del inventario y la preparación del envío.

### Recursos Necesarios

- AWS CLI
- SDK de AWS para Java
- IDE (Eclipse, IntelliJ, etc.)
- AWS Management Console

### Ejercicio Práctico

#### Paso 1: Crear un Tópico SNS para Pedidos

**Objetivo:** Crear un tópico SNS para publicar eventos de pedidos.

1. **Crear un Tópico SNS con AWS CLI:**

   ```sh
   aws sns create-topic --name OrderEvents
   ```

2. **Obtener el ARN del Tópico:**

   ```sh
   aws sns list-topics
   ```

#### Paso 2: Crear Colas SQS para Inventario y Envío

**Objetivo:** Crear dos colas SQS, una para la verificación del inventario y otra para la preparación del envío.

1. **Crear una Cola SQS para Inventario:**

   ```sh
   aws sqs create-queue --queue-name InventoryQueue
   ```

2. **Obtener la URL y ARN de la Cola de Inventario:**

   ```sh
   aws sqs get-queue-url --queue-name InventoryQueue
   aws sqs get-queue-attributes --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/InventoryQueue --attribute-names QueueArn
   ```

3. **Crear una Cola SQS para Envío:**

   ```sh
   aws sqs create-queue --queue-name ShippingQueue
   ```

4. **Obtener la URL y ARN de la Cola de Envío:**

   ```sh
   aws sqs get-queue-url --queue-name ShippingQueue
   aws sqs get-queue-attributes --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/ShippingQueue --attribute-names QueueArn
   ```

#### Paso 3: Suscribir las Colas SQS al Tópico SNS

**Objetivo:** Configurar el tópico SNS para enviar eventos a las colas SQS.

1. **Suscribir la Cola de Inventario al Tópico SNS:**

   ```sh
   aws sns subscribe --topic-arn arn:aws:sns:us-east-1:123456789012:OrderEvents --protocol sqs --notification-endpoint arn:aws:sqs:us-east-1:123456789012:InventoryQueue
   ```

2. **Configurar la Política de la Cola de Inventario:**

   ```sh
   aws sqs set-queue-attributes --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/InventoryQueue --attributes '{"Policy":"{\"Version\":\"2012-10-17\",\"Id\":\"SQSPolicy\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"sns.amazonaws.com\"},\"Action\":\"sqs:SendMessage\",\"Resource\":\"arn:aws:sqs:us-east-1:123456789012:InventoryQueue\",\"Condition\":{\"ArnEquals\":{\"aws:SourceArn\":\"arn:aws:sns:us-east-1:123456789012:OrderEvents\"}}}]"}"}'
   ```

3. **Suscribir la Cola de Envío al Tópico SNS:**

   ```sh
   aws sns subscribe --topic-arn arn:aws:sns:us-east-1:123456789012:OrderEvents --protocol sqs --notification-endpoint arn:aws:sqs:us-east-1:123456789012:ShippingQueue
   ```

4. **Configurar la Política de la Cola de Envío:**

   ```sh
   aws sqs set-queue-attributes --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/ShippingQueue --attributes '{"Policy":"{\"Version\":\"2012-10-17\",\"Id\":\"SQSPolicy\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"sns.amazonaws.com\"},\"Action\":\"sqs:SendMessage\",\"Resource\":\"arn:aws:sqs:us-east-1:123456789012:ShippingQueue\",\"Condition\":{\"ArnEquals\":{\"aws:SourceArn\":\"arn:aws:sns:us-east-1:123456789012:OrderEvents\"}}}]"}"}'
   ```

#### Paso 4: Implementar Funciones Lambda para Procesar Eventos

**Objetivo:** Crear funciones Lambda que procesen los eventos de pedidos desde las colas SQS.

1. **Configurar el Proyecto Maven (`pom.xml`):**

   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>

       <groupId>com.example</groupId>
       <artifactId>order-processing</artifactId>
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
                                       <mainClass>com.example.InventoryProcessor</mainClass>
                                   </transformers>
                               </configuration>
                       </execution>
                   </executions>
               </plugin>
           </plugins>
       </build>
   </project>
   ```

2. **Implementar la Clase InventoryProcessor:**

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;
   import com.amazonaws.services.lambda.runtime.events.SQSEvent;

   public class InventoryProcessor implements RequestHandler<SQSEvent, Void> {

       @Override
       public Void handleRequest(SQSEvent event, Context context) {
           for (SQSEvent.SQSMessage msg : event.getRecords()) {
               context.getLogger().log("Verificación de inventario para el pedido: " + msg.getBody());
               // Lógica para verificar el inventario
           }
           return null;
       }
   }
   ```

3. **Implementar la Clase ShippingProcessor:**

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;
   import com.amazonaws.services.lambda.runtime.events.SQSEvent;

   public class ShippingProcessor implements RequestHandler<SQSEvent, Void> {

       @Override
       public Void handleRequest(SQSEvent event, Context context) {
           for (SQSEvent.SQSMessage msg : event.getRecords()) {
               context.getLogger().log("Preparación de envío para el pedido: " + msg.getBody());
               // Lógica para preparar el envío
           }
           return null;
       }
   }
   ```

4. **Construir y Desplegar las Funciones Lambda:**

   ```sh
   mvn clean package

   aws lambda create-function --function-name InventoryProcessor \
       --runtime java11 --role arn:aws:iam::YOUR_ACCOUNT_ID:role/YOUR_LAMBDA_ROLE \
       --handler com.example.InventoryProcessor \
       --zip-file fileb://target/order-processing-1.0-SNAPSHOT.jar

   aws lambda create-function --function-name ShippingProcessor \
       --runtime java11 --role arn:aws:iam::YOUR_ACCOUNT_ID:role/YOUR_LAMBDA_ROLE \
       --handler com.example.ShippingProcessor \
       --zip-file fileb://target/order-processing-1.0-SNAPSHOT.jar
   ```

#### Paso 5: Configurar los Triggers de SQS para Lambda

**Objetivo:** Configurar las colas SQS para que desencadenen las funciones Lambda cuando lleguen mensajes.

1. **Configurar el Trigger de la Cola de Inventario:**

   ```sh
   aws lambda add-permission --function-name InventoryProcessor --statement-id sqs-invoke --action "

lambda:InvokeFunction" --principal sqs.amazonaws.com --source-arn arn:aws:sqs:us-east-1:123456789012:InventoryQueue

   aws lambda create-event-source-mapping --function-name InventoryProcessor --event-source-arn arn:aws:sqs:us-east-1:123456789012:InventoryQueue --batch-size 10
   ```

2. **Configurar el Trigger de la Cola de Envío:**

   ```sh
   aws lambda add-permission --function-name ShippingProcessor --statement-id sqs-invoke --action "lambda:InvokeFunction" --principal sqs.amazonaws.com --source-arn arn:aws:sqs:us-east-1:123456789012:ShippingQueue

   aws lambda create-event-source-mapping --function-name ShippingProcessor --event-source-arn arn:aws:sqs:us-east-1:123456789012:ShippingQueue --batch-size 10
   ```

#### Paso 6: Probar la Integración Completa

**Objetivo:** Publicar mensajes en el tópico SNS y verificar que se procesan automáticamente por las funciones Lambda a través de SQS.

1. **Publicar un Mensaje en el Tópico SNS:**

   ```sh
   aws sns publish --topic-arn arn:aws:sns:us-east-1:123456789012:OrderEvents --message "Pedido de prueba para procesamiento de inventario y envío"
   ```

2. **Verificar la Ejecución de las Funciones Lambda:**
   - Accede a la consola de CloudWatch Logs.
   - Encuentra los grupos de logs de las funciones `InventoryProcessor` y `ShippingProcessor`.
   - Verifica que los mensajes "Pedido de prueba para procesamiento de inventario y envío" fueron recibidos y registrados por ambas funciones.

### Resumen

En este laboratorio, diseñamos e implementamos una arquitectura orientada a eventos utilizando Amazon SNS, SQS y Lambda. Creamos un sistema de procesamiento de pedidos que desencadena flujos de trabajo para la verificación del inventario y la preparación del envío. Esta arquitectura permite construir aplicaciones asíncronas, desacopladas y escalables, mejorando la capacidad de respuesta y la resiliencia de las aplicaciones empresariales.