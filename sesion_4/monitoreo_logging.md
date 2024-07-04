### 4.3. Monitoreo y Logging en AWS Lambda

---

## Monitoreo y Logging en AWS Lambda

El monitoreo y logging son componentes cruciales para mantener la salud, el rendimiento y la seguridad de las aplicaciones en AWS Lambda. AWS proporciona herramientas robustas como Amazon CloudWatch para monitorear y registrar los eventos y métricas de las funciones Lambda. En esta sección, exploraremos cómo configurar el monitoreo y logging para funciones Lambda, así como la creación de alarmas y métricas personalizadas.

### Uso de CloudWatch para Monitoreo

Amazon CloudWatch es un servicio de monitoreo para recursos y aplicaciones en AWS. Proporciona datos y métricas que se pueden utilizar para realizar un seguimiento del rendimiento, identificar problemas y optimizar los recursos.

#### Métricas de CloudWatch para AWS Lambda

AWS Lambda envía automáticamente varias métricas a CloudWatch, que incluyen:

- **Invocations:** Número de veces que se invoca la función Lambda.
- **Duration:** El tiempo que tarda en ejecutarse la función Lambda.
- **Errors:** Número de invocaciones que resultan en un error.
- **Throttles:** Número de invocaciones que se han limitado debido a que se alcanzó la tasa de solicitudes concurrentes configurada.
- **Dead Letter Errors:** Número de errores al escribir en la cola DLQ (Dead Letter Queue).
- **IteratorAge:** Solo para funciones Lambda que leen desde una stream de Kinesis o DynamoDB, mide la edad de los registros procesados por la función.

#### Configuración de Logging en Lambda

AWS Lambda utiliza Amazon CloudWatch Logs para registrar la salida de las funciones. Los mensajes de log se pueden generar en el código de la función utilizando el objeto `Context` proporcionado por Lambda.

**Ejemplo de Configuración de Logging en una Función Lambda en Java:**

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

### Configuración de Alarmas y Métricas en CloudWatch

Las alarmas de CloudWatch se pueden configurar para tomar acciones específicas cuando las métricas alcanzan ciertos umbrales. Esto es útil para la detección temprana de problemas y la respuesta automática.

#### Crear una Alarma de CloudWatch

**Paso 1: Crear una Alarma para la Métrica de Invocaciones:**

1. **Acceder a la Consola de CloudWatch:**
   - Abre la consola de CloudWatch en AWS Management Console.

2. **Navegar a Alarms:**
   - En el panel de navegación, selecciona `Alarms`, y luego `Create Alarm`.

3. **Seleccionar la Métrica:**
   - Elige la métrica `Invocations` para tu función Lambda.

4. **Configurar la Condición:**
   - Define un umbral para la alarma, por ejemplo, si las invocaciones superan 1000 en un período de 5 minutos.

5. **Configurar las Acciones:**
   - Define las acciones a tomar cuando se activa la alarma, como enviar una notificación a través de SNS.

6. **Nombre y Descripción:**
   - Asigna un nombre y una descripción a la alarma, y luego crea la alarma.

#### Crear una Métrica Personalizada

**Paso 2: Enviar Métricas Personalizadas desde la Función Lambda:**

1. **Incluir la Dependencia del SDK de CloudWatch:**
   - Asegúrate de tener la dependencia de AWS SDK para CloudWatch en tu `pom.xml`.

   ```xml
   <dependency>
       <groupId>com.amazonaws</groupId>
       <artifactId>aws-java-sdk-cloudwatch</artifactId>
       <version>1.12.118</version>
   </dependency>
   ```

2. **Enviar Métricas Personalizadas:**

   ```java
   package com.example;

   import com.amazonaws.services.cloudwatch.AmazonCloudWatch;
   import com.amazonaws.services.cloudwatch.AmazonCloudWatchClientBuilder;
   import com.amazonaws.services.cloudwatch.model.MetricDatum;
   import com.amazonaws.services.cloudwatch.model.PutMetricDataRequest;
   import com.amazonaws.services.cloudwatch.model.StandardUnit;
   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;

   public class CustomMetricsHandler implements RequestHandler<Object, String> {

       @Override
       public String handleRequest(Object input, Context context) {
           context.getLogger().log("Enviando métricas personalizadas a CloudWatch...");

           AmazonCloudWatch cw = AmazonCloudWatchClientBuilder.defaultClient();

           MetricDatum datum = new MetricDatum()
               .withMetricName("CustomMetric")
               .withUnit(StandardUnit.Count)
               .withValue(1.0);

           PutMetricDataRequest request = new PutMetricDataRequest()
               .withNamespace("MyNamespace")
               .withMetricData(datum);

           cw.putMetricData(request);

           context.getLogger().log("Métricas enviadas correctamente.");
           return "Métricas personalizadas enviadas.";
       }
   }
   ```

### Resumen

En esta sección, aprendimos sobre el monitoreo y logging en AWS Lambda utilizando Amazon CloudWatch. Exploramos las métricas disponibles, cómo configurar logging en las funciones Lambda y cómo crear alarmas y métricas personalizadas en CloudWatch. Estas prácticas son esenciales para mantener la salud y el rendimiento de las aplicaciones serverless, permitiendo una respuesta rápida a problemas y optimización continua.