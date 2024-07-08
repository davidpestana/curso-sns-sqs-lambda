### Laboratorio de Implementación de GitOps con AWS Lambda, SNS, SQS, Step Functions, y Kinesis

Este laboratorio te guiará a través de la configuración de un entorno GitOps para gestionar y desplegar una aplicación serverless en AWS que utiliza Lambda, SNS, SQS, Step Functions y Kinesis. Utilizaremos AWS SAM (Serverless Application Model) para definir nuestra infraestructura como código y AWS CodePipeline para automatizar el despliegue.

### Objetivo del Laboratorio

- **Automatizar el despliegue**: Configurar un pipeline CI/CD para automatizar el despliegue de una aplicación serverless.
- **Infraestructura como Código**: Utilizar AWS SAM para definir la infraestructura y el código de la aplicación.
- **Git como Fuente de Verdad**: Utilizar Git para gestionar el código y las configuraciones de la infraestructura.

### Prerrequisitos

- **AWS CLI**: Instalada y configurada.
- **SAM CLI**: Instalada.
- **Git**: Instalada y configurada.
- **Cuenta de AWS**: Con permisos suficientes para crear y gestionar recursos.

### Paso 1: Crear el Repositorio Git

1. **Crear un Repositorio Git en GitHub**
   - Nombre: `gitops-lambda-lab`
   - Descripción: "Repositorio para implementar GitOps con AWS Lambda y otros servicios".

### Paso 2: Configurar el Repositorio Local

1. **Clonar el Repositorio**
   ```sh
   git clone https://github.com/tu-usuario/gitops-lambda-lab.git
   cd gitops-lambda-lab
   ```

2. **Estructurar el Repositorio**
   ```sh
   mkdir -p src/hello-world
   touch template.yaml
   touch buildspec.yml
   ```

### Paso 3: Definir la Infraestructura con AWS SAM

1. **Archivo `template.yaml`**

   El propósito de este archivo es definir la infraestructura de la aplicación utilizando AWS SAM.

   ```yaml
   AWSTemplateFormatVersion: '2010-09-09'
   Transform: 'AWS::Serverless-2016-10-31'
   Resources:
     HelloWorldFunction:
       Type: 'AWS::Serverless::Function'
       Properties:
         Handler: app.lambdaHandler
         Runtime: nodejs14.x
         CodeUri: src/hello-world/
         Events:
           ApiEvent:
             Type: Api
             Properties:
               Path: /hello
               Method: get

     MyQueue:
       Type: 'AWS::SQS::Queue'

     MySNSTopic:
       Type: 'AWS::SNS::Topic'

     MyKinesisStream:
       Type: 'AWS::Kinesis::Stream'
       Properties:
         ShardCount: 1

     MyStateMachine:
       Type: 'AWS::StepFunctions::StateMachine'
       Properties:
         DefinitionString: !Sub |
           {
             "StartAt": "HelloWorldFunction",
             "States": {
               "HelloWorldFunction": {
                 "Type": "Task",
                 "Resource": "${HelloWorldFunction.Arn}",
                 "End": true
               }
             }
           }
         RoleArn: !GetAtt StepFunctionExecutionRole.Arn

     StepFunctionExecutionRole:
       Type: 'AWS::IAM::Role'
       Properties:
         AssumeRolePolicyDocument:
           Version: '2012-10-17'
           Statement:
             - Effect: 'Allow'
               Principal:
                 Service: 'states.amazonaws.com'
               Action: 'sts:AssumeRole'
         Policies:
           - PolicyName: 'StepFunctionExecutionPolicy'
             PolicyDocument:
               Version: '2012-10-17'
               Statement:
                 - Effect: 'Allow'
                   Action:
                     - 'lambda:InvokeFunction'
                   Resource: '*'
   ```

2. **Código de la Función Lambda**

   **Archivo `src/hello-world/app.js`**:

   ```javascript
   exports.lambdaHandler = async (event) => {
       return {
           statusCode: 200,
           body: JSON.stringify('Hello from Lambda!'),
       };
   };
   ```

### Paso 4: Configurar la Construcción con AWS CodeBuild

1. **Archivo `buildspec.yml`**

   Este archivo define las fases de construcción y empaquetado de la aplicación.

   ```yaml
   version: 0.2
   phases:
     install:
       runtime-versions:
         nodejs: 14
         python: 3.8
       commands:
         - npm install -g aws-sam-cli
     build:
       commands:
         - sam build
     post_build:
       commands:
         - sam package --s3-bucket YOUR_S3_BUCKET --output-template-file packaged.yaml
   artifacts:
     files:
       - packaged.yaml
   ```

### Paso 5: Configurar AWS CodePipeline

1. **Crear un Bucket S3**

   Este bucket se utiliza para almacenar los artefactos de construcción.

   ```sh
   aws s3 mb s3://gitops-lambda-lab-bucket-1234567890
   ```

2. **Crear Roles de IAM**

   - **Role para CodePipeline**:
     - Política: `AWSCodePipelineFullAccess`.

   - **Role para CodeBuild**:
     - Política: `AWSCodeBuildDeveloperAccess`.

3. **Configurar CodePipeline**

   - **Source Stage**:
     - Configura GitHub como fuente.
     - Selecciona el repositorio `gitops-lambda-lab`.

   - **Build Stage**:
     - Configura AWS CodeBuild.
     - Usa el archivo `buildspec.yml`.

   - **Deploy Stage**:
     - Usa AWS CloudFormation para desplegar la plantilla `packaged.yaml`.

### Paso 6: Configurar AWS CodeBuild

1. **Crear un Proyecto de CodeBuild**

   - Nombre: `gitops-lambda-lab-build`.
   - Entorno: Ubuntu, Node.js 14 y Python 3.8.
   - Buildspec: Utiliza el archivo `buildspec.yml`.

### Paso 7: Desplegar la Aplicación

1. **Iniciar CodePipeline**

   - Ve a la consola de AWS CodePipeline.
   - Selecciona la pipeline `gitops-lambda-lab-pipeline` y haz clic en "Release change".

2. **Verificar el Despliegue**

   - Ve a la consola de AWS CloudFormation y verifica que el stack `gitops-lambda-lab-stack` se haya creado.
   - Ve a la consola de AWS Lambda y verifica que la función `HelloWorldFunction` se haya desplegado.
   - Prueba la función Lambda invocándola a través del endpoint de API Gateway.

### Conclusión

Este laboratorio ha cubierto la configuración de GitOps para una aplicación serverless utilizando AWS Lambda, SNS, SQS, Step Functions y Kinesis. Siguiendo estos pasos, puedes automatizar el despliegue de tus aplicaciones y mantener una infraestructura consistente y versionada mediante Git.