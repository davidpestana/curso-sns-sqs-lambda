### 3.3. Introducción a Amazon SNS

---

## Introducción a Amazon SNS

Amazon Simple Notification Service (SNS) es un servicio de mensajería gestionado que permite enviar mensajes a una gran cantidad de suscriptores de manera rápida y fiable. SNS facilita la comunicación entre sistemas distribuidos, microservicios y dispositivos, permitiendo la entrega de mensajes en múltiples formatos y a múltiples destinos.

### Conceptos Básicos de SNS

#### Definición y Uso

Amazon SNS es un servicio de mensajería basado en el modelo de publicación/suscripción (pub/sub). Los editores envían mensajes a un tema (topic), y los suscriptores reciben estos mensajes de acuerdo con sus preferencias de suscripción.

**Componentes Clave de SNS:**

1. **Temas (Topics):**
   - Los temas son canales a los que los editores publican mensajes y los suscriptores se suscriben para recibir esos mensajes.

2. **Suscripciones:**
   - Las suscripciones son las entidades que reciben los mensajes publicados en un tema. Los suscriptores pueden ser direcciones de correo electrónico, colas SQS, funciones Lambda, endpoints HTTP/HTTPS, y dispositivos móviles (mediante SMS o notificaciones push).

3. **Mensajes:**
   - Los mensajes pueden ser texto plano o JSON, y contienen la información que el editor quiere enviar a los suscriptores.

**Ventajas de SNS:**

- **Entrega Fan-Out:** Un mensaje publicado en un tema puede entregarse a múltiples suscriptores simultáneamente.
- **Flexibilidad de Suscripción:** Soporta múltiples protocolos de suscripción, incluyendo HTTP/HTTPS, email, SMS, SQS y Lambda.
- **Alta Disponibilidad y Durabilidad:** Garantiza la entrega de mensajes de manera fiable y en tiempo real.
- **Escalabilidad:** Capaz de manejar millones de mensajes por día sin necesidad de gestionar la infraestructura subyacente.

### Creación y Configuración de Temas

#### Paso 1: Crear un Tema SNS

**Objetivo:** Crear un tema SNS utilizando AWS CLI y verificar su creación.

1. **Crear un Tema SNS con AWS CLI:**

   ```sh
   aws sns create-topic --name MySNSTopic
   ```

2. **Verificar la Creación del Tema:**

   ```sh
   aws sns list-topics
   ```

   - Deberías ver el ARN de `MySNSTopic` en la lista de temas.

#### Paso 2: Crear Suscripciones al Tema SNS

**Objetivo:** Crear suscripciones para el tema SNS que entreguen mensajes a diferentes destinos.

1. **Suscribirse con un Endpoint HTTP/HTTPS:**

   ```sh
   aws sns subscribe --topic-arn arn:aws:sns:us-east-1:123456789012:MySNSTopic --protocol https --notification-endpoint https://myapi.example.com/notify
   ```

2. **Suscribirse con un Correo Electrónico:**

   ```sh
   aws sns subscribe --topic-arn arn:aws:sns:us-east-1:123456789012:MySNSTopic --protocol email --notification-endpoint user@example.com
   ```

3. **Suscribirse con una Cola SQS:**

   ```sh
   aws sns subscribe --topic-arn arn:aws:sns:us-east-1:123456789012:MySNSTopic --protocol sqs --notification-endpoint arn:aws:sqs:us-east-1:123456789012:MyQueue
   ```

4. **Suscribirse con una Función Lambda:**

   ```sh
   aws sns subscribe --topic-arn arn:aws:sns:us-east-1:123456789012:MySNSTopic --protocol lambda --notification-endpoint arn:aws:lambda:us-east-1:123456789012:function:MyLambdaFunction
   ```

### Publicación de Mensajes en un Tema SNS

**Objetivo:** Publicar mensajes en el tema SNS y verificar la entrega a los suscriptores.

1. **Publicar un Mensaje en el Tema SNS:**

   ```sh
   aws sns publish --topic-arn arn:aws:sns:us-east-1:123456789012:MySNSTopic --message "Hello, SNS!"
   ```

2. **Verificar la Entrega de Mensajes:**
   - Revisa los diferentes endpoints (correo electrónico, cola SQS, función Lambda, endpoint HTTP/HTTPS) para asegurarte de que el mensaje "Hello, SNS!" fue recibido.

### Integración de SNS con Otros Servicios de AWS

#### Integración con AWS Lambda

**Objetivo:** Desencadenar funciones Lambda en respuesta a mensajes publicados en un tema SNS.

1. **Crear una Función Lambda que Procese Mensajes de SNS:**

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;
   import com.amazonaws.services.lambda.runtime.events.SNSEvent;

   public class SNSEventHandler implements RequestHandler<SNSEvent, Void> {

       @Override
       public Void handleRequest(SNSEvent event, Context context) {
           for (SNSEvent.SNSRecord record : event.getRecords()) {
               context.getLogger().log("Mensaje de SNS: " + record.getSNS().getMessage());
           }
           return null;
       }
   }
   ```

2. **Desplegar la Función Lambda:**

   ```sh
   mvn clean package

   aws lambda create-function --function-name SNSEventHandler \
       --runtime java11 --role arn:aws:iam::YOUR_ACCOUNT_ID:role/YOUR_LAMBDA_ROLE \
       --handler com.example.SNSEventHandler \
       --zip-file fileb://target/sns-lambda-1.0-SNAPSHOT.jar
   ```

3. **Configurar la Suscripción del Tema SNS a la Función Lambda:**

   ```sh
   aws sns subscribe --topic-arn arn:aws:sns:us-east-1:123456789012:MySNSTopic --protocol lambda --notification-endpoint arn:aws:lambda:us-east-1:123456789012:function:SNSEventHandler
   ```

#### Integración con Amazon SQS

**Objetivo:** Enviar mensajes de SNS a una cola SQS y procesarlos posteriormente.

1. **Crear una Cola SQS:**

   ```sh
   aws sqs create-queue --queue-name MyQueue
   ```

2. **Suscribir la Cola SQS al Tema SNS:**

   ```sh
   aws sns subscribe --topic-arn arn:aws:sns:us-east-1:123456789012:MySNSTopic --protocol sqs --notification-endpoint arn:aws:sqs:us-east-1:123456789012:MyQueue
   ```

3. **Verificar que los Mensajes se Entregan a la Cola SQS:**
   - Publica un mensaje en el tema SNS y verifica que el mensaje se entrega a la cola SQS.

### Resumen

Amazon SNS es una herramienta poderosa para la mensajería basada en eventos y la notificación en tiempo real. Permite la entrega de mensajes a múltiples suscriptores mediante diversos protocolos, facilitando la integración entre sistemas distribuidos y mejorando la capacidad de respuesta de las aplicaciones. A través de este laboratorio, aprendiste a crear y configurar temas y suscripciones de SNS, así como a integrar SNS con otros servicios de AWS como Lambda y SQS.