### 4.9. Integración Avanzada con Step Functions y SAM

---

## Integración Avanzada con Step Functions y SAM

En esta sección, exploraremos cómo coordinar flujos de trabajo complejos con AWS Step Functions y cómo mejorar la automatización y despliegue continuo con AWS Serverless Application Model (SAM). Step Functions permite coordinar múltiples servicios de AWS en flujos de trabajo visuales, mientras que SAM facilita la gestión y despliegue de aplicaciones sin servidor.

### Coordinar Flujos de Trabajo Complejos con Step Functions

AWS Step Functions permite construir aplicaciones distribuidas utilizando flujos de trabajo visuales. Puedes definir una serie de pasos (estados) y las transiciones entre ellos para coordinar funciones Lambda, servicios de AWS y tareas manuales.

#### Componentes de Step Functions

1. **Estados:** Representan las tareas individuales en el flujo de trabajo. Pueden ser tareas, elecciones, esperas, paralelos, etc.
2. **Transiciones:** Definen cómo se pasa de un estado a otro.
3. **Máquinas de Estado:** La representación completa del flujo de trabajo, compuesta por estados y transiciones.

#### Ejemplo de Definición de Máquina de Estado

A continuación, se muestra un ejemplo de definición de una máquina de estado utilizando Amazon States Language (ASL):

```json
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
```

#### Creación de una Máquina de Estado con AWS CLI

1. **Crear una Máquina de Estado:**

   ```sh
   aws stepfunctions create-state-machine --name MiMaquinaDeEstado --definition file://maquina-estado.json --role-arn arn:aws:iam::123456789012:role/StepFunctionsExecutionRole
   ```

2. **Ejecutar una Máquina de Estado:**

   ```sh
   aws stepfunctions start-execution --state-machine-arn arn:aws:states:us-east-1:123456789012:stateMachine:MiMaquinaDeEstado --input '{"key":"value"}'
   ```

### Mejorar la Automatización y Despliegue Continuo con SAM

AWS SAM facilita la definición, desarrollo y despliegue de aplicaciones serverless. Permite utilizar CloudFormation para gestionar la infraestructura y proporciona herramientas para pruebas locales y despliegue continuo.

#### Plantillas de SAM

Una plantilla SAM es un archivo YAML que define los recursos de la aplicación serverless. Aquí se muestra un ejemplo de una plantilla SAM para una función Lambda integrada con Step Functions:

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Transform: 'AWS::Serverless-2016-10-31'
Resources:
  MiFuncionLambda:
    Type: 'AWS::Serverless::Function'
    Properties:
      Handler: com.example.MiFuncionLambda::handleRequest
      Runtime: java11
      CodeUri: ./target/mi-funcion-lambda-1.0-SNAPSHOT.jar
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

#### Despliegue de Aplicaciones con SAM CLI

1. **Construir el Proyecto SAM:**

   ```sh
   sam build
   ```

2. **Desplegar la Aplicación:**

   ```sh
   sam deploy --guided
   ```

   - Sigue las instrucciones y proporciona los detalles necesarios para el despliegue, como el nombre del stack, la región y los permisos.

### Laboratorio: Integración Completa con Step Functions y SAM

#### Descripción del Laboratorio

Implementaremos una solución que integre Step Functions y SAM para coordinar y desplegar funciones Lambda. Aprenderemos a definir un flujo de trabajo complejo con Step Functions y a utilizar SAM para automatizar el despliegue.

#### Recursos Necesarios

- AWS CLI
- AWS SAM CLI
- SDK de AWS para Java
- IDE (Eclipse, IntelliJ, etc.)

#### Ejercicio Práctico

1. **Configurar el Proyecto Maven (`pom.xml`):**

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

2. **Implementar la Clase MiFuncionLambda:**

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

4. **Crear una Plantilla SAM (`template.yaml`):**

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
                 "Resource": "arn:aws:lambda:us-east

-1:123456789012:function:MiFuncionLambda",
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

5. **Construir y Desplegar la Aplicación con SAM CLI:**

   ```sh
   sam build
   sam deploy --guided
   ```

   - Sigue las instrucciones y proporciona los detalles necesarios para el despliegue.

6. **Ejecutar la Máquina de Estado:**

   ```sh
   aws stepfunctions start-execution --state-machine-arn arn:aws:states:us-east-1:123456789012:stateMachine:MiMaquinaDeEstado --input '{"key":"value"}'
   ```

7. **Verificar la Ejecución:**
   - Accede a la consola de Step Functions y revisa la ejecución de la máquina de estado.
   - Verifica los logs en CloudWatch para asegurarte de que la función Lambda se ejecutó correctamente dentro del flujo de trabajo.

### Resumen

En esta sección, exploramos cómo coordinar flujos de trabajo complejos con AWS Step Functions y cómo mejorar la automatización y el despliegue continuo con AWS SAM. Implementamos una solución que integra Step Functions y SAM para coordinar y desplegar funciones Lambda, lo que facilita la gestión de aplicaciones serverless complejas y mejora la eficiencia del desarrollo y despliegue.