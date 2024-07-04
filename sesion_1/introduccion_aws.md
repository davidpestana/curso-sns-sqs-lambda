### Curso de AWS Lambda con Gestión de Colas (SNS + SQS) en Java

### Sesión 1: Introducción a AWS y Fundamentos de Lambda

#### 1.1. Introducción a AWS

##### ¿Qué es AWS?

**Historia y evolución**

Amazon Web Services (AWS) es la plataforma de servicios en la nube más completa y adoptada en el mundo. Ofrece más de 200 servicios integrales de centros de datos a nivel mundial. AWS se lanzó en 2006, y desde entonces, ha transformado la manera en que las empresas operan, ofreciendo soluciones escalables y de bajo costo. La idea de AWS surgió cuando Amazon decidió aprovechar su infraestructura interna y su experiencia en la gestión de centros de datos para ofrecer servicios tecnológicos a otras empresas.

- **2002:** Amazon lanza su primer servicio web, Amazon Web Services, que permitía a los desarrolladores integrar características de Amazon en sus propios sitios web.
- **2006:** Se lanzan los servicios fundacionales de AWS: Amazon S3 (Simple Storage Service) y Amazon EC2 (Elastic Compute Cloud).
- **2010:** AWS experimenta un crecimiento significativo, con la incorporación de servicios como RDS (Relational Database Service) y Elastic Beanstalk.
- **2014:** AWS presenta Lambda, un servicio de computación sin servidor que permite a los desarrolladores ejecutar código sin aprovisionar ni gestionar servidores.
- **2019:** AWS alcanza un ingreso anual de 35 mil millones de dólares, consolidándose como líder del mercado de la nube.
- **2021:** AWS continúa expandiendo su cartera de servicios, introduciendo nuevas tecnologías y mejorando las capacidades de los servicios existentes para satisfacer las demandas de las empresas modernas.
- **2023:** AWS anuncia la disponibilidad de instancias de computación cuántica como parte de su iniciativa para impulsar la computación de próxima generación.

**Principales servicios y su propósito**

AWS ofrece una amplia gama de servicios, agrupados en varias categorías:

1. **Cómputo:**
   - **Amazon EC2 (Elastic Compute Cloud):** Proporciona capacidad de computación escalable en la nube. Permite a los usuarios lanzar instancias de servidor virtual en la infraestructura de Amazon. Las instancias EC2 se pueden configurar con diferentes tamaños de CPU, memoria y almacenamiento, y se pueden utilizar para diversas aplicaciones, desde servidores web hasta análisis de datos.

   **Familias de instancias EC2:**
   
   - **Instancias de propósito general:** Ideales para aplicaciones que necesitan un equilibrio de recursos de computación, memoria y redes. Ejemplo: t2.micro, m5.large.
   - **Instancias optimizadas para cómputo:** Adecuadas para aplicaciones con altos requisitos de procesamiento, como servidores web de alto rendimiento y análisis científicos. Ejemplo: c5.large, c5n.4xlarge.
   - **Instancias optimizadas para memoria:** Diseñadas para aplicaciones que requieren grandes cantidades de memoria, como bases de datos en memoria y análisis en tiempo real. Ejemplo: r5.large, x1e.32xlarge.
   - **Instancias optimizadas para almacenamiento:** Indicadas para aplicaciones que necesitan un acceso rápido y masivo a almacenamiento local, como bases de datos NoSQL y procesamiento de datos grandes. Ejemplo: i3.large, d2.8xlarge.
   - **Instancias aceleradas por GPU:** Para aplicaciones que necesitan una capacidad de procesamiento gráfico intensiva, como el aprendizaje profundo y el procesamiento de video. Ejemplo: p3.2xlarge, g4dn.xlarge.

2. **Almacenamiento:**
   - **Amazon S3 (Simple Storage Service):** Servicio de almacenamiento de objetos que ofrece escalabilidad, disponibilidad y seguridad de datos a un costo bajo. Es ideal para copias de seguridad, almacenamiento de archivos, y distribución de contenido. S3 garantiza una durabilidad del 99.999999999% para los objetos almacenados.
   
   **Clases de almacenamiento S3:**
   
   - **S3 Standard:** Para datos que se acceden con frecuencia.
   - **S3 Intelligent-Tiering:** Mueve automáticamente los datos entre dos niveles de acceso (frecuente e infrecuente) según los patrones de acceso.
   - **S3 Standard-IA (Infrequent Access):** Para datos a los que se accede menos frecuentemente, pero que aún necesitan estar rápidamente disponibles.
   - **S3 One Zone-IA:** Para datos infrecuentes que no necesitan la resiliencia de datos multizona.
   - **S3 Glacier:** Almacenamiento de bajo costo para archivado de datos y copias de seguridad a largo plazo.
   - **S3 Glacier Deep Archive:** La clase de almacenamiento más económica para archivado de datos que raramente se acceden y necesitan retención a largo plazo.

3. **Bases de datos:**
   - **Amazon RDS (Relational Database Service):** Facilita la configuración, operación y escalado de bases de datos relacionales en la nube. Compatible con bases de datos como MySQL, PostgreSQL, MariaDB, Oracle y SQL Server. RDS automatiza tareas administrativas como actualizaciones de software, copias de seguridad y escalado.
   - **Amazon DynamoDB:** Base de datos NoSQL totalmente gestionada que proporciona rendimiento rápido y predecible con escalabilidad sin problemas. Es ideal para aplicaciones que requieren baja latencia de acceso a datos a cualquier escala.
   - **Amazon Aurora:** Base de datos relacional compatible con MySQL y PostgreSQL, diseñada para la nube y que combina la velocidad y disponibilidad de las bases de datos comerciales con la simplicidad y el costo de las bases de datos de código abierto.

4. **Seguridad y gestión de identidades:**
   - **AWS IAM (Identity and Access Management):** Gestiona el acceso a los recursos de AWS de manera segura, permitiendo la creación y administración de usuarios y grupos, y la definición de políticas para controlar el acceso a los servicios y recursos. IAM permite establecer permisos detallados a nivel de recursos y acciones.
   - **AWS KMS (Key Management Service):** Servicio de gestión de claves que facilita la creación y el control de las claves de cifrado utilizadas para cifrar los datos. KMS es integrado con muchos otros servicios de AWS para cifrar datos en reposo.

5. **Redes y entrega de contenido:**
   - **Amazon VPC (Virtual Private Cloud):** Permite provisionar una sección aislada de la nube de AWS donde se pueden lanzar recursos de AWS en una red virtual que se define. Proporciona control total sobre el entorno de red, incluyendo la selección del rango de direcciones IP, creación de subredes y configuración de tablas de rutas y puertas de enlace de red.
   - **Amazon CloudFront:** Servicio de red de entrega de contenido (CDN) que distribuye contenido a los usuarios con baja latencia y altas velocidades de transferencia. Ideal para entregar contenido web, video, archivos de software y otros activos digitales.

**Componentes clave de Amazon VPC:**
   
   - **CIDR (Classless Inter-Domain Routing):** Especifica el rango de direcciones IP para la VPC. Ejemplo: 10.0.0.0/16.
   - **Subnets:** Dividen la VPC en segmentos más pequeños. Pueden ser públicas o privadas.
   - **Internet Gateway:** Permite la comunicación entre la VPC y internet.
   - **NAT Gateway:** Permite a las instancias en una subred privada acceder a internet sin exponerlas a conexiones entrantes no solicitadas.
   - **Route Tables:** Definen las reglas de enrutamiento dentro de la VPC.
   - **Security Groups:** Actúan como firewalls virtuales para controlar el tráfico hacia y desde las instancias de EC2.
   - **Network ACLs (Access Control Lists):** Proveen una capa adicional de seguridad controlando el tráfico hacia y desde las subnets.

**Tecnología Nitro**

La plataforma Nitro es la tecnología subyacente que potencia las instancias EC2 más recientes. Proporciona varias mejoras clave:

- **Desempeño mejorado:** La tecnología Nitro permite a las instancias EC2 utilizar casi toda la capacidad de la CPU y la memoria sin overhead de hipervisor.
- **Seguridad avanzada:** Nitro incorpora capacidades de seguridad integradas, como cifrado de datos en reposo y en tránsito.
- **Funcionalidad avanzada:** Nitro soporta características avanzadas como instancias de metal desnudo (bare metal), que permiten a las aplicaciones acceder directamente al hardware subyacente.

**Zonas de disponibilidad y regiones**

AWS organiza su infraestructura global en regiones y zonas de disponibilidad (AZs):

- **Regiones:** Son ubicaciones geográficas separadas que contienen múltiples zonas de disponibilidad. Cada región es completamente independiente y está aislada del resto en términos de latencia y fallas.
- **Zonas de disponibilidad:** Son centros de datos discretos dentro de una región, cada uno con energía, redes y conectividad redundantes. Las AZs están conectadas a través de enlaces de baja latencia, permitiendo la replicación de datos y la alta disponibilidad.

**Mecanismos de reservación**

Amazon EC2 ofrece varios modelos de pago y mecanismos de reservación para optimizar costos:

- **On-Demand:** Permite pagar por capacidad de computación por segundo, sin compromisos a largo plazo. Es ideal para cargas de trabajo impredecibles.
- **Reserved Instances:** Ofrece descuentos significativos en comparación con On-Demand al comprometerse a utilizar instancias por uno o tres años. Existen tres tipos de instancias reservadas:
  - **Standard Reserved Instances:** Ofrecen el mayor descuento y flexibilidad limitada en términos de cambiar atributos de la instancia.
  - **Convertible Reserved Instances:** Permiten cambiar los atributos de

 la instancia (como el tipo de instancia) a cambio de un menor descuento en comparación con las Standard.
  - **Scheduled Reserved Instances:** Permiten reservar instancias para períodos específicos durante la semana.
- **Spot Instances:** Ofrecen capacidad de computación no utilizada con descuentos significativos, ideales para cargas de trabajo flexibles y tolerantes a fallos.

**Usos y prácticas recomendadas para Amazon S3**

Amazon S3 es un servicio versátil que puede ser utilizado para una variedad de casos de uso:

1. **Backup y restauración:**
   - **Buenas prácticas:** Configurar versiones y habilitar el borrado con MFA para proteger contra eliminaciones accidentales. Utilizar políticas de ciclo de vida para mover datos a S3 Glacier para almacenamiento a largo plazo.
   - **Malas prácticas:** No habilitar versiones puede resultar en la pérdida de datos críticos si se borran accidentalmente.

2. **Almacenamiento y distribución de contenido:**
   - **Buenas prácticas:** Usar Amazon CloudFront para distribuir contenido almacenado en S3, mejorando la velocidad de entrega y reduciendo la latencia.
   - **Malas prácticas:** Servir contenido directamente desde S3 sin utilizar CloudFront puede resultar en mayores latencias y costos.

3. **Lago de datos (Data Lake):**
   - **Buenas prácticas:** Utilizar S3 en conjunto con AWS Glue y Amazon Athena para catalogar y consultar datos. Implementar cifrado en reposo y en tránsito para proteger datos sensibles.
   - **Malas prácticas:** No configurar políticas de seguridad adecuadas puede exponer datos sensibles a accesos no autorizados.

**Recomendaciones generales y advertencias**

1. **Seguridad:**
   - **Recomendación:** Siempre usar IAM roles y políticas para gestionar el acceso a los recursos de AWS. Configurar Multi-Factor Authentication (MFA) para mayor seguridad.
   - **Advertencia:** No compartir nunca las claves de acceso de AWS públicamente. Utilizar roles de IAM con los permisos mínimos necesarios.

2. **Costos:**
   - **Recomendación:** Monitorizar el uso y los costos mediante AWS Cost Explorer y configurar alertas de presupuesto para evitar sorpresas.
   - **Advertencia:** No monitorizar el uso puede llevar a cargos inesperados. Utilizar instancias reservadas y spot para optimizar costos.

3. **Escalabilidad:**
   - **Recomendación:** Diseñar aplicaciones para que sean escalables automáticamente utilizando servicios como Auto Scaling, AWS Lambda y Amazon RDS.
   - **Advertencia:** No diseñar para la escalabilidad puede resultar en una degradación del rendimiento durante picos de carga.

#### Ejemplo práctico: Implementación de una aplicación web simple usando AWS

Para ilustrar cómo una empresa puede utilizar varios servicios de AWS para implementar y gestionar una aplicación web simple, asegurando escalabilidad, seguridad y disponibilidad, seguimos los siguientes pasos:

1. **Lanzamiento de una instancia EC2 para el servidor web:**
   ```bash
   aws ec2 run-instances --image-id ami-0abcdef1234567890 --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids sg-0123456789abcdef0 --subnet-id subnet-6e7f829e
   ```

2. **Configuración de un bucket S3 para almacenar archivos estáticos:**
   ```bash
   aws s3api create-bucket --bucket mi-bucket-web --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2
   aws s3 cp mi-sitio-web/ s3://mi-bucket-web/ --recursive
   ```

3. **Creación de una base de datos RDS para almacenar datos de la aplicación:**
   ```bash
   aws rds create-db-instance --db-instance-identifier mi-base-datos --allocated-storage 20 --db-instance-class db.t2.micro --engine mysql --master-username admin --master-user-password password --backup-retention-period 3 --availability-zone us-west-2a
   ```

4. **Configuración de roles y permisos con IAM:**
   ```bash
   aws iam create-role --role-name mi-rol-ec2 --assume-role-policy-document file://trust-policy.json
   aws iam attach-role-policy --role-name mi-rol-ec2 --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
   aws iam attach-role-policy --role-name mi-rol-ec2 --policy-arn arn:aws:iam::aws:policy/AmazonRDSFullAccess
   ```

5. **Configuración de una VPC para aislar la red de la aplicación:**
   ```bash
   aws ec2 create-vpc --cidr-block 10.0.0.0/16
   aws ec2 create-subnet --vpc-id vpc-0abcdef1234567890 --cidr-block 10.0.1.0/24
   aws ec2 create-internet-gateway
   aws ec2 attach-internet-gateway --vpc-id vpc-0abcdef1234567890 --internet-gateway-id igw-0abcdef1234567890
   aws ec2 create-route-table --vpc-id vpc-0abcdef1234567890
   aws ec2 create-route --route-table-id rtb-0abcdef1234567890 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-0abcdef1234567890
   ```

6. **Configuración de balanceador de carga para distribuir el tráfico:**
   ```bash
   aws elb create-load-balancer --load-balancer-name my-load-balancer --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80" --subnets subnet-15aaab61 --security-groups sg-0123456789abcdef0
   aws elb register-instances-with-load-balancer --load-balancer-name my-load-balancer --instances i-abcdef0123456789a
   ```

7. **Configuración de Auto Scaling para la instancia EC2:**
   ```bash
   aws autoscaling create-launch-configuration --launch-configuration-name my-launch-config --image-id ami-0abcdef1234567890 --instance-type t2.micro --key-name MyKeyPair --security-groups sg-0123456789abcdef0
   aws autoscaling create-auto-scaling-group --auto-scaling-group-name my-auto-scaling-group --launch-configuration-name my-launch-config --min-size 1 --max-size 5 --desired-capacity 2 --vpc-zone-identifier "subnet-15aaab61,subnet-6782e71a"
   aws autoscaling put-scaling-policy --auto-scaling-group-name my-auto-scaling-group --policy-name my-scaleout-policy --scaling-adjustment 1 --adjustment-type ChangeInCapacity
   ```

#### Casos de uso específicos y arquitecturas típicas en AWS

**Caso de uso 1: Aplicación web altamente escalable**

Una empresa de comercio electrónico necesita una plataforma web que pueda manejar picos de tráfico durante eventos de ventas. Utilizando AWS, la arquitectura podría ser la siguiente:

- **Amazon EC2:** Para servidores web y de aplicaciones.
- **Amazon S3:** Para almacenar contenido estático como imágenes, videos y archivos CSS/JS.
- **Amazon RDS:** Para la base de datos relacional que maneja el inventario, pedidos y usuarios.
- **Amazon CloudFront:** Para distribuir el contenido a los usuarios finales con baja latencia.
- **Auto Scaling:** Para ajustar automáticamente la capacidad de EC2 en función de la demanda de tráfico.
- **Elastic Load Balancing (ELB):** Para distribuir el tráfico entrante a través de múltiples instancias EC2.

**Caso de uso 2: Procesamiento de Big Data**

Una empresa de análisis de datos necesita procesar grandes volúmenes de datos generados por sensores IoT. Utilizando AWS, la arquitectura podría ser la siguiente:

- **Amazon Kinesis:** Para la ingesta de datos en tiempo real.
- **Amazon S3:** Para almacenar datos en bruto y procesados.
- **Amazon EMR (Elastic MapReduce):** Para procesar grandes volúmenes de datos utilizando Hadoop y Spark.
- **AWS Lambda:** Para procesar y transformar datos en tiempo real.
- **Amazon Redshift:** Para el almacenamiento de datos y análisis complejos.
- **Amazon QuickSight:** Para la visualización de datos y generación de informes.

**Caso de uso 3: Backup y recuperación ante desastres**

Una empresa necesita una solución de backup y recuperación ante desastres para su infraestructura de TI. Utilizando AWS, la arquitectura podría ser la siguiente:

- **AWS Backup:** Para automatizar y centralizar la administración de backups.
- **Amazon S3 Glacier:** Para almacenar copias de seguridad a largo plazo de manera económica.
- **Amazon RDS:** Con habilitación de snapshots automáticas para la base de datos.
- **Amazon EC2:** Para lanzar instancias en una región diferente en caso de desastre.
- **AWS CloudFormation:** Para definir y desplegar toda la infraestructura en una región de respaldo en caso de fallo en la región principal.

#### Detalles adicionales sobre componentes clave de AWS

**Amazon EC2:**

- **Familias de instancias:**
  - **t2, t3 (Burstable Performance):** Adecuadas para cargas de trabajo que tienen picos ocasionales de uso.
  - **m5, m6 (General Purpose):** Equilibrio entre cómputo, memoria y redes.
  - **c5, c6 (Compute Optimized):** Para cargas de trabajo intensivas en cómputo

, como servidores web de alto rendimiento.
  - **r5, r6 (Memory Optimized):** Para aplicaciones que requieren grandes cantidades de memoria, como bases de datos en memoria.
  - **i3, i4 (Storage Optimized):** Para aplicaciones que necesitan un acceso rápido y masivo a almacenamiento local.
  - **g4, p3 (Accelerated Computing):** Para cargas de trabajo que requieren procesamiento gráfico intensivo, como aprendizaje automático y procesamiento de video.

**Amazon S3:**

- **Características de seguridad:**
  - **Cifrado de datos en reposo:** Usando claves gestionadas por AWS (SSE-S3), claves gestionadas por el cliente (SSE-C) o AWS Key Management Service (SSE-KMS).
  - **Control de acceso:** Mediante políticas de bucket, listas de control de acceso (ACLs) y políticas de IAM.
  - **Versionado:** Permite mantener múltiples versiones de un objeto en el mismo bucket.
  - **MFA Delete:** Requiere autenticación multifactor para eliminar objetos, proporcionando una capa adicional de protección.

**Amazon VPC:**

- **Subnets públicas y privadas:**
  - **Subnets públicas:** Tienen rutas a la Internet Gateway, permitiendo que las instancias dentro de ellas tengan acceso directo a Internet.
  - **Subnets privadas:** No tienen rutas directas a Internet Gateway, proporcionando un entorno aislado. Acceden a internet a través de un NAT Gateway.
- **Configuración de Security Groups y NACLs:**
  - **Security Groups:** Reglas de firewall a nivel de instancia que controlan el tráfico de entrada y salida.
  - **NACLs (Network Access Control Lists):** Reglas de firewall a nivel de subnet que controlan el tráfico de entrada y salida para las subnets.

**Amazon RDS:**

- **Características avanzadas:**
  - **Multi-AZ deployments:** Proporciona alta disponibilidad y recuperación ante desastres mediante la replicación de datos en múltiples zonas de disponibilidad.
  - **Read Replicas:** Mejora la escalabilidad de lectura distribuyendo las cargas de trabajo de lectura a réplicas en distintas regiones.
  - **Automated Backups:** RDS realiza automáticamente copias de seguridad completas diarias y copias de seguridad de transacciones, permitiendo restaurar la base de datos a cualquier punto en el tiempo dentro del período de retención especificado.

Estos detalles adicionales proporcionan una comprensión profunda y exhaustiva de los servicios de AWS y sus características, adecuadas para un curso introductorio expandido sobre AWS.