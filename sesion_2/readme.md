### Sesión 2: Avanzando con AWS Lambda y Introducción a SQS

#### 2.1. [Gestión de Dependencias y Uso de Librerías](gestion_dependencias.md)
- **Uso de Maven para gestionar dependencias**
  - Configuración de Maven en el proyecto
  - Manejo de dependencias comunes
- **Integración de bibliotecas externas en funciones Lambda**

#### 2.2. [AWS Lambda Avanzado](lambda_avanzado.md)
- **Variables de entorno y configuración**
- **Manejo de eventos y errores**
  - Tipos de errores
  - Estrategias de manejo de errores

#### 2.3. [Laboratorio: Lambda Avanzado](laboratorio_avanzado.md)
- **Descripción del laboratorio:**
  - Crear una función Lambda que maneje diferentes tipos de errores y registre los eventos en CloudWatch.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java, Maven
- **Ejercicio práctico:**
  - Implementar una función Lambda que maneje errores específicos
  - Configurar variables de entorno
  - Registrar eventos en CloudWatch

#### 2.4. [Introducción a Amazon SQS](introduccion_sqs.md)
- **Conceptos básicos de SQS**
- **Tipos de colas: Estándar y FIFO**

#### 2.5. [Laboratorio: Configuración de SQS](laboratorio_sqs.md)
- **Descripción del laboratorio:**
  - Crear y configurar una cola SQS estándar y enviar mensajes de prueba.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Crear una cola SQS
  - Enviar mensajes a la cola
  - Leer mensajes de la cola utilizando una aplicación Java

#### 2.6. [Introducción a AWS Step Functions](introduccion_step_functions.md)
- **Conceptos básicos de Step Functions**
  - Definición y uso
  - Casos de uso y beneficios
- **Componentes de Step Functions**
  - Estados y transiciones
  - Tipos de estados
  - Flujos de trabajo

#### 2.7. [Laboratorio: Creación de Flujos de Trabajo con Step Functions](laboratorio_step_functions.md)
- **Descripción del laboratorio:**
  - Crear un flujo de trabajo utilizando Step Functions que coordine varias funciones Lambda.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Diseñar e implementar un flujo de trabajo con Step Functions
  - Probar el flujo de trabajo y registrar los resultados
