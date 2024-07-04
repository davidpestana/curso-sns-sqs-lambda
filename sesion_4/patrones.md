### Patrones de Arquitectura de Eventos en Java

#### 1. Publicador-Suscriptor (Pub/Sub)
**Descripción:**
Un publicador envía mensajes a un tópico SNS, y múltiples suscriptores reciben esos mensajes.

**Ejemplo:**
Un sistema de notificaciones donde un nuevo producto se publica y varias partes de la aplicación reciben la actualización.

**Código:**
```java
import com.amazonaws.services.sns.AmazonSNS;
import com.amazonaws.services.sns.AmazonSNSClientBuilder;
import com.amazonaws.services.sns.model.PublishRequest;

public class PubSubExample {
    public static void main(String[] args) {
        AmazonSNS snsClient = AmazonSNSClientBuilder.defaultClient();
        String topicArn = "arn:aws:sns:us-east-1:123456789012:new-product-topic";

        PublishRequest publishRequest = new PublishRequest(topicArn, "Nuevo producto disponible");
        snsClient.publish(publishRequest);
    }
}
```

#### 2. Cola de Trabajo (Work Queue)
**Descripción:**
Las tareas se colocan en una cola SQS, y los trabajadores consumen las tareas y las procesan.

**Ejemplo:**
Procesamiento de imágenes subidas por usuarios.

**Código:**
```java
import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
import com.amazonaws.services.sqs.model.ReceiveMessageRequest;
import com.amazonaws.services.sqs.model.Message;

public class WorkQueueExample {
    public static void main(String[] args) {
        AmazonSQS sqs = AmazonSQSClientBuilder.defaultClient();
        String queueUrl = "https://sqs.us-east-1.amazonaws.com/123456789012/image-processing-queue";

        ReceiveMessageRequest receiveMessageRequest = new ReceiveMessageRequest(queueUrl);
        List<Message> messages = sqs.receiveMessage(receiveMessageRequest).getMessages();

        for (Message message : messages) {
            System.out.println("Processing image: " + message.getBody());
            // Procesar la imagen
        }
    }
}
```

#### 3. Fan-Out
**Descripción:**
Un mensaje se publica en un tópico SNS y se distribuye a múltiples colas SQS.

**Ejemplo:**
Un sistema de pedidos que notifica a varios servicios (inventario, facturación, envío).

**Código:**
```java
import com.amazonaws.services.sns.AmazonSNS;
import com.amazonaws.services.sns.AmazonSNSClientBuilder;
import com.amazonaws.services.sns.model.PublishRequest;

public class FanOutExample {
    public static void main(String[] args) {
        AmazonSNS snsClient = AmazonSNSClientBuilder.defaultClient();
        String topicArn = "arn:aws:sns:us-east-1:123456789012:order-topic";

        PublishRequest publishRequest = new PublishRequest(topicArn, "Nuevo pedido recibido");
        snsClient.publish(publishRequest);
    }
}
```

#### 4. Event Sourcing
**Descripción:**
Los eventos se registran en el orden en que ocurren y se almacenan para ser reproducidos o consultados posteriormente.

**Ejemplo:**
Registro de transacciones bancarias.

**Código:**
```java
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.dynamodbv2.document.Item;

public class EventSourcingExample {
    public static void main(String[] args) {
        AmazonDynamoDB client = AmazonDynamoDBClientBuilder.defaultClient();
        DynamoDB dynamoDB = new DynamoDB(client);
        Table table = dynamoDB.getTable("Transactions");

        Item item = new Item()
            .withPrimaryKey("eventId", "1")
            .withString("eventType", "TransactionCreated")
            .withString("eventTimestamp", "2023-07-04T12:00:00Z")
            .withMap("eventData", Map.of("transactionId", "123", "amount", 100.00));

        table.putItem(item);
    }
}
```

#### 5. Enrutamiento de Eventos
**Descripción:**
Un evento se enruta a diferentes destinos basado en su contenido o en reglas específicas.

**Ejemplo:**
Envío de alertas a equipos específicos según el tipo de evento.

**Código:**
```java
import com.amazonaws.services.sns.AmazonSNS;
import com.amazonaws.services.sns.AmazonSNSClientBuilder;
import com.amazonaws.services.sns.model.PublishRequest;

public class EventRoutingExample {
    public static void main(String[] args) {
        AmazonSNS snsClient = AmazonSNSClientBuilder.defaultClient();

        String message = "Error: fallo en el sistema";
        String topicArn;
        
        if (message.contains("error")) {
            topicArn = "arn:aws:sns:us-east-1:123456789012:support-team";
        } else {
            topicArn = "arn:aws:sns:us-east-1:123456789012:dev-team";
        }

        PublishRequest publishRequest = new PublishRequest(topicArn, message);
        snsClient.publish(publishRequest);
    }
}
```

#### 6. Compensación de Transacciones
**Descripción:**
Se emiten eventos para deshacer o compensar acciones previas cuando una transacción falla.

**Ejemplo:**
Reversión de un pedido fallido.

**Código:**
```java
import com.amazonaws.services.sns.AmazonSNS;
import com.amazonaws.services.sns.AmazonSNSClientBuilder;
import com.amazonaws.services.sns.model.PublishRequest;

public class TransactionCompensationExample {
    public static void main(String[] args) {
        AmazonSNS snsClient = AmazonSNSClientBuilder.defaultClient();
        String topicArn = "arn:aws:sns:us-east-1:123456789012:compensation-topic";

        String message = "{ \"transactionId\": \"123\", \"status\": \"transactionFailed\" }";
        PublishRequest publishRequest = new PublishRequest(topicArn, "Compensar transacción " + message);
        snsClient.publish(publishRequest);
    }
}
```

#### 7. Agregación de Eventos
**Descripción:**
Múltiples eventos se agrupan y procesan juntos.

**Ejemplo:**
Agregación de datos de sensores en intervalos de tiempo.

**Código:**
```java
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
import com.amazonaws.services.sqs.model.ReceiveMessageRequest;
import com.amazonaws.services.sqs.model.Message;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.ArrayList;
import java.util.List;

public class EventAggregationExample {
    public static void main(String[] args) {
        AmazonSQS sqs = AmazonSQSClientBuilder.defaultClient();
        AmazonS3 s3 = AmazonS3ClientBuilder.defaultClient();
        String queueUrl = "https://sqs.us-east-1.amazonaws.com/123456789012/sensor-data-queue";
        String bucketName = "aggregated-data-bucket";
        String key = "aggregated.json";

        ReceiveMessageRequest receiveMessageRequest = new ReceiveMessageRequest(queueUrl);
        List<Message> messages = sqs.receiveMessage(receiveMessageRequest).getMessages();

        List<Object> aggregatedData = new ArrayList<>();
        ObjectMapper objectMapper = new ObjectMapper();

        for (Message message : messages) {
            try {
                Object data = objectMapper.readValue(message.getBody(), Object.class);
                aggregatedData.add(data);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        try {
            String aggregatedJson = objectMapper.writeValueAsString(aggregatedData);
            s3.putObject(new PutObjectRequest(bucketName, key, aggregatedJson));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

#### 8. Correlación de Eventos
**Descripción:**
Eventos relacionados se correlacionan y se manejan juntos.

**Ejemplo:**
Correlación de inicio y fin de sesión.

**Código:**
```java
import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
import com.amazonaws.services.sqs.model.ReceiveMessageRequest;
import com.amazonaws.services.sqs.model.Message;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EventCorrelationExample {
    public static void main(String[] args) {
        AmazonSQS sqs = AmazonSQSClientBuilder.defaultClient();
        String queueUrl = "https://sqs.us-east-1.amazonaws.com/123456789012/session-events-queue";

        ReceiveMessageRequest receiveMessageRequest = new ReceiveMessageRequest(queueUrl);
        List<Message> messages = sqs.receiveMessage(receiveMessageRequest).getMessages();

        Map<String, Long> sessions = new HashMap<>();
        ObjectMapper objectMapper = new ObjectMapper();

        for (Message message : messages) {
            try {
                Map<String, Object> event = objectMapper.readValue(message.getBody(), Map.class);
                String eventType = (String) event.get("eventType");
                String sessionId = (String) event.get("sessionId");
                long timestamp = (long) event.get("timestamp");

                if ("sessionStart".equals(eventType)) {
                    sessions.put(sessionId, timestamp);
                } else if ("sessionEnd".equals(eventType)) {
                    Long startTime = sessions.remove(sessionId);
                    if (

```java
import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
import com.amazonaws.services.sqs.model.ReceiveMessageRequest;
import com.amazonaws.services.sqs.model.Message;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EventCorrelationExample {
    public static void main(String[] args) {
        AmazonSQS sqs = AmazonSQSClientBuilder.defaultClient();
        String queueUrl = "https://sqs.us-east-1.amazonaws.com/123456789012/session-events-queue";

        ReceiveMessageRequest receiveMessageRequest = new ReceiveMessageRequest(queueUrl);
        List<Message> messages = sqs.receiveMessage(receiveMessageRequest).getMessages();

        Map<String, Long> sessions = new HashMap<>();
        ObjectMapper objectMapper = new ObjectMapper();

        for (Message message : messages) {
            try {
                Map<String, Object> event = objectMapper.readValue(message.getBody(), Map.class);
                String eventType = (String) event.get("eventType");
                String sessionId = (String) event.get("sessionId");
                long timestamp = (long) event.get("timestamp");

                if ("sessionStart".equals(eventType)) {
                    sessions.put(sessionId, timestamp);
                } else if ("sessionEnd".equals(eventType)) {
                    Long startTime = sessions.remove(sessionId);
                    if (startTime != null) {
                        long sessionDuration = timestamp - startTime;
                        System.out.println("Session duration: " + sessionDuration);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
```

#### 9. Procesamiento en Paralelo
**Descripción:**
Los eventos se dividen en subtareas que se procesan en paralelo.

**Ejemplo:**
Procesamiento de grandes conjuntos de datos en paralelo.

**Código:**
```java
import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
import com.amazonaws.services.sqs.model.ReceiveMessageRequest;
import com.amazonaws.services.sqs.model.Message;

import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class ParallelProcessingExample {
    public static void main(String[] args) {
        AmazonSQS sqs = AmazonSQSClientBuilder.defaultClient();
        String queueUrl = "https://sqs.us-east-1.amazonaws.com/123456789012/parallel-processing-queue";

        ReceiveMessageRequest receiveMessageRequest = new ReceiveMessageRequest(queueUrl);
        List<Message> messages = sqs.receiveMessage(receiveMessageRequest).getMessages();

        ExecutorService executorService = Executors.newFixedThreadPool(10);

        for (Message message : messages) {
            Future<?> future = executorService.submit(() -> {
                System.out.println("Processing message: " + message.getBody());
                // Procesar el mensaje
            });
        }

        executorService.shutdown();
    }
}
```

#### 10. Ventana de Tiempo (Time Window)
**Descripción:**
Eventos se agrupan en ventanas de tiempo específicas para procesamiento por lotes.

**Ejemplo:**
Análisis de datos de tráfico de red en intervalos de cinco minutos.

**Código:**
```java
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
import com.amazonaws.services.sqs.model.ReceiveMessageRequest;
import com.amazonaws.services.sqs.model.Message;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class TimeWindowExample {
    public static void main(String[] args) {
        AmazonSQS sqs = AmazonSQSClientBuilder.defaultClient();
        AmazonS3 s3 = AmazonS3ClientBuilder.defaultClient();
        String queueUrl = "https://sqs.us-east-1.amazonaws.com/123456789012/time-window-queue";
        String bucketName = "traffic-data-bucket";

        ReceiveMessageRequest receiveMessageRequest = new ReceiveMessageRequest(queueUrl);
        List<Message> messages = sqs.receiveMessage(receiveMessageRequest).getMessages();

        List<Object> aggregatedData = new ArrayList<>();
        ObjectMapper objectMapper = new ObjectMapper();
        Date now = new Date();
        long fiveMinutesAgo = now.getTime() - 5 * 60 * 1000;

        for (Message message : messages) {
            try {
                Object data = objectMapper.readValue(message.getBody(), Object.class);
                long timestamp = Long.parseLong((String) ((Map<String, Object>) data).get("timestamp"));
                if (timestamp >= fiveMinutesAgo) {
                    aggregatedData.add(data);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        try {
            String key = "traffic-" + now.toInstant().toString() + ".json";
            String aggregatedJson = objectMapper.writeValueAsString(aggregatedData);
            s3.putObject(new PutObjectRequest(bucketName, key, aggregatedJson));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

#### 11. Event Stream Processing
**Descripción:**
Procesamiento continuo de flujos de eventos en tiempo real utilizando herramientas como Amazon Kinesis o Apache Kafka.

**Ejemplo:**
Procesamiento de datos de sensores en tiempo real en una aplicación IoT.

**Código:**
```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.KinesisEvent;

import java.nio.charset.StandardCharsets;

public class EventStreamProcessingExample implements RequestHandler<KinesisEvent, Void> {
    @Override
    public Void handleRequest(KinesisEvent event, Context context) {
        for (KinesisEvent.KinesisEventRecord record : event.getRecords()) {
            String data = StandardCharsets.UTF_8.decode(record.getKinesis().getData()).toString();
            System.out.println("Processing Kinesis data: " + data);
        }
        return null;
    }
}
```

#### 12. Saga Pattern
**Descripción:**
Manejo de transacciones distribuidas donde cada servicio realiza su parte de la transacción y publica un evento para el siguiente paso.

**Ejemplo:**
Gestión de pedidos en una aplicación de comercio electrónico.

**Código:**
```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.SQSEvent;
import com.amazonaws.services.sns.AmazonSNS;
import com.amazonaws.services.sns.AmazonSNSClientBuilder;
import com.amazonaws.services.sns.model.PublishRequest;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.Map;

public class SagaPatternExample implements RequestHandler<SQSEvent, Void> {
    private final AmazonSNS snsClient = AmazonSNSClientBuilder.defaultClient();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public Void handleRequest(SQSEvent event, Context context) {
        for (SQSEvent.SQSMessage message : event.getRecords()) {
            try {
                Map<String, Object> orderEvent = objectMapper.readValue(message.getBody(), Map.class);
                String status = (String) orderEvent.get("status");
                String topicArn;

                if ("orderCreated".equals(status)) {
                    topicArn = "arn:aws:sns:us-east-1:123456789012:payment-topic";
                } else if ("paymentConfirmed".equals(status)) {
                    topicArn = "arn:aws:sns:us-east-1:123456789012:confirmation-topic";
                } else {
                    continue;
                }

                snsClient.publish(new PublishRequest(topicArn, objectMapper.writeValueAsString(orderEvent)));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return null;
    }
}
```

#### 13. Command Query Responsibility Segregation (CQRS)
**Descripción:**
Separación de los modelos de lectura y escritura. Los comandos actualizan el estado, y los eventos reflejan los cambios para los modelos de consulta.

**Ejemplo:**
Sistemas de gestión de contenido donde las operaciones de escritura son manejadas por un servicio y las consultas por otro.

**Código:**
```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.dynamodbv2.document.Item;
import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
import com.amazonaws.services.sqs.model.ReceiveMessageRequest;
import com.amazonaws.services.sqs.model.Message;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.List;
import java.util.Map;

public class CqrsExample implements RequestHandler<Void, Void> {
    private final AmazonSQS sqs = AmazonSQSClientBuilder.defaultClient();
    private final AmazonDynamoDB dynamoDBClient = AmazonDynamoDBClientBuilder.defaultClient();
    private final DynamoDB dynamoDB = new DynamoDB(dynamoDBClient);
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final String queueUrl = "https://sqs.us-east-1.amazonaws.com/123456789012/cqrs-commands-queue";
    private final Table table = dynamoDB.getTable("Commands");

    @

#### 13. Command Query Responsibility Segregation (CQRS)

**Descripción:**
Separación de los modelos de lectura y escritura. Los comandos actualizan el estado, y los eventos reflejan los cambios para los modelos de consulta.

**Ejemplo:**
Sistemas de gestión de contenido donde las operaciones de escritura son manejadas por un servicio y las consultas por otro.

**Código:**
```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.dynamodbv2.document.Item;
import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
import com.amazonaws.services.sqs.model.ReceiveMessageRequest;
import com.amazonaws.services.sqs.model.Message;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.List;
import java.util.Map;

public class CqrsExample implements RequestHandler<Void, Void> {
    private final AmazonSQS sqs = AmazonSQSClientBuilder.defaultClient();
    private final AmazonDynamoDB dynamoDBClient = AmazonDynamoDBClientBuilder.defaultClient();
    private final DynamoDB dynamoDB = new DynamoDB(dynamoDBClient);
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final String queueUrl = "https://sqs.us-east-1.amazonaws.com/123456789012/cqrs-commands-queue";
    private final Table table = dynamoDB.getTable("Commands");

    @Override
    public Void handleRequest(Void input, Context context) {
        ReceiveMessageRequest receiveMessageRequest = new ReceiveMessageRequest(queueUrl);
        List<Message> messages = sqs.receiveMessage(receiveMessageRequest).getMessages();

        for (Message message : messages) {
            try {
                Map<String, Object> command = objectMapper.readValue(message.getBody(), Map.class);
                String commandType = (String) command.get("commandType");

                if ("CreateContent".equals(commandType)) {
                    table.putItem(new Item()
                        .withPrimaryKey("commandId", command.get("commandId"))
                        .withString("content", (String) command.get("content"))
                        .withString("timestamp", (String) command.get("timestamp")));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return null;
    }
}
```

#### 14. Data Pipeline

**Descripción:**
Un flujo de trabajo para mover y transformar datos entre diferentes servicios de AWS.

**Ejemplo:**
ETL (Extract, Transform, Load) en data lakes, usando servicios como AWS Glue y AWS Step Functions.

**Código:**
```java
import com.amazonaws.services.glue.AWSGlue;
import com.amazonaws.services.glue.AWSGlueClientBuilder;
import com.amazonaws.services.glue.model.CreateJobRequest;
import com.amazonaws.services.glue.model.JobCommand;

public class DataPipelineExample {
    public static void main(String[] args) {
        AWSGlue glueClient = AWSGlueClientBuilder.defaultClient();

        CreateJobRequest createJobRequest = new CreateJobRequest()
            .withName("MyGlueJob")
            .withRole("MyGlueRole")
            .withCommand(new JobCommand()
                .withName("glueetl")
                .withScriptLocation("s3://my-bucket/scripts/my-script.py"));

        glueClient.createJob(createJobRequest);
    }
}
```

#### 15. Event-Driven Microservices

**Descripción:**
Cada microservicio publica eventos cuando su estado cambia, y otros microservicios reaccionan a esos eventos.

**Ejemplo:**
Arquitectura de microservicios en una aplicación de comercio electrónico, donde el servicio de inventario actualiza el stock y notifica a otros servicios.

**Código:**
```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.dynamodbv2.document.Item;
import com.amazonaws.services.sns.AmazonSNS;
import com.amazonaws.services.sns.AmazonSNSClientBuilder;
import com.amazonaws.services.sns.model.PublishRequest;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.Map;

public class EventDrivenMicroservicesExample implements RequestHandler<Map<String, Object>, Void> {
    private final AmazonDynamoDB dynamoDBClient = AmazonDynamoDBClientBuilder.defaultClient();
    private final DynamoDB dynamoDB = new DynamoDB(dynamoDBClient);
    private final AmazonSNS snsClient = AmazonSNSClientBuilder.defaultClient();
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final Table inventoryTable = dynamoDB.getTable("Inventory");
    private final String topicArn = "arn:aws:sns:us-east-1:123456789012:inventory-updates";

    @Override
    public Void handleRequest(Map<String, Object> event, Context context) {
        try {
            String productId = (String) event.get("productId");
            int quantity = (int) event.get("quantity");

            inventoryTable.updateItem("productId", productId, "SET quantity = :quantity",
                    new ValueMap().withNumber(":quantity", quantity));

            snsClient.publish(new PublishRequest(topicArn, objectMapper.writeValueAsString(event)));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
```

#### 16. Event Replay

**Descripción:**
Capacidad de reproducir eventos pasados para reconstruir el estado del sistema.

**Ejemplo:**
Restauración del estado del sistema después de una falla o para auditorías y depuración.

**Código:**
```java
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.dynamodbv2.document.Item;
import com.amazonaws.services.dynamodbv2.document.ScanOutcome;
import com.amazonaws.services.dynamodbv2.document.spec.ScanSpec;

public class EventReplayExample {
    public static void main(String[] args) {
        AmazonDynamoDB client = AmazonDynamoDBClientBuilder.defaultClient();
        DynamoDB dynamoDB = new DynamoDB(client);
        Table table = dynamoDB.getTable("Events");

        ScanSpec scanSpec = new ScanSpec();
        for (Item item : table.scan(scanSpec)) {
            System.out.println("Replaying event: " + item.toJSONPretty());
            // Procesar evento para reconstruir el estado
        }
    }
}
```

#### 17. Event Logging

**Descripción:**
Registro de todos los eventos en un almacenamiento duradero para análisis y auditoría posterior.

**Ejemplo:**
Sistemas financieros que requieren mantener un registro completo de todas las transacciones para cumplir con regulaciones.

**Código:**
```java
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.dynamodbv2.document.Item;

public class EventLoggingExample {
    public static void main(String[] args) {
        AmazonDynamoDB client = AmazonDynamoDBClientBuilder.defaultClient();
        DynamoDB dynamoDB = new DynamoDB(client);
        Table table = dynamoDB.getTable("EventLogs");

        Item item = new Item()
            .withPrimaryKey("eventId", "1")
            .withString("eventType", "Transaction")
            .withString("timestamp", "2023-07-04T12:00:00Z")
            .withMap("eventData", Map.of("transactionId", "123", "amount", 100.00));

        table.putItem(item);
    }
}
```

Estos ejemplos en Java muestran cómo implementar diversos patrones de arquitectura de eventos utilizando servicios de AWS como SNS, SQS, Lambda, DynamoDB, S3, y Kinesis.