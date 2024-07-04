### 4.4. Laboratorio: Monitoreo y Logging

---

## Laboratorio: Monitoreo y Logging

### Descripción del Laboratorio

En este laboratorio, implementaremos y configuraremos CloudWatch Logs y métricas personalizadas para una función Lambda. Aprenderemos a enviar logs desde una función Lambda a CloudWatch, a crear métricas personalizadas y a configurar alarmas para monitorizar el rendimiento y la salud de nuestras aplicaciones.

### Recursos Necesarios

- AWS CLI
- SDK de AWS para Java
- IDE (Eclipse, IntelliJ, etc.)
- AWS Management Console

### Ejercicio Práctico

#### Paso 1: Configurar el Proyecto Maven

**Objetivo:** Configurar un proyecto Maven con las dependencias necesarias para AWS Lambda y CloudWatch.

1. **Crear un Proyecto Maven (`pom.xml`):**

   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://www.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>

       <groupId>com.example</groupId>
       <artifactId>lambda-cloudwatch</artifactId>
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
               <artifactId>aws-java-sdk-cloudwatch</artifactId>
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
                                       <mainClass>com.example.LoggingHandler</mainClass>
                                   </transformers>
                               </configuration>
                       </execution>
                   </executions>
               </plugin>
           </plugins>
       </build>
   </project>
   ```

#### Paso 2: Implementar la Función Lambda con Logging

**Objetivo:** Escribir una función Lambda que registre mensajes en CloudWatch Logs.

1. **Implementar la Clase LoggingHandler:**

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;

   public class LoggingHandler implements RequestHandler<Object, String> {

       @Override
       public String handleRequest(Object input, Context context) {
           context.getLogger().log("Iniciando la función Lambda...");
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
   aws lambda create-function --function-name LoggingHandler \
       --runtime java11 --role arn:aws:iam::YOUR_ACCOUNT_ID:role/YOUR_LAMBDA_ROLE \
       --handler com.example.LoggingHandler \
       --zip-file fileb://target/lambda-cloudwatch-1.0-SNAPSHOT.jar
   ```

#### Paso 3: Verificar los Logs en CloudWatch

**Objetivo:** Ejecutar la función Lambda y verificar que los logs se registran en CloudWatch.

1. **Invocar la Función Lambda:**

   ```sh
   aws lambda invoke --function-name LoggingHandler output.txt
   ```

2. **Verificar los Logs en CloudWatch:**
   - Accede a la consola de CloudWatch.
   - Navega a `Logs` y encuentra el grupo de logs de la función `LoggingHandler`.
   - Verifica que los mensajes "Iniciando la función Lambda..." y "Función Lambda completada." fueron registrados.

#### Paso 4: Enviar Métricas Personalizadas a CloudWatch

**Objetivo:** Modificar la función Lambda para enviar métricas personalizadas a CloudWatch.

1. **Modificar la Clase LoggingHandler para Enviar Métricas:**

   ```java
   package com.example;

   import com.amazonaws.services.cloudwatch.AmazonCloudWatch;
   import com.amazonaws.services.cloudwatch.AmazonCloudWatchClientBuilder;
   import com.amazonaws.services.cloudwatch.model.MetricDatum;
   import com.amazonaws.services.cloudwatch.model.PutMetricDataRequest;
   import com.amazonaws.services.cloudwatch.model.StandardUnit;
   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;

   public class LoggingHandler implements RequestHandler<Object, String> {

       @Override
       public String handleRequest(Object input, Context context) {
           context.getLogger().log("Iniciando la función Lambda...");

           AmazonCloudWatch cw = AmazonCloudWatchClientBuilder.defaultClient();

           MetricDatum datum = new MetricDatum()
               .withMetricName("CustomMetric")
               .withUnit(StandardUnit.Count)
               .withValue(1.0);

           PutMetricDataRequest request = new PutMetricDataRequest()
               .withNamespace("MyNamespace")
               .withMetricData(datum);

           cw.putMetricData(request);

           context.getLogger().log("Métricas personalizadas enviadas correctamente.");
           context.getLogger().log("Función Lambda completada.");
           return "Función ejecutada correctamente.";
       }
   }
   ```

2. **Reconstruir y Desplegar la Función Lambda:**

   ```sh
   mvn clean package

   aws lambda update-function-code --function-name LoggingHandler --zip-file fileb://target/lambda-cloudwatch-1.0-SNAPSHOT.jar
   ```

3. **Invocar la Función Lambda y Verificar las Métricas:**

   ```sh
   aws lambda invoke --function-name LoggingHandler output.txt
   ```

   - Accede a la consola de CloudWatch.
   - Navega a `Metrics` y encuentra el namespace `MyNamespace`.
   - Verifica que la métrica `CustomMetric` se ha registrado correctamente.

#### Paso 5: Crear una Alarma de CloudWatch

**Objetivo:** Configurar una alarma para la métrica personalizada creada en CloudWatch.

1. **Crear una Alarma en la Consola de CloudWatch:**
   - Accede a la consola de CloudWatch.
   - Selecciona `Alarms` y haz clic en `Create Alarm`.
   - Selecciona la métrica `CustomMetric` en el namespace `MyNamespace`.
   - Configura un umbral para la alarma, por ejemplo, si el valor de la métrica es mayor que 0.
   - Configura las acciones a tomar cuando se active la alarma, como enviar una notificación a través de SNS.
   - Asigna un nombre y una descripción a la alarma, y crea la alarma.

### Resumen

En este laboratorio, configuramos CloudWatch Logs y métricas personalizadas para una función Lambda. Aprendimos a enviar logs desde una función Lambda a CloudWatch, a enviar métricas personalizadas y a configurar alarmas en CloudWatch. Estas prácticas son esenciales para mantener la salud y el rendimiento de las aplicaciones serverless, permitiendo una respuesta rápida a problemas y optimización continua.