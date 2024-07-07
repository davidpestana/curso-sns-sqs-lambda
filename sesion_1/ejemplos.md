# Integración de AWS Lambda con Servicios de AWS

AWS Lambda permite ejecutar código sin necesidad de gestionar servidores, lo que facilita la integración con otros servicios de AWS. Aquí se presenta una guía monográfica sobre la integración de Lambda con diversos servicios de AWS, acompañada de ejemplos de código en Java.

## Integración con Amazon S3

### Ejemplo 1: Procesamiento de Cargas de Archivos

Este ejemplo muestra cómo usar Lambda para procesar archivos subidos a un bucket de S3.

**Configuración del Trigger en S3:**

1. Crear un bucket en Amazon S3.
2. Configurar un evento de creación de objeto (put) para invocar la función Lambda.

**Código de Lambda:**

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.S3Event;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.S3Object;
import java.io.BufferedReader;
import java.io.InputStreamReader;

public class S3EventProcessor implements RequestHandler<S3Event, String> {
    private final AmazonS3 s3 = AmazonS3ClientBuilder.standard().build();

    @Override
    public String handleRequest(S3Event s3event, Context context) {
        s3event.getRecords().forEach(record -> {
            String bucketName = record.getS3().getBucket().getName();
            String key = record.getS3().getObject().getKey();
            S3Object s3Object = s3.getObject(bucketName, key);
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(s3Object.getObjectContent()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    System.out.println(line);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
        return "Processed";
    }
}
```

### Ejemplo 2: Generación de Miniaturas

Este ejemplo muestra cómo generar miniaturas de imágenes subidas a un bucket de S3.

**Código de Lambda:**

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.S3Event;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.PutObjectRequest;

import java.awt.image.BufferedImage;
import java.io.File;
import javax.imageio.ImageIO;

public class ThumbnailGenerator implements RequestHandler<S3Event, String> {
    private final AmazonS3 s3 = AmazonS3ClientBuilder.standard().build();

    @Override
    public String handleRequest(S3Event s3event, Context context) {
        s3event.getRecords().forEach(record -> {
            String bucketName = record.getS3().getBucket().getName();
            String key = record.getS3().getObject().getKey();
            S3Object s3Object = s3.getObject(bucketName, key);
            try {
                BufferedImage img = ImageIO.read(s3Object.getObjectContent());
                BufferedImage thumbnail = resize(img, 100, 100);
                File thumbnailFile = new File("/tmp/thumbnail.png");
                ImageIO.write(thumbnail, "png", thumbnailFile);
                s3.putObject(new PutObjectRequest(bucketName, "thumbnails/" + key, thumbnailFile));
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
        return "Thumbnails generated";
    }

    private BufferedImage resize(BufferedImage img, int newW, int newH) {
        BufferedImage resized = new BufferedImage(newW, newH, img.getType());
        resized.getGraphics().drawImage(img, 0, 0, newW, newH, null);
        return resized;
    }
}
```

## Integración con Amazon DynamoDB

### Ejemplo 1: Insertar Datos

Este ejemplo muestra cómo insertar datos en una tabla de DynamoDB.

**Código de Lambda:**

```java
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.dynamodbv2.model.PutItemRequest;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.SNSEvent;

public class DynamoDBInserter implements RequestHandler<SNSEvent, String> {
    private final AmazonDynamoDB client = AmazonDynamoDBClientBuilder.standard().build();
    private final DynamoDB dynamoDB = new DynamoDB(client);
    private final Table table = dynamoDB.getTable("MyTable");

    @Override
    public String handleRequest(SNSEvent event, Context context) {
        event.getRecords().forEach(record -> {
            String message = record.getSNS().getMessage();
            table.putItem(new PutItemRequest().withItem(new HashMap<String, Object>() {{
                put("Message", message);
            }}));
        });
        return "Data inserted";
    }
}
```

### Ejemplo 2: Leer Datos

Este ejemplo muestra cómo leer datos desde una tabla de DynamoDB.

**Código de Lambda:**

```java
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Item;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;

public class DynamoDBReader implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {
    private final AmazonDynamoDB client = AmazonDynamoDBClientBuilder.standard().build();
    private final DynamoDB dynamoDB = new DynamoDB(client);
    private final Table table = dynamoDB.getTable("MyTable");

    @Override
    public APIGatewayProxyResponseEvent handleRequest(APIGatewayProxyRequestEvent request, Context context) {
        String key = request.getPathParameters().get("id");
        Item item = table.getItem("id", key);
        return new APIGatewayProxyResponseEvent().withStatusCode(200).withBody(item.toJSON());
    }
}
```

## Integración con Amazon SNS

### Ejemplo 1: Publicar Mensajes

Este ejemplo muestra cómo publicar mensajes en un tema de SNS.

**Código de Lambda:**

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.S3Event;
import com.amazonaws.services.sns.AmazonSNS;
import com.amazonaws.services.sns.AmazonSNSClientBuilder;
import com.amazonaws.services.sns.model.PublishRequest;

public class SNSPublisher implements RequestHandler<S3Event, String> {
    private final AmazonSNS sns = AmazonSNSClientBuilder.standard().build();

    @Override
    public String handleRequest(S3Event event, Context context) {
        event.getRecords().forEach(record -> {
            String message = "New object uploaded: " + record.getS3().getObject().getKey();
            sns.publish(new PublishRequest("arn:aws:sns:us-east-1:123456789012:MyTopic", message));
        });
        return "Messages published";
    }
}
```

### Ejemplo 2: Enviar Notificaciones por Correo Electrónico

Este ejemplo muestra cómo enviar notificaciones por correo electrónico utilizando SNS.

**Código de Lambda:**

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.SNSEvent;
import com.amazonaws.services.sns.AmazonSNS;
import com.amazonaws.services.sns.AmazonSNSClientBuilder;
import com.amazonaws.services.sns.model.PublishRequest;

public class EmailNotifier implements RequestHandler<SNSEvent, String> {
    private final AmazonSNS sns = AmazonSNSClientBuilder.standard().build();

    @Override
    public String handleRequest(SNSEvent event, Context context) {
        event.getRecords().forEach(record -> {
            String message = "New SNS message: " + record.getSNS().getMessage();
            sns.publish(new PublishRequest("arn:aws:sns:us-east-1:123456789012:EmailTopic", message));
        });
        return "Notifications sent";
    }
}
```

## Integración con Amazon SQS

### Ejemplo 1: Enviar Mensajes a una Cola

Este ejemplo muestra cómo enviar mensajes a una cola de SQS.

**Código de Lambda:**

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.S3Event;
import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
import com.amazonaws.services.sqs.model.SendMessageRequest;

public class SQSSender implements RequestHandler<S3Event, String> {
    private final AmazonSQS sqs = AmazonSQSClientBuilder.standard().build();
    private final String queueUrl = "https://sqs.us-east-1.amazonaws.com/123456789012/MyQueue";

    @Override
    public String handleRequest(S3Event event, Context context) {
        event.getRecords().forEach(record -> {
            String message = "New object