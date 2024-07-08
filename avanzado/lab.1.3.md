### Lab 1.3: Disparar Eventos SNS y SQS desde RDS para Procesar Datos con Lambdas y Almacenar Resultados en Otra Tabla

#### Objetivo
Crear un flujo de datos en AWS donde las inserciones en una tabla de RDS disparan eventos SNS y SQS. Las Lambdas suscritas a estos eventos realizarán consultas y transformaciones sobre los datos, almacenando los resultados en una segunda tabla. Este proceso generará carga en la RDS y permitirá observar problemas de índices y rendimiento.

#### Prerrequisitos
1. Completar el Lab 1.1 y Lab 1.2.
2. Cuenta de AWS con permisos adecuados.
3. Instalación de Terraform.
4. Instalación de AWS CLI y SAM CLI.
5. Conocimientos básicos de AWS Lambda, Amazon RDS, CloudWatch, SNS, SQS, Terraform y Java.
6. Instalación de Java y Maven.

### Paso 1: Configuración Inicial de Terraform para la Nueva Tabla y SNS/SQS

1. Crear un archivo `rds_sns_sqs.tf` para definir la configuración de Terraform:

   ```hcl
   provider "aws" {
     region = "us-west-2"
   }

   resource "aws_sns_topic" "insert_event_topic" {
     name = "insert_event_topic"
   }

   resource "aws_sqs_queue" "insert_event_queue" {
     name = "insert_event_queue"
   }

   resource "aws_sns_topic_subscription" "sns_to_sqs" {
     topic_arn = aws_sns_topic.insert_event_topic.arn
     protocol  = "sqs"
     endpoint  = aws_sqs_queue.insert_event_queue.arn
   }

   resource "aws_sqs_queue_policy" "queue_policy" {
     queue_url = aws_sqs_queue.insert_event_queue.id
     policy    = jsonencode({
       Version = "2012-10-17",
       Statement = [
         {
           Effect = "Allow",
           Principal = "*",
           Action = "sqs:SendMessage",
           Resource = aws_sqs_queue.insert_event_queue.arn,
           Condition = {
             ArnEquals = {
               "aws:SourceArn" = aws_sns_topic.insert_event_topic.arn
             }
           }
         }
       ]
     })
   }

   resource "aws_db_instance" "mydb" {
     allocated_storage    = 20
     storage_type         = "gp2"
     engine               = "postgres"
     engine_version       = "13.3"
     instance_class       = "db.t3.micro"
     name                 = "mydatabase"
     username             = "admin"
     password             = "password123"
     parameter_group_name = "default.postgres13"
     skip_final_snapshot  = true
     db_subnet_group_name = aws_db_subnet_group.default.name
   }

   resource "aws_lambda_function" "process_insert_events" {
     function_name = "process_insert_events"
     role          = aws_iam_role.lambda_exec.arn
     handler       = "com.example.ProcessInsertHandler::handleRequest"
     runtime       = "java11"
     filename      = "process_insert_events.zip"
     environment {
       variables = {
         DB_HOST     = aws_db_instance.mydb.endpoint
         DB_NAME     = aws_db_instance.mydb.name
         DB_USER     = aws_db_instance.mydb.username
         DB_PASSWORD = aws_db_instance.mydb.password
         SNS_TOPIC   = aws_sns_topic.insert_event_topic.arn
       }
     }
   }

   resource "aws_lambda_event_source_mapping" "sqs_event_mapping" {
     event_source_arn = aws_sqs_queue.insert_event_queue.arn
     function_name    = aws_lambda_function.process_insert_events.arn
     batch_size       = 10
   }
   ```

2. Ejecutar Terraform para desplegar los recursos:

   ```sh
   terraform init
   terraform apply
   ```

### Paso 2: Crear la Función Lambda en Java para Procesar Inserciones y Disparar Eventos

1. Crear un proyecto Maven:

   ```sh
   mvn archetype:generate -DgroupId=com.example -DartifactId=lambda-cloudwatch-rds -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
   cd lambda-cloudwatch-rds
   ```

2. Modificar el archivo `pom.xml` para incluir las dependencias necesarias:

   ```xml
   <dependencies>
     <dependency>
       <groupId>com.amazonaws</groupId>
       <artifactId>aws-lambda-java-core</artifactId>
       <version>1.2.1</version>
     </dependency>
     <dependency>
       <groupId>com.amazonaws</groupId>
       <artifactId>aws-lambda-java-events</artifactId>
       <version>3.10.0</version>
     </dependency>
     <dependency>
       <groupId>org.postgresql</groupId>
       <artifactId>postgresql</artifactId>
       <version>42.2.19</version>
     </dependency>
     <dependency>
       <groupId>com.amazonaws</groupId>
       <artifactId>aws-java-sdk-sns</artifactId>
       <version>1.11.901</version>
     </dependency>
     <dependency>
       <groupId>com.amazonaws</groupId>
       <artifactId>aws-java-sdk-sqs</artifactId>
       <version>1.11.901</version>
     </dependency>
   </dependencies>
   ```

3. Crear la clase `ProcessInsertHandler`:

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;
   import com.amazonaws.services.lambda.runtime.events.SQSEvent;
   import com.amazonaws.services.sns.AmazonSNS;
   import com.amazonaws.services.sns.AmazonSNSClientBuilder;
   import com.amazonaws.services.sns.model.PublishRequest;
   import com.amazonaws.services.sns.model.PublishResult;

   import java.sql.Connection;
   import java.sql.DriverManager;
   import java.sql.PreparedStatement;
   import java.sql.SQLException;

   public class ProcessInsertHandler implements RequestHandler<SQSEvent, String> {

       private String dbHost = System.getenv("DB_HOST");
       private String dbName = System.getenv("DB_NAME");
       private String dbUser = System.getenv("DB_USER");
       private String dbPassword = System.getenv("DB_PASSWORD");
       private String snsTopic = System.getenv("SNS_TOPIC");

       private AmazonSNS snsClient = AmazonSNSClientBuilder.defaultClient();

       @Override
       public String handleRequest(SQSEvent event, Context context) {
           for (SQSEvent.SQSMessage msg : event.getRecords()) {
               String message = msg.getBody();
               // Aquí se puede procesar el mensaje y realizar consultas en la base de datos
               try (Connection connection = DriverManager.getConnection(
                       "jdbc:postgresql://" + dbHost + "/" + dbName, dbUser, dbPassword)) {

                   // Ejemplo de consulta de inserción
                   String sql = "INSERT INTO processed_events (message) VALUES (?)";
                   try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                       stmt.setString(1, message);
                       stmt.executeUpdate();
                   }

                   // Publicar un evento SNS
                   PublishRequest publishRequest = new PublishRequest(snsTopic, message);
                   PublishResult publishResult = snsClient.publish(publishRequest);
                   context.getLogger().log("MessageId - " + publishResult.getMessageId());

               } catch (SQLException e) {
                   context.getLogger().log("Error: " + e.getMessage());
                   return "Error: " + e.getMessage();
               }
           }
           return "Processed " + event.getRecords().size() + " messages";
       }
   }
   ```

### Paso 3: Desplegar la Función Lambda con SAM

1. Crear el archivo `template.yaml` para definir la infraestructura SAM:

   ```yaml
   AWSTemplateFormatVersion: '2010-09-09'
   Transform: 'AWS::Serverless-2016-10-31'
   Resources:
     ProcessInsertEventsFunction:
       Type: 'AWS::Serverless::Function'
       Properties:
         Handler: com.example.ProcessInsertHandler::handleRequest
         Runtime: java11
         CodeUri: ./target/lambda-cloudwatch-rds-1.0-SNAPSHOT.jar
         MemorySize: 512
         Timeout: 30
         Environment:
           Variables:
             DB_HOST: !Ref DBHost
             DB_NAME: !Ref DBName
             DB_USER: !Ref DBUser
             DB_PASSWORD: !Ref DBPassword
             SNS_TOPIC: !Ref SNSTopic
         Policies:
           - AWSLambdaBasicExecutionRole
           - Version: '2012-10-17'
             Statement:
               - Effect: 'Allow'
                 Action:
                   - 'rds-db:connect'
                   - 'sns:Publish'
                 Resource: '*'
     SQSTrigger:
       Type: 'AWS::Lambda::EventSourceMapping'
       Properties:
         BatchSize: 10
         EventSourceArn: !Ref SQSQueueArn
         FunctionName: !GetAtt ProcessInsertEventsFunction.Arn
   Parameters:
     DBHost:
       Type: String
     DBName:
       Type: String
     DBUser:
       Type: String
     DBPassword:
       Type: String
     SNSTopic:
       Type: String
     SQSQueueArn:
       Type: String
   ```

2. Construir el proyecto Maven:

   ```sh
   mvn clean package
   ```

3. Empaquetar la aplicación SAM:

   ```sh


   sam package --template-file template.yaml --output-template-file packaged.yaml --s3-bucket YOUR_S3_BUCKET_NAME
   ```

4. Desplegar la aplicación SAM:

   ```sh
   sam deploy --template-file packaged.yaml --stack-name lambda-sns-sqs-rds --capabilities CAPABILITY_IAM --parameter-overrides DBHost=${aws_db_instance.mydb.endpoint} DBName=mydatabase DBUser=admin DBPassword=password123 SNSTopic=${aws_sns_topic.insert_event_topic.arn} SQSQueueArn=${aws_sqs_queue.insert_event_queue.arn}
   ```

### Paso 4: Validación y Generación de Carga

1. Generar eventos de CloudWatch simulando cambios de estado en instancias EC2.
2. Observar los tiempos de ejecución en los registros de CloudWatch Logs para la función Lambda.
3. Utilizar pgAnalyze para monitorizar la carga y el rendimiento de la base de datos PostgreSQL.
4. Observar el impacto de las consultas y transformaciones de datos en la nueva tabla `processed_events`.

### Conclusión

Este laboratorio crea una infraestructura en AWS donde las inserciones en una tabla RDS disparan eventos SNS y SQS, que son procesados por funciones Lambda para realizar consultas y transformaciones sobre los datos. Los resultados se almacenan en una segunda tabla, generando carga en la RDS y permitiendo observar problemas de índices y rendimiento.