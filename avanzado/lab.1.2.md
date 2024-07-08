### Lab 1.2: Introducción de pgAnalyze en una EC2 para Monitorización y Medición del Impacto en las Lambdas

#### Objetivo
Desplegar pgAnalyze en una instancia EC2 para monitorizar una base de datos PostgreSQL y medir el impacto en los tiempos de ejecución de las funciones Lambda.

#### Prerrequisitos
1. Completar el Lab 1.1.
2. Cuenta de AWS con permisos adecuados.
3. Instalación de Terraform.
4. Instalación de AWS CLI y SAM CLI.
5. Conocimientos básicos de AWS Lambda, Amazon RDS, CloudWatch, Terraform y Java.
6. Instalación de Java y Maven.

### Paso 1: Desplegar pgAnalyze en una EC2

1. Crear un archivo `pg_analyze.tf` para definir la configuración de Terraform:

   ```hcl
   provider "aws" {
     region = "us-west-2"
   }

   resource "aws_instance" "pg_analyze" {
     ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
     instance_type = "t2.micro"
     key_name      = "my-key" # Reemplaza con tu propia clave SSH

     vpc_security_group_ids = [aws_security_group.pg_analyze_sg.id]
     subnet_id              = aws_subnet.my_subnet.id

     tags = {
       Name = "pgAnalyzeInstance"
     }

     user_data = <<-EOF
                 #!/bin/bash
                 yum update -y
                 amazon-linux-extras install postgresql10 -y
                 yum install -y pgadmin4
                 wget https://download.pganalyze.com/collector/pganalyze_collector_linux_amd64.tar.gz
                 tar -xvzf pganalyze_collector_linux_amd64.tar.gz
                 cd pganalyze_collector_linux_amd64
                 ./pganalyze-collector install
                 EOF
   }

   resource "aws_security_group" "pg_analyze_sg" {
     name_prefix = "pg_analyze_sg"

     ingress {
       from_port   = 22
       to_port     = 22
       protocol    = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
     }

     ingress {
       from_port   = 80
       to_port     = 80
       protocol    = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
     }

     ingress {
       from_port   = 443
       to_port     = 443
       protocol    = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
     }

     ingress {
       from_port   = 5432
       to_port     = 5432
       protocol    = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
     }

     egress {
       from_port   = 0
       to_port     = 0
       protocol    = "-1"
       cidr_blocks = ["0.0.0.0/0"]
     }
   }
   ```

2. Ejecutar Terraform para desplegar la instancia EC2 con pgAnalyze:

   ```sh
   terraform init
   terraform apply
   ```

### Paso 2: Configurar pgAnalyze

1. Acceder a la instancia EC2 mediante SSH:

   ```sh
   ssh -i "my-key.pem" ec2-user@<instance_public_ip>
   ```

2. Configurar pgAnalyze para que se conecte a la base de datos PostgreSQL en RDS:

   ```sh
   sudo ./pganalyze-collector setup --api_key <your_pg_analyze_api_key>
   ```

3. Seguir las instrucciones para completar la configuración, proporcionando los detalles de conexión de la base de datos RDS.

### Paso 3: Medir el Impacto en los Tiempos de Ejecución de las Lambdas

1. Modificar la clase `LambdaHandler` para medir el tiempo de ejecución y enviar los datos a CloudWatch Logs:

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
           long startTime = System.currentTimeMillis();

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

           long endTime = System.currentTimeMillis();
           long duration = endTime - startTime;
           context.getLogger().log("Execution time: " + duration + " ms");

           return "Inserted " + instanceId + " with state " + state;
       }
   }
   ```

2. Reconstruir el proyecto Maven y desplegar la función Lambda actualizada utilizando SAM:

   ```sh
   mvn clean package
   sam package --template-file template.yaml --output-template-file packaged.yaml --s3-bucket YOUR_S3_BUCKET_NAME
   sam deploy --template-file packaged.yaml --stack-name lambda-cloudwatch-rds --capabilities CAPABILITY_IAM --parameter-overrides DBHost=${aws_db_instance.mydb.endpoint} DBName=mydatabase DBUser=admin DBPassword=password123
   ```

### Paso 4: Generar Eventos y Analizar el Impacto

1. Generar eventos de CloudWatch simulando cambios de estado en instancias EC2.
2. Observar los tiempos de ejecución en los registros de CloudWatch Logs para la función Lambda.
3. Utilizar pgAnalyze para monitorizar la carga y el rendimiento de la base de datos PostgreSQL.

### Conclusión

En este laboratorio se ha desplegado pgAnalyze en una instancia EC2 para monitorizar una base de datos PostgreSQL y se ha medido el impacto en los tiempos de ejecución de las funciones Lambda. Esto permite evaluar el rendimiento de la arquitectura y optimizar los componentes según sea necesario.