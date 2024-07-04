### 4.8. Laboratorio: Optimización y Escalabilidad

---

## Laboratorio: Optimización y Escalabilidad

### Descripción del Laboratorio

En este laboratorio, implementaremos configuraciones de escalado automático y optimización de rendimiento para Lambda, SNS y SQS. Aprenderemos a ajustar parámetros como la memoria, el timeout y la concurrencia de funciones Lambda, así como a usar Lambda Layers y configurar el escalado automático para manejar un alto volumen de solicitudes.

### Recursos Necesarios

- AWS CLI
- SDK de AWS para Java
- IDE (Eclipse, IntelliJ, etc.)
- AWS Management Console

### Ejercicio Práctico

#### Paso 1: Ajustar la Configuración de Memoria y Timeout

**Objetivo:** Configurar una función Lambda para manejar un alto volumen de solicitudes ajustando la memoria y el timeout.

1. **Crear una Función Lambda Básica:**

   - Configura el proyecto Maven (`pom.xml`):

     ```xml
     <project xmlns="http://maven.apache.org/POM/4.0.0"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://www.apache.org/xsd/maven-4.0.0.xsd">
         <modelVersion>4.0.0</modelVersion>

         <groupId>com.example</groupId>
         <artifactId>optimized-lambda</artifactId>
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
                                         <mainClass>com.example.OptimizedLambdaHandler</mainClass>
                                     </transformers>
                             </configuration>
                         </execution>
                     </executions>
                 </plugin>
             </plugins>
         </build>
     </project>
     ```

   - Implementar la clase `OptimizedLambdaHandler`:

     ```java
     package com.example;

     import com.amazonaws.services.lambda.runtime.Context;
     import com.amazonaws.services.lambda.runtime.RequestHandler;

     public class OptimizedLambdaHandler implements RequestHandler<Object, String> {

         @Override
         public String handleRequest(Object input, Context context) {
             context.getLogger().log("Ejecutando la función Lambda optimizada...");
             // Lógica de la función
             context.getLogger().log("Función Lambda completada.");
             return "Función ejecutada correctamente.";
         }
     }
     ```

2. **Construir el Proyecto:**

   ```sh
   mvn clean package
   ```

3. **Desplegar la Función Lambda:**

   ```sh
   aws lambda create-function --function-name OptimizedLambdaHandler \
       --runtime java11 --role arn:aws:iam::YOUR_ACCOUNT_ID:role/YOUR_LAMBDA_ROLE \
       --handler com.example.OptimizedLambdaHandler \
       --zip-file fileb://target/optimized-lambda-1.0-SNAPSHOT.jar
   ```

4. **Ajustar la Configuración de Memoria y Timeout:**

   ```sh
   aws lambda update-function-configuration --function-name OptimizedLambdaHandler --memory-size 2048 --timeout 60
   ```

#### Paso 2: Configurar la Concurrencia Reservada

**Objetivo:** Configurar la concurrencia para manejar picos de tráfico de manera eficiente.

1. **Configurar la Concurrencia Reservada:**

   ```sh
   aws lambda put-function-concurrency --function-name OptimizedLambdaHandler --reserved-concurrent-executions 200
   ```

#### Paso 3: Crear y Usar un Lambda Layer

**Objetivo:** Reducir el tamaño del paquete de implementación y gestionar dependencias comunes utilizando Lambda Layers.

1. **Empaquetar Librerías Comunes en un Archivo ZIP:**

   ```sh
   zip -r common-libraries.zip lib/
   ```

2. **Crear un Lambda Layer:**

   ```sh
   aws lambda publish-layer-version --layer-name CommonLibraries --description "Librerías comunes para funciones Lambda" --zip-file fileb://common-libraries.zip --compatible-runtimes java11
   ```

3. **Agregar el Layer a la Función Lambda:**

   ```sh
   aws lambda update-function-configuration --function-name OptimizedLambdaHandler --layers arn:aws:lambda:us-east-1:123456789012:layer:CommonLibraries:1
   ```

#### Paso 4: Configurar el Trigger de SQS para Lambda

**Objetivo:** Configurar una cola SQS para que desencadene la función Lambda cuando lleguen mensajes.

1. **Crear una Cola SQS:**

   ```sh
   aws sqs create-queue --queue-name OptimizedQueue
   ```

2. **Obtener la URL y ARN de la Cola SQS:**

   ```sh
   aws sqs get-queue-url --queue-name OptimizedQueue
   aws sqs get-queue-attributes --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/OptimizedQueue --attribute-names QueueArn
   ```

3. **Configurar el Trigger de SQS para Lambda:**

   ```sh
   aws lambda create-event-source-mapping --function-name OptimizedLambdaHandler --event-source-arn arn:aws:sqs:us-east-1:123456789012:OptimizedQueue --batch-size 10
   ```

4. **Dar Permisos a SQS para Invocar la Función Lambda:**

   ```sh
   aws lambda add-permission --function-name OptimizedLambdaHandler --statement-id sqs-invoke --action "lambda:InvokeFunction" --principal sqs.amazonaws.com --source-arn arn:aws:sqs:us-east-1:123456789012:OptimizedQueue
   ```

#### Paso 5: Probar la Configuración

**Objetivo:** Publicar mensajes en la cola SQS y verificar que se procesan automáticamente por la función Lambda.

1. **Enviar Mensajes a la Cola SQS:**

   ```sh
   aws sqs send-message --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/OptimizedQueue --message-body "Mensaje de prueba para Lambda a través de SQS"
   ```

2. **Verificar la Ejecución de la Función Lambda:**
   - Accede a la consola de CloudWatch Logs.
   - Encuentra el grupo de logs de la función `OptimizedLambdaHandler`.
   - Verifica que el mensaje "Mensaje de prueba para Lambda a través de SQS" fue recibido y registrado.

### Resumen

En este laboratorio, implementamos configuraciones de escalado automático y optimización de rendimiento para Lambda, SNS y SQS. Ajustamos parámetros como la memoria, el timeout y la concurrencia de funciones Lambda, utilizamos Lambda Layers y configuramos el escalado automático para manejar un alto volumen de solicitudes. Estas prácticas son esenciales para asegurar que las aplicaciones serverless puedan manejar cargas de trabajo variables de manera eficiente y efectiva.