### Descripción del Proyecto

**Aplicativo: Sistema de Gestión Logística y Fulfillment de Pedidos**

En este laboratorio, vamos a expandir nuestro sistema de monitoreo de pedidos para incluir una gestión logística completa utilizando AWS Step Functions. Crearemos una máquina de estados que coordinará las distintas etapas del fulfillment de pedidos, desde la recepción hasta el envío.

**Escenario del eCommerce**

Continuando con nuestro ejemplo de tienda en línea, ahora queremos gestionar el fulfillment de los pedidos. Esto implica varios pasos como validar el inventario, procesar el pago, empaquetar los productos y enviarlos.

**Objetivos**

1. **Automatización del Fulfillment de Pedidos:** Utilizar AWS Step Functions para coordinar las diferentes etapas del fulfillment de pedidos.
2. **Escalabilidad y Eficiencia:** Asegurar que el sistema pueda manejar un gran volumen de pedidos de manera eficiente.
3. **Monitoreo y Trazabilidad:** Proveer capacidades de monitoreo y trazabilidad para cada etapa del fulfillment.

### Índice del Laboratorio

1. **Configuración Inicial**
   - Crear una Cuenta de AWS
   - Configurar AWS CLI
   - Configurar AWS SDK para Java

2. **Creación de Roles y Políticas de IAM**
   - Crear un Rol para Step Functions con Permisos Necesarios

3. **Diseñar la Máquina de Estados con Step Functions**
   - Definir los Estados del Fulfillment de Pedidos
   - Crear las Funciones Lambda para Cada Estado

4. **Implementación de las Funciones Lambda**
   - Validar Inventario
   - Procesar Pago
   - Empaquetar Productos
   - Enviar Pedido

5. **Crear y Configurar la Máquina de Estados**
   - Crear el Archivo de Definición de Estados
   - Desplegar la Máquina de Estados en AWS

6. **Implementación del Ejemplo Aplicativo**
   - Simular Pedidos y Ejecutar la Máquina de Estados
   - Verificar el Flujo Completo de Fulfillment

7. **Monitoreo y Optimización**
   - Utilizar AWS CloudWatch para Monitorear el Sistema
   - Analizar y Optimizar el Sistema

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

Las Step Functions y las funciones Lambda necesitan permisos para interactuar con otros servicios de AWS como SQS, SNS y DynamoDB. Crearemos un rol de IAM con las políticas necesarias.

**Pasos Detallados**

**Paso 4: Crear un Rol para Step Functions con Permisos Necesarios**
- Navega a la consola de IAM.
- Crea un nuevo rol para el tipo de entidad de confianza "Step Functions".
- Adjunta las políticas administradas `AWSLambdaRole`, `AmazonSQSFullAccess`, `AmazonSNSFullAccess` y `AmazonDynamoDBFullAccess` a este rol.

---

### Iteración 3: Diseñar la Máquina de Estados con Step Functions

**Motivación y Objetivos**

Diseñaremos una máquina de estados que coordine las distintas etapas del fulfillment de pedidos.

**Pasos Detallados**

**Paso 5: Definir los Estados del Fulfillment de Pedidos**
- Recepción del pedido
- Validación del inventario
- Procesamiento del pago
- Empaque de productos
- Envío del pedido

**Paso 6: Crear las Funciones Lambda para Cada Estado**
- Cada función Lambda representará un estado en el proceso de fulfillment.

---

### Iteración 4: Implementación de las Funciones Lambda

**Motivación y Objetivos**

Desarrollaremos las funciones Lambda que se usarán en cada estado de la máquina de estados.

**Pasos Detallados**

**Paso 7: Validar Inventario**
- Crea una función Lambda llamada `ValidateInventory`.
- Usa el siguiente código para la función Lambda:

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import org.json.JSONObject;

public class ValidateInventory implements RequestHandler<JSONObject, JSONObject> {
    @Override
    public JSONObject handleRequest(JSONObject input, Context context) {
        String orderId = input.getString("order_id");
        // Lógica para validar inventario
        boolean isAvailable = true; // Simulación
        JSONObject response = new JSONObject();
        response.put("order_id", orderId);
        response.put("inventory_valid", isAvailable);
        return response;
    }
}
```

**Paso 8: Procesar Pago**
- Crea una función Lambda llamada `ProcessPayment`.
- Usa el siguiente código para la función Lambda:

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import org.json.JSONObject;

public class ProcessPayment implements RequestHandler<JSONObject, JSONObject> {
    @Override
    public JSONObject handleRequest(JSONObject input, Context context) {
        String orderId = input.getString("order_id");
        // Lógica para procesar pago
        boolean paymentSuccess = true; // Simulación
        JSONObject response = new JSONObject();
        response.put("order_id", orderId);
        response.put("payment_processed", paymentSuccess);
        return response;
    }
}
```

**Paso 9: Empaquetar Productos**
- Crea una función Lambda llamada `PackItems`.
- Usa el siguiente código para la función Lambda:

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import org.json.JSONObject;

public class PackItems implements RequestHandler<JSONObject, JSONObject> {
    @Override
    public JSONObject handleRequest(JSONObject input, Context context) {
        String orderId = input.getString("order_id");
        // Lógica para empaquetar productos
        boolean packingSuccess = true; // Simulación
        JSONObject response = new JSONObject();
        response.put("order_id", orderId);
        response.put("items_packed", packingSuccess);
        return response;
    }
}
```

**Paso 10: Enviar Pedido**
- Crea una función Lambda llamada `ShipOrder`.
- Usa el siguiente código para la función Lambda:

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import org.json.JSONObject;

public class ShipOrder implements RequestHandler<JSONObject, JSONObject> {
    @Override
    public JSONObject handleRequest(JSONObject input, Context context) {
        String orderId = input.getString("order_id");
        // Lógica para enviar pedido
        boolean shippingSuccess = true; // Simulación
        JSONObject response = new JSONObject();
        response.put("order_id", orderId);
        response.put("order_shipped", shippingSuccess);
        return response;
    }
}
```

---

### Iteración 5: Crear y Configurar la Máquina de Estados

**Motivación y Objetivos**

Definiremos la máquina de estados utilizando AWS Step Functions y configuraremos los estados.

**Pasos Detallados**

**Paso 11: Crear el Archivo de Definición de Estados**
- Crea un archivo `state_machine_definition.json` con el siguiente contenido:

```json
{
  "Comment": "State Machine for Order Fulfillment",
  "StartAt": "ValidateInventory",
  "States": {
    "ValidateInventory": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:<REGION>:<ACCOUNT-ID>:function:ValidateInventory",
      "Next": "ProcessPayment"
    },
    "ProcessPayment": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:<REGION>:<ACCOUNT-ID>:function:ProcessPayment",
      "Next": "PackItems"
    },
    "PackItems": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:<REGION>:<ACCOUNT-ID>:function:PackItems",
      "Next": "ShipOrder"
    },
    "ShipOrder": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:<REGION>:<ACCOUNT-ID>:function:ShipOrder",
      "End": true
    }
  }
}
```

**Paso 12: Desplegar la Máquina de Estados en AWS**
- Navega a la consola de AWS Step Functions.
- Crea una nueva máquina de estados y carga el archivo `state_machine_definition.json`.

---

### Iteración 6: Implementación del Ejemplo Aplicativo

**Motivación y Objetivos**

Vamos a implementar un generador de pedidos en Java para simular eventos de pedidos y verificar que todo el sistema de fulfillment funciona correctamente.

**Pasos Detallados**

**Paso 13: Crear un Generador de Pedidos en Java**

Crea una clase `OrderGenerator` con el siguiente contenido:

```java
import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs

.AmazonSQSClientBuilder;
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

**Paso 14: Verificar el Flujo Completo de Fulfillment**
- Ejecuta la clase `OrderGenerator` y verifica que los pedidos se envían y procesan correctamente revisando los logs de CloudWatch y el estado en AWS Step Functions.

---

### Iteración 7: Monitoreo y Optimización

**Motivación y Objetivos**

Monitorearemos el sistema usando AWS CloudWatch y utilizaremos AWS Compute Optimizer para asegurar que el sistema esté optimizado.

**Pasos Detallados**

**Paso 15: Utilizar AWS CloudWatch para Monitorear el Sistema**
- Configura métricas y alarmas en CloudWatch para monitorear el rendimiento de las funciones Lambda y la máquina de estados.

**Paso 16: Activar AWS Compute Optimizer**
- Si no lo has hecho ya, habilita AWS Compute Optimizer en la consola de AWS.

**Paso 17: Analizar y Optimizar el Sistema**
- Revisa las recomendaciones proporcionadas por Compute Optimizer.
- Ajusta la configuración de memoria y concurrencia de las funciones Lambda según las recomendaciones.
- Monitorea el rendimiento y los costos después de aplicar las recomendaciones.

---

Este laboratorio proporciona un flujo completo desde la configuración inicial hasta la optimización del sistema, cubriendo cada paso necesario para construir y mejorar un sistema de gestión logística y fulfillment de pedidos en un eCommerce utilizando AWS. La implementación en Java permite aplicar habilidades de programación robustas y aprovechar el SDK de AWS para Java en la construcción del sistema.