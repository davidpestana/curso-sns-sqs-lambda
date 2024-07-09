### Amazon SNS (Simple Notification Service)
**Afirmaciones:**
1. **SNS permite a los sistemas enviar notificaciones en tiempo real a múltiples suscriptores.**
2. **SNS puede distribuir mensajes a una variedad de endpoints como HTTP/S, Lambda, SQS y direcciones de correo electrónico.**
3. **SNS es ideal para la comunicación de uno a muchos, como enviar notificaciones de aplicaciones a usuarios finales.**
4. **SNS permite la entrega de mensajes fan-out a múltiples colas SQS suscritas.**
5. **SNS garantiza la entrega de mensajes en el orden en que fueron publicados si se utiliza FIFO (First-In-First-Out).**

**Negaciones:**
1. **SNS no almacena mensajes para su procesamiento posterior; los mensajes se entregan tan pronto como son enviados.**
2. **SNS no proporciona garantía de entrega si el endpoint no está disponible en el momento de la publicación del mensaje.**
3. **SNS no puede ser utilizado directamente para recibir mensajes de otras aplicaciones; se utiliza solo para enviar notificaciones.**
4. **SNS no ofrece características de procesamiento de mensajes como reintentos automáticos de entrega a intervalos definidos.**
5. **SNS no soporta la especificación de una secuencia estricta de procesamiento entre diferentes suscriptores.**

### Amazon SQS (Simple Queue Service)
**Afirmaciones:**
1. **SQS es un servicio de mensajería que permite la descomposición de aplicaciones distribuidas en componentes independientes.**
2. **SQS almacena mensajes en colas hasta que son procesados y eliminados por los consumidores.**
3. **SQS soporta dos tipos de colas: Estándar (Standard) y FIFO (First-In-First-Out).**
4. **SQS permite la configuración de políticas de retención de mensajes, que pueden durar hasta 14 días.**
5. **SQS se puede usar para desacoplar la comunicación entre los diferentes componentes de una aplicación.**

**Negaciones:**
1. **SQS no garantiza la entrega en tiempo real de los mensajes; los mensajes pueden ser procesados con retraso.**
2. **SQS no permite la suscripción directa a servicios HTTP/S, Lambda o correos electrónicos; solo a otros servicios AWS como SNS.**
3. **SQS no garantiza la entrega única de mensajes en colas Estándar (puede haber duplicados).**
4. **SQS no permite la transmisión de mensajes a múltiples destinos desde una sola cola (a diferencia de SNS).**
5. **SQS no proporciona la capacidad de filtrar mensajes basados en sus atributos; cada mensaje en la cola es tratado por igual.**

### Amazon EventBridge
**Afirmaciones:**
1. **EventBridge permite la creación de reglas para enrutar eventos de múltiples fuentes a múltiples destinos.**
2. **EventBridge soporta la integración nativa con una amplia gama de servicios AWS y aplicaciones SaaS.**
3. **EventBridge puede procesar eventos en tiempo real, activando funciones Lambda, Step Functions, entre otros destinos.**
4. **EventBridge permite la creación de buses de eventos personalizados para aplicaciones propias.**
5. **EventBridge puede filtrar eventos basados en criterios específicos, enviando solo eventos relevantes a los destinos.**

**Negaciones:**
1. **EventBridge no almacena eventos indefinidamente; los eventos deben ser procesados inmediatamente o dentro de un tiempo limitado.**
2. **EventBridge no garantiza la entrega de eventos en un orden específico, a menos que se configure adecuadamente con reglas y buses específicos.**
3. **EventBridge no permite la manipulación directa de eventos a través de API, a diferencia de servicios de cola como SQS.**
4. **EventBridge no proporciona mecanismos de reintento por defecto si el destino falla en procesar el evento; esto debe ser manejado manualmente.**
5. **EventBridge no puede enviar eventos directamente a correos electrónicos o servicios HTTP/S sin configuraciones adicionales.**

Estas afirmaciones y negaciones resumen las características y limitaciones clave de SNS, SQS y EventBridge en AWS, ayudando a comprender mejor sus usos y restricciones en arquitecturas distribuidas.