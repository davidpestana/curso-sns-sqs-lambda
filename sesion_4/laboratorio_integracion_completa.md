### 4.10. Laboratorio: Integración Completa con Step Functions y SAM

---

## Laboratorio: Integración Completa con Step Functions y SAM

### Descripción del Laboratorio

En este laboratorio, crearemos una solución que integre AWS Step Functions y AWS Serverless Application Model (SAM) para coordinar y desplegar funciones Lambda. Implementaremos una aplicación serverless que incluye un flujo de trabajo complejo con Step Functions y utilizaremos SAM para automatizar el despliegue de la infraestructura.

### Recursos Necesarios

- AWS CLI
- AWS SAM CLI
- SDK de AWS para Java
- IDE (Eclipse, IntelliJ, etc.)
- AWS Management Console

### Ejercicio Práctico

#### Paso 1: Configurar el Proyecto Maven

**Objetivo:** Configurar un proyecto Maven con las dependencias necesarias para AWS Lambda y Step Functions.

1. **Crear un Proyecto Maven (`pom.xml`):**

   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>

       <groupId>com.example</groupId>
       <artifactId>lambda-stepfunctions</artifactId>
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
                                       <mainClass>com.example.MiFuncionLambda</mainClass>
                                   </transformers>
                           </configuration>
                       </execution>
                   </executions>
               </plugin>
           </plugins>
       </build>
   </project>
   ```

2. **Implementar la Clase `MiFuncionLambda`:**

   ```java
   package com.example;

   import com.amazonaws.services.lambda.runtime.Context;
   import com.amazonaws.services.lambda.runtime.RequestHandler;

   public class MiFuncionLambda implements RequestHandler<Object, String> {

       @Override
       public String handleRequest(Object input, Context context) {
           context.getLogger().log("Ejecutando la función Lambda dentro de Step Functions...");
           // Lógica de la función
           return "Función ejecutada correctamente.";
       }
   }
   ```

3. **Construir el Proyecto:**

   ```sh
   mvn clean package
   ```

#### Paso 2: Crear una Plantilla SAM

**Objetivo:** Definir los recursos necesarios utilizando una plantilla SAM.

1. **Crear un Archivo de Plantilla SAM (`template.yaml`):**

   ```yaml
   AWSTemplateFormatVersion: '2010-09-09'
   Transform: 'AWS::Serverless-2016-10-31'
   Resources:
     MiFuncionLambda:
       Type: 'AWS::Serverless::Function'
       Properties:
         Handler: com.example.MiFuncionLambda
         Runtime: java11
         CodeUri: ./target/lambda-stepfunctions-1.0-SNAPSHOT.jar
         MemorySize: 512
         Timeout: 30
         Policies:
           - AWSLambdaBasicExecutionRole
     MiMaquinaDeEstado:
       Type: 'AWS::StepFunctions::StateMachine'
       Properties:
         DefinitionString: |
           {
             "Comment": "Ejemplo de máquina de estado con Step Functions",
             "StartAt": "Inicio",
             "States": {
               "Inicio": {
                 "Type": "Task",
                 "Resource": "arn:aws:lambda:us-east-1:123456789012:function:MiFuncionLambda",
                 "Next": "ProcesoIntermedio"
               },
               "ProcesoIntermedio": {
                 "Type": "Choice",
                 "Choices": [
                   {
                     "Variable": "$.statusCode",
                     "NumericEquals": 200,
                     "Next": "ProcesoExitoso"
                   }
                 ],
                 "Default": "ProcesoFallido"
               },
               "ProcesoExitoso": {
                 "Type": "Succeed"
               },
               "ProcesoFallido": {
                 "Type": "Fail"
               }
             }
           }
         Role: arn:aws:iam::123456789012:role/StepFunctionsExecutionRole
   ```

#### Paso 3: Construir y Desplegar la Aplicación con SAM CLI

**Objetivo:** Utilizar SAM CLI para construir y desplegar la aplicación.

1. **Construir el Proyecto SAM:**

   ```sh
   sam build
   ```

2. **Desplegar la Aplicación:**

   ```sh
   sam deploy --guided
   ```

   - Sigue las instrucciones y proporciona los detalles necesarios para el despliegue.

#### Paso 4: Ejecutar y Probar la Máquina de Estado

**Objetivo:** Ejecutar la máquina de estado y verificar que los pasos se ejecuten correctamente.

1. **Ejecutar la Máquina de Estado:**

   ```sh
   aws stepfunctions start-execution --state-machine-arn arn:aws:states:us-east-1:123456789012:stateMachine:MiMaquinaDeEstado --input '{"key":"value"}'
   ```

2. **Verificar la Ejecución:**
   - Accede a la consola de Step Functions y revisa la ejecución de la máquina de estado.
   - Verifica los logs en CloudWatch para asegurarte de que la función Lambda se ejecutó correctamente dentro del flujo de trabajo.

### Resumen

En este laboratorio, creamos una solución que integra AWS Step Functions y AWS SAM para coordinar y desplegar funciones Lambda. Definimos un flujo de trabajo complejo utilizando Step Functions y utilizamos SAM para automatizar el despliegue de la infraestructura. Esta integración facilita la gestión de aplicaciones serverless complejas y mejora la eficiencia del desarrollo y despliegue.