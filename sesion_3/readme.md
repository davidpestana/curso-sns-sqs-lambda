### Sesión 3: Integración de Lambda con SQS y SNS

#### 3.1. [Integración de AWS Lambda con SQS](integracion_lambda_sqs.md)
- **Configuración de triggers de SQS en Lambda**

#### 3.2. [Laboratorio: Procesamiento de Mensajes de SQS con Lambda](laboratorio_procesamiento_sqs.md)
- **Descripción del laboratorio:**
  - Implementar una función Lambda que procese mensajes de una cola SQS y los registre en CloudWatch.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Configurar SQS como desencadenador de Lambda
  - Implementar la lógica de procesamiento de mensajes en la función Lambda
  - Registrar la salida en CloudWatch

#### 3.3. [Introducción a Amazon SNS](introduccion_sns.md)
- **Conceptos básicos de SNS**
- **Creación y configuración de tópicos**

#### 3.4. [Laboratorio: Configuración de SNS](laboratorio_sns.md)
- **Descripción del laboratorio:**
  - Crear un tópico SNS y suscribirse con una dirección de correo electrónico.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Crear un tópico SNS
  - Suscribir una dirección de correo electrónico al tópico
  - Enviar mensajes al tópico y verificar la recepción

#### 3.5. [Integración de SNS con SQS y Lambda](integracion_sns_sqs_lambda.md)
- **Enviar mensajes desde SNS a SQS**
- **Configurar Lambda para procesar mensajes de SQS**

#### 3.6. [Laboratorio: Integración de SNS, SQS y Lambda](laboratorio_integracion.md)
- **Descripción del laboratorio:**
  - Crear una solución que integre SNS, SQS y Lambda para procesar notificaciones.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Crear un tópico SNS y una cola SQS
  - Configurar el tópico SNS para enviar mensajes a la cola SQS
  - Configurar Lambda para procesar mensajes de la cola SQS

#### 3.7. [Automatización de Implementaciones con AWS SAM](introduccion_sam.md)
- **Conceptos básicos de SAM**
  - Definición y uso
  - Ventajas de usar SAM para definir aplicaciones serverless
- **Plantillas de SAM**
  - Estructura y componentes de una plantilla SAM
  - Ejemplos de plantillas

#### 3.8. [Laboratorio: Implementación de Aplicaciones Serverless con SAM](laboratorio_sam.md)
- **Descripción del laboratorio:**
  - Definir e implementar una aplicación serverless utilizando SAM.
- **Recursos necesarios:**
  - AWS CLI, AWS SAM CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Crear una plantilla SAM para una función Lambda
  - Desplegar la aplicación utilizando SAM
  - Probar la implementación y realizar ajustes