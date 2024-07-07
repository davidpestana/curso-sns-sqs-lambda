# Laboratorio: Control de Versiones y CI/CD para Arquitectura AWS Lambda

Este laboratorio te guiará a través de la configuración de un flujo de trabajo de control de versiones y CI/CD para una arquitectura basada en AWS Lambda, SNS, y SQS. Utilizaremos Git para el control de versiones, AWS CodePipeline para CI/CD, y CloudFormation para la infraestructura como código (IaC).

## Iteración 1: Configuración del Entorno de Desarrollo
### Objetivo
Configurar el entorno necesario para trabajar con AWS Lambda y Git.

### Pasos
1. **Instalar AWS CLI**:
   - Descargar e instalar AWS CLI desde [AWS CLI Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).
   - Configurar AWS CLI con `aws configure`.

2. **Instalar Git**:
   - Descargar e instalar Git desde [Git Downloads](https://git-scm.com/downloads).
   - Configurar Git con tu nombre y correo electrónico.
   ```sh
   git config --global user.name "Tu Nombre"
   git config --global user.email "tu.email@example.com"
   ```

3. **Instalar Node.js y npm** (si es necesario para tu función Lambda):
   - Descargar e instalar Node.js desde [Node.js](https://nodejs.org/).

4. **Configurar IDE**:
   - Instalar un IDE como [Visual Studio Code](https://code.visualstudio.com/).

## Iteración 2: Crear un Repositorio Git
### Objetivo
Crear un repositorio Git para gestionar el código fuente de la función Lambda.

### Pasos
1. **Inicializar un nuevo repositorio Git**:
   - Crear un directorio para el proyecto y navegar a él.
   ```sh
   mkdir aws-lambda-project
   cd aws-lambda-project
   git init
   ```

2. **Crear archivos base**:
   - Crear un archivo `index.js` para la función Lambda.
   - Crear un archivo `package.json` para gestionar las dependencias (si usas Node.js).
   - Crear un archivo `.gitignore` para excluir archivos no deseados del control de versiones.
   ```sh
   echo "node_modules/" >> .gitignore
   ```

3. **Hacer el primer commit**:
   ```sh
   git add .
   git commit -m "Initial commit"
   ```

4. **Crear un repositorio remoto en GitHub** y empujar el repositorio local.
   ```sh
   git remote add origin https://github.com/tu-usuario/aws-lambda-project.git
   git push -u origin master
   ```

## Iteración 3: Configurar AWS Lambda y Subir el Código
### Objetivo
Configurar una función Lambda en AWS y subir el código fuente.

### Pasos
1. **Escribir la función Lambda**:
   - En `index.js`, escribe una función Lambda básica:
   ```javascript
   exports.handler = async (event) => {
       return {
           statusCode: 200,
           body: JSON.stringify('Hello from Lambda!'),
       };
   };
   ```

2. **Empaquetar y subir la función Lambda**:
   - Crear un archivo ZIP con el código.
   ```sh
   zip -r function.zip .
   ```

   - Crear la función Lambda en AWS usando AWS CLI.
   ```sh
   aws lambda create-function --function-name my-function --zip-file fileb://function.zip --handler index.handler --runtime nodejs14.x --role arn:aws:iam::123456789012:role/execution_role
   ```

## Iteración 4: Configurar AWS CodePipeline
### Objetivo
Configurar AWS CodePipeline para la integración continua y despliegue continuo.

### Pasos
1. **Crear un archivo `buildspec.yml` para CodeBuild**:
   - Este archivo define los pasos de construcción.
   ```yaml
   version: 0.2

   phases:
     install:
       runtime-versions:
         nodejs: 14
       commands:
         - npm install
     build:
       commands:
         - zip -r function.zip .
         - aws s3 cp function.zip s3://my-bucket/function.zip
   ```

2. **Configurar CodePipeline en la consola de AWS**:
   - Crear una nueva pipeline y seleccionar el repositorio de GitHub como fuente.
   - Configurar CodeBuild como etapa de construcción y proporcionar el archivo `buildspec.yml`.
   - Añadir una etapa de despliegue usando AWS Lambda.

## Iteración 5: Configurar AWS CloudFormation
### Objetivo
Definir la infraestructura como código utilizando AWS CloudFormation.

### Pasos
1. **Crear una plantilla CloudFormation (`template.yaml`)**:
   ```yaml
   Resources:
     MyLambdaFunction:
       Type: AWS::Lambda::Function
       Properties:
         Handler: index.handler
         Role: arn:aws:iam::123456789012:role/execution_role
         Code:
           S3Bucket: my-bucket
           S3Key: function.zip
         Runtime: nodejs14.x

     MySNSTopic:
       Type: AWS::SNS::Topic
       Properties:
         TopicName: my-sns-topic

     MySQSQueue:
       Type: AWS::SQS::Queue
       Properties:
         QueueName: my-sqs-queue
   ```

2. **Añadir la plantilla al repositorio** y hacer commit.
   ```sh
   git add template.yaml
   git commit -m "Añadir plantilla CloudFormation"
   git push origin master
   ```

## Iteración 6: Integrar CloudFormation con CodePipeline
### Objetivo
Desplegar la infraestructura utilizando AWS CloudFormation desde CodePipeline.

### Pasos
1. **Añadir una etapa de despliegue en CodePipeline**:
   - En la consola de AWS, editar la pipeline para añadir una nueva etapa de despliegue usando CloudFormation.
   - Proporcionar la plantilla `template.yaml` y especificar los parámetros necesarios.

## Iteración 7: Configurar Monitoreo con CloudWatch
### Objetivo
Configurar CloudWatch Logs y métricas para la función Lambda.

### Pasos
1. **Configurar permisos para CloudWatch Logs**:
   - Asegurarse de que el rol de ejecución de Lambda tenga permisos para escribir en CloudWatch Logs.
   ```json
   {
       "Effect": "Allow",
       "Action": [
           "logs:CreateLogGroup",
           "logs:CreateLogStream",
           "logs:PutLogEvents"
       ],
       "Resource": "arn:aws:logs:*:*:*"
   }
   ```

2. **Verificar logs en CloudWatch**:
   - Usar la consola de CloudWatch para revisar los logs de la función Lambda.

## Iteración 8: Añadir Pruebas Automáticas
### Objetivo
Añadir pruebas automáticas a la pipeline para asegurar la calidad del código.

### Pasos
1. **Escribir pruebas para la función Lambda**:
   - Crear un archivo `test.js` con pruebas usando una librería como Mocha.
   ```javascript
   const assert = require('assert');
   const lambda = require('./index');

   describe('Lambda Function', () => {
       it('should return a successful response', async () => {
           const result = await lambda.handler();
           assert.strictEqual(result.statusCode, 200);
           assert.strictEqual(JSON.parse(result.body), 'Hello from Lambda!');
       });
   });
   ```

2. **Actualizar `buildspec.yml` para ejecutar pruebas**:
   ```yaml
   version: 0.2

   phases:
     install:
       runtime-versions:
         nodejs: 14
       commands:
         - npm install
         - npm install mocha
     build:
       commands:
         - npm test
         - zip -r function.zip .
         - aws s3 cp function.zip s3://my-bucket/function.zip
   ```

## Iteración 9: Canary Deployments con AWS Lambda
### Objetivo
Implementar despliegues canary para minimizar el riesgo de despliegue.

### Pasos
1. **Configurar CodeDeploy**:
   - Crear una aplicación y un grupo de despliegue en CodeDeploy para Lambda.
   - Configurar el grupo de despliegue para usar canary deployments.

2. **Actualizar CodePipeline para usar CodeDeploy**:
   - En la consola de AWS, editar la pipeline para añadir una acción de despliegue con CodeDeploy.

## Iteración 10: Monitoreo y Alerta con CloudWatch
### Objetivo
Configurar alertas de CloudWatch para monitorear el estado de la función Lambda y otros recursos.

### Pasos
1. **Crear alarmas de CloudWatch**:
   - Configurar alarmas para métricas como errores de Lambda, tiempo de ejecución, y otros indicadores clave.

2. **Configurar SNS para notificaciones**:
   - Crear un tópico SNS y suscribirse para recibir notificaciones de las alarmas de CloudWatch.
   ```yaml
   Resources:
     AlarmTopic:
       Type: AWS::SNS::Topic
       Properties:
         TopicName: alarm-topic

     LambdaErrorAlarm:
       Type: AWS::CloudWatch::Alarm
       Properties:
         AlarmDescription: "Alarma de errores en Lambda"
         Namespace: "AWS/Lambda"
         MetricName: "Errors"
         Dimensions:
           - Name: "FunctionName"
             Value: !Ref MyLambdaFunction
         Statistic: "Sum"
         Period: 300
         EvaluationPeriods: 1
         Threshold: 1
         ComparisonOperator: "GreaterThanOrEqualToThreshold