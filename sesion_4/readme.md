### Sesión 4: Arquitectura de Eventos y Profundizando en AWS Lambda, SNS y SQS

#### 4.1. [Arquitectura de Eventos](arquitectura_eventos.md)
- **Conceptos de arquitectura orientada a eventos**
- **Patrones de diseño para sistemas event-driven**
- **Casos de uso y ejemplos prácticos**

#### 4.2. [Laboratorio: Implementación de Arquitectura de Eventos](laboratorio_arquitectura.md)
- **Descripción del laboratorio:**
  - Diseñar e implementar una arquitectura orientada a eventos utilizando SNS, SQS y Lambda.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Diseñar un sistema basado en eventos
  - Implementar los componentes utilizando SNS, SQS y Lambda
  - Probar el flujo de eventos y la interacción entre componentes

#### 4.3. [Monitoreo y Logging en AWS Lambda](monitoreo_logging.md)
- **Uso de CloudWatch para monitoreo**
- **Configuración de alarmas y métricas**

#### 4.4. [Laboratorio: Monitoreo y Logging](laboratorio_monitoreo.md)
- **Descripción del laboratorio:**
  - Implementar y configurar CloudWatch Logs y métricas para una función Lambda.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Configurar CloudWatch Logs para una función Lambda
  - Crear métricas personalizadas
  - Configurar alarmas basadas en las métricas

#### 4.5. [Seguridad en AWS Lambda, SNS y SQS](seguridad.md)
- **Gestión de permisos con IAM**
- **Usuarios, Roles, Policies**
- **Buenas prácticas de seguridad**
- **Cifrado** [uso de aws KMS](cifrado.md) 

#### 4.6. [Laboratorio: Seguridad y Permisos](laboratorio_seguridad.md)
- **Descripción del laboratorio:**
  - Configurar roles y políticas de IAM para Lambda, SNS y SQS.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Crear roles y políticas de IAM para una función Lambda
  - Asignar permisos adecuados para SNS y SQS
  - Probar el acceso y las restricciones de seguridad

#### 4.7. [Optimización y Escalabilidad](optimizacion_escalabilidad.md)
- **Ajustes de rendimiento**
- **Escalado automático y configuraciones avanzadas**
- **Inicio cold / warm**

#### 4.8. [Laboratorio: Optimización y Escalabilidad](laboratorio_optimizacion.md)
- **Descripción del laboratorio:**
  - Implementar configuraciones de escalado automático y optimización de rendimiento para Lambda, SNS y SQS.
- **Recursos necesarios:**
  - AWS CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Configurar el escalado automático para una función Lambda
  - Ajustar parámetros de rendimiento
  - Probar la solución bajo diferentes cargas

#### 4.9. [Integración Avanzada con Step Functions y SAM](integracion_avanzada.md)
- **Coordinar flujos de trabajo complejos con Step Functions**
  - Ejemplos avanzados y casos de uso
- **Mejorar la automatización y despliegue continuo con SAM**
  - Estrategias para CI/CD en aplicaciones serverless

#### 4.10. [Laboratorio: Integración Completa con Step Functions y SAM](laboratorio_integracion_completa.md)
- **Descripción del laboratorio:**
  - Crear una solución que integre Step Functions y SAM para coordinar y desplegar funciones Lambda.
- **Recursos necesarios:**
  - AWS CLI, AWS SAM CLI, SDK de AWS para Java
- **Ejercicio práctico:**
  - Implementar una solución serverless utilizando Step Functions para coordinar varias funciones Lambda
  - Desplegar la solución utilizando SAM
  - Probar y ajustar la solución para optimizar el rendimiento y la escalabilidad
