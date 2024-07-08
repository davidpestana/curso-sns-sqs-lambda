### Lab 1.1: Creación de una Arquitectura Lambda que Procesa Eventos de CloudWatch y los Almacena en una Tabla RDS PostgreSQL utilizando Terraform y SAM

#### Objetivo
Crear una arquitectura en AWS que utiliza Lambda para procesar eventos de CloudWatch y almacenar los resultados en una base de datos RDS PostgreSQL utilizando Terraform y AWS Serverless Application Model (SAM).

#### Prerrequisitos
1. Cuenta de AWS con permisos adecuados.
2. Instalación de Terraform.
3. Instalación de AWS CLI y SAM CLI.
4. Conocimientos básicos de AWS Lambda, Amazon RDS, CloudWatch, Terraform y Java.
5. Instalación de Java y Maven.

### Paso 1: Configuración Inicial de Terraform

1. Crear un directorio para el proyecto y navegar a él:
   ```sh
   mkdir lambda-cloudwatch-rds
   cd lambda-cloudwatch-rds
   ```

2. Crear un archivo `main.tf` y añadir la configuración de Terraform:

   ```hcl
   provider "aws" {
     region = "us-west-2"
   }

   resource "aws_vpc" "my_vpc" {
     cidr_block = "10.0.0.0/16"
   }

   resource "aws_subnet" "my_subnet" {
     vpc_id     = aws_vpc.my_vpc.id
     cidr_block = "10.0.1.0/24"
   }

   resource "aws_db_subnet_group" "default" {
     name       = "main"
     subnet_ids = [aws_subnet.my_subnet.id]

     tags = {
       Name = "My DB subnet group"
     }
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
   ```

3. Ejecutar Terraform para desplegar los recursos:

   ```sh
   terraform init
   terraform apply
   ```

### Paso 2: Crear la Función Lambda en Java con SAM

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
   </dependencies>
   ```

3. Crear la clase `LambdaHandler`:

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;
   import com.amazonaws.services.lambda.runtime.events.CloudWatchEvent;
   import java.sql.Connection;
   import java.sql.DriverManager;
   import java.sql.PreparedStatement;
   import java.sql.SQLException;

   public class LambdaHandler implements RequestHandler<CloudWatchEvent, String> {

       private String dbHost = System.getenv("DB_HOST");
       private String dbName = System.getenv("DB_NAME");
       private String dbUser = System.getenv("DB_USER");
       private String dbPassword = System.getenv("DB_PASSWORD");

       @Override
       public String handleRequest(CloudWatchEvent event, Context context) {
           String instanceId = event.getDetail().get("instance-id").toString();
           String state = event.getDetail().get("state").toString();

           try (Connection connection = DriverManager.getConnection(
                   "jdbc:postgresql://" + dbHost + "/" + dbName, dbUser, dbPassword)) {

               String sql = "INSERT INTO ec2_instance_states (instance_id, state) VALUES (?, ?)";
               try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                   stmt.setString(1, instanceId);
                   stmt.setString(2, state);
                   stmt.executeUpdate();
               }

           } catch (SQLException e) {
               context.getLogger().log("Error: " + e.getMessage());
               return "Error: " + e.getMessage();
           }

           return "Inserted " + instanceId + " with state " + state;
       }
   }
   ```

4. Crear la clase `CreateTableHandler`:

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;
   import java.sql.Connection;
   import java.sql.DriverManager;
   import java.sql.SQLException;
   import java.sql.Statement;

   public class CreateTableHandler implements RequestHandler<Object, String> {

       private String dbHost = System.getenv("DB_HOST");
       private String dbName = System.getenv("DB_NAME");
       private String dbUser = System.getenv("DB_USER");
       private String dbPassword = System.getenv("DB_PASSWORD");

       @Override
       public String handleRequest(Object input, Context context) {
           try (Connection connection = DriverManager.getConnection(
                   "jdbc:postgresql://" + dbHost + "/" + dbName, dbUser, dbPassword)) {

               try (Statement stmt = connection.createStatement()) {
                   String sql = "CREATE TABLE IF NOT EXISTS ec2_instance_states (" +
                           "id SERIAL PRIMARY KEY, " +
                           "instance_id VARCHAR(255), " +
                           "state VARCHAR(255), " +
                           "timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP" +
                           ")";
                   stmt.executeUpdate(sql);
               }

           } catch (SQLException e) {
               context.getLogger().log("Error: " + e.getMessage());
               return "Error: " + e.getMessage();
           }

           return "Table created successfully";
       }
   }
   ```

5. Crear el archivo `template.yaml` para definir la infraestructura SAM:

   ```yaml
   AWSTemplateFormatVersion: '2010-09-09'
   Transform: 'AWS::Serverless-2016-10-31'
   Resources:
     CloudWatchToRDSFunction:
       Type: 'AWS::Serverless::Function'
       Properties:
         Handler: com.example.LambdaHandler::handleRequest
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
         Policies:
           - AWSLambdaBasicExecutionRole
           - Version: '2012-10-17'
             Statement:
               - Effect: 'Allow'
                 Action:
                   - 'rds-db:connect'
                 Resource: !GetAtt MyDB.Arn
     CreateTableFunction:
       Type: 'AWS::Serverless::Function'
       Properties:
         Handler: com.example.CreateTableHandler::handleRequest
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
         Policies:
           - AWSLambdaBasicExecutionRole
           - Version: '2012-10-17'
             Statement:
               - Effect: 'Allow'
                 Action:
                   - 'rds-db:connect'
                 Resource: !GetAtt MyDB.Arn
     CloudWatchEventRule:
       Type: 'AWS::Events::Rule'
       Properties:
         EventPattern:
           source:
             - 'aws.ec2'
           detail-type:
             - 'EC2 Instance State-change Notification'
         Targets:
           - Arn: !GetAtt CloudWatchToRDSFunction.Arn
             Id: 'LambdaTarget'
     LambdaInvokePermission:
       Type: 'AWS::Lambda::Permission'
       Properties:
         FunctionName: !GetAtt CloudWatchToRDSFunction.Arn
         Action: 'lambda:InvokeFunction'
         Principal: 'events.amazonaws.com'
         SourceArn: !GetAtt CloudWatchEventRule.Arn
   Parameters:
     DBHost:
       Type: String
     DBName:
       Type: String
     DBUser:
       Type: String
     DBPassword:
       Type: String
   ```

### Paso 3: Desplegar la Función Lambda con SAM

1. Construir el proyecto Maven:

   ```sh
   mvn clean package
   ```

2. Empaquetar la aplicación SAM:

   ```sh
   sam package --template-file template.yaml --output-template-file packaged.yaml --s3-bucket YOUR_S3_BUCKET_NAME
   ```

3. Desple

gar la aplicación SAM:

   ```sh
   sam deploy --template-file packaged.yaml --stack-name lambda-cloudwatch-rds --capabilities CAPABILITY_IAM --parameter-overrides DBHost=${aws_db_instance.mydb.endpoint} DBName=mydatabase DBUser=admin DBPassword=password123
   ```

### Paso 4: Validación

1. Generar eventos de CloudWatch simulando cambios de estado en instancias EC2.
2. Verificar que los eventos sean capturados por la Lambda y que se inserten registros en la tabla RDS.

### Conclusión

Este laboratorio te ha guiado en la creación de una arquitectura que consume eventos de CloudWatch y los procesa mediante una función Lambda, almacenando la información en una base de datos RDS PostgreSQL. Además, has aprendido a usar Terraform y AWS SAM para la provisión de recursos en AWS y la implementación de funciones Lambda en Java.