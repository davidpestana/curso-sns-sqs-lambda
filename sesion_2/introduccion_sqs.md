### 2.4. Introducción a Amazon SQS

---

## Introducción a Amazon SQS

Amazon Simple Queue Service (SQS) es un servicio de mensajería totalmente gestionado que permite desacoplar y escalar microservicios, sistemas distribuidos y aplicaciones sin servidor. En esta sección, cubriremos los conceptos básicos de SQS, incluyendo los tipos de colas disponibles: Estándar y FIFO.

### Conceptos Básicos de SQS

Amazon SQS proporciona colas de mensajes que permiten la comunicación asíncrona entre componentes de un sistema distribuido. Los mensajes pueden ser encolados por un productor y procesados posteriormente por un consumidor. Esto permite desacoplar los componentes del sistema, mejorando la escalabilidad y la resiliencia.

**Componentes Clave de SQS:**

1. **Colas de Mensajes:**
   - Las colas de SQS almacenan mensajes hasta que un componente los procesa.
   
2. **Productores y Consumidores:**
   - Los productores envían mensajes a las colas, y los consumidores recuperan y procesan esos mensajes.

3. **Mensajes:**
   - Cada mensaje puede contener hasta 256 KB de datos en formato texto o binario.

**Ventajas de SQS:**

- **Desacoplamiento:** Permite que los componentes del sistema interactúen de manera asíncrona y desacoplada.
- **Escalabilidad:** Puede manejar cualquier volumen de mensajes sin necesidad de preocuparse por la administración de la infraestructura subyacente.
- **Fiabilidad:** Garantiza la entrega de mensajes con múltiples intentos de reenvío y opciones de almacenamiento de mensajes fallidos (dead-letter queues).

### Tipos de Colas: Estándar y FIFO

Amazon SQS ofrece dos tipos de colas: Estándar y FIFO, cada una diseñada para diferentes casos de uso.

#### Colas Estándar

Las colas estándar ofrecen un rendimiento casi ilimitado y garantizan la entrega de mensajes al menos una vez. Sin embargo, los mensajes pueden ser entregados en un orden diferente al que fueron enviados y pueden ser entregados más de una vez.

**Características de las Colas Estándar:**

- **Escalabilidad:** Soportan un número casi ilimitado de transacciones por segundo.
- **Entrega Múltiple:** Los mensajes pueden ser entregados más de una vez.
- **Orden de Mensajes:** La entrega de mensajes no está garantizada en el orden en que fueron enviados.

**Casos de Uso Comunes:**

- **Procesamiento de Tareas en Segundo Plano:** Ideal para trabajos en lotes y tareas que no requieren un orden estricto.
- **Desacoplamiento de Microservicios:** Permite la comunicación asíncrona entre componentes de un sistema distribuido.

#### Colas FIFO

Las colas FIFO (First-In-First-Out) garantizan que los mensajes sean procesados en el orden exacto en que fueron enviados y garantizan que cada mensaje sea procesado exactamente una vez.

**Características de las Colas FIFO:**

- **Orden Estricto:** Los mensajes se entregan y procesan en el orden exacto en que fueron enviados.
- **Entrega Única:** Cada mensaje es entregado y procesado exactamente una vez.
- **Grupos de Mensajes:** Permiten procesar mensajes en grupos para mantener el orden en diferentes flujos de trabajo.

**Casos de Uso Comunes:**

- **Procesamiento de Transacciones Financieras:** Donde el orden y la entrega única de mensajes es crucial.
- **Sistemas de Reservas:** Como sistemas de boletos, donde el orden de las solicitudes es importante.

### Comparación de Colas Estándar y FIFO

| Característica            | Colas Estándar                | Colas FIFO                    |
|---------------------------|-------------------------------|-------------------------------|
| Orden de Mensajes         | No garantizado                | Garantizado                   |
| Entrega de Mensajes       | Múltiples entregas posibles   | Entrega única                 |
| Escalabilidad             | Alta                          | Limitada a 300 TPS (por defecto) |
| Uso Típico                | Procesamiento de tareas en segundo plano, desacoplamiento de microservicios | Procesamiento de transacciones financieras, sistemas de reservas |

### Ejemplo de Uso de SQS con AWS SDK para Java

Vamos a ver un ejemplo de cómo interactuar con SQS utilizando AWS SDK para Java. Este ejemplo cubrirá la creación de una cola, el envío de un mensaje y la recepción de mensajes.

#### Dependencias Maven

Primero, asegúrate de tener las siguientes dependencias en tu archivo `pom.xml`:

```xml
<dependencies>
    <dependency>
        <groupId>com.amazonaws</groupId>
        <artifactId>aws-java-sdk-sqs</artifactId>
        <version>1.12.118</version>
    </dependency>
</dependencies>
```

#### Código de Ejemplo

1. **Crear una Cola SQS:**

   ```java
   import com.amazonaws.services.sqs.AmazonSQS;
   import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
   import com.amazonaws.services.sqs.model.CreateQueueRequest;
   import com.amazonaws.services.sqs.model.CreateQueueResult;

   public class SQSDemo {

       public static void main(String[] args) {
           AmazonSQS sqsClient = AmazonSQSClientBuilder.defaultClient();

           // Crear una cola SQS
           CreateQueueRequest createQueueRequest = new CreateQueueRequest("MyQueue");
           CreateQueueResult createQueueResult = sqsClient.createQueue(createQueueRequest);

           // Obtener la URL de la cola
           String queueUrl = createQueueResult.getQueueUrl();
           System.out.println("Cola creada con URL: " + queueUrl);
       }
   }
   ```

2. **Enviar un Mensaje a la Cola SQS:**

   ```java
   import com.amazonaws.services.sqs.model.SendMessageRequest;
   import com.amazonaws.services.sqs.model.SendMessageResult;

   public class SQSDemo {

       public static void main(String[] args) {
           AmazonSQS sqsClient = AmazonSQSClientBuilder.defaultClient();
           String queueUrl = "https://sqs.us-east-1.amazonaws.com/123456789012/MyQueue";

           // Enviar un mensaje a la cola
           SendMessageRequest sendMessageRequest = new SendMessageRequest()
                   .withQueueUrl(queueUrl)
                   .withMessageBody("Hello, SQS!");
           SendMessageResult sendMessageResult = sqsClient.sendMessage(sendMessageRequest);

           System.out.println("Mensaje enviado con ID: " + sendMessageResult.getMessageId());
       }
   }
   ```

3. **Recibir Mensajes de la Cola SQS:**

   ```java
   import com.amazonaws.services.sqs.model.ReceiveMessageRequest;
   import com.amazonaws.services.sqs.model.ReceiveMessageResult;
   import com.amazonaws.services.sqs.model.Message;

   public class SQSDemo {

       public static void main(String[] args) {
           AmazonSQS sqsClient = AmazonSQSClientBuilder.defaultClient();
           String queueUrl = "https://sqs.us-east-1.amazonaws.com/123456789012/MyQueue";

           // Recibir mensajes de la cola
           ReceiveMessageRequest receiveMessageRequest = new ReceiveMessageRequest(queueUrl);
           ReceiveMessageResult receiveMessageResult = sqsClient.receiveMessage(receiveMessageRequest);

           for (Message message : receiveMessageResult.getMessages()) {
               System.out.println("Mensaje recibido: " + message.getBody());
           }
       }
   }
   ```

### Conclusión

Amazon SQS es una herramienta poderosa para desacoplar y escalar aplicaciones distribuidas. Ofrece flexibilidad con colas estándar y FIFO, cada una adecuada para diferentes casos de uso. Utilizando el SDK de AWS para Java, puedes crear, enviar y recibir mensajes de colas SQS de manera eficiente, facilitando la comunicación asíncrona entre componentes de tu aplicación.