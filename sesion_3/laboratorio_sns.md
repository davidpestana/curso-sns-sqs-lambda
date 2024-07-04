### 3.4. Laboratorio: Configuración de SNS

---

## Laboratorio: Configuración de SNS

### Descripción del Laboratorio

En este laboratorio, aprenderás a crear un tópico SNS y suscribirte a él utilizando una dirección de correo electrónico. Luego, enviarás mensajes al tópico y verificarás la recepción de estos mensajes.

### Recursos Necesarios

- AWS CLI
- SDK de AWS para Java (opcional)
- AWS Management Console
- Una dirección de correo electrónico para la suscripción

### Ejercicio Práctico

#### Paso 1: Crear un Tópico SNS

**Objetivo:** Crear un tópico SNS utilizando AWS CLI y verificar su creación.

1. **Crear un Tópico SNS con AWS CLI:**

   ```sh
   aws sns create-topic --name MySNSTopic
   ```

2. **Verificar la Creación del Tópico:**

   ```sh
   aws sns list-topics
   ```

   - Deberías ver el ARN de `MySNSTopic` en la lista de tópicos.

#### Paso 2: Suscribirse al Tópico SNS con un Correo Electrónico

**Objetivo:** Suscribirse al tópico SNS utilizando una dirección de correo electrónico.

1. **Suscribirse al Tópico con una Dirección de Correo Electrónico:**

   ```sh
   aws sns subscribe --topic-arn arn:aws:sns:us-east-1:123456789012:MySNSTopic --protocol email --notification-endpoint tu-email@example.com
   ```

2. **Confirmar la Suscripción:**
   - Revisa tu bandeja de entrada del correo electrónico que proporcionaste.
   - Deberías recibir un correo de AWS SNS pidiéndote que confirmes la suscripción. Haz clic en el enlace de confirmación.

#### Paso 3: Enviar Mensajes al Tópico SNS

**Objetivo:** Publicar mensajes en el tópico SNS y verificar la entrega a la dirección de correo electrónico suscrita.

1. **Publicar un Mensaje en el Tópico SNS:**

   ```sh
   aws sns publish --topic-arn arn:aws:sns:us-east-1:123456789012:MySNSTopic --message "Hola, este es un mensaje de prueba de SNS!"
   ```

2. **Verificar la Recepción del Mensaje:**
   - Revisa tu bandeja de entrada del correo electrónico.
   - Deberías recibir un correo con el mensaje "Hola, este es un mensaje de prueba de SNS!".

#### Paso 4: Verificar la Configuración en la Consola de AWS

**Objetivo:** Revisar y verificar la configuración del tópico y las suscripciones en la consola de AWS.

1. **Acceder a la Consola de SNS:**
   - Abre la consola de AWS y navega hasta el servicio SNS.
   - Selecciona `Topics` en el menú lateral y busca `MySNSTopic`.

2. **Revisar las Suscripciones:**
   - Haz clic en el tópico `MySNSTopic`.
   - En la pestaña `Subscriptions`, deberías ver la suscripción de tu correo electrónico.

#### Paso 5: (Opcional) Integración con AWS SDK para Java

**Objetivo:** Crear un programa Java que publique mensajes en el tópico SNS.

1. **Configurar el Proyecto Maven (`pom.xml`):**

   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>

       <groupId>com.example</groupId>
       <artifactId>sns-publisher</artifactId>
       <version>1.0-SNAPSHOT</version>

       <dependencies>
           <dependency>
               <groupId>com.amazonaws</groupId>
               <artifactId>aws-java-sdk-sns</artifactId>
               <version>1.12.118</version>
           </dependency>
       </dependencies>

       <build>
           <plugins>
               <plugin>
                   <groupId>org.apache.maven.plugins</groupId>
                   <artifactId>maven-compiler-plugin</artifactId>
                   <version>3.8.0</version>
                   <configuration>
                       <source>1.8</source>
                       <target>1.8</target>
                   </configuration>
               </plugin>
           </plugins>
       </build>
   </project>
   ```

2. **Crear la Clase Java para Publicar Mensajes:**

   ```java
   package com.example;

   import com.amazonaws.services.sns.AmazonSNS;
   import com.amazonaws.services.sns.AmazonSNSClientBuilder;
   import com.amazonaws.services.sns.model.PublishRequest;
   import com.amazonaws.services.sns.model.PublishResult;

   public class SNSPublisher {

       public static void main(String[] args) {
           AmazonSNS snsClient = AmazonSNSClientBuilder.defaultClient();
           String topicArn = "arn:aws:sns:us-east-1:123456789012:MySNSTopic";

           // Publicar un mensaje
           PublishRequest publishRequest = new PublishRequest(topicArn, "Hola, este es un mensaje de prueba de SNS desde Java!");
           PublishResult publishResult = snsClient.publish(publishRequest);

           System.out.println("Mensaje publicado con ID: " + publishResult.getMessageId());
       }
   }
   ```

3. **Ejecutar el Programa para Publicar Mensajes:**
   - Ejecuta la clase `SNSPublisher` desde tu IDE para publicar un mensaje en el tópico SNS.
   - Verifica que el mensaje se recibe en la dirección de correo electrónico suscrita.

### Resumen

En este laboratorio, aprendiste a crear y configurar un tópico SNS, a suscribirte a él utilizando una dirección de correo electrónico, y a enviar mensajes al tópico para verificar la entrega. Además, exploraste cómo integrar SNS con una aplicación Java utilizando el AWS SDK para Java. Esta configuración es fundamental para implementar sistemas de mensajería y notificación en tiempo real, facilitando la comunicación entre sistemas distribuidos y mejorando la capacidad de respuesta de las aplicaciones.