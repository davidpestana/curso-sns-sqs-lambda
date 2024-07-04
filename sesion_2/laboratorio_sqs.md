### 2.5. Laboratorio: Configuración de SQS

---

## Laboratorio: Configuración de SQS

### Descripción del Laboratorio

En este laboratorio, aprenderás a crear y configurar una cola SQS estándar, enviar mensajes de prueba y leer los mensajes de la cola utilizando una aplicación Java. Este ejercicio te ayudará a comprender cómo utilizar Amazon SQS para desacoplar componentes de una aplicación y manejar la comunicación asíncrona.

### Recursos Necesarios

- AWS CLI
- SDK de AWS para Java
- IDE (Eclipse, IntelliJ, etc.)

### Ejercicio Práctico

#### Paso 1: Crear una Cola SQS

**Objetivo:** Crear una cola SQS estándar utilizando AWS CLI y verificar su creación.

1. **Crear una Cola SQS con AWS CLI:**
   - Abre tu terminal y ejecuta el siguiente comando para crear una cola SQS estándar llamada `MyStandardQueue`:

   ```sh
   aws sqs create-queue --queue-name MyStandardQueue
   ```

2. **Verificar la Creación de la Cola:**
   - Ejecuta el siguiente comando para listar las colas y verificar que `MyStandardQueue` ha sido creada:

   ```sh
   aws sqs list-queues
   ```

   - Deberías ver la URL de `MyStandardQueue` en la lista de colas.

#### Paso 2: Configurar el Proyecto Maven

**Objetivo:** Configurar un proyecto Maven con las dependencias necesarias para interactuar con SQS.

1. **Crear un nuevo proyecto Maven en tu IDE:**
   - Abre tu IDE y crea un nuevo proyecto Maven.
   - Configura el `pom.xml` con las dependencias necesarias para AWS SQS.

   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>

       <groupId>com.example</groupId>
       <artifactId>sqs-lab</artifactId>
       <version>1.0-SNAPSHOT</version>

       <dependencies>
           <dependency>
               <groupId>com.amazonaws</groupId>
               <artifactId>aws-java-sdk-sqs</artifactId>
               <version>1.12.118</version>
           </dependency>
           <dependency>
               <groupId>junit</groupId>
               <artifactId>junit</artifactId>
               <version>4.12</version>
               <scope>test</scope>
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
           </plugins>
       </build>
   </project>
   ```

#### Paso 3: Enviar Mensajes a la Cola SQS

**Objetivo:** Escribir un programa Java que envíe mensajes a la cola SQS.

1. **Crear una Clase para Enviar Mensajes:**

   ```java
   package com.example;

   import com.amazonaws.services.sqs.AmazonSQS;
   import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
   import com.amazonaws.services.sqs.model.SendMessageRequest;
   import com.amazonaws.services.sqs.model.SendMessageResult;

   public class SQSSender {

       public static void main(String[] args) {
           AmazonSQS sqsClient = AmazonSQSClientBuilder.defaultClient();
           String queueUrl = "https://sqs.us-east-1.amazonaws.com/123456789012/MyStandardQueue";

           // Enviar un mensaje a la cola
           SendMessageRequest sendMessageRequest = new SendMessageRequest()
                   .withQueueUrl(queueUrl)
                   .withMessageBody("Hello, SQS!");
           SendMessageResult sendMessageResult = sqsClient.sendMessage(sendMessageRequest);

           System.out.println("Mensaje enviado con ID: " + sendMessageResult.getMessageId());
       }
   }
   ```

2. **Ejecutar el Programa para Enviar Mensajes:**
   - Ejecuta la clase `SQSSender` desde tu IDE para enviar un mensaje a la cola SQS.

#### Paso 4: Leer Mensajes de la Cola SQS

**Objetivo:** Escribir un programa Java que lea mensajes de la cola SQS.

1. **Crear una Clase para Leer Mensajes:**

   ```java
   package com.example;

   import com.amazonaws.services.sqs.AmazonSQS;
   import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
   import com.amazonaws.services.sqs.model.ReceiveMessageRequest;
   import com.amazonaws.services.sqs.model.ReceiveMessageResult;
   import com.amazonaws.services.sqs.model.Message;

   public class SQSReceiver {

       public static void main(String[] args) {
           AmazonSQS sqsClient = AmazonSQSClientBuilder.defaultClient();
           String queueUrl = "https://sqs.us-east-1.amazonaws.com/123456789012/MyStandardQueue";

           // Recibir mensajes de la cola
           ReceiveMessageRequest receiveMessageRequest = new ReceiveMessageRequest(queueUrl);
           ReceiveMessageResult receiveMessageResult = sqsClient.receiveMessage(receiveMessageRequest);

           for (Message message : receiveMessageResult.getMessages()) {
               System.out.println("Mensaje recibido: " + message.getBody());
           }
       }
   }
   ```

2. **Ejecutar el Programa para Leer Mensajes:**
   - Ejecuta la clase `SQSReceiver` desde tu IDE para leer los mensajes de la cola SQS.

#### Paso 5: Manejo de Mensajes Recibidos

**Objetivo:** Implementar la lógica para eliminar mensajes de la cola después de procesarlos.

1. **Modificar la Clase `SQSReceiver` para Eliminar Mensajes:**

   ```java
   package com.example;

   import com.amazonaws.services.sqs.AmazonSQS;
   import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
   import com.amazonaws.services.sqs.model.ReceiveMessageRequest;
   import com.amazonaws.services.sqs.model.ReceiveMessageResult;
   import com.amazonaws.services.sqs.model.Message;
   import com.amazonaws.services.sqs.model.DeleteMessageRequest;

   public class SQSReceiver {

       public static void main(String[] args) {
           AmazonSQS sqsClient = AmazonSQSClientBuilder.defaultClient();
           String queueUrl = "https://sqs.us-east-1.amazonaws.com/123456789012/MyStandardQueue";

           // Recibir mensajes de la cola
           ReceiveMessageRequest receiveMessageRequest = new ReceiveMessageRequest(queueUrl);
           ReceiveMessageResult receiveMessageResult = sqsClient.receiveMessage(receiveMessageRequest);

           for (Message message : receiveMessageResult.getMessages()) {
               System.out.println("Mensaje recibido: " + message.getBody());

               // Eliminar el mensaje después de procesarlo
               String messageReceiptHandle = message.getReceiptHandle();
               sqsClient.deleteMessage(new DeleteMessageRequest(queueUrl, messageReceiptHandle));
               System.out.println("Mensaje eliminado: " + message.getMessageId());
           }
       }
   }
   ```

2. **Ejecutar el Programa para Leer y Eliminar Mensajes:**
   - Ejecuta la clase `SQSReceiver` desde tu IDE para leer y eliminar los mensajes de la cola SQS después de procesarlos.

### Resumen

En este laboratorio, hemos creado y configurado una cola SQS estándar, enviado mensajes de prueba y leído mensajes de la cola utilizando una aplicación Java. Hemos aprendido a manejar la comunicación asíncrona entre componentes de una aplicación utilizando Amazon SQS, lo que facilita el desacoplamiento y mejora la escalabilidad y la resiliencia del sistema.