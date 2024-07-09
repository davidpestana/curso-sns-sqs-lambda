### Laboratorio: Ampliación de Flujos con Notificaciones al Cliente y Envío de Facturas

En este laboratorio, vamos a ampliar nuestra arquitectura de gestión logística y fulfillment de pedidos para incluir notificaciones al cliente a través del API de Shopify y el envío de facturas. Esta integración mejorará la comunicación con los clientes y automatizará el proceso de facturación.

### Índice del Laboratorio

1. **Configuración Inicial**
   - Crear una Cuenta de AWS
   - Configurar AWS CLI
   - Configurar AWS SDK para Java

2. **Integración con el API de Shopify**
   - Configurar Credenciales de Shopify
   - Crear Funciones Lambda para Interactuar con Shopify

3. **Notificaciones al Cliente a través del API de Shopify**
   - Configurar Shopify para Notificaciones
   - Crear Funciones Lambda para Enviar Notificaciones de Estado

4. **Envío de Facturas**
   - Generar Facturas con AWS Lambda
   - Enviar Facturas por Correo Electrónico usando Amazon SES

5. **Integración con el Flujo de Fulfillment**
   - Modificar la Máquina de Estados para Incluir Nuevos Pasos
   - Probar la Integración Completa

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

### Iteración 2: Integración con el API de Shopify

**Motivación y Objetivos**

Vamos a configurar nuestras credenciales de Shopify y crear funciones Lambda que interactúen con el API de Shopify.

**Pasos Detallados**

**Paso 4: Configurar Credenciales de Shopify**
- Ve a la consola de administración de Shopify.
- Crea una aplicación privada o personalizada para obtener las credenciales (API key y password).

**Paso 5: Crear Funciones Lambda para Interactuar con Shopify**

**Función Lambda para Actualizar el Estado del Pedido:**

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import org.json.JSONObject;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.entity.StringEntity;

public class UpdateOrderStatus implements RequestHandler<JSONObject, String> {
    private static final String SHOPIFY_API_URL = "https://<SHOP_NAME>.myshopify.com/admin/api/2021-07/orders/";

    @Override
    public String handleRequest(JSONObject input, Context context) {
        String orderId = input.getString("order_id");
        String status = input.getString("status");
        String apiKey = System.getenv("SHOPIFY_API_KEY");
        String password = System.getenv("SHOPIFY_API_PASSWORD");

        try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
            HttpPost request = new HttpPost(SHOPIFY_API_URL + orderId + ".json");
            request.setHeader("Content-Type", "application/json");
            request.setHeader("Authorization", "Basic " + Base64.getEncoder().encodeToString((apiKey + ":" + password).getBytes()));

            JSONObject statusUpdate = new JSONObject();
            statusUpdate.put("order", new JSONObject().put("note", "Status updated to " + status));

            StringEntity entity = new StringEntity(statusUpdate.toString());
            request.setEntity(entity);

            httpClient.execute(request);
            context.getLogger().log("Order status updated: " + orderId);

            return "Order status updated";
        } catch (Exception e) {
            context.getLogger().log("Error updating order status: " + e.getMessage());
            return "Error updating order status";
        }
    }
}
```

---

### Iteración 3: Notificaciones al Cliente a través del API de Shopify

**Motivación y Objetivos**

Configurar Shopify para enviar notificaciones y crear funciones Lambda para enviar notificaciones de estado a los clientes.

**Pasos Detallados**

**Paso 6: Configurar Shopify para Notificaciones**
- En la consola de administración de Shopify, configura las notificaciones para pedidos.

**Paso 7: Crear Funciones Lambda para Enviar Notificaciones de Estado**

**Función Lambda para Enviar Notificaciones de Estado:**

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import org.json.JSONObject;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.entity.StringEntity;

public class NotifyCustomer implements RequestHandler<JSONObject, String> {
    private static final String SHOPIFY_API_URL = "https://<SHOP_NAME>.myshopify.com/admin/api/2021-07/orders/";

    @Override
    public String handleRequest(JSONObject input, Context context) {
        String orderId = input.getString("order_id");
        String email = input.getString("email");
        String message = input.getString("message");
        String apiKey = System.getenv("SHOPIFY_API_KEY");
        String password = System.getenv("SHOPIFY_API_PASSWORD");

        try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
            HttpPost request = new HttpPost(SHOPIFY_API_URL + orderId + "/fulfillments.json");
            request.setHeader("Content-Type", "application/json");
            request.setHeader("Authorization", "Basic " + Base64.getEncoder().encodeToString((apiKey + ":" + password).getBytes()));

            JSONObject notification = new JSONObject();
            notification.put("fulfillment", new JSONObject()
                .put("notify_customer", true)
                .put("tracking_number", "123456")
                .put("tracking_urls", new JSONArray().put("https://tracking-url.com"))
                .put("line_items", new JSONArray().put(new JSONObject().put("id", orderId)))
                .put("note", message));

            StringEntity entity = new StringEntity(notification.toString());
            request.setEntity(entity);

            httpClient.execute(request);
            context.getLogger().log("Customer notified: " + email);

            return "Customer notified";
        } catch (Exception e) {
            context.getLogger().log("Error notifying customer: " + e.getMessage());
            return "Error notifying customer";
        }
    }
}
```

---

### Iteración 4: Envío de Facturas

**Motivación y Objetivos**

Automatizar el envío de facturas a los clientes utilizando AWS Lambda y Amazon SES.

**Pasos Detallados**

**Paso 8: Generar Facturas con AWS Lambda**

**Función Lambda para Generar Facturas:**

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import org.json.JSONObject;

public class GenerateInvoice implements RequestHandler<JSONObject, String> {
    @Override
    public String handleRequest(JSONObject input, Context context) {
        String orderId = input.getString("order_id");
        String customerEmail = input.getString("email");
        // Lógica para generar factura (PDF u otro formato)
        String invoice = "Generated invoice for order: " + orderId;

        context.getLogger().log("Invoice generated: " + invoice);
        return invoice;
    }
}
```

**Paso 9: Enviar Facturas por Correo Electrónico usando Amazon SES**

**Función Lambda para Enviar Facturas:**

```java
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailService;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailServiceClientBuilder;
import com.amazonaws.services.simpleemail.model.*;
import org.json.JSONObject;

public class SendInvoice implements RequestHandler<JSONObject, String> {
    private final AmazonSimpleEmailService sesClient = AmazonSimpleEmailServiceClientBuilder.defaultClient();
    private final String FROM_EMAIL = System.getenv("FROM_EMAIL");

    @Override
    public String handleRequest(JSONObject input, Context context) {
        String orderId = input.getString("order_id");
        String customerEmail = input.getString("email");
        String invoice = input.getString("invoice");

        SendEmailRequest request = new SendEmailRequest()
            .withDestination(new Destination().withToAddresses(customerEmail))
            .withMessage(new Message()
                .withBody(new Body().withText(new Content().withCharset("UTF-8").withData(invoice)))
                .withSubject(new Content().withCharset("UTF-8").withData("Invoice for Order " + orderId)))
            .withSource(FROM_EMAIL);

        sesClient.sendEmail(request);
        context.getLogger().log("Invoice sent to: " + customerEmail);

        return "Invoice sent";
    }
}
```

---

### Iteración 5: Integración con el Flujo de Fulfillment

**Motivación y Objetivos**

Modificar la máquina de estados para incluir los nuevos pasos de notificación al cliente y envío de facturas.

**Pasos Detallados

**

**Paso 10: Modificar la Máquina de Estados para Incluir Nuevos Pasos**

Actualiza el archivo `state_machine_definition.json` para incluir los nuevos pasos:

```json
{
  "Comment": "State Machine for Order Fulfillment with Notifications and Invoices",
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
      "Next": "GenerateInvoice"
    },
    "GenerateInvoice": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:<REGION>:<ACCOUNT-ID>:function:GenerateInvoice",
      "Next": "SendInvoice"
    },
    "SendInvoice": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:<REGION>:<ACCOUNT-ID>:function:SendInvoice",
      "End": true
    }
  }
}
```

**Paso 11: Probar la Integración Completa**
- Ejecuta la máquina de estados con un pedido de prueba y verifica que todos los pasos se ejecutan correctamente, incluyendo las notificaciones y el envío de facturas.

---

### Conclusión

Este laboratorio amplía la arquitectura existente para incluir notificaciones al cliente a través del API de Shopify y el envío automatizado de facturas. La integración con Shopify mejora la comunicación con los clientes y la automatización del proceso de facturación asegura una experiencia fluida y eficiente para los usuarios. La implementación en Java permite aprovechar las capacidades del SDK de AWS para Java, asegurando una solución robusta y escalable.