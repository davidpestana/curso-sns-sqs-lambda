### 1.2. AWS Lambda

## ¿Es Lambda un Contenedor?

### Introducción

La computación moderna ha visto una evolución significativa en cómo se implementan y gestionan las aplicaciones. Dos tecnologías clave en este ámbito son la virtualización y los contenedores. Ambas ofrecen formas de aislar y gestionar aplicaciones, pero lo hacen de maneras fundamentalmente diferentes. AWS Lambda, aunque no es un servicio de contenedores en sí, utiliza contenedores de manera subyacente para proporcionar entornos de ejecución aislados y eficientes.

### ¿Qué son los Contenedores?

Los contenedores son una tecnología de virtualización a nivel de sistema operativo que permite empaquetar y ejecutar aplicaciones y sus dependencias en un entorno aislado. A diferencia de la virtualización tradicional, los contenedores comparten el núcleo del sistema operativo con el host, lo que los hace más ligeros y eficientes.

**Características de los Contenedores:**

1. **Ligereza:** Los contenedores no requieren un sistema operativo completo, lo que los hace significativamente más ligeros que las máquinas virtuales (VMs). Esto se debe a que comparten el núcleo del sistema operativo con el host.
   
2. **Aislamiento:** Proporcionan un entorno aislado para aplicaciones, asegurando que cada contenedor tenga su propio sistema de archivos, variables de entorno y configuraciones.

3. **Portabilidad:** Los contenedores se pueden ejecutar en cualquier sistema que soporte la tecnología de contenedores (como Docker), haciendo que las aplicaciones sean portátiles entre diferentes entornos de desarrollo y producción.

4. **Escalabilidad:** Facilitan la creación y destrucción rápida de entornos, lo que es ideal para aplicaciones que necesitan escalar dinámicamente.

**Ejemplo de un Dockerfile:**

```Dockerfile
# Utiliza una imagen base de Python
FROM python:3.8-slim-buster

# Establece el directorio de trabajo
WORKDIR /app

# Copia el archivo de requerimientos y los instala
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Copia el código de la aplicación
COPY . .

# Comando para ejecutar la aplicación
CMD ["python", "app.py"]
```

### Virtualización vs. Contenedores

**Virtualización:**

La virtualización tradicional permite ejecutar múltiples sistemas operativos completos en una sola máquina física mediante la creación de VMs. Cada VM tiene su propio kernel y sistema operativo, lo que proporciona un fuerte aislamiento pero con un mayor consumo de recursos.

**Características de la Virtualización:**

1. **Aislamiento Completo:** Cada VM tiene su propio sistema operativo, lo que proporciona un fuerte aislamiento entre VMs.
   
2. **Compatibilidad:** Las VMs pueden ejecutar diferentes sistemas operativos y versiones, proporcionando flexibilidad en términos de compatibilidad con aplicaciones y sistemas legados.

3. **Overhead:** Las VMs tienen un mayor overhead debido a la necesidad de virtualizar hardware y ejecutar sistemas operativos completos.

**Ejemplo de Virtualización:**

```plaintext
+-----------------+  +-----------------+  +-----------------+
|    VM 1         |  |    VM 2         |  |    VM 3         |
| OS + App        |  | OS + App        |  | OS + App        |
+-----------------+  +-----------------+  +-----------------+
| Hypervisor      |  | Hypervisor      |  | Hypervisor      |
+-----------------+  +-----------------+  +-----------------+
| Hardware        |  | Hardware        |  | Hardware        |
+-----------------+  +-----------------+  +-----------------+
```

**Diferencias Clave entre Contenedores y Virtualización:**

1. **Uso de Recursos:**
   - **Contenedores:** Comparten el kernel del sistema operativo con el host, lo que reduce significativamente el overhead y el uso de recursos.
   - **Virtualización:** Cada VM tiene su propio kernel, lo que aumenta el consumo de recursos.

2. **Aislamiento:**
   - **Contenedores:** Proporcionan un aislamiento a nivel de aplicación, compartiendo el kernel del sistema operativo.
   - **Virtualización:** Proporciona un aislamiento completo a nivel de sistema operativo, con cada VM ejecutando su propio kernel.

3. **Arranque:**
   - **Contenedores:** Arrancan mucho más rápido que las VMs porque no necesitan inicializar un sistema operativo completo.
   - **Virtualización:** Las VMs tardan más en arrancar debido a la necesidad de iniciar un sistema operativo completo.

4. **Portabilidad:**
   - **Contenedores:** Altamente portátiles entre diferentes entornos que soporten la tecnología de contenedores.
   - **Virtualización:** Menos portátiles debido a la dependencia del hipervisor específico y configuraciones del sistema.

### ¿Cómo utiliza contenedores AWS Lambda?

AWS Lambda no es un contenedor en el sentido tradicional, pero usa contenedores para ejecutar sus funciones de manera eficiente. Vamos a profundizar en cómo funciona AWS Lambda y cómo utiliza contenedores en su arquitectura.

**Aislamiento del Entorno:**
- Cada función Lambda se ejecuta en un contenedor aislado, lo que garantiza que no haya interferencia entre diferentes funciones o invocaciones. Esto proporciona seguridad y consistencia en la ejecución.

**Escalabilidad:**
- Lambda escala automáticamente al lanzar múltiples contenedores para manejar el tráfico entrante. Si hay muchas solicitudes, Lambda puede lanzar muchos contenedores en paralelo para manejar la carga.

**Inicio Rápido:**
- Los contenedores de Lambda están diseñados para iniciar rápidamente, minimizando el tiempo de arranque en frío (cold start). AWS optimiza estos contenedores para reducir la latencia en el arranque.

### Arquitectura de AWS Lambda

![Arquitectura AWS Lambda](https://docs.aws.amazon.com/es_es/whitepapers/latest/serverless-multi-tier-architectures-api-gateway-lambda/images/microservices-with-lambda.png)

1. **Desencadenadores (Triggers):**
   - Eventos de servicios como S3, DynamoDB, API Gateway, SQS, SNS, entre otros, pueden actuar como desencadenadores para funciones Lambda.

2. **Envío del Código:**
   - Los desarrolladores suben su código a Lambda, donde se almacena y se prepara para la ejecución.

3. **Entorno de Ejecución:**
   - Lambda usa un entorno de ejecución basado en contenedores para ejecutar el código. Estos entornos incluyen los recursos necesarios, como CPU, memoria y almacenamiento temporal.

4. **Retorno de Resultados:**
   - Una vez ejecutado el código, Lambda devuelve los resultados al origen del evento o realiza acciones específicas, como escribir en una base de datos o enviar una notificación.

![Integracion de soluciones](https://d1.awsstatic.com/ac-serverless-wa-apps-intro.9623178d724f8a8f24febe415329757aeb85aa6c.png)

### Beneficios de Usar AWS Lambda

1. **Sin Gestión de Servidores:**
   - No necesitas preocuparte por la infraestructura subyacente. AWS Lambda se encarga de todo el aprovisionamiento, escalado, monitoreo y registro de tu código.

2. **Escalabilidad Automática:**
   - Lambda ajusta automáticamente la escala en función del tráfico entrante, lanzando más contenedores según sea necesario.

3. **Pago por Uso:**
   - Solo pagas por el tiempo de computación consumido y la cantidad de ejecuciones. Esto puede ser más económico en comparación con mantener servidores dedicados.

4. **Integración con Otros Servicios de AWS:**
   - Lambda se integra fácilmente con otros servicios de AWS, lo que facilita la creación de aplicaciones complejas y escalables.

### Ejemplo de una Función Lambda en Java

Vamos a repasar brevemente el ejemplo práctico de crear una función Lambda que procese un archivo CSV desde S3 y almacene los datos en DynamoDB.

1. **Código de la Función:**

```java
package com.example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.S3Event;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.dynamodbv2.document.Item;
import com.amazonaws.services.lambda.runtime.events.S3EventNotification;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

public class ProcessCSVFunction implements RequestHandler<S3Event, String> {

    private final AmazonS3 s3 = AmazonS3ClientBuilder.defaultClient();
    private final AmazonDynamoDB dynamoDBClient = AmazonDynamoDBClientBuilder.defaultClient();
    private final DynamoDB dynamoDB = new DynamoDB(dynamoDBClient);
    private final String tableName = "ProcessedData";

    @Override
    public String handleRequest(S3Event event, Context context) {
        try {
            S3EventNotification.S3EventNotificationRecord record = event.getRecords().get(0);
            String bucketName = record.getS3().getBucket().getName();
            String objectKey = record.getS3().getObject().getKey();

            // Descargar el archivo CSV desde S3
            InputStream s3Object = s3.getObject(bucketName, objectKey).getObjectContent();
            File file = new File("/tmp/" + objectKey);
            com.amazonaws.util.IOUtils.copy(s3Object, new java.io.FileOutputStream(file));

            // Procesar el archivo CSV
            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] values = line.split(",");
                    Map<String, String> item = new HashMap<>();
                   

 item.put("RecordId", values[0]);
                    item.put("Name", values[1]);
                    item.put("Email", values[2]);
                    item.put("ProcessedTimestamp", context.getAwsRequestId());

                    // Guardar los datos en DynamoDB
                    Table table = dynamoDB.getTable(tableName);
                    table.putItem(new Item().withPrimaryKey("RecordId", values[0])
                            .withString("Name", values[1])
                            .withString("Email", values[2])
                            .withString("ProcessedTimestamp", context.getAwsRequestId()));
                }
            }
            return "File processed successfully!";
        } catch (Exception e) {
            e.printStackTrace();
            return "Error processing file.";
        }
    }
}
```

2. **Despliegue y Configuración:**

   - **Desplegar el Código en Lambda:**
     - Sube el código (archivo JAR) a AWS Lambda.
     - Configura el handler y asigna los permisos necesarios.

   - **Configurar el Desencadenador de S3:**
     - Configura para que la función se ejecute automáticamente cuando se cargue un archivo CSV en el bucket de S3.

3. **Prueba de la Función:**

   - **Sube un Archivo CSV a S3:**
     - Sube un archivo CSV al bucket configurado.
   
   - **Verifica la Ejecución:**
     - Revisa los logs en CloudWatch y verifica que los datos se hayan almacenado correctamente en DynamoDB.

### Conclusión

AWS Lambda no es un contenedor en el sentido tradicional, pero utiliza contenedores para proporcionar entornos de ejecución aislados, escalables y eficientes. Esto permite a los desarrolladores centrarse en el código y la lógica de negocio sin preocuparse por la infraestructura subyacente.

### AWS Lambda


AWS Lambda es un servicio de computación sin servidor que ejecuta tu código en respuesta a eventos y gestiona automáticamente los recursos de cómputo necesarios para esa ejecución. Lambda te permite ejecutar código sin aprovisionar ni gestionar servidores, escalando automáticamente desde unas pocas solicitudes por día hasta miles por segundo.

#### Conceptos básicos

AWS Lambda se basa en un modelo de computación sin servidor, lo que significa que no tienes que preocuparte por la infraestructura subyacente. Simplemente cargas tu código, configuras los desencadenadores y Lambda se encarga del resto.

**Definición y uso:**

AWS Lambda ejecuta tu código en respuesta a eventos como cambios en datos en un bucket de Amazon S3, actualizaciones a una tabla en Amazon DynamoDB, o tráfico HTTP mediante Amazon API Gateway. Lambda admite varios lenguajes de programación, incluidos Node.js, Python, Java, Ruby, C#, Go y PowerShell.

**Beneficios y limitaciones:**

- **Beneficios:**
  - Sin servidores que gestionar: AWS Lambda se encarga del aprovisionamiento, escalado, monitoreo y registro de tu código.
  - Escalabilidad automática: Lambda ajusta automáticamente la escala en función del tráfico entrante.
  - Modelo de pago por uso: Solo pagas por el tiempo de computación consumido, lo que puede ser más económico en comparación con servidores tradicionales.

- **Limitaciones:**
  - Tiempo de ejecución limitado: Cada invocación de función tiene un tiempo máximo de ejecución de 15 minutos.
  - Recursos limitados: Las funciones de Lambda están limitadas a 10 GB de memoria y 512 MB de espacio de almacenamiento temporal.

#### Arquitectura de AWS Lambda

La arquitectura de AWS Lambda está diseñada para manejar solicitudes entrantes en forma de eventos, procesarlos y luego devolver una respuesta o realizar alguna acción específica.

**Cómo funciona:**

- **Desencadenadores:** Los desencadenadores son eventos que invocan tu función Lambda. Estos pueden ser eventos de S3, DynamoDB, API Gateway, SQS, SNS, entre otros.
- **Ejecución del código:** Una vez que se invoca la función, Lambda ejecuta el código en un entorno controlado. Este entorno incluye los recursos necesarios para la ejecución, como CPU, memoria y almacenamiento temporal.
- **Retorno de resultados:** Después de ejecutar el código, Lambda devuelve los resultados al origen del evento o ejecuta la acción configurada, como escribir en una base de datos o enviar una notificación.

**Componentes clave:**

- **Función Lambda:** El código que deseas ejecutar.
- **Desencadenadores:** Los eventos que invocan la función.
- **Entorno de ejecución:** El contexto en el cual se ejecuta la función, que incluye variables de entorno y configuración de recursos.
- **Roles de IAM:** Los permisos necesarios para que Lambda acceda a otros recursos de AWS.

#### Uso de Lambda en diferentes escenarios

AWS Lambda se puede utilizar en una amplia variedad de casos de uso, desde procesamiento de datos en tiempo real hasta la creación de backends sin servidor para aplicaciones web y móviles.

**Casos de uso comunes:**

- **Procesamiento de datos en tiempo real:** Procesa flujos de datos en tiempo real desde servicios como Kinesis o DynamoDB Streams.
- **Automatización de operaciones:** Automatiza tareas administrativas como copias de seguridad, monitoreo y respuestas a eventos de la infraestructura.
- **Backends para aplicaciones web y móviles:** Crea API RESTful utilizando Lambda y API Gateway para manejar solicitudes HTTP sin necesidad de servidores dedicados.

**Integraciones con otros servicios de AWS:**

- **Amazon S3:** Ejecuta funciones Lambda en respuesta a eventos de S3, como la carga o eliminación de objetos.
- **Amazon DynamoDB:** Procesa cambios en tablas de DynamoDB utilizando Streams.
- **Amazon SNS:** Envía notificaciones en tiempo real a través de SNS.
- **Amazon SQS:** Procesa mensajes de colas de SQS.

#### Ejemplo de código en Java para una función Lambda simple:

```java
package example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

public class HelloLambda implements RequestHandler<RequestClass, ResponseClass> {

    @Override
    public ResponseClass handleRequest(RequestClass request, Context context) {
        String greetingString = String.format("Hello %s, %s.", request.firstName, request.lastName);
        return new ResponseClass(greetingString);
    }
}
```

**Clases auxiliares para la solicitud y la respuesta:**

```java
package example;

public class RequestClass {
    String firstName;
    String lastName;

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
}
```

```java
package example;

public class ResponseClass {
    String greetings;

    public ResponseClass(String greetings) {
        this.greetings = greetings;
    }

    public String getGreetings() {
        return greetings;
    }

    public void setGreetings(String greetings) {
        this.greetings = greetings;
    }
}
```

En este ejemplo, la función Lambda recibe un objeto `RequestClass` con los campos `firstName` y `lastName`, y devuelve un objeto `ResponseClass` con un saludo personalizado.

#### Ejemplo de código en Python para una función Lambda simple:

```python
def lambda_handler(event, context):
    first_name = event.get('firstName')
    last_name = event.get('lastName')
    greeting = f"Hello {first_name} {last_name}."
    return {
        'statusCode': 200,
        'body': greeting
    }
```

#### Ejemplo de código en Node.js para una función Lambda simple:

```javascript
exports.handler = async (event) => {
    const firstName = event.firstName;
    const lastName = event.lastName;
    const greeting = `Hello ${firstName} ${lastName}.`;
    
    const response = {
        statusCode: 200,
        body: JSON.stringify(greeting),
    };
    return response;
};
```

### Triggers (Desencadenadores) en AWS Lambda

Los triggers son los eventos que invocan una función Lambda. AWS Lambda puede integrarse con una variedad de servicios de AWS que actúan como fuentes de eventos. Aquí se explican algunos de los triggers más comunes:

- **Amazon S3:** Permite que una función Lambda procese eventos de un bucket S3, como la carga, eliminación o actualización de objetos. Por ejemplo, puedes usar Lambda para generar miniaturas de imágenes cargadas.
  
- **Amazon DynamoDB:** Usa DynamoDB Streams para desencadenar funciones Lambda en respuesta a cambios en una tabla DynamoDB. Esto es útil para tareas como replicación de datos o procesamiento en tiempo real.
  
- **Amazon Kinesis:** Lambda puede procesar registros de un stream de Kinesis. Esto es útil para análisis en tiempo real de datos como logs de aplicación o eventos de clics en un sitio web.
  
- **Amazon SNS:** Lambda puede ser suscrito a un tópico SNS para procesar mensajes enviados al tópico. Esto es útil para notificaciones en tiempo real y sistemas de mensajería.
  
- **Amazon SQS:** Lambda puede leer mensajes de una cola SQS y procesarlos. Esto es útil para aplicaciones que necesitan manejar colas de trabajo o procesamiento asíncrono.
  
- **Amazon CloudWatch Events y EventBridge:** Estos servicios permiten crear reglas basadas en eventos que pueden desencadenar una función Lambda. Por ejemplo, puedes ejecutar una función Lambda en respuesta a cambios en la configuración de AWS o eventos de aplicación personalizada.

### Buenas prácticas para desarrollar con AWS Lambda

1. **Escribe funciones pequeñas y enfocadas:** Cada función Lambda debe hacer una sola cosa y hacerlo bien. Esto facilita la gestión y las pruebas de las funciones.
  
2. **Minimiza el tamaño del paquete de implementación:** Mantén tu paquete de implementación lo más pequeño posible incluyendo solo las dependencias necesarias. Esto reduce el tiempo de arranque en frío y facilita las actualizaciones.
  
3. **Usa versiones de funciones:** Utiliza la funcionalidad de versiones de Lambda para gestionar cambios en el código de manera segura. Esto permite probar nuevas versiones sin interrumpir la producción.
  
4. **Gestiona la configuración con variables de entorno:** Utiliza variables de entorno para gestionar la configuración de tu función Lambda. Esto te permite cambiar la configuración sin modificar el código.
  
5. **Configura el tiempo de espera y la memoria adecuadamente:** Ajusta el tiempo de espera y la memoria asignada a tu función Lambda en función de las necesidades de tu aplicación. Un mayor tiempo de espera y más memoria pueden mejorar el rendimiento, pero también aumentar los costos.
  
6. **Monitorea y registra con CloudWatch:** Configura CloudWatch Logs y CloudWatch Metrics para monitorear el rendimiento de tu función Lambda. Configura alarmas para notificarte sobre problemas.
  
7. **Manejo de errores:** Implementa un manejo de errores adecuado. Utiliza try/catch en tu código y maneja errores de manera que puedas enviar alertas o tomar acciones correctivas.
  
8. **Pruebas exhaustivas:** Escribe pruebas unitarias y de integración para tu función Lambda. Utiliza frameworks de pruebas como JUnit para Java, pytest para Python o Mocha para Node.js.

### Casos de uso avanzados

1. **Procesamiento de ETL (Extract, Transform, Load):** Usa AWS Lambda para transformar datos en tiempo real y cargarlos en un almacén de datos como Amazon Redshift o Amazon S3.



2. **Chatbots y asistentes virtuales:** Implementa chatbots utilizando AWS Lambda en combinación con Amazon Lex para procesamiento del lenguaje natural.

3. **Automatización de DevOps:** Utiliza Lambda para automatizar tareas de DevOps como despliegues continuos, integración continua y monitoreo de infraestructura.

4. **Aplicaciones IoT:** Procesa datos de dispositivos IoT en tiempo real usando AWS IoT y Lambda para ejecutar lógica de negocio basada en eventos de dispositivos.

5. **Microservicios:** Implementa arquitecturas de microservicios utilizando Lambda y API Gateway, lo que permite un desarrollo modular y escalable de aplicaciones.

### Conclusión

AWS Lambda es una poderosa herramienta para desarrollar aplicaciones sin servidor, proporcionando una escalabilidad automática y un modelo de pago por uso que puede ser más económico en comparación con la infraestructura tradicional. Con la capacidad de integrarse fácilmente con otros servicios de AWS, Lambda permite a los desarrolladores construir aplicaciones complejas y escalables sin preocuparse por la gestión de la infraestructura subyacente.

Esta sección cubre de manera detallada los conceptos básicos, la arquitectura, los casos de uso comunes y avanzados, las mejores prácticas y ejemplos de código en diferentes lenguajes, proporcionando una comprensión integral de cómo trabajar con AWS Lambda.





### Creación y Prueba de una Función AWS Lambda en Java: Ejemplo Práctico

#### Objetivo

Crear una función Lambda que procese datos de un archivo CSV almacenado en un bucket de Amazon S3, lo transforme y almacene los resultados en una tabla de Amazon DynamoDB. Este ejemplo es útil en un contexto empresarial donde se requiere procesar grandes volúmenes de datos cargados a S3 y almacenarlos en una base de datos para análisis posterior.

### Paso 1: Configurar los servicios de AWS

1. **Crear un Bucket de S3:**
   
   **Motivación:**
   - Amazon S3 es ideal para almacenar grandes cantidades de datos no estructurados como archivos CSV, imágenes y videos. Usar S3 permite acceder a estos datos de manera escalable y duradera.

   **Objetivo:**
   - Configurar un lugar centralizado y accesible donde se puedan cargar los archivos CSV para que sean procesados por AWS Lambda.

   **Pasos:**
   - Accede a la consola de Amazon S3.
   - Haz clic en "Create bucket".
   - Ingresa un nombre único para el bucket y selecciona la región.
   - Configura las opciones según tus necesidades y haz clic en "Create bucket".

2. **Crear una Tabla DynamoDB:**

   **Motivación:**
   - DynamoDB proporciona una base de datos NoSQL escalable y de alto rendimiento. Es ideal para almacenar datos estructurados y realizar consultas rápidas y eficientes.

   **Objetivo:**
   - Configurar una base de datos donde se puedan almacenar los datos procesados del archivo CSV para análisis y consultas futuras.

   **Pasos:**
   - Accede a la consola de Amazon DynamoDB.
   - Haz clic en "Create table".
   - Ingresa un nombre para la tabla (por ejemplo, `ProcessedData`).
   - Define una clave de partición (por ejemplo, `RecordId` de tipo String).
   - Configura las opciones adicionales según tus necesidades y haz clic en "Create table".

### Paso 2: Crear una Función Lambda en Java

1. **Configurar el Proyecto en tu IDE:**

   **Motivación:**
   - Usar un entorno de desarrollo integrado (IDE) facilita la gestión y el desarrollo del proyecto Java. Maven, una herramienta de gestión de proyectos, ayuda a manejar las dependencias y la configuración del proyecto.

   **Objetivo:**
   - Establecer un entorno de desarrollo adecuado que permita compilar y gestionar las dependencias del proyecto de manera eficiente.

   **Pasos:**
   - Abre tu IDE preferido (Eclipse, IntelliJ, etc.).
   - Crea un nuevo proyecto Maven.
   - Añade las dependencias necesarias para AWS Lambda y AWS SDK para Java en el archivo `pom.xml`:

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
           <artifactId>aws-java-sdk-s3</artifactId>
           <version>1.12.118</version>
       </dependency>
       <dependency>
           <groupId>com.amazonaws</groupId>
           <artifactId>aws-java-sdk-dynamodb</artifactId>
           <version>1.12.118</version>
       </dependency>
   </dependencies>
   ```

2. **Crear la Clase de la Función Lambda:**
   
   **Motivación:**
   - Definir el comportamiento de la función Lambda, que se ejecutará cada vez que se dispare el evento (en este caso, la carga de un archivo CSV en S3).

   **Objetivo:**
   - Implementar la lógica que permitirá procesar los archivos CSV y almacenar los resultados en DynamoDB.

   **Pasos:**
   - Crea una nueva clase en tu proyecto (por ejemplo, `ProcessCSVFunction`).
   - Implementa la interfaz `RequestHandler` que define el método `handleRequest`, el punto de entrada para la función Lambda.

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;
   import com.amazonaws.services.lambda.runtime.events.S3Event;

   public class ProcessCSVFunction implements RequestHandler<S3Event, String> {

       @Override
       public String handleRequest(S3Event event, Context context) {
           // Lógica para procesar el archivo CSV
           return "File processed successfully!";
       }
   }
   ```

3. **Implementar la Lógica de Procesamiento del CSV:**

   **Motivación:**
   - La función Lambda necesita descargar el archivo CSV desde S3, leer su contenido, transformarlo y almacenarlo en DynamoDB. Cada una de estas operaciones es esencial para completar el flujo de procesamiento de datos desde la carga hasta el almacenamiento.

   **Objetivo:**
   - Desarrollar la lógica necesaria para descargar, procesar y almacenar los datos de manera eficiente y confiable.

   **Pasos:**
   - Descarga el archivo CSV desde S3 al entorno temporal de Lambda usando el SDK de AWS para Java.
   - Lee el archivo y transforma los datos según sea necesario.
   - Usa el SDK de AWS para Java para almacenar los datos transformados en la tabla DynamoDB.

   ```java
   import com.amazonaws.services.s3.AmazonS3;
   import com.amazonaws.services.s3.AmazonS3ClientBuilder;
   import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
   import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
   import com.amazonaws.services.dynamodbv2.document.DynamoDB;
   import com.amazonaws.services.dynamodbv2.document.Table;
   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;
   import com.amazonaws.services.lambda.runtime.events.S3Event;
   import com.amazonaws.services.lambda.runtime.events.S3EventNotification;
   import java.io.BufferedReader;
   import java.io.File;
   import java.io.FileReader;
   import java.io.InputStream;
   import java.util.HashMap;
   import java.util.Map;

   public class ProcessCSVFunction implements RequestHandler<S3Event, String> {

       private final AmazonS3 s3 = AmazonS3ClientBuilder.defaultClient();
       private final AmazonDynamoDB dynamoDBClient = AmazonDynamoDBClientBuilder.defaultClient();
       private final DynamoDB dynamoDB = new DynamoDB(dynamoDBClient);
       private final String tableName = "ProcessedData";

       @Override
       public String handleRequest(S3Event event, Context context) {
           try {
               S3EventNotification.S3EventNotificationRecord record = event.getRecords().get(0);
               String bucketName = record.getS3().getBucket().getName();
               String objectKey = record.getS3().getObject().getKey();

               // Descargar el archivo CSV desde S3
               InputStream s3Object = s3.getObject(bucketName, objectKey).getObjectContent();
               File file = new File("/tmp/" + objectKey);
               com.amazonaws.util.IOUtils.copy(s3Object, new java.io.FileOutputStream(file));

               // Procesar el archivo CSV
               try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                   String line;
                   while ((line = br.readLine()) != null) {
                       String[] values = line.split(",");
                       Map<String, String> item = new HashMap<>();
                       item.put("RecordId", values[0]);
                       item.put("Name", values[1]);
                       item.put("Email", values[2]);
                       item.put("ProcessedTimestamp", context.getAwsRequestId());

                       // Guardar los datos en DynamoDB
                       Table table = dynamoDB.getTable(tableName);
                       table.putItem(new com.amazonaws.services.dynamodbv2.document.Item().withPrimaryKey("RecordId", values[0])
                               .withString("Name", values[1])
                               .withString("Email", values[2])
                               .withString("ProcessedTimestamp", context.getAwsRequestId()));
                   }
               }
               return "File processed successfully!";
           } catch (Exception e) {
               e.printStackTrace();
               return "Error processing file.";
           }
       }
   }
   ```

### Paso 3: Desplegar y Configurar la Función Lambda

1. **Desplegar el Código en Lambda:**

   **Motivación:**
   - Desplegar el código permite que AWS Lambda lo ejecute en respuesta a eventos definidos (por ejemplo, carga de archivos en S3).

   **Objetivo:**
   - Subir el código a Lambda para que pueda ser ejecutado automáticamente cuando se carguen archivos CSV en el bucket de S3.

   **Pasos:**
   - Compila el proyecto en tu IDE y genera el archivo JAR.
   - Accede a la consola de AWS Lambda.
   - Crea una nueva función Lambda, seleccionando "Author from scratch".
   - Ingresa un nombre para la función (por ejemplo, `ProcessCSVFunction`).
   - Selecciona "Java 11" como entorno de ejecución.
   - En la sección de permisos, selecciona "Create a new role with basic Lambda permissions".
   - Haz clic en "Create function".
   - En la sección "Function code", selecciona "Upload a .zip or .jar file" y sube el archivo JAR generado.
  

 - Establece el handler a `com.example.ProcessCSVFunction::handleRequest`.
   - Haz clic en "Save".

2. **Configurar el Desencadenador de S3:**

   **Motivación:**
   - Configurar un desencadenador permite que la función Lambda se ejecute automáticamente cuando se carga un archivo CSV en el bucket de S3.

   **Objetivo:**
   - Asegurar que la función Lambda procese los archivos CSV tan pronto como se suben a S3, automatizando el flujo de trabajo.

   **Pasos:**
   - En la consola de Lambda, dentro de la función creada, haz clic en "Add trigger".
   - Selecciona "S3" como fuente del evento.
   - Elige el bucket que creaste anteriormente.
   - Configura el evento para que se dispare en la carga de objetos con la extensión `.csv`.
   - Haz clic en "Add".

### Paso 4: Probar la Función Lambda

1. **Subir un Archivo CSV a S3:**

   **Motivación:**
   - Probar la función Lambda con datos reales asegura que todo el flujo de procesamiento y almacenamiento funcione correctamente.

   **Objetivo:**
   - Verificar que la función Lambda procese el archivo CSV y almacene los datos en DynamoDB como se espera.

   **Pasos:**
   - Crea un archivo CSV en tu computadora con el siguiente contenido de ejemplo:

     ```csv
     RecordId,Name,Email
     1,John Doe,john.doe@example.com
     2,Jane Smith,jane.smith@example.com
     3,Bob Johnson,bob.johnson@example.com
     ```

   - Accede a la consola de S3 y sube el archivo CSV al bucket que configuraste anteriormente.

2. **Verificar la Ejecución de la Función Lambda:**

   **Motivación:**
   - Revisar los logs y resultados de la ejecución de Lambda permite identificar y solucionar posibles errores en el proceso.

   **Objetivo:**
   - Asegurar que la función Lambda se ejecute correctamente y procese el archivo CSV como se esperaba.

   **Pasos:**
   - Accede a la consola de CloudWatch Logs y busca los logs de la función Lambda (`ProcessCSVFunction`).
   - Verifica que la función se haya ejecutado correctamente y que los registros de procesamiento aparezcan en los logs.

3. **Verificar los Datos en DynamoDB:**

   **Motivación:**
   - Confirmar que los datos procesados se hayan almacenado correctamente en DynamoDB asegura que el flujo de trabajo completo funcione como se esperaba.

   **Objetivo:**
   - Verificar que los datos del archivo CSV se hayan almacenado correctamente en la tabla DynamoDB.

   **Pasos:**
   - Accede a la consola de DynamoDB y abre la tabla `ProcessedData`.
   - Verifica que los registros del archivo CSV hayan sido almacenados correctamente en la tabla.

### Conclusión

Hemos creado una función AWS Lambda en Java que procesa archivos CSV subidos a un bucket de S3, transforma los datos y los almacena en una tabla de DynamoDB. Este ejemplo muestra cómo Lambda puede integrarse con otros servicios de AWS para automatizar flujos de trabajo de procesamiento de datos, lo cual es muy útil en un contexto empresarial donde se requiere manejar grandes volúmenes de datos de manera eficiente y escalable.



### Lambda en Ubicaciones de AWS Edge

#### ¿Qué es AWS Edge?

**AWS Edge Locations** son ubicaciones físicas distribuidas globalmente donde AWS implementa infraestructura para entregar contenido y ejecutar código cerca de los usuarios finales. Estas ubicaciones son puntos de presencia (PoPs) utilizados principalmente por Amazon CloudFront, la red de entrega de contenido (CDN) de AWS.

**Objetivo:**
- **Reducción de latencia:** Al estar más cerca de los usuarios finales, las solicitudes de contenido pueden ser atendidas más rápidamente, mejorando la experiencia del usuario.

#### Motivación para Implementar Lambda@Edge

**AWS Lambda@Edge** permite ejecutar funciones Lambda en estas ubicaciones de borde, lo que permite a los desarrolladores personalizar la entrega de contenido y ejecutar lógica de aplicación más cerca del usuario final.

**Ventajas:**
1. **Reducción de Latencia:** Las solicitudes no necesitan viajar hasta una región principal de AWS.
2. **Personalización Dinámica:** Personalizar el contenido entregado en función de la geolocalización, tipo de dispositivo, y otros metadatos.
3. **Mejora en la Experiencia del Usuario:** Tiempos de respuesta más rápidos y rendimiento mejorado.
4. **Escalabilidad Global:** Aprovechar la infraestructura global de AWS para escalar automáticamente en múltiples ubicaciones.

#### Cómo Implementar Lambda@Edge

**1. Crear una Función Lambda:**
- Escribir una función Lambda para manipular las solicitudes o respuestas HTTP.
  
  ```javascript
  exports.handler = async (event) => {
      const request = event.Records[0].cf.request;
      const headers = request.headers;
      
      // Personalizar respuesta basada en geolocalización
      if (headers['cloudfront-viewer-country']) {
          const country = headers['cloudfront-viewer-country'][0].value;
          if (country === 'US') {
              request.uri = '/us-index.html';
          } else if (country === 'FR') {
              request.uri = '/fr-index.html';
          }
      }
      
      return request;
  };
  ```

**2. Configurar Lambda@Edge:**
- Desplegar la función Lambda en las ubicaciones de Edge y asociarla con una distribución de CloudFront.
  
  ```bash
  aws lambda create-function --function-name MyEdgeFunction \
      --runtime nodejs14.x --role arn:aws:iam::123456789012:role/execution_role \
      --handler index.handler --zip-file fileb://function.zip \
      --region us-east-1
      
  aws lambda add-permission --function-name MyEdgeFunction \
      --statement-id 1 --action lambda:InvokeFunction \
      --principal edgelambda.amazonaws.com --source-arn arn:aws:cloudfront::123456789012:distribution/EXAMPLE
  ```

**3. Asociar con CloudFront:**
- Asociar la función Lambda@Edge con eventos específicos en CloudFront, como "origin-request" o "viewer-response".

#### Costos de AWS Lambda@Edge

**Costos de Ejecución:**
- **Número de Ejecuciones:** Se cobra por cada invocación de la función Lambda.
- **Duración:** Se cobra por el tiempo de ejecución de la función, medido en milisegundos, desde el inicio hasta la finalización.

**Costos de Solicitudes de CloudFront:**
- **Solicitudes HTTP/HTTPS:** Se cobran por las solicitudes realizadas a la distribución de CloudFront.

**Transferencia de Datos:**
- **Transferencia de Datos desde CloudFront a Internet:** Se cobran los datos transferidos desde CloudFront a los usuarios finales en internet. Las tarifas varían según la región de la ubicación de borde.
- **Transferencia de Datos entre Regiones:** Si los datos deben ser transferidos entre diferentes regiones de AWS, se aplican cargos adicionales por la transferencia de datos entre regiones.

#### Recomendaciones y Buenas Prácticas

1. **Optimización de Costos:**
   - Utilizar Lambda@Edge solo para funciones que realmente se beneficien de la reducción de latencia y personalización en el borde.
   
2. **Seguridad:**
   - Implementar controles de seguridad robustos para validar y sanitizar las entradas, ya que el código se ejecuta en ubicaciones de borde más expuestas.

3. **Monitoreo y Logging:**
   - Configurar AWS CloudWatch para monitorear y registrar las ejecuciones de Lambda@Edge, permitiendo una visibilidad completa de su desempeño y errores.

4. **Pruebas Exhaustivas:**
   - Realizar pruebas exhaustivas en entornos de prueba que emulen las condiciones de borde antes de desplegar en producción.

AWS Lambda@Edge es una poderosa herramienta para mejorar la latencia y la personalización de aplicaciones y servicios globales, aprovechando la infraestructura de borde de AWS para llevar el procesamiento más cerca de los usuarios finales.
