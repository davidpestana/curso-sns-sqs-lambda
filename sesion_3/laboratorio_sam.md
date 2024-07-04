### 3.8. Laboratorio: Implementación de Aplicaciones Serverless con SAM

---

## Laboratorio: Implementación de Aplicaciones Serverless con SAM

### Descripción del Laboratorio

En este laboratorio, definiremos e implementaremos una aplicación serverless utilizando AWS Serverless Application Model (SAM). Crearemos una función Lambda, una API Gateway para invocar la función y una tabla DynamoDB para almacenar datos. Desplegaremos esta infraestructura y probaremos la aplicación.

### Recursos Necesarios

- AWS CLI
- AWS SAM CLI
- SDK de AWS para Java (opcional)
- IDE (Eclipse, IntelliJ, etc.)
- AWS Management Console

### Ejercicio Práctico

#### Paso 1: Configurar el Proyecto Maven

**Objetivo:** Configurar un proyecto Maven con las dependencias necesarias para AWS Lambda.

1. **Crear un Proyecto Maven (`pom.xml`):**

   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>

       <groupId>com.example</groupId>
       <artifactId>lambda-sam-app</artifactId>
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
               <artifactId>aws-java-sdk-dynamodb</artifactId>
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
                                       <mainClass>com.example.MyLambdaHandler</mainClass>
                                   </transformers>
                               </configuration>
                       </execution>
                   </executions>
               </plugin>
           </plugins>
       </build>
   </project>
   ```

2. **Implementar la Clase MyLambdaHandler:**

   ```java
   package com.example;

   import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
   import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
   import com.amazonaws.services.dynamodbv2.document.DynamoDB;
   import com.amazonaws.services.dynamodbv2.document.Table;
   import com.amazonaws.services.dynamodbv2.document.Item;
   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;
   import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
   import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;

   public class MyLambdaHandler implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {

       private final DynamoDB dynamoDB;
       private final String tableName = "MyDynamoDBTable";

       public MyLambdaHandler() {
           AmazonDynamoDB client = AmazonDynamoDBClientBuilder.defaultClient();
           this.dynamoDB = new DynamoDB(client);
       }

       @Override
       public APIGatewayProxyResponseEvent handleRequest(APIGatewayProxyRequestEvent request, Context context) {
           String id = request.getPathParameters().get("id");
           String data = request.getBody();

           Table table = dynamoDB.getTable(tableName);
           Item item = new Item().withPrimaryKey("id", id).withString("data", data);
           table.putItem(item);

           APIGatewayProxyResponseEvent response = new APIGatewayProxyResponseEvent();
           response.setStatusCode(200);
           response.setBody("Item stored successfully");

           return response;
       }
   }
   ```

3. **Construir el Proyecto:**

   ```sh
   mvn clean package
   ```

#### Paso 2: Crear la Plantilla SAM

1. **Crear un Archivo de Plantilla SAM (`template.yaml`):**

   ```yaml
   AWSTemplateFormatVersion: '2010-09-09'
   Transform: 'AWS::Serverless-2016-10-31'
   Resources:
     MyLambdaFunction:
       Type: 'AWS::Serverless::Function'
       Properties:
         Handler: com.example.MyLambdaHandler
         Runtime: java11
         CodeUri: ./target/lambda-sam-app-1.0-SNAPSHOT.jar
         MemorySize: 512
         Timeout: 10
         Policies:
           - AWSLambdaBasicExecutionRole
           - PolicyName: DynamoDBCrudPolicy
             PolicyDocument:
               Version: '2012-10-17'
               Statement:
                 - Effect: Allow
                   Action:
                     - dynamodb:PutItem
                   Resource: !GetAtt MyDynamoDBTable.Arn
         Events:
           MyAPI:
             Type: Api
             Properties:
               Path: /items/{id}
               Method: post

     MyDynamoDBTable:
       Type: 'AWS::DynamoDB::Table'
       Properties:
         AttributeDefinitions:
           - AttributeName: id
             AttributeType: S
         KeySchema:
           - AttributeName: id
             KeyType: HASH
         ProvisionedThroughput:
           ReadCapacityUnits: 5
           WriteCapacityUnits: 5
   ```

#### Paso 3: Desplegar la Aplicación con SAM CLI

1. **Instalar SAM CLI:**
   - Sigue las instrucciones de instalación de [SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html).

2. **Inicializar el Proyecto SAM:**

   ```sh
   sam init
   ```

   - Selecciona las opciones para un proyecto Hello World en Java.

3. **Construir y Empaquetar la Aplicación:**

   ```sh
   sam build
   ```

4. **Desplegar la Aplicación:**

   ```sh
   sam deploy --guided
   ```

   - Sigue las instrucciones y proporciona los detalles necesarios para el despliegue.

#### Paso 4: Probar la Aplicación

**Objetivo:** Verificar que la función Lambda se ejecute correctamente y almacene datos en DynamoDB a través de API Gateway.

1. **Enviar una Solicitud POST a la API Gateway:**

   ```sh
   curl -X POST https://YOUR_API_GATEWAY_ENDPOINT/items/123 --data '{"data": "example data"}'
   ```

2. **Verificar los Datos en DynamoDB:**
   - Accede a la consola de DynamoDB.
   - Encuentra la tabla `MyDynamoDBTable`.
   - Verifica que el ítem con `id=123` y `data="example data"` fue almacenado correctamente.

3. **Verificar los Logs en CloudWatch:**
   - Accede a la consola de CloudWatch Logs.
   - Encuentra el grupo de logs de la función `MyLambdaFunction`.
   - Verifica que la ejecución se realizó correctamente y los mensajes de log se registraron.

### Resumen

En este laboratorio, aprendimos a utilizar AWS SAM para definir y desplegar una aplicación serverless que incluye una función Lambda, una API Gateway y una tabla DynamoDB. Configuramos una plantilla SAM para definir los recursos, construimos y desplegamos la aplicación utilizando SAM CLI, y verificamos que la función Lambda procesó correctamente las solicitudes HTTP y almacenó los datos en DynamoDB. Esta automatización facilita la gestión y el despliegue de aplicaciones serverless en AWS.