### Curso de AWS Lambda con Gestión de Colas (SNS + SQS) en Java

### Sesión 1: [Introducción a AWS y Fundamentos de Lambda](sesion_1)

#### 1.1. [Introducción a AWS](sesion_1/introduccion_aws.md)
- **¿Qué es AWS?**
  - Historia y evolución
  - Principales servicios y su propósito
- **Servicios principales de AWS**
  - EC2, S3, RDS, IAM, VPC

#### 1.2. [AWS Lambda](sesion_1/aws_lambda.md)
- **Conceptos básicos**
  - Definición y uso
  - Beneficios y limitaciones
- **Arquitectura de AWS Lambda**
  - Cómo funciona
  - Componentes clave
- **Uso de Lambda en diferentes escenarios**
  - Casos de uso comunes
  - Integraciones con otros servicios de AWS

#### 1.3. [Configuración de Entorno de Desarrollo](sesion_1/configuracion_entorno.md)
- **Instalación y configuración de AWS CLI**
  - Pasos para la instalación
  - Configuración básica y avanzada
- **Configuración de entorno para desarrollo en Java**
  - SDK de AWS para Java
  - Configuración del IDE (Eclipse, IntelliJ, etc.)

#### 1.4. [Laboratorio: Primeros Pasos con Lambda en Java](sesion_1/laboratorio_lambda.md)
- **Descripción del laboratorio:**
  - Crear una función Lambda simple en Java que recibe una cadena de texto, la convierte a mayúsculas y la devuelve.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java, IDE
- **Ejercicio práctico:**
  - Implementar la función Lambda en Java
  - Desplegar la función en AWS Lambda
  - Probar la función desde la consola de AWS

---

### Sesión 2: [Avanzando con AWS Lambda y Introducción a SQS](sesion_2)

#### 2.1. [Gestión de Dependencias y Uso de Librerías](sesion_2/gestion_dependencias.md)
- **Uso de Maven para gestionar dependencias**
  - Configuración de Maven en el proyecto
  - Manejo de dependencias comunes
- **Integración de bibliotecas externas en funciones Lambda**

#### 2.2. [AWS Lambda Avanzado](sesion_2/lambda_avanzado.md)
- **Variables de entorno y configuración**
- **Manejo de eventos y errores**
  - Tipos de errores
  - Estrategias de manejo de errores

#### 2.3. [Laboratorio: Lambda Avanzado](sesion_2/laboratorio_avanzado.md)
- **Descripción del laboratorio:**
  - Crear una función Lambda que maneje diferentes tipos de errores y registre los eventos en CloudWatch.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java, Maven
- **Ejercicio práctico:**
  - Implementar una función Lambda que maneje errores específicos
  - Configurar variables de entorno
  - Registrar eventos en CloudWatch

#### 2.4. [Introducción a Amazon SQS](sesion_2/introduccion_sqs.md)
- **Conceptos básicos de SQS**
- **Tipos de colas: Estándar y FIFO**

#### 2.5. [Laboratorio: Configuración de SQS](sesion_2/laboratorio_sqs.md)
- **Descripción del laboratorio:**
  - Crear y configurar una cola SQS estándar y enviar mensajes de prueba.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Crear una cola SQS
  - Enviar mensajes a la cola
  - Leer mensajes de la cola utilizando una aplicación Java

#### 2.6. [Introducción a AWS Step Functions](sesion_2/introduccion_step_functions.md)
- **Conceptos básicos de Step Functions**
  - Definición y uso
  - Casos de uso y beneficios
- **Componentes de Step Functions**
  - Estados y transiciones
  - Tipos de estados

#### 2.7. [Laboratorio: Creación de Flujos de Trabajo con Step Functions](sesion_2/laboratorio_step_functions.md)
- **Descripción del laboratorio:**
  - Crear un flujo de trabajo utilizando Step Functions que coordine varias funciones Lambda.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Diseñar e implementar un flujo de trabajo con Step Functions
  - Probar el flujo de trabajo y registrar los resultados

---

### Sesión 3: [Integración de Lambda con SQS y SNS](sesion_3)

#### 3.1. [Integración de AWS Lambda con SQS](sesion_3/integracion_lambda_sqs.md)
- **Configuración de triggers de SQS en Lambda**

#### 3.2. [Laboratorio: Procesamiento de Mensajes de SQS con Lambda](sesion_3/laboratorio_procesamiento_sqs.md)
- **Descripción del laboratorio:**
  - Implementar una función Lambda que procese mensajes de una cola SQS y los registre en CloudWatch.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Configurar SQS como desencadenador de Lambda
  - Implementar la lógica de procesamiento de mensajes en la función Lambda
  - Registrar la salida en CloudWatch

#### 3.3. [Introducción a Amazon SNS](sesion_3/introduccion_sns.md)
- **Conceptos básicos de SNS**
- **Creación y configuración de tópicos**

#### 3.4. [Laboratorio: Configuración de SNS](sesion_3/laboratorio_sns.md)
- **Descripción del laboratorio:**
  - Crear un tópico SNS y suscribirse con una dirección de correo electrónico.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Crear un tópico SNS
  - Suscribir una dirección de correo electrónico al tópico
  - Enviar mensajes al tópico y verificar la recepción

#### 3.5. [Integración de SNS con SQS y Lambda](sesion_3/integracion_sns_sqs_lambda.md)
- **Enviar mensajes desde SNS a SQS**
- **Configurar Lambda para procesar mensajes de SQS**

#### 3.6. [Laboratorio: Integración de SNS, SQS y Lambda](sesion_3/laboratorio_integracion.md)
- **Descripción del laboratorio:**
  - Crear una solución que integre SNS, SQS y Lambda para procesar notificaciones.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Crear un tópico SNS y una cola SQS
  - Configurar el tópico SNS para enviar mensajes a la cola SQS
  - Configurar Lambda para procesar mensajes de la cola SQS

#### 3.7. [Automatización de Implementaciones con AWS SAM](sesion_3/introduccion_sam.md)
- **Conceptos básicos de SAM**
  - Definición y uso
  - Ventajas de usar SAM para definir aplicaciones serverless
- **Plantillas de SAM**
  - Estructura y componentes de una plantilla SAM
  - Ejemplos de plantillas

#### 3.8. [Laboratorio: Implementación de Aplicaciones Serverless con SAM](sesion_3/laboratorio_sam.md)
- **Descripción del laboratorio:**
  - Definir e implementar una aplicación serverless utilizando SAM.
- **Recursos necesarios:**
  - AWS CLI, AWS SAM CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Crear una plantilla SAM para una función Lambda
  - Desplegar la aplicación utilizando SAM
  - Probar la implementación y realizar ajustes

---

### Sesión 4: [Arquitectura de Eventos y Profundizando en AWS Lambda, SNS y SQS](sesion_4)

#### 4.1. [Arquitectura de Eventos](sesion_4/arquitectura_eventos.md)
- **Conceptos de arquitectura orientada a eventos**
- **Patrones de diseño para sistemas event-driven**
- **Casos de uso y ejemplos prácticos**

#### 4.2. [Laboratorio: Implementación de Arquitectura de Eventos](sesion_4/laboratorio_arquitectura.md)
- **Descripción del laboratorio:**
  - Diseñar e implementar una arquitectura orientada a eventos utilizando SNS, SQS y Lambda.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Diseñar un sistema basado en eventos
  - Implementar los componentes utilizando SNS, SQS y Lambda
  - Probar el flujo de eventos y la interacción entre componentes

#### 4.3. [Monitoreo y Logging en AWS Lambda](sesion_4/monitoreo_logging.md)
- **Uso de CloudWatch para monitoreo**
- **Configuración de alarmas y métricas**

#### 4.4. [Laboratorio: Monitoreo y Logging](sesion_4/laboratorio_monitoreo.md)
- **Descripción del laboratorio:**
  - Implementar y configurar CloudWatch Logs y métricas para una función Lambda.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Configurar CloudWatch Logs para una función Lambda
  - Crear métricas personalizadas
  - Configurar alarmas basadas en las métricas

#### 4.5. [Seguridad en AWS Lambda, SNS y SQS](sesion_4/seguridad.md)
- **Gestión de permisos con IAM**
- **Buenas prácticas de seguridad**

#### 4.6. [Laboratorio: Seguridad y Permisos](sesion_4/laboratorio_seguridad.md)
- **Descripción del laboratorio:**
  - Configurar roles y políticas de IAM para Lambda, SNS y SQS.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Crear roles y políticas de IAM para una función Lambda
  - Asignar permisos adecuados para SNS y SQS
  - Probar el acceso y las restricciones de seguridad

#### 4.7. [Optimización y Escalabilidad](sesion_4/optimizacion_escalabilidad.md)
- **Ajustes de rendimiento**
- **Escalado automático y configuraciones avanzadas**

#### 4.8. [Laboratorio: Optimización y Escalabilidad](sesion_4/laboratorio_optimizacion.md)
- **Descripción del laboratorio:**
  - Implementar configuraciones de escalado automático y optimización de rendimiento para Lambda, SNS y SQS.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Configurar el escalado automático para una función Lambda
  - Ajustar parámetros de rendimiento
  - Probar la solución bajo diferentes cargas
 
#### 4.9. [Integración Avanzada con Step Functions y SAM](sesion_4/integracion_avanzada.md)
- **Coordinar flujos de trabajo complejos con Step Functions**
  - Ejemplos avanzados y casos de uso
- **Mejorar la automatización y despliegue continuo con SAM**
  - Estrategias para CI/CD en aplicaciones serverless

#### 4.10. [Laboratorio: Integración Completa con Step Functions y SAM](sesion_4/laboratorio_integracion_completa.md)
- **Descripción del laboratorio:**
  - Crear una solución que integre Step Functions y SAM para coordinar y desplegar funciones Lambda.
- **Recursos necesarios:**
  - AWS CLI, AWS SAM CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Implementar una solución serverless utilizando Step Functions para coordinar varias funciones Lambda
  - Desplegar la solución utilizando SAM
  - Probar y ajustar la solución para optimizar el rendimiento y la escalabilidad









