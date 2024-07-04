### 4.5. Seguridad en AWS Lambda, SNS y SQS

---
[Usuarios, Roles, Políticas](iam.md)

## Seguridad en AWS Lambda, SNS y SQS

La seguridad es un aspecto crítico al desarrollar y desplegar aplicaciones en AWS. AWS proporciona una variedad de herramientas y servicios para asegurar que tus recursos estén protegidos. En esta sección, exploraremos la gestión de permisos con IAM, las mejores prácticas de seguridad, y cómo configurar roles y políticas para AWS Lambda, SNS y SQS.

### Gestión de Permisos con IAM

AWS Identity and Access Management (IAM) es un servicio que permite gestionar de manera segura el acceso a los servicios y recursos de AWS. Utilizando IAM, puedes crear y gestionar usuarios y grupos, y usar permisos para permitir o denegar su acceso a recursos de AWS.

#### Componentes Clave de IAM:

1. **Usuarios:** Representan una identidad de persona o aplicación que necesita interactuar con AWS.
2. **Grupos:** Conjuntos de usuarios a los que se les pueden asignar permisos de manera colectiva.
3. **Roles:** Conjuntos de permisos que pueden ser asumidos por cualquier entidad autorizada, como usuarios, servicios o aplicaciones.
4. **Políticas:** Documentos JSON que especifican los permisos que se otorgan a los usuarios, grupos y roles.

### Buenas Prácticas de Seguridad

#### 1. Principio de Mínimos Privilegios

Asigna solo los permisos necesarios para realizar una tarea específica. Evita otorgar permisos más amplios de lo necesario.

#### 2. Uso de Roles de IAM para Servicios

En lugar de almacenar credenciales en tu código, usa roles de IAM que pueden ser asumidos por servicios como Lambda, EC2 o ECS.

#### 3. Rotación de Credenciales

Implementa políticas para la rotación regular de claves de acceso y otros secretos.

#### 4. Monitoreo y Auditoría

Utiliza AWS CloudTrail para registrar todas las llamadas a la API de IAM y otros servicios, y monitorea estos logs para detectar actividades sospechosas.

### Configuración de Roles y Políticas

#### Paso 1: Crear Roles de IAM para Lambda

**Objetivo:** Crear un rol de IAM que otorga permisos a una función Lambda para acceder a otros servicios de AWS.

1. **Crear un Rol de IAM:**

   ```sh
   aws iam create-role --role-name LambdaBasicExecutionRole --assume-role-policy-document file://trust-policy.json
   ```

   Contenido de `trust-policy.json`:

   ```json
   {
       "Version": "2012-10-17",
       "Statement": [
           {
               "Effect": "Allow",
               "Principal": {
                   "Service": "lambda.amazonaws.com"
               },
               "Action": "sts:AssumeRole"
           }
       ]
   }
   ```

2. **Adjuntar la Política de Ejecución Básica para Lambda:**

   ```sh
   aws iam attach-role-policy --role-name LambdaBasicExecutionRole --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
   ```

#### Paso 2: Crear Roles de IAM para SNS y SQS

**Objetivo:** Crear roles de IAM para SNS y SQS que permiten a estos servicios interactuar con Lambda.

1. **Crear un Rol de IAM para SNS:**

   ```sh
   aws iam create-role --role-name SNSExecutionRole --assume-role-policy-document file://trust-policy-sns.json
   ```

   Contenido de `trust-policy-sns.json`:

   ```json
   {
       "Version": "2012-10-17",
       "Statement": [
           {
               "Effect": "Allow",
               "Principal": {
                   "Service": "sns.amazonaws.com"
               },
               "Action": "sts:AssumeRole"
           }
       ]
   }
   ```

2. **Adjuntar una Política para SNS:**

   ```sh
   aws iam attach-role-policy --role-name SNSExecutionRole --policy-arn arn:aws:iam::aws:policy/AmazonSNSFullAccess
   ```

3. **Crear un Rol de IAM para SQS:**

   ```sh
   aws iam create-role --role-name SQSExecutionRole --assume-role-policy-document file://trust-policy-sqs.json
   ```

   Contenido de `trust-policy-sqs.json`:

   ```json
   {
       "Version": "2012-10-17",
       "Statement": [
           {
               "Effect": "Allow",
               "Principal": {
                   "Service": "sqs.amazonaws.com"
               },
               "Action": "sts:AssumeRole"
           }
       ]
   }
   ```

4. **Adjuntar una Política para SQS:**

   ```sh
   aws iam attach-role-policy --role-name SQSExecutionRole --policy-arn arn:aws:iam::aws:policy/AmazonSQSFullAccess
   ```

### Implementar Seguridad en Funciones Lambda

**Ejemplo de Configuración de Seguridad en una Función Lambda en Java:**

1. **Configurar el Proyecto Maven (`pom.xml`):**

   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>

       <groupId>com.example</groupId>
       <artifactId>secure-lambda</artifactId>
       <version>1.0-SNAPSHOT</version>

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
               <artifactId>aws-java-sdk-sns</artifactId>
               <version>1.12.118</version>
           </dependency>
           <dependency>
               <groupId>com.amazonaws</groupId>
               <artifactId>aws-java-sdk-sqs</artifactId>
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
               <plugin>
                   <groupId>org.apache.maven.plugins</groupId>
                   <artifactId>maven-shade-plugin</artifactId>
                   <version>3.2.1</version>
                   <executions>
                       <execution>
                           <phase>package</phase>
                           <goals>
                               <goal>shade</goal>
                           </goals>
                           <configuration>
                               <createDependencyReducedPom>false</createDependencyReducedPom>
                               <transformers>
                                   <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                       <mainClass>com.example.SecureLambdaHandler</mainClass>
                                   </transformers>
                               </configuration>
                       </execution>
                   </executions>
               </plugin>
           </plugins>
       </build>
   </project>
   ```

2. **Implementar la Clase SecureLambdaHandler:**

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;
   import com.amazonaws.services.lambda.runtime.events.SQSEvent;

   public class SecureLambdaHandler implements RequestHandler<SQSEvent, String> {

       @Override
       public String handleRequest(SQSEvent event, Context context) {
           context.getLogger().log("Procesando evento SQS...");
           for (SQSEvent.SQSMessage msg : event.getRecords()) {
               context.getLogger().log("Mensaje recibido: " + msg.getBody());
               // Procesar el mensaje
           }
           return "Procesado correctamente.";
       }
   }
   ```

3. **Construir y Desplegar la Función Lambda:**

   ```sh
   mvn clean package

   aws lambda create-function --function-name SecureLambdaHandler \
       --runtime java11 --role arn:aws:iam::YOUR_ACCOUNT_ID:role/LambdaBasicExecutionRole \
       --handler com.example.SecureLambdaHandler \
       --zip-file fileb://target/secure-lambda-1.0-SNAPSHOT.jar
   ```

### Resumen

En esta sección, aprendimos sobre la gestión de permisos con IAM, las mejores prácticas de seguridad y cómo configurar roles y políticas para AWS Lambda, SNS y SQS. Implementamos un ejemplo práctico de una función Lambda con seguridad configurada, utilizando roles y políticas de IAM para controlar el acceso a los recursos. Estas prácticas son esenciales para asegurar tus aplicaciones y datos en AWS.