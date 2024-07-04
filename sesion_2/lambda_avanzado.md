### 2.2. AWS Lambda Avanzado

---

## AWS Lambda Avanzado

En esta sección, profundizaremos en características avanzadas de AWS Lambda, como el uso de variables de entorno y el manejo de eventos y errores. Estas características son esenciales para crear funciones Lambda robustas y eficaces.

### Variables de Entorno y Configuración

Las variables de entorno permiten personalizar el comportamiento de las funciones Lambda sin modificar el código. Puedes usar variables de entorno para configurar parámetros de tu función, como los nombres de tablas de DynamoDB, claves API y otras configuraciones sensibles.

#### Configuración de Variables de Entorno

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
   aws lambda update-function-configuration --function-name MyLambdaFunction --environment Variables={KEY_NAME=exampleKey,DB_TABLE_NAME=myTable}
   ```

#### Uso de Variables de Entorno en el Código

Puedes acceder a las variables de entorno en tu código Java utilizando `System.getenv`.

**Ejemplo de Código:**

```java
package com.example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

public class EnvironmentVariableHandler implements RequestHandler<Object, String> {

    @Override
    public String handleRequest(Object input, Context context) {
        String keyName = System.getenv("KEY_NAME");
        String tableName = System.getenv("DB_TABLE_NAME");

        return "Key: " + keyName + ", Table: " + tableName;
    }
}
```

### Manejo de Eventos y Errores

El manejo adecuado de eventos y errores es crucial para asegurar que las funciones Lambda sean resilientes y fiables.

#### Tipos de Errores

1. **Errores Controlados (Handled Exceptions):**
   - Errores que puedes prever y manejar dentro de tu código. Por ejemplo, validaciones de entrada, errores de conexión, etc.

2. **Errores No Controlados (Unhandled Exceptions):**
   - Errores inesperados que no se manejan dentro del código, como errores de sistema o excepciones inesperadas.

#### Estrategias de Manejo de Errores

1. **Bloques try-catch:**
   - Utiliza bloques try-catch para manejar excepciones dentro de tu código y evitar que la función falle inesperadamente.

   **Ejemplo:**

   ```java
   @Override
   public String handleRequest(Object input, Context context) {
       try {
           // Código que puede lanzar una excepción
           return "Processed successfully!";
       } catch (Exception e) {
           context.getLogger().log("Error: " + e.getMessage());
           return "Error processing request: " + e.getMessage();
       }
   }
   ```

2. **Registro de Errores:**
   - Usa el contexto de la función Lambda para registrar errores y mensajes de depuración en CloudWatch Logs.

   **Ejemplo:**

   ```java
   @Override
   public String handleRequest(Object input, Context context) {
       context.getLogger().log("Input: " + input);
       try {
           // Lógica de procesamiento
           return "Processed successfully!";
       } catch (Exception e) {
           context.getLogger().log("Error: " + e.getMessage());
           throw e;
       }
   }
   ```

3. **Dead Letter Queues (DLQ):**
   - Configura una cola de SQS o un tema de SNS como DLQ para manejar mensajes fallidos. Esto asegura que los mensajes que no se pueden procesar no se pierdan y puedan ser revisados posteriormente.

   **Configuración de DLQ en la Consola de AWS:**
   - Accede a la configuración de tu función Lambda.
   - Selecciona "Asynchronous invocation".
   - Configura la Dead Letter Queue (DLQ) seleccionando una cola de SQS o un tema de SNS.

### Ejemplo Completo de Función Lambda Avanzada

**Código de Ejemplo:**

```java
package com.example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

public class AdvancedLambdaHandler implements RequestHandler<Object, String> {

    @Override
    public String handleRequest(Object input, Context context) {
        String keyName = System.getenv("KEY_NAME");
        String tableName = System.getenv("DB_TABLE_NAME");

        context.getLogger().log("Input: " + input);
        context.getLogger().log("Key: " + keyName + ", Table: " + tableName);

        try {
            // Lógica de procesamiento
            if (input == null || input.toString().isEmpty()) {
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

**Configuración de la Función Lambda:**

1. **Variables de Entorno:**
   - KEY_NAME: exampleKey
   - DB_TABLE_NAME: myTable

2. **Configuración de DLQ:**
   - Configura una cola de SQS o un tema de SNS como DLQ para manejar mensajes fallidos.

**Despliegue y Prueba:**

1. **Construir el Proyecto:**
   - Ejecuta `mvn clean package` para empaquetar el proyecto en un archivo JAR.

2. **Desplegar la Función:**
   - Usa AWS CLI para desplegar el archivo JAR en AWS Lambda:

   ```sh
   aws lambda update-function-code --function-name AdvancedLambdaFunction --zip-file fileb://target/lambda-project-1.0-SNAPSHOT.jar
   ```

3. **Probar la Función:**
   - Usa la consola de AWS Lambda o el comando AWS CLI para invocar la función y verificar el manejo adecuado de variables de entorno y errores.

### Conclusión

Esta sección ha cubierto aspectos avanzados de AWS Lambda, incluyendo la configuración y uso de variables de entorno, así como estrategias para el manejo de eventos y errores. Estas prácticas son fundamentales para crear funciones Lambda robustas y eficientes, capaces de manejar diversas situaciones y garantizar un funcionamiento confiable en producción.