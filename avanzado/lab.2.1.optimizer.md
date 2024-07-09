### Descripción del Proyecto

**Aplicativo: Sistema de Monitoreo de Pedidos en un eCommerce**

En este laboratorio, vamos a crear un sistema de monitoreo de pedidos para un eCommerce utilizando AWS Lambda, SQS y SNS. Utilizaremos un generador de pedidos emulado que se comporta como un webhook de Shopify para alimentar nuestro sistema con eventos de pedidos masivos.

**Escenario del eCommerce**

Imaginemos que tenemos una tienda en línea que maneja miles de pedidos al día. Necesitamos un sistema para monitorear estos pedidos, enviar notificaciones cuando se crean nuevos pedidos y procesar estos pedidos de manera eficiente.

**Objetivos**

1. **Procesar Eventos de Pedidos:** Utilizar AWS Lambda para procesar eventos de nuevos pedidos.
2. **Notificaciones de Pedidos:** Enviar notificaciones sobre nuevos pedidos utilizando SNS.
3. **Optimización de Recursos:** Usar AWS Compute Optimizer para analizar y optimizar el uso de recursos, asegurando que nuestro sistema sea eficiente y rentable.

**Problemas a Resolver**

1. **Escalabilidad:** El sistema debe manejar un gran volumen de eventos de pedidos.
2. **Eficiencia en el Uso de Recursos:** Minimizar costos y maximizar el rendimiento.
3. **Tiempo de Procesamiento:** Asegurar que los pedidos se procesen rápidamente.

**Aplicación de AWS Compute Optimizer**

AWS Compute Optimizer nos ayudará a identificar áreas donde podemos optimizar el uso de los recursos de AWS, como las funciones Lambda, para reducir costos y mejorar el rendimiento.

### Emulación del eCommerce

Vamos a crear un generador de pedidos emulado que simulará los eventos de pedidos de Shopify. Este generador será un script Java que enviará eventos de pedidos a un webhook local, simulando el comportamiento de un webhook de Shopify.

---

### Índice del Laboratorio

1. **Configuración Inicial**
   - Crear una Cuenta de AWS
   - Configurar AWS CLI
   - Configurar AWS SDK para Java

2. **Creación de Roles y Políticas de IAM**
   - Crear un Rol para Lambda con Permisos Necesarios

3. **Crear Colas SQS**
   - Crear una Cola SQS

4. **Crear SNS**
   - Crear un Tema SNS

5. **Crear Funciones Lambda**
   - Crear Función Lambda que Envía Notificaciones a SNS
   - Crear Función Lambda que Procesa Pedidos de SQS

6. **Configurar Triggers de Lambda**
   - Configurar Lambda para Ser Disparado por SQS
   - Configurar Lambda para Ser Disparado por SNS

7. **Implementación del Ejemplo Aplicativo**
   - Crear un Generador de Pedidos en Java
   - Verificar el Flujo Completo de Eventos

8. **Uso de AWS Compute Optimizer**
   - Activar AWS Compute Optimizer
   - Analizar las Recomendaciones de Compute Optimizer

---

### Iteración 1: Configuración Inicial

**Motivación y Objetivos**

Para comenzar, necesitamos asegurarnos de que tenemos acceso a AWS y las herramientas necesarias configuradas.

**Pasos Detallados**

**Paso 1: Crear una Cuenta de AWS**
- Regístrate en AWS si no tienes una cuenta en [AWS Signup](https://aws.amazon.com/signup).

**Paso 2: Configurar AWS CLI**
- Descarga e instala AWS CLI desde [Instalación de AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).
- Configura AWS CLI con el comando `aws configure` y proporciona tus credenciales de AWS.

**Paso 3: Configurar AWS SDK para Java**
- Descarga e instala el SDK de AWS para Java siguiendo las instrucciones en [AWS SDK for Java](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-install.html).
- Configura tu proyecto Java para usar el SDK de AWS.

---

### Iteración 2: Creación de Roles y Políticas de IAM

**Motivación y Objetivos**

Las funciones Lambda necesitan permisos para interactuar con otros servicios de AWS como SQS y SNS. Crearemos un rol de IAM con las políticas necesarias.

**Pasos Detallados**

**Paso 4: Crear un Rol para Lambda con Permisos Necesarios**
- Navega a la consola de IAM.
- Crea un nuevo rol para el tipo de entidad de confianza "Lambda".
- Adjunta las políticas administradas `AWSLambdaBasicExecutionRole`, `AmazonSQSFullAccess` y `AmazonSNSFullAccess` a este rol.

---

### Iteración 3: Crear Colas SQS

**Motivación y Objetivos**

SQS es un servicio de colas de mensajes que permite la comunicación asíncrona entre diferentes componentes del sistema. Crearemos una cola SQS para almacenar eventos de pedidos.

**Pasos Detallados**

**Paso 5: Crear una Cola SQS**
- Navega a la consola de SQS.
- Crea una cola estándar llamada `OrdersQueue`.

---

### Iteración 4: Crear SNS

**Motivación y Objetivos**

SNS es un servicio de notificaciones que permite enviar mensajes a múltiples suscriptores. Crearemos un tema SNS para enviar notificaciones de nuevos pedidos.

**Pasos Detallados**

**Paso 6: Crear un Tema SNS**
- Navega a la consola de SNS.
- Crea un nuevo tema llamado `OrdersTopic`.

---

### Iteración 5: Crear Funciones Lambda

**Motivación y Objetivos**

Las funciones Lambda serán responsables de procesar eventos de pedidos y enviar notificaciones.

**Pasos Detallados**

**Paso 7: Crear Función Lambda que Envía Notificaciones a SNS**
- Navega a la consola de Lambda.
- Crea una nueva función Lambda llamada `NotifyNewOrder`.
- Usa el siguiente código para la función Lambda:

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.SQSEvent;
import com.amazonaws.services.sns.AmazonSNS;
import com.amazonaws.services.sns.AmazonSNSClientBuilder;
import com.amazonaws.services.sns.model.PublishRequest;
import com.amazonaws.services.sns.model.PublishResult;
import org.json.JSONObject;

public class NotifyNewOrder implements RequestHandler<SQSEvent, String> {
    private final AmazonSNS snsClient = AmazonSNSClientBuilder.defaultClient();
    private final String topicArn = System.getenv("TOPIC_ARN");

    @Override
    public String handleRequest(SQSEvent event, Context context) {
        for (SQSEvent.SQSMessage message : event.getRecords()) {
            JSONObject order = new JSONObject(message.getBody());
            String messageBody = new JSONObject().put("order", order).toString();
            PublishRequest publishRequest = new PublishRequest(topicArn, messageBody, "New Order Notification");
            PublishResult publishResult = snsClient.publish(publishRequest);
            context.getLogger().log("Message sent to SNS: " + publishResult.getMessageId());
        }
        return "Notifications sent";
    }
}
```

**Paso 8: Crear Función Lambda que Procesa Pedidos de SQS**
- Crea una nueva función Lambda llamada `ProcessOrder`.
- Usa el siguiente código para la función Lambda:

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.SQSEvent;
import org.json.JSONObject;

public class ProcessOrder implements RequestHandler<SQSEvent, String> {
    @Override
    public String handleRequest(SQSEvent event, Context context) {
        for (SQSEvent.SQSMessage message : event.getRecords()) {
            JSONObject order = new JSONObject(message.getBody());
            context.getLogger().log("Processing order: " + order.toString());
        }
        return "Orders processed";
    }
}
```

---

### Iteración 6: Configurar Triggers de Lambda

**Motivación y Objetivos**

Para que las funciones Lambda se ejecuten automáticamente, necesitamos configurar los disparadores.

**Pasos Detallados**

**Paso 9: Configurar Lambda para Ser Disparado por SQS**
- Navega a la consola de Lambda y selecciona `ProcessOrder`.
- En la sección de disparadores, añade la cola SQS `OrdersQueue`.

**Paso 10: Configurar Lambda para Ser Disparado por SNS**
- Navega a la consola de SNS y suscribe `NotifyNewOrder` al tema `OrdersTopic`.

---

### Iteración 7: Implementación del Ejemplo Aplicativo

**Motivación y Objetivos**

Vamos a implementar un generador de pedidos en Java para simular eventos de pedidos y verificar que todo el sistema funciona correctamente.

**Pasos Detallados**

**Paso 11: Crear un Generador de Pedidos en Java**

Crea un proyecto Java y añade las siguientes dependencias en tu archivo `pom.xml` si estás utilizando Maven:

```xml
<dependencies>
    <dependency>
        <groupId>com.amazonaws</groupId>
        <artifactId>aws-java-sdk-sqs</artifactId>
        <version>1.11.1000</version>
    </dependency>
    <dependency>
        <groupId>com.amazonaws</groupId>
        <artifactId>aws-java-sdk-sns</artifactId>
        <version>1.11.1000</version>
    </dependency>
    <dependency>
        <groupId>org.json</groupId>
        <artifactId>json</artifactId>
        <version>20210307</version>
    </dependency>
</dependencies>
```

Crea una clase `OrderGenerator` con el siguiente contenido:

```java
import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs.AmazonS

QSClientBuilder;
import com.amazonaws.services.sqs.model.SendMessageRequest;
import org.json.JSONObject;

import java.util.Arrays;
import java.util.List;
import java.util.Random;
import java.util.concurrent.TimeUnit;

public class OrderGenerator {
    private static final AmazonSQS sqs = AmazonSQSClientBuilder.defaultClient();
    private static final String queueUrl = "https://sqs.<REGION>.amazonaws.com/<ACCOUNT-ID>/OrdersQueue";

    private static final List<JSONObject> orders = Arrays.asList(
        new JSONObject().put("order_id", 1).put("item", "Laptop").put("quantity", 1),
        new JSONObject().put("order_id", 2).put("item", "Phone").put("quantity", 2),
        new JSONObject().put("order_id", 3).put("item", "Headphones").put("quantity", 3)
    );

    public static void main(String[] args) {
        Random random = new Random();
        while (true) {
            JSONObject order = orders.get(random.nextInt(orders.size()));
            sendOrder(order);
            try {
                TimeUnit.SECONDS.sleep(5);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                break;
            }
        }
    }

    private static void sendOrder(JSONObject order) {
        SendMessageRequest send_msg_request = new SendMessageRequest()
            .withQueueUrl(queueUrl)
            .withMessageBody(order.toString());
        sqs.sendMessage(send_msg_request);
        System.out.println("Sent order: " + order.toString());
    }
}
```

**Paso 12: Verificar el Flujo Completo de Eventos**
- Ejecuta la clase `OrderGenerator` y verifica que los pedidos se envían y procesan correctamente revisando los logs de CloudWatch.

---

### Iteración 8: Uso de AWS Compute Optimizer

**Motivación y Objetivos**

Para optimizar el uso de los recursos y reducir costos, usaremos AWS Compute Optimizer.

**Pasos Detallados**

**Paso 13: Activar AWS Compute Optimizer**

1. **Navegar a la Consola de Compute Optimizer:**
   - Inicia sesión en la consola de administración de AWS.
   - Ve a la consola de AWS Compute Optimizer.

2. **Habilitar AWS Compute Optimizer:**
   - Si es la primera vez que utilizas Compute Optimizer, selecciona "Enable Compute Optimizer" en la página de bienvenida.
   - Acepta los términos y condiciones y habilita el servicio.

**Paso 14: Analizar las Recomendaciones de Compute Optimizer**

1. **Revisar las Recomendaciones:**
   - Navega a la sección de recomendaciones de Lambda en la consola de Compute Optimizer.
   - Verifica las recomendaciones para las funciones Lambda que has creado.

2. **Interpretar las Recomendaciones:**
   - **Memory Size:** Compute Optimizer puede recomendar cambiar el tamaño de memoria asignado a tus funciones Lambda. Por ejemplo, puede sugerir reducir o aumentar la memoria para mejorar el rendimiento o reducir costos.
   - **Execution Duration:** Verifica si hay recomendaciones para mejorar la duración de ejecución de las funciones Lambda. Esto puede implicar optimizar el código o ajustar la memoria.
   - **Provisioned Concurrency:** Si tienes configurada concurrencia aprovisionada, puede haber recomendaciones para ajustarla según el uso real.

3. **Aplicar las Recomendaciones:**
   - Realiza los cambios sugeridos en la configuración de tus funciones Lambda directamente desde la consola de Lambda.
   - Monitorea el rendimiento y los costos después de aplicar las recomendaciones para asegurar que se logran los beneficios esperados.

4. **Monitorear y Ajustar Continuamente:**
   - AWS Compute Optimizer proporciona recomendaciones periódicas. Continúa monitoreando el rendimiento y los costos, y aplica nuevas recomendaciones según sea necesario.

---

Este laboratorio proporciona un flujo completo desde la configuración inicial hasta la optimización del sistema, cubriendo cada paso necesario para construir y mejorar un sistema de monitoreo de pedidos en un eCommerce utilizando AWS. La implementación en Java permite aplicar habilidades de programación robustas y aprovechar el SDK de AWS para Java en la construcción del sistema.