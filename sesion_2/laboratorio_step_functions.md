### 2.7. Laboratorio: Creación de Flujos de Trabajo con Step Functions

---

## Laboratorio: Creación de Flujos de Trabajo con Step Functions

### Descripción del Laboratorio

En este laboratorio, crearás un flujo de trabajo utilizando AWS Step Functions que coordine varias funciones Lambda. Aprenderás a definir un flujo de trabajo, a desplegarlo y a probarlo para asegurarte de que funciona correctamente.

### Recursos Necesarios

- AWS CLI
- SDK de AWS para Java
- Un IDE (Eclipse, IntelliJ, etc.)
- AWS Management Console

### Ejercicio Práctico

#### Paso 1: Crear Funciones Lambda

**Objetivo:** Implementar dos funciones Lambda que se utilizarán en el flujo de trabajo.

1. **Implementar la Primera Función Lambda (Lambda1):**

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;

   public class Lambda1Handler implements RequestHandler<Object, String> {

       @Override
       public String handleRequest(Object input, Context context) {
           context.getLogger().log("Lambda1 Invoked");
           return "Output from Lambda1";
       }
   }
   ```

2. **Implementar la Segunda Función Lambda (Lambda2):**

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;

   public class Lambda2Handler implements RequestHandler<Object, String> {

       @Override
       public String handleRequest(Object input, Context context) {
           context.getLogger().log("Lambda2 Invoked");
           return "Output from Lambda2";
       }
   }
   ```

3. **Configurar el Proyecto Maven (`pom.xml`):**

   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>

       <groupId>com.example</groupId>
       <artifactId>step-functions-lambda</artifactId>
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
                                       <mainClass>com.example.Lambda1Handler</mainClass>
                                   </transformers>
                               </configuration>
                       </execution>
                   </executions>
               </plugin>
           </plugins>
       </build>
   </project>
   ```

4. **Construir y Desplegar las Funciones Lambda:**

   ```sh
   mvn clean package

   aws lambda create-function --function-name Lambda1Function \
       --runtime java11 --role arn:aws:iam::YOUR_ACCOUNT_ID:role/YOUR_LAMBDA_ROLE \
       --handler com.example.Lambda1Handler \
       --zip-file fileb://target/step-functions-lambda-1.0-SNAPSHOT.jar

   aws lambda create-function --function-name Lambda2Function \
       --runtime java11 --role arn:aws:iam::YOUR_ACCOUNT_ID:role/YOUR_LAMBDA_ROLE \
       --handler com.example.Lambda2Handler \
       --zip-file fileb://target/step-functions-lambda-1.0-SNAPSHOT.jar
   ```

#### Paso 2: Crear el Flujo de Trabajo de Step Functions

**Objetivo:** Definir y desplegar un flujo de trabajo que coordine las funciones Lambda.

1. **Definir el Flujo de Trabajo (`state-machine-definition.json`):**

   ```json
   {
     "Comment": "A simple AWS Step Functions state machine that calls two Lambda functions",
     "StartAt": "Lambda1",
     "States": {
       "Lambda1": {
         "Type": "Task",
         "Resource": "arn:aws:lambda:REGION:ACCOUNT_ID:function:Lambda1Function",
         "Next": "Lambda2"
       },
       "Lambda2": {
         "Type": "Task",
         "Resource": "arn:aws:lambda:REGION:ACCOUNT_ID:function:Lambda2Function",
         "End": true
       }
     }
   }
   ```

2. **Crear la Máquina de Estado de Step Functions:**

   ```sh
   aws stepfunctions create-state-machine --name SimpleStateMachine \
       --definition file://state-machine-definition.json \
       --role-arn arn:aws:iam::YOUR_ACCOUNT_ID:role/YOUR_STEP_FUNCTIONS_ROLE
   ```

#### Paso 3: Ejecutar y Probar el Flujo de Trabajo

**Objetivo:** Iniciar una ejecución del flujo de trabajo y verificar que las funciones Lambda se ejecutan correctamente.

1. **Iniciar una Ejecución del Flujo de Trabajo:**

   ```sh
   aws stepfunctions start-execution --state-machine-arn arn:aws:states:REGION:ACCOUNT_ID:stateMachine:SimpleStateMachine
   ```

2. **Verificar la Ejecución:**
   - Accede a la consola de AWS Step Functions.
   - Selecciona la máquina de estado `SimpleStateMachine`.
   - Revisa las ejecuciones y verifica que ambas funciones Lambda se ejecutaron correctamente.

3. **Revisar los Logs en CloudWatch:**
   - Accede a CloudWatch Logs en la consola de AWS.
   - Revisa los logs generados por `Lambda1Function` y `Lambda2Function` para verificar que los mensajes de log se registraron correctamente.

### Resumen

En este laboratorio, hemos creado y configurado un flujo de trabajo utilizando AWS Step Functions. Implementamos dos funciones Lambda, las desplegamos y definimos una máquina de estado que coordina estas funciones. Finalmente, iniciamos una ejecución del flujo de trabajo y verificamos su correcta ejecución. Este ejercicio proporciona una comprensión práctica de cómo utilizar Step Functions para orquestar tareas y coordinar servicios de AWS en flujos de trabajo complejos.