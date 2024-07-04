### 1.4. Laboratorio: Primeros Pasos con Lambda en Java

#### Descripción del Laboratorio

En este laboratorio, crearás una función Lambda en Java que recibe una cadena de texto, la convierte a mayúsculas y la devuelve. El laboratorio se dividirá en 10 iteraciones, donde cada paso mejorará y probará el desarrollo y la implementación de la función Lambda.

#### Recursos Necesarios

- AWS CLI
- SDK de AWS para Java
- IDE (Eclipse, IntelliJ, etc.)

### Iteración 1: Configuración Inicial del Proyecto

**Motivación:**
Configurar correctamente el entorno de desarrollo es esencial para asegurar que todas las dependencias necesarias estén disponibles y que el proyecto esté estructurado adecuadamente.

**Objetivo:**
Crear un proyecto Maven en tu IDE y agregar las dependencias necesarias para AWS Lambda.

1. **Crear un nuevo proyecto Maven en tu IDE:**
   - Abre tu IDE y crea un nuevo proyecto Maven.
   - Configura el `pom.xml` con las dependencias necesarias para AWS Lambda:

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
           <version>3.9.0</version>
       </dependency>
       <dependency>
           <groupId>com.amazonaws</groupId>
           <artifactId>aws-java-sdk-lambda</artifactId>
           <version>1.12.118</version>
       </dependency>
   </dependencies>
   ```

### Iteración 2: Implementación Básica de la Función Lambda

**Motivación:**
Comenzar con una implementación básica permite establecer la estructura de la función Lambda y asegura que el código se ejecute correctamente.

**Objetivo:**
Implementar una función Lambda básica que convierta una cadena de texto a mayúsculas.

2. **Implementar la clase Lambda:**
   - Crea una nueva clase Java llamada `UpperCaseLambda` en tu proyecto:

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;

   public class UpperCaseLambda implements RequestHandler<String, String> {

       @Override
       public String handleRequest(String input, Context context) {
           return input.toUpperCase();
       }
   }
   ```

### Iteración 3: Crear un Archivo de Evento de Prueba

**Motivación:**
Tener un evento de prueba permite simular las invocaciones de la función Lambda y facilita la verificación del comportamiento esperado.

**Objetivo:**
Crear un archivo JSON que contenga los datos de entrada para probar la función Lambda.

3. **Crear un archivo de evento de prueba:**
   - Crea un archivo `event.json` en el directorio raíz del proyecto con el siguiente contenido:

   ```json
   {
       "input": "hello world"
   }
   ```

### Iteración 4: Prueba Local de la Función con AWS SAM

**Motivación:**
Probar la función localmente permite identificar y corregir errores antes de desplegarla en AWS, ahorrando tiempo y recursos.

**Objetivo:**
Configurar AWS SAM para probar la función Lambda localmente.

4. **Configurar el template.yaml para SAM:**
   - Crea un archivo `template.yaml` en el directorio raíz del proyecto con el siguiente contenido:

   ```yaml
   AWSTemplateFormatVersion: '2010-09-09'
   Transform: AWS::Serverless-2016-10-31
   Resources:
     UpperCaseFunction:
       Type: AWS::Serverless::Function
       Properties:
         Handler: com.example.UpperCaseLambda::handleRequest
         Runtime: java11
         CodeUri: .
         MemorySize: 512
         Timeout: 10
         Events:
           UpperCase:
             Type: Api
             Properties:
               Path: /uppercase
               Method: post
   ```

5. **Probar la función localmente con SAM:**
   - Ejecuta el siguiente comando en el terminal para probar la función Lambda localmente:

   ```sh
   sam local invoke "UpperCaseFunction" -e event.json
   ```

### Iteración 5: Agregar Manejo de Errores

**Motivación:**
Implementar el manejo de errores asegura que la función Lambda sea robusta y capaz de manejar entradas no válidas o situaciones inesperadas.

**Objetivo:**
Mejorar la función Lambda para manejar errores de manera adecuada.

6. **Mejorar la función Lambda con manejo de errores:**
   - Modifica la clase `UpperCaseLambda` para manejar errores:

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;

   public class UpperCaseLambda implements RequestHandler<String, String> {

       @Override
       public String handleRequest(String input, Context context) {
           if (input == null || input.isEmpty()) {
               return "Input string is null or empty";
           }
           return input.toUpperCase();
       }
   }
   ```

7. **Probar nuevamente la función localmente con SAM:**
   - Ejecuta el comando de prueba local para asegurarte de que el manejo de errores funcione correctamente.

### Iteración 6: Configurar Roles y Permisos en AWS

**Motivación:**
Configurar roles y permisos adecuados es crucial para la seguridad y el correcto funcionamiento de la función Lambda en AWS.

**Objetivo:**
Crear y configurar un rol IAM que la función Lambda utilizará para ejecutar con los permisos necesarios.

8. **Configurar un rol IAM para Lambda:**
   - Accede a la consola de IAM en AWS.
   - Crea un nuevo rol con permisos básicos para Lambda (por ejemplo, `AWSLambdaBasicExecutionRole`).

### Iteración 7: Desplegar la Función Lambda en AWS

**Motivación:**
Desplegar la función en AWS permite que sea accesible y utilizable en un entorno de producción.

**Objetivo:**
Desplegar la función Lambda en AWS utilizando SAM.

9. **Desplegar la función en AWS Lambda:**
   - Ejecuta el siguiente comando para empaquetar y desplegar la función Lambda:

   ```sh
   sam package --output-template-file packaged.yaml --s3-bucket YOUR_S3_BUCKET_NAME
   sam deploy --template-file packaged.yaml --stack-name UpperCaseLambdaStack --capabilities CAPABILITY_IAM
   ```

### Iteración 8: Probar la Función Lambda desde la Consola de AWS

**Motivación:**
Probar la función Lambda desde la consola de AWS asegura que funcione correctamente en el entorno de AWS y que esté correctamente configurada.

**Objetivo:**
Ejecutar y verificar la función Lambda desde la consola de AWS.

10. **Probar la función desde la consola de AWS:**
   - Accede a la consola de AWS Lambda.
   - Encuentra y selecciona la función `UpperCaseLambda`.
   - Usa el panel de pruebas para enviar una cadena de texto y verifica que la respuesta esté en mayúsculas.

### Iteración 9: Monitorear la Función Lambda

**Motivación:**
Monitorear la función Lambda permite detectar y solucionar problemas de rendimiento y asegurar que la función se ejecute correctamente.

**Objetivo:**
Configurar y revisar los logs de la función Lambda en CloudWatch.

11. **Configurar y verificar los logs en CloudWatch:**
   - Asegúrate de que la función Lambda esté configurada para enviar logs a CloudWatch.
   - Accede a CloudWatch Logs en la consola de AWS y revisa los logs generados por la función Lambda para verificar que todo funcione correctamente.

### Iteración 10: Mejoras y Optimización

**Motivación:**
Optimizar la función Lambda asegura que sea eficiente y escalable, y que cumpla con los requisitos de rendimiento y costos.

**Objetivo:**
Realizar mejoras y optimizaciones en la configuración y el código de la función Lambda.

12. **Mejorar el rendimiento y optimización:**
   - Ajusta la configuración de memoria y el tiempo de espera de la función Lambda según sea necesario.
   - Agrega más pruebas unitarias y de integración para asegurar la calidad del código.
   - Implementa mejores prácticas de desarrollo y seguridad para Lambda.

### Resumen

Este laboratorio te ha guiado a través de la creación, implementación y prueba de una función Lambda en Java, dividida en 10 iteraciones para mejorar y verificar el desarrollo paso a paso. Has aprendido a configurar el entorno de desarrollo, escribir y probar el código, manejar errores, desplegar en AWS y monitorear el funcionamiento de la función.
