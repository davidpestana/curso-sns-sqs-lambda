### Lab 1.4: Optimización de la Arquitectura para Reducir los Tiempos de Ejecución de las Lambdas

#### Objetivo
Optimizar la arquitectura existente para reducir los tiempos de ejecución de las funciones Lambda y mejorar el rendimiento general.

#### Prerrequisitos
1. Completar el Lab 1.1, Lab 1.2 y Lab 1.3.
2. Cuenta de AWS con permisos adecuados.
3. Instalación de Terraform.
4. Instalación de AWS CLI y SAM CLI.
5. Conocimientos básicos de AWS Lambda, Amazon RDS, CloudWatch, SNS, SQS, Terraform y Java.
6. Instalación de Java y Maven.

### Paso 1: Optimización de la Base de Datos

1. **Índices en las Tablas de RDS:**
   Asegúrate de que las tablas tengan índices adecuados para las consultas frecuentes.

   ```sql
   CREATE INDEX idx_instance_id ON ec2_instance_states (instance_id);
   CREATE INDEX idx_state ON ec2_instance_states (state);
   CREATE INDEX idx_timestamp ON ec2_instance_states (timestamp);
   CREATE INDEX idx_message ON processed_events (message);
   ```

2. **Añadir un Módulo Terraform para Ejecutar las Consultas SQL:**
   Crea un archivo `rds_optimization.tf` para definir la configuración de Terraform:

   ```hcl
   resource "null_resource" "create_indexes" {
     provisioner "local-exec" {
       command = <<EOT
       psql postgresql://${var.db_user}:${var.db_password}@${aws_db_instance.mydb.endpoint}/${aws_db_instance.mydb.name} <<EOF
       CREATE INDEX IF NOT EXISTS idx_instance_id ON ec2_instance_states (instance_id);
       CREATE INDEX IF NOT EXISTS idx_state ON ec2_instance_states (state);
       CREATE INDEX IF NOT EXISTS idx_timestamp ON ec2_instance_states (timestamp);
       CREATE INDEX IF NOT EXISTS idx_message ON processed_events (message);
       EOF
       EOT
     }
     depends_on = [aws_db_instance.mydb]
   }

   variable "db_user" {
     description = "Database user"
     type        = string
   }

   variable "db_password" {
     description = "Database password"
     type        = string
   }
   ```

3. **Ejecutar Terraform para Crear los Índices:**

   ```sh
   terraform apply -var "db_user=admin" -var "db_password=password123"
   ```

### Paso 2: Optimización de las Funciones Lambda

1. **Uso de Conexiones Persistentes:**
   Implementar un pool de conexiones para reutilizar conexiones existentes en lugar de abrir una nueva conexión en cada invocación de Lambda.

   Modificar la clase `LambdaHandler` y `ProcessInsertHandler` para usar un pool de conexiones.

   ```java
   import com.zaxxer.hikari.HikariConfig;
   import com.zaxxer.hikari.HikariDataSource;

   public class DatabaseConnectionPool {
       private static HikariDataSource dataSource;

       static {
           HikariConfig config = new HikariConfig();
           config.setJdbcUrl("jdbc:postgresql://" + System.getenv("DB_HOST") + "/" + System.getenv("DB_NAME"));
           config.setUsername(System.getenv("DB_USER"));
           config.setPassword(System.getenv("DB_PASSWORD"));
           config.addDataSourceProperty("cachePrepStmts", "true");
           config.addDataSourceProperty("prepStmtCacheSize", "250");
           config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

           dataSource = new HikariDataSource(config);
       }

       public static Connection getConnection() throws SQLException {
           return dataSource.getConnection();
       }
   }
   ```

   Actualizar `LambdaHandler` y `ProcessInsertHandler` para usar `DatabaseConnectionPool`.

   ```java
   public class LambdaHandler implements RequestHandler<CloudWatchEvent, String> {

       @Override
       public String handleRequest(CloudWatchEvent event, Context context) {
           long startTime = System.currentTimeMillis();

           String instanceId = event.getDetail().get("instance-id").toString();
           String state = event.getDetail().get("state").toString();

           try (Connection connection = DatabaseConnectionPool.getConnection()) {
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

2. **Aumentar el Tamaño de Memoria y el Tiempo de Ejecución:**
   Ajustar los valores de memoria y timeout de las funciones Lambda en el archivo `template.yaml`.

   ```yaml
   Resources:
     ProcessInsertEventsFunction:
       Type: 'AWS::Serverless::Function'
       Properties:
         Handler: com.example.ProcessInsertHandler::handleRequest
         Runtime: java11
         CodeUri: ./target/lambda-cloudwatch-rds-1.0-SNAPSHOT.jar
         MemorySize: 1024  # Incrementado de 512 a 1024
         Timeout: 60       # Incrementado de 30 a 60
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
   ```

3. **Desplegar la Función Lambda con SAM:**

   ```sh
   mvn clean package
   sam package --template-file template.yaml --output-template-file packaged.yaml --s3-bucket YOUR_S3_BUCKET_NAME
   sam deploy --template-file packaged.yaml --stack-name lambda-sns-sqs-rds --capabilities CAPABILITY_IAM --parameter-overrides DBHost=${aws_db_instance.mydb.endpoint} DBName=mydatabase DBUser=admin DBPassword=password123 SNSTopic=${aws_sns_topic.insert_event_topic.arn} SQSQueueArn=${aws_sqs_queue.insert_event_queue.arn}
   ```

### Paso 3: Monitorear y Validar las Optimizaciones

1. **Monitorear el Rendimiento con CloudWatch:**
   Verificar los tiempos de ejecución de las funciones Lambda en los registros de CloudWatch.

2. **Monitorear la Base de Datos con pgAnalyze:**
   Observar el impacto de las optimizaciones en la carga y el rendimiento de la base de datos PostgreSQL.

3. **Generar Eventos y Validar:**
   Generar eventos de CloudWatch simulando cambios de estado en instancias EC2 y validar que las funciones Lambda están procesando los eventos más rápido.

### Conclusión

En este laboratorio se han optimizado las funciones Lambda y la base de datos para reducir los tiempos de ejecución y mejorar el rendimiento general de la arquitectura. Las optimizaciones incluyeron la creación de índices en las tablas de RDS, el uso de un pool de conexiones en las Lambdas, y el ajuste de los recursos de memoria y tiempo de ejecución para las funciones Lambda.