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

### Sesión 2: Avanzando con AWS Lambda y Introducción a SQS

#### 2.1. Gestión de Dependencias y Uso de Librerías
- **Uso de Maven para gestionar dependencias**
  - Configuración de Maven en el proyecto
  - Manejo de dependencias comunes
- **Integración de bibliotecas externas en funciones Lambda**

#### 2.2. AWS Lambda Avanzado
- **Variables de entorno y configuración**
- **Manejo de eventos y errores**
  - Tipos de errores
  - Estrategias de manejo de errores

#### 2.3. Laboratorio: Lambda Avanzado
- **Descripción del laboratorio:**
  - Crear una función Lambda que maneje diferentes tipos de errores y registre los eventos en CloudWatch.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java, Maven
- **Ejercicio práctico:**
  - Implementar una función Lambda que maneje errores específicos
  - Configurar variables de entorno
  - Registrar eventos en CloudWatch

#### 2.4. Introducción a Amazon SQS
- **Conceptos básicos de SQS**
- **Tipos de colas: Estándar y FIFO**

#### 2.5. Laboratorio: Configuración de SQS
- **Descripción del laboratorio:**
  - Crear y configurar una cola SQS estándar y enviar mensajes de prueba.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Crear una cola SQS
  - Enviar mensajes a la cola
  - Leer mensajes de la cola utilizando una aplicación Java

---

### Sesión 3: Integración de Lambda con SQS y SNS

#### 3.1. Integración de AWS Lambda con SQS
- **Configuración de triggers de SQS en Lambda**

#### 3.2. Laboratorio: Procesamiento de Mensajes de SQS con Lambda
- **Descripción del laboratorio:**
  - Implementar una función Lambda que procese mensajes de una cola SQS y los registre en CloudWatch.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Configurar SQS como desencadenador de Lambda
  - Implementar la lógica de procesamiento de mensajes en la función Lambda
  - Registrar la salida en CloudWatch

#### 3.3. Introducción a Amazon SNS
- **Conceptos básicos de SNS**
- **Creación y configuración de tópicos**

#### 3.4. Laboratorio: Configuración de SNS
- **Descripción del laboratorio:**
  - Crear un tópico SNS y suscribirse con una dirección de correo electrónico.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Crear un tópico SNS
  - Suscribir una dirección de correo electrónico al tópico
  - Enviar mensajes al tópico y verificar la recepción

#### 3.5. Integración de SNS con SQS y Lambda
- **Enviar mensajes desde SNS a SQS**
- **Configurar Lambda para procesar mensajes de SQS**

#### 3.6. Laboratorio: Integración de SNS, SQS y Lambda
- **Descripción del laboratorio:**
  - Crear una solución que integre SNS, SQS y Lambda para procesar notificaciones.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Crear un tópico SNS y una cola SQS
  - Configurar el tópico SNS para enviar mensajes a la cola SQS
  - Configurar Lambda para procesar mensajes de la cola SQS

---

### Sesión 4: Arquitectura de Eventos y Profundizando en AWS Lambda, SNS y SQS

#### 4.1. Arquitectura de Eventos
- **Conceptos de arquitectura orientada a eventos**
- **Patrones de diseño para sistemas event-driven**
- **Casos de uso y ejemplos prácticos**

#### 4.2. Laboratorio: Implementación de Arquitectura de Eventos
- **Descripción del laboratorio:**
  - Diseñar e implementar una arquitectura orientada a eventos utilizando SNS, SQS y Lambda.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Diseñar un sistema basado en eventos
  - Implementar los componentes utilizando SNS, SQS y Lambda
  - Probar el flujo de eventos y la interacción entre componentes

#### 4.3. Monitoreo y Logging en AWS Lambda
- **Uso de CloudWatch para monitoreo**
- **Configuración de alarmas y métricas**

#### 4.4. Laboratorio: Monitoreo y Logging
- **Descripción del laboratorio:**
  - Implementar y configurar CloudWatch Logs y métricas para una función Lambda.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Configurar CloudWatch Logs para una función Lambda
  - Crear métricas personalizadas
  - Configurar alarmas basadas en las métricas

#### 4.5. Seguridad en AWS Lambda, SNS y SQS
- **Gestión de permisos con IAM**
- **Buenas prácticas de seguridad**

#### 4.6. Laboratorio: Seguridad y Permisos
- **Descripción del laboratorio:**
  - Configurar roles y políticas de IAM para Lambda, SNS y SQS.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Crear roles y políticas de IAM para una función Lambda
  - Asignar permisos adecuados para SNS y SQS
  - Probar el acceso y las restricciones de seguridad

#### 4.7. Optimización y Escalabilidad
- **Ajustes de rendimiento**
- **Escalado automático y configuraciones avanzadas**

#### 4.8. Laboratorio: Optimización y Escalabilidad
- **Descripción del laboratorio:**
  - Implementar configuraciones de escalado automático y optimización de rendimiento para Lambda, SNS y SQS.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Configurar el escalado automático para una función Lambda
  - Ajustar parámetros de rendimiento
  - Probar la solución bajo diferentes cargas
