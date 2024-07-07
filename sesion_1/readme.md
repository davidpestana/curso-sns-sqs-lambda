### Sesión 1: Introducción a AWS y Fundamentos de Lambda

Aquí tienes una versión mejorada del índice para la Sesión 1:

### Sesión 1: Introducción a AWS y Fundamentos de Lambda

#### 1.1. [Introducción a AWS](introduccion_aws.md)
- **¿Qué es AWS?**
  - Historia y evolución
  - Principales servicios y su propósito
  - Características avanzadas más recientes
  - Tecnología Nitro
- **Servicios principales de AWS**
  - EC2, S3, RDS, IAM, VPC
  - **Detalles avanzados**
    - Familias de instancias EC2
    - Clases de almacenamiento en S3
    - Configuraciones Multi-AZ y Read Replicas en RDS
- **Configuraciones y Recomendaciones**
  - Disponibilidad y zonas de disponibilidad
  - Mecanismos de reservación y optimización de costos
  - Riesgos de sobrecoste indeseado

#### 1.2. [AWS Lambda](aws_lambda.md)
- **Conceptos básicos**
  - Definición y uso
  - Beneficios y limitaciones
- **Arquitectura de AWS Lambda**
  - Cómo funciona
  - Componentes clave
- **Uso de Lambda en diferentes escenarios**
  - Casos de uso comunes
  - Integraciones con otros servicios de AWS
  - Lambda en ubicaciones de AWS Edge

#### 1.3. [Configuración de Entorno de Desarrollo](configuracion_entorno.md)
- **Instalación y configuración de AWS CLI**
  - Pasos para la instalación
  - Configuración básica y avanzada
- **Configuración de entorno para desarrollo en Java**
  - SDK de AWS para Java
  - Configuración del IDE (Eclipse, IntelliJ, etc.)

#### 1.4. [Laboratorio: Primeros Pasos con Lambda en Java](laboratorio_lambda.md)
- **Descripción del laboratorio:**
  - Crear una función Lambda simple en Java que recibe una cadena de texto, la convierte a mayúsculas y la devuelve.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java, IDE
- **Ejercicio práctico:**
  - Implementar la función Lambda en Java
  - Desplegar la función en AWS Lambda
  - Probar la función desde la consola de AWS
 
#### 1.5. [Uso de Lambda Layers](aws_lambda_layer.md)
- **Qué son los Lambda Layers**
- **Beneficios de usar Layers**
- **Pasos para crear un Lambda Layer**
- **Adjuntar un Layer a una Función Lambda**
- **Ejemplo de código**

#### 1.6. [Laboratorio: Creación y Uso de Lambda Layers](laboratorio_lambda_layers.md)
- **Descripción del laboratorio**
- **Recursos necesarios**
- **Ejercicio práctico**
  - Paso 1: Crear y publicar un Layer con la biblioteca `requests`.
  - Paso 2: Crear una función Lambda que utilice el Layer.
  - Paso 3: Desplegar y probar la función Lambda.
