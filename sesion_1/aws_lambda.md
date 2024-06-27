# AWS Lambda

AWS Lambda es un servicio de computación sin servidor que ejecuta tu código en respuesta a eventos y gestiona automáticamente los recursos de cómputo necesarios para esa ejecución. Lambda te permite ejecutar código sin aprovisionar ni gestionar servidores, escalando automáticamente desde unas pocas solicitudes por día hasta miles por segundo.

#### Conceptos básicos

AWS Lambda se basa en un modelo de computación sin servidor, lo que significa que no tienes que preocuparte por la infraestructura subyacente. Simplemente cargas tu código, configuras los desencadenadores y Lambda se encarga del resto.

- **Definición y uso:** AWS Lambda ejecuta tu código en respuesta a eventos como cambios en datos en un bucket de Amazon S3, actualizaciones a una tabla en Amazon DynamoDB, o tráfico HTTP mediante Amazon API Gateway. Lambda admite varios lenguajes de programación, incluidos Node.js, Python, Java, Ruby, C#, Go y PowerShell.
  
- **Beneficios y limitaciones:**
  - **Beneficios:**
    - **Sin servidores que gestionar:** AWS Lambda se encarga del aprovisionamiento, escalado, monitoreo y registro de tu código.
    - **Escalabilidad automática:** Lambda ajusta automáticamente la escala en función del tráfico entrante.
    - **Modelo de pago por uso:** Solo pagas por el tiempo de computación consumido, lo que puede ser más económico en comparación con servidores tradicionales.
  - **Limitaciones:**
    - **Tiempo de ejecución limitado:** Cada invocación de función tiene un tiempo máximo de ejecución de 15 minutos.
    - **Recursos limitados:** Las funciones de Lambda están limitadas a 3 GB de memoria y 512 MB de espacio de almacenamiento temporal.

#### Arquitectura de AWS Lambda

La arquitectura de AWS Lambda está diseñada para manejar solicitudes entrantes en forma de eventos, procesarlos y luego devolver una respuesta o realizar alguna acción específica.

- **Cómo funciona:**
  - **Desencadenadores:** Los desencadenadores son eventos que invocan tu función Lambda. Estos pueden ser eventos de S3, DynamoDB, API Gateway, SQS, SNS, entre otros.
  - **Ejecución del código:** Una vez que se invoca la función, Lambda ejecuta el código en un entorno controlado. Este entorno incluye los recursos necesarios para la ejecución, como CPU, memoria y almacenamiento temporal.
  - **Retorno de resultados:** Después de ejecutar el código, Lambda devuelve los resultados al origen del evento o ejecuta la acción configurada, como escribir en una base de datos o enviar una notificación.

![Arquitectura de AWS Lambda](https://d1.awsstatic.com/product-marketing/Lambda/Diagrams/product-page-diagram_Lambda-How-It-Works.6b9ce4084e13b0e9b4d407ca0a6d4787d29b7c2f.png)

- **Componentes clave:**
  - **Función Lambda:** El código que deseas ejecutar.
  - **Desencadenadores:** Los eventos que invocan la función.
  - **Entorno de ejecución:** El contexto en el cual se ejecuta la función, que incluye variables de entorno y configuración de recursos.
  - **Roles de IAM:** Los permisos necesarios para que Lambda acceda a otros recursos de AWS.

#### Uso de Lambda en diferentes escenarios

AWS Lambda se puede utilizar en una amplia variedad de casos de uso, desde procesamiento de datos en tiempo real hasta la creación de backends sin servidor para aplicaciones web y móviles.

- **Casos de uso comunes:**
  - **Procesamiento de datos en tiempo real:** Procesa flujos de datos en tiempo real desde servicios como Kinesis o DynamoDB Streams.
  - **Automatización de operaciones:** Automatiza tareas administrativas como copias de seguridad, monitoreo y respuestas a eventos de la infraestructura.
  - **Backends para aplicaciones web y móviles:** Crea API RESTful utilizando Lambda y API Gateway para manejar solicitudes HTTP sin necesidad de servidores dedicados.
  - **Integraciones con otros servicios de AWS:** Lambda puede integrarse fácilmente con otros servicios de AWS, como S3, DynamoDB, SNS, SQS, y más, para construir aplicaciones complejas y escalables.

- **Integraciones con otros servicios de AWS:**
  - **Amazon S3:** Ejecuta funciones Lambda en respuesta a eventos de S3, como la carga o eliminación de objetos.
  - **Amazon DynamoDB:** Procesa cambios en tablas de DynamoDB utilizando Streams.
  - **Amazon SNS:** Envia notificaciones en tiempo real a través de SNS.
  - **Amazon SQS:** Procesa mensajes de colas de SQS.

**Ejemplo de código en Java para una función Lambda simple:**

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

### Conclusión

AWS Lambda es una poderosa herramienta para desarrollar aplicaciones sin servidor, proporcionando una escalabilidad automática y un modelo de pago por uso que puede ser más económico en comparación con la infraestructura tradicional. Con la capacidad de integrarse fácilmente con otros servicios de AWS, Lambda permite a los desarrolladores construir aplicaciones complejas y escalables sin preocuparse por la gestión de la infraestructura subyacente.
