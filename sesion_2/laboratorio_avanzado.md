### 2.3. Laboratorio: Lambda Avanzado

---

## Laboratorio: Lambda Avanzado

### Descripción del Laboratorio

En este laboratorio, vamos a crear una función Lambda avanzada que maneje diferentes tipos de errores y registre eventos en CloudWatch. Aprenderemos a configurar variables de entorno y a implementar estrategias de manejo de errores para hacer nuestras funciones más robustas y confiables.

### Recursos Necesarios

- AWS CLI
- SDK de AWS para Java
- Maven
- IDE (Eclipse, IntelliJ, etc.)

### Ejercicio Práctico

#### Paso 1: Configuración del Proyecto

**Objetivo:** Crear un proyecto Maven y configurar las dependencias necesarias.

1. **Crear un nuevo proyecto Maven en tu IDE:**
   - Abre tu IDE y crea un nuevo proyecto Maven.
   - Configura el `pom.xml` con las dependencias necesarias para AWS Lambda.

   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>

       <groupId>com.example</groupId>
       <artifactId>lambda-advanced</artifactId>
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
               <artifactId>aws-java-sdk-s3</artifactId>
               <version>1.12.118</version>
           </dependency>
           <dependency>
               <groupId>junit</groupId>
               <artifactId>junit</artifactId>
               <version>4.12</version>
               <scope>test</scope>
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
                                       <mainClass>com.example.AdvancedLambdaHandler</mainClass>
                                   </transformers>
                               </configuration>
                       </execution>
                   </executions>
               </plugin>
           </plugins>
       </build>
   </project>
   ```

#### Paso 2: Implementar la Función Lambda

**Objetivo:** Escribir la función Lambda que maneje diferentes tipos de errores y registre eventos en CloudWatch.

1. **Crear la clase `AdvancedLambdaHandler`:**

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;

   public class AdvancedLambdaHandler implements RequestHandler<String, String> {

       @Override
       public String handleRequest(String input, Context context) {
           String keyName = System.getenv("KEY_NAME");
           String tableName = System.getenv("DB_TABLE_NAME");

           context.getLogger().log("Input: " + input);
           context.getLogger().log("Key: " + keyName + ", Table: " + tableName);

           try {
               // Lógica de procesamiento
               if (input == null || input.isEmpty()) {
                   throw new IllegalArgumentException("Input cannot be null or empty");
               }

               // Simulación de procesamiento exitoso
               return "Processed successfully with key: " + keyName + " and table: " + tableName;
           } catch (Exception e) {
               context.getLogger().log("Error: " + e.getMessage());
               return "Error processing request: " + e.getMessage();
           }
       }
   }
   ```

#### Paso 3: Configurar Variables de Entorno

**Objetivo:** Configurar variables de entorno necesarias para la función Lambda.

1. **Desde la Consola de AWS:**
   - Accede a la consola de AWS Lambda.
   - Selecciona tu función Lambda.
   - En la pestaña "Configuration", selecciona "Environment variables".
   - Añade las variables de entorno necesarias.

   **Ejemplo:**
   ```plaintext
   KEY_NAME=exampleKey
   DB_TABLE_NAME=myTable
   ```

2. **Desde AWS CLI:**

   - Usa el siguiente comando para actualizar las variables de entorno de una función Lambda:

   ```sh
   aws lambda update-function-configuration --function-name AdvancedLambdaFunction --environment Variables={KEY_NAME=exampleKey,DB_TABLE_NAME=myTable}
   ```

#### Paso 4: Desplegar la Función en AWS Lambda

**Objetivo:** Desplegar la función Lambda en AWS.

1. **Construir el Proyecto:**
   - Ejecuta el siguiente comando para construir y empaquetar el proyecto en un archivo JAR:

   ```sh
   mvn clean package
   ```

2. **Desplegar la Función Lambda:**
   - Usa el siguiente comando para desplegar el archivo JAR en AWS Lambda:

   ```sh
   aws lambda update-function-code --function-name AdvancedLambdaFunction --zip-file fileb://target/lambda-advanced-1.0-SNAPSHOT.jar
   ```

#### Paso 5: Probar la Función desde la Consola de AWS

**Objetivo:** Verificar el funcionamiento de la función Lambda y el manejo adecuado de errores.

1. **Probar la Función desde la Consola de AWS:**
   - Accede a la consola de AWS Lambda.
   - Encuentra y selecciona la función `AdvancedLambdaHandler`.
   - Usa el panel de pruebas para enviar una cadena de texto y verifica que la respuesta esté en mayúsculas.

2. **Verificar los Logs en CloudWatch:**
   - Accede a CloudWatch Logs en la consola de AWS y revisa los logs generados por la función Lambda para verificar que todo funcione correctamente.

### Resumen

Este laboratorio te ha guiado a través de la creación, implementación y prueba de una función Lambda avanzada en Java. Hemos configurado el entorno de desarrollo, escrito y probado el código, manejado errores y desplegado la función en AWS. Además, hemos aprendido a configurar variables de entorno y a registrar eventos en CloudWatch, lo que asegura que la función Lambda sea robusta y confiable en un entorno de producción.