# Laboratorio: Creación y Uso de Lambda Layers en AWS Lambda

## Objetivo
El objetivo de este laboratorio es guiarte a través de la creación de un Lambda Layer en AWS y su uso en una función Lambda escrita en Java. Al final del laboratorio, serás capaz de construir y desplegar una solución funcional que utilice Lambda Layers para gestionar dependencias de manera eficiente.

## Iteración 1: Configuración del Entorno de Desarrollo
### Objetivo
Configurar el entorno de desarrollo necesario para trabajar con AWS Lambda y Java.

### Pasos
1. **Instalar AWS CLI**:
   - Descargar e instalar AWS CLI desde [AWS CLI Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).
   - Configurar AWS CLI con `aws configure`.

2. **Instalar Java y Maven**:
   - Instalar [Java JDK](https://www.oracle.com/java/technologies/javase-downloads.html).
   - Instalar [Apache Maven](https://maven.apache.org/install.html).

3. **Configurar IDE**:
   - Instalar un IDE como [Eclipse](https://www.eclipse.org/downloads/) o [IntelliJ IDEA](https://www.jetbrains.com/idea/download/).

## Iteración 2: Crear un Proyecto Maven
### Objetivo
Crear un proyecto Maven para la función Lambda en Java.

### Pasos
1. **Crear estructura del proyecto**:
   - Ejecutar `mvn archetype:generate -DgroupId=com.example -DartifactId=LambdaFunction -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false`.

2. **Actualizar el archivo `pom.xml`**:
   - Añadir dependencias necesarias para AWS Lambda.
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
   </dependencies>

   <build>
       <plugins>
           <plugin>
               <groupId>org.apache.maven.plugins</groupId>
               <artifactId>maven-shade-plugin</artifactId>
               <version>3.2.4</version>
               <executions>
                   <execution>
                       <phase>package</phase>
                       <goals>
                           <goal>shade</goal>
                       </goals>
                   </execution>
               </executions>
           </plugin>
       </plugins>
   </build>
   ```

## Iteración 3: Implementar la Función Lambda en Java
### Objetivo
Crear una función Lambda simple en Java que maneje una solicitud HTTP.

### Pasos
1. **Crear la clase `LambdaFunctionHandler`**:
   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;
   import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
   import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;

   public class LambdaFunctionHandler implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {
       public APIGatewayProxyResponseEvent handleRequest(APIGatewayProxyRequestEvent request, Context context) {
           APIGatewayProxyResponseEvent response = new APIGatewayProxyResponseEvent();
           response.setStatusCode(200);
           response.setBody("Hello, World!");
           return response;
       }
   }
   ```

2. **Empaquetar el proyecto**:
   - Ejecutar `mvn clean package`.

## Iteración 4: Crear y Publicar un Lambda Layer
### Objetivo
Crear un Lambda Layer que contenga dependencias comunes para las funciones Lambda.

### Pasos
1. **Crear el directorio `java`**:
   - Crear un directorio llamado `java` y mover las dependencias necesarias.
   ```sh
   mkdir java
   cp target/dependency/*.jar java/
   ```

2. **Empaquetar el Layer**:
   - Crear un archivo ZIP con las dependencias.
   ```sh
   zip -r layer.zip java/
   ```

3. **Publicar el Layer en AWS Lambda**:
   ```sh
   aws lambda publish-layer-version --layer-name java-dependencies --zip-file fileb://layer.zip --compatible-runtimes java11
   ```

## Iteración 5: Crear la Función Lambda en AWS
### Objetivo
Desplegar la función Lambda en AWS y adjuntar el Layer creado.

### Pasos
1. **Crear la función Lambda**:
   - Utilizar la consola de AWS Lambda para crear una nueva función Lambda.
   - Seleccionar Java 11 como entorno de ejecución.

2. **Adjuntar el Layer a la función Lambda**:
   - En la configuración de la función, seleccionar "Add a layer" y elegir el Layer `java-dependencies`.

## Iteración 6: Configurar API Gateway
### Objetivo
Configurar API Gateway para invocar la función Lambda a través de una solicitud HTTP.

### Pasos
1. **Crear un nuevo API REST**:
   - Usar la consola de API Gateway para crear un nuevo API REST.
   - Crear un nuevo recurso y método (GET) que invoque la función Lambda.

2. **Desplegar la API**:
   - Desplegar la API en un nuevo stage y obtener la URL de invocación.

## Iteración 7: Probar la Función Lambda
### Objetivo
Probar la función Lambda a través de la URL de API Gateway.

### Pasos
1. **Enviar una solicitud HTTP**:
   - Utilizar herramientas como `curl` o Postman para enviar una solicitud GET a la URL de API Gateway.
   ```sh
   curl -X GET <API_GATEWAY_URL>
   ```

2. **Verificar la respuesta**:
   - Asegurarse de que la respuesta sea "Hello, World!".

## Iteración 8: Añadir Dependencias Adicionales al Layer
### Objetivo
Añadir dependencias adicionales al Layer y actualizar la función Lambda.

### Pasos
1. **Actualizar el directorio `java`**:
   - Añadir nuevas dependencias al directorio `java`.
   ```sh
   cp path/to/new/dependency.jar java/
   ```

2. **Actualizar el archivo ZIP del Layer**:
   ```sh
   zip -r layer.zip java/
   ```

3. **Publicar una nueva versión del Layer**:
   ```sh
   aws lambda publish-layer-version --layer-name java-dependencies --zip-file fileb://layer.zip --compatible-runtimes java11
   ```

4. **Actualizar la función Lambda**:
   - Adjuntar la nueva versión del Layer a la función Lambda en la consola de AWS.

## Iteración 9: Manejar Errores en la Función Lambda
### Objetivo
Añadir manejo de errores a la función Lambda para mejorar la robustez.

### Pasos
1. **Actualizar `LambdaFunctionHandler`**:
   ```java
   public class LambdaFunctionHandler implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {
       public APIGatewayProxyResponseEvent handleRequest(APIGatewayProxyRequestEvent request, Context context) {
           APIGatewayProxyResponseEvent response = new APIGatewayProxyResponseEvent();
           try {
               // Lógica principal
               response.setStatusCode(200);
               response.setBody("Hello, World!");
           } catch (Exception e) {
               response.setStatusCode(500);
               response.setBody("Error: " + e.getMessage());
           }
           return response;
       }
   }
   ```

2. **Empaquetar y desplegar la función**:
   - Ejecutar `mvn clean package`.
   - Desplegar la función Lambda en AWS.

## Iteración 10: Monitorear la Función Lambda
### Objetivo
Configurar CloudWatch para monitorear la función Lambda.

### Pasos
1. **Configurar CloudWatch Logs**:
   - Asegurarse de que la función Lambda tenga permisos para escribir en CloudWatch Logs.

2. **Verificar los logs en CloudWatch**:
   - Usar la consola de CloudWatch para revisar los logs de ejecución de la función Lambda.

Con estos pasos, habrás creado y desplegado una solución completa utilizando Lambda Layers en AWS Lambda con Java, gestionando eficientemente las dependencias y mejorando la organización y mantenibilidad de tu código.