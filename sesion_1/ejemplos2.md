# Integración con Otros Servicios de AWS

AWS Lambda puede integrarse con una amplia gama de servicios de AWS, lo que permite la creación de aplicaciones versátiles y escalables. A continuación se presenta una lista de servicios adicionales que se pueden integrar directamente con Lambda, junto con ejemplos de código en Java para cada uno.

## Amazon Kinesis

### Ejemplo 1: Procesar Flujos de Datos

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.KinesisEvent;

public class KinesisProcessor implements RequestHandler<KinesisEvent, Void> {
    @Override
    public Void handleRequest(KinesisEvent event, Context context) {
        event.getRecords().forEach(record -> {
            String data = new String(record.getKinesis().getData().array());
            System.out.println("Data: " + data);
        });
        return null;
    }
}
```

### Ejemplo 2: Almacenar Datos de Kinesis en DynamoDB

```java
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.KinesisEvent;

public class KinesisToDynamoDB implements RequestHandler<KinesisEvent, Void> {
    private final AmazonDynamoDB client = AmazonDynamoDBClientBuilder.standard().build();
    private final DynamoDB dynamoDB = new DynamoDB(client);
    private final Table table = dynamoDB.getTable("MyTable");

    @Override
    public Void handleRequest(KinesisEvent event, Context context) {
        event.getRecords().forEach(record -> {
            String data = new String(record.getKinesis().getData().array());
            table.putItem(new Item().withPrimaryKey("id", UUID.randomUUID().toString()).withString("data", data));
        });
        return null;
    }
}
```

## Amazon RDS

### Ejemplo 1: Conectar y Consultar una Base de Datos MySQL

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class RDSMySQLConnector implements RequestHandler<Object, String> {
    private static final String DB_URL = "jdbc:mysql://your-rds-endpoint:3306/yourdb";
    private static final String USER = "yourusername";
    private static final String PASS = "yourpassword";

    @Override
    public String handleRequest(Object input, Context context) {
        String result = "";
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             Statement stmt = conn.createStatement()) {
            ResultSet rs = stmt.executeQuery("SELECT * FROM yourtable");
            while (rs.next()) {
                result += rs.getString("yourcolumn") + "\n";
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
```

### Ejemplo 2: Insertar Datos en una Base de Datos PostgreSQL

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class RDSPostgresInserter implements RequestHandler<Object, String> {
    private static final String DB_URL = "jdbc:postgresql://your-rds-endpoint:5432/yourdb";
    private static final String USER = "yourusername";
    private static final String PASS = "yourpassword";

    @Override
    public String handleRequest(Object input, Context context) {
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             PreparedStatement pstmt = conn.prepareStatement("INSERT INTO yourtable (yourcolumn) VALUES (?)")) {
            pstmt.setString(1, "yourdata");
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Data inserted";
    }
}
```

## Amazon Elasticsearch Service (OpenSearch Service)

### Ejemplo 1: Indexar Documentos

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import org.apache.http.HttpHost;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.common.xcontent.XContentType;

import java.util.HashMap;
import java.util.Map;

public class ElasticsearchIndexer implements RequestHandler<Object, String> {
    private static final String ES_ENDPOINT = "your-elasticsearch-endpoint";

    @Override
    public String handleRequest(Object input, Context context) {
        try (RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost(ES_ENDPOINT, 443, "https")))) {
            Map<String, Object> jsonMap = new HashMap<>();
            jsonMap.put("field", "value");
            IndexRequest request = new IndexRequest("yourindex").id("1").source(jsonMap, XContentType.JSON);
            client.index(request);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Document indexed";
    }
}
```

### Ejemplo 2: Buscar Documentos

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import org.apache.http.HttpHost;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.builder.SearchSourceBuilder;

public class ElasticsearchSearcher implements RequestHandler<Object, String> {
    private static final String ES_ENDPOINT = "your-elasticsearch-endpoint";

    @Override
    public String handleRequest(Object input, Context context) {
        StringBuilder result = new StringBuilder();
        try (RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost(ES_ENDPOINT, 443, "https")))) {
            SearchRequest searchRequest = new SearchRequest("yourindex");
            SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
            searchSourceBuilder.query(QueryBuilders.matchAllQuery());
            searchRequest.source(searchSourceBuilder);

            SearchResponse response = client.search(searchRequest);
            response.getHits().forEach(hit -> result.append(hit.getSourceAsString()).append("\n"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result.toString();
    }
}
```

## Amazon SES

### Ejemplo 1: Enviar Correo Electrónico

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailService;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailServiceClientBuilder;
import com.amazonaws.services.simpleemail.model.*;

public class SESEmailSender implements RequestHandler<Object, String> {
    private final AmazonSimpleEmailService ses = AmazonSimpleEmailServiceClientBuilder.standard().build();

    @Override
    public String handleRequest(Object input, Context context) {
        try {
            SendEmailRequest request = new SendEmailRequest()
                    .withDestination(new Destination().withToAddresses("recipient@example.com"))
                    .withMessage(new Message()
                            .withBody(new Body().withText(new Content().withCharset("UTF-8").withData("Hello, this is a test email.")))
                            .withSubject(new Content().withCharset("UTF-8").withData("Test Email")))
                    .withSource("sender@example.com");
            ses.sendEmail(request);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Email sent";
    }
}
```

### Ejemplo 2: Enviar Correo Electrónico con HTML

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailService;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailServiceClientBuilder;
import com.amazonaws.services.simpleemail.model.*;

public class SESEmailSenderWithHTML implements RequestHandler<Object, String> {
    private final AmazonSimpleEmailService ses = AmazonSimpleEmailServiceClientBuilder.standard().build();

    @Override
    public String handleRequest(Object input, Context context) {
        try {
            SendEmailRequest request = new SendEmailRequest()
                    .withDestination(new Destination().withToAddresses("recipient@example.com"))
                    .withMessage(new Message()
                            .withBody(new Body().withHtml(new Content().withCharset("UTF-8").withData("<h1>Hello</h1><p>This is a test email with HTML content.</p>")))
                            .withSubject(new Content().withCharset("UTF-8").withData("Test Email with HTML")))
                    .withSource("sender@example.com");
            ses.sendEmail(request);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Email with HTML sent";
    }
}
```

## Amazon CloudWatch

### Ejemplo 1: Enviar Logs a CloudWatch

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.LambdaLogger;

public class CloudWatchLogger implements RequestHandler<Object, String> {
    @Override
    public String handleRequest(Object input, Context context) {
        LambdaLogger logger = context.getLogger();
        logger.log("This is a log message");
        return "Log message sent";
    }
}
```

### Ejemplo 2: Crear Alarma de Cloud

# Integración con Otros Servicios de AWS

AWS Lambda puede integrarse con una amplia variedad de servicios de AWS, permitiendo la creación de aplicaciones flexibles y escalables. A continuación se detallan algunos de los servicios adicionales que pueden integrarse directamente con Lambda, junto con ejemplos de código en Java.

## Amazon Kinesis

### Ejemplo 1: Procesar Flujos de Datos

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.KinesisEvent;

public class KinesisProcessor implements RequestHandler<KinesisEvent, Void> {
    @Override
    public Void handleRequest(KinesisEvent event, Context context) {
        event.getRecords().forEach(record -> {
            String data = new String(record.getKinesis().getData().array());
            System.out.println("Data: " + data);
        });
        return null;
    }
}
```

### Ejemplo 2: Almacenar Datos de Kinesis en DynamoDB

```java
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.KinesisEvent;

public class KinesisToDynamoDB implements RequestHandler<KinesisEvent, Void> {
    private final AmazonDynamoDB client = AmazonDynamoDBClientBuilder.standard().build();
    private final DynamoDB dynamoDB = new DynamoDB(client);
    private final Table table = dynamoDB.getTable("MyTable");

    @Override
    public Void handleRequest(KinesisEvent event, Context context) {
        event.getRecords().forEach(record -> {
            String data = new String(record.getKinesis().getData().array());
            table.putItem(new Item().withPrimaryKey("id", UUID.randomUUID().toString()).withString("data", data));
        });
        return null;
    }
}
```

## Amazon RDS

### Ejemplo 1: Conectar y Consultar una Base de Datos MySQL

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class RDSMySQLConnector implements RequestHandler<Object, String> {
    private static final String DB_URL = "jdbc:mysql://your-rds-endpoint:3306/yourdb";
    private static final String USER = "yourusername";
    private static final String PASS = "yourpassword";

    @Override
    public String handleRequest(Object input, Context context) {
        String result = "";
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             Statement stmt = conn.createStatement()) {
            ResultSet rs = stmt.executeQuery("SELECT * FROM yourtable");
            while (rs.next()) {
                result += rs.getString("yourcolumn") + "\n";
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
```

### Ejemplo 2: Insertar Datos en una Base de Datos PostgreSQL

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class RDSPostgresInserter implements RequestHandler<Object, String> {
    private static final String DB_URL = "jdbc:postgresql://your-rds-endpoint:5432/yourdb";
    private static final String USER = "yourusername";
    private static final String PASS = "yourpassword";

    @Override
    public String handleRequest(Object input, Context context) {
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             PreparedStatement pstmt = conn.prepareStatement("INSERT INTO yourtable (yourcolumn) VALUES (?)")) {
            pstmt.setString(1, "yourdata");
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Data inserted";
    }
}
```

## Amazon Elasticsearch Service (OpenSearch Service)

### Ejemplo 1: Indexar Documentos

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import org.apache.http.HttpHost;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.common.xcontent.XContentType;

import java.util.HashMap;
import java.util.Map;

public class ElasticsearchIndexer implements RequestHandler<Object, String> {
    private static final String ES_ENDPOINT = "your-elasticsearch-endpoint";

    @Override
    public String handleRequest(Object input, Context context) {
        try (RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost(ES_ENDPOINT, 443, "https")))) {
            Map<String, Object> jsonMap = new HashMap<>();
            jsonMap.put("field", "value");
            IndexRequest request = new IndexRequest("yourindex").id("1").source(jsonMap, XContentType.JSON);
            client.index(request);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Document indexed";
    }
}
```

### Ejemplo 2: Buscar Documentos

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import org.apache.http.HttpHost;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.builder.SearchSourceBuilder;

public class ElasticsearchSearcher implements RequestHandler<Object, String> {
    private static final String ES_ENDPOINT = "your-elasticsearch-endpoint";

    @Override
    public String handleRequest(Object input, Context context) {
        StringBuilder result = new StringBuilder();
        try (RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost(ES_ENDPOINT, 443, "https")))) {
            SearchRequest searchRequest = new SearchRequest("yourindex");
            SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
            searchSourceBuilder.query(QueryBuilders.matchAllQuery());
            searchRequest.source(searchSourceBuilder);

            SearchResponse response = client.search(searchRequest);
            response.getHits().forEach(hit -> result.append(hit.getSourceAsString()).append("\n"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result.toString();
    }
}
```

## Amazon SES

### Ejemplo 1: Enviar Correo Electrónico

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailService;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailServiceClientBuilder;
import com.amazonaws.services.simpleemail.model.*;

public class SESEmailSender implements RequestHandler<Object, String> {
    private final AmazonSimpleEmailService ses = AmazonSimpleEmailServiceClientBuilder.standard().build();

    @Override
    public String handleRequest(Object input, Context context) {
        try {
            SendEmailRequest request = new SendEmailRequest()
                    .withDestination(new Destination().withToAddresses("recipient@example.com"))
                    .withMessage(new Message()
                            .withBody(new Body().withText(new Content().withCharset("UTF-8").withData("Hello, this is a test email.")))
                            .withSubject(new Content().withCharset("UTF-8").withData("Test Email")))
                    .withSource("sender@example.com");
            ses.sendEmail(request);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Email sent";
    }
}
```

### Ejemplo 2: Enviar Correo Electrónico con HTML

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailService;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailServiceClientBuilder;
import com.amazonaws.services.simpleemail.model.*;

public class SESEmailSenderWithHTML implements RequestHandler<Object, String> {
    private final AmazonSimpleEmailService ses = AmazonSimpleEmailServiceClientBuilder.standard().build();

    @Override
    public String handleRequest(Object input, Context context) {
        try {
            SendEmailRequest request = new SendEmailRequest()
                    .withDestination(new Destination().withToAddresses("recipient@example.com"))
                    .withMessage(new Message()
                            .withBody(new Body().withHtml(new Content().withCharset("UTF-8").withData("<h1>Hello</h1><p>This is a test email with HTML content.</p>")))
                            .withSubject(new Content().withCharset("UTF-8").withData("Test Email with HTML")))
                    .withSource("sender@example.com");
            ses.sendEmail(request);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Email with HTML sent";
    }
}
```

## Amazon CloudWatch

### Ejemplo 1: Enviar Logs a CloudWatch

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.LambdaLogger;

public class CloudWatchLogger implements RequestHandler<Object, String> {
    @Override
    public String handleRequest(Object input, Context context) {
        LambdaLogger logger = context.getLogger();
        logger.log("This is a log message");
        return "Log message sent";
    }
}
```

### Ejemplo 2: Crear Alarma de CloudWatch

```

# Integración con Otros Servicios de AWS

AWS Lambda puede integrarse con una amplia variedad de servicios de AWS, permitiendo la creación de aplicaciones flexibles y escalables. A continuación se detallan algunos de los servicios adicionales que pueden integrarse directamente con Lambda, junto con ejemplos de código en Java.

## Amazon Kinesis

### Ejemplo 1: Procesar Flujos de Datos

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.KinesisEvent;

public class KinesisProcessor implements RequestHandler<KinesisEvent, Void> {
    @Override
    public Void handleRequest(KinesisEvent event, Context context) {
        event.getRecords().forEach(record -> {
            String data = new String(record.getKinesis().getData().array());
            System.out.println("Data: " + data);
        });
        return null;
    }
}
```

### Ejemplo 2: Almacenar Datos de Kinesis en DynamoDB

```java
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.dynamodbv2.document.Item;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.KinesisEvent;
import java.util.UUID;

public class KinesisToDynamoDB implements RequestHandler<KinesisEvent, Void> {
    private final AmazonDynamoDB client = AmazonDynamoDBClientBuilder.standard().build();
    private final DynamoDB dynamoDB = new DynamoDB(client);
    private final Table table = dynamoDB.getTable("MyTable");

    @Override
    public Void handleRequest(KinesisEvent event, Context context) {
        event.getRecords().forEach(record -> {
            String data = new String(record.getKinesis().getData().array());
            table.putItem(new Item().withPrimaryKey("id", UUID.randomUUID().toString()).withString("data", data));
        });
        return null;
    }
}
```

## Amazon RDS

### Ejemplo 1: Conectar y Consultar una Base de Datos MySQL

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class RDSMySQLConnector implements RequestHandler<Object, String> {
    private static final String DB_URL = "jdbc:mysql://your-rds-endpoint:3306/yourdb";
    private static final String USER = "yourusername";
    private static final String PASS = "yourpassword";

    @Override
    public String handleRequest(Object input, Context context) {
        String result = "";
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             Statement stmt = conn.createStatement()) {
            ResultSet rs = stmt.executeQuery("SELECT * FROM yourtable");
            while (rs.next()) {
                result += rs.getString("yourcolumn") + "\n";
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
```

### Ejemplo 2: Insertar Datos en una Base de Datos PostgreSQL

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class RDSPostgresInserter implements RequestHandler<Object, String> {
    private static final String DB_URL = "jdbc:postgresql://your-rds-endpoint:5432/yourdb";
    private static final String USER = "yourusername";
    private static final String PASS = "yourpassword";

    @Override
    public String handleRequest(Object input, Context context) {
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
             PreparedStatement pstmt = conn.prepareStatement("INSERT INTO yourtable (yourcolumn) VALUES (?)")) {
            pstmt.setString(1, "yourdata");
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Data inserted";
    }
}
```

## Amazon Elasticsearch Service (OpenSearch Service)

### Ejemplo 1: Indexar Documentos

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import org.apache.http.HttpHost;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.common.xcontent.XContentType;

import java.util.HashMap;
import java.util.Map;

public class ElasticsearchIndexer implements RequestHandler<Object, String> {
    private static final String ES_ENDPOINT = "your-elasticsearch-endpoint";

    @Override
    public String handleRequest(Object input, Context context) {
        try (RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost(ES_ENDPOINT, 443, "https")))) {
            Map<String, Object> jsonMap = new HashMap<>();
            jsonMap.put("field", "value");
            IndexRequest request = new IndexRequest("yourindex").id("1").source(jsonMap, XContentType.JSON);
            client.index(request);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Document indexed";
    }
}
```

### Ejemplo 2: Buscar Documentos

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import org.apache.http.HttpHost;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.builder.SearchSourceBuilder;

public class ElasticsearchSearcher implements RequestHandler<Object, String> {
    private static final String ES_ENDPOINT = "your-elasticsearch-endpoint";

    @Override
    public String handleRequest(Object input, Context context) {
        StringBuilder result = new StringBuilder();
        try (RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost(ES_ENDPOINT, 443, "https")))) {
            SearchRequest searchRequest = new SearchRequest("yourindex");
            SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
            searchSourceBuilder.query(QueryBuilders.matchAllQuery());
            searchRequest.source(searchSourceBuilder);

            SearchResponse response = client.search(searchRequest);
            response.getHits().forEach(hit -> result.append(hit.getSourceAsString()).append("\n"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result.toString();
    }
}
```

## Amazon SES

### Ejemplo 1: Enviar Correo Electrónico

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailService;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailServiceClientBuilder;
import com.amazonaws.services.simpleemail.model.*;

public class SESEmailSender implements RequestHandler<Object, String> {
    private final AmazonSimpleEmailService ses = AmazonSimpleEmailServiceClientBuilder.standard().build();

    @Override
    public String handleRequest(Object input, Context context) {
        try {
            SendEmailRequest request = new SendEmailRequest()
                    .withDestination(new Destination().withToAddresses("recipient@example.com"))
                    .withMessage(new Message()
                            .withBody(new Body().withText(new Content().withCharset("UTF-8").withData("Hello, this is a test email.")))
                            .withSubject(new Content().withCharset("UTF-8").withData("Test Email")))
                    .withSource("sender@example.com");
            ses.sendEmail(request);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Email sent";
    }
}
```

### Ejemplo 2: Enviar Correo Electrónico con HTML

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailService;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailServiceClientBuilder;
import com.amazonaws.services.simpleemail.model.*;

public class SESEmailSenderWithHTML implements RequestHandler<Object, String> {
    private final AmazonSimpleEmailService ses = AmazonSimpleEmailServiceClientBuilder.standard().build();

    @Override
    public String handleRequest(Object input, Context context) {
        try {
            SendEmailRequest request = new SendEmailRequest()
                    .withDestination(new Destination().withToAddresses("recipient@example.com"))
                    .withMessage(new Message()
                            .withBody(new Body().withHtml(new Content().withCharset("UTF-8").withData("<h1>Hello</h1><p>This is a test email with HTML content.</p>")))
                            .withSubject(new Content().withCharset("UTF-8").withData("Test Email with HTML")))
                    .withSource("sender@example.com");
            ses.sendEmail(request);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Email with HTML sent";
    }
}
```

## Amazon CloudWatch

### Ejemplo 1: Enviar Logs a CloudWatch

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.LambdaLogger;

public class CloudWatchLogger implements RequestHandler<Object, String> {
    @Override
    public String handleRequest(Object input, Context context) {
        LambdaLogger logger = context.getLogger();
        logger.log("This is a log message");
        return "Log message sent";
    }
}
