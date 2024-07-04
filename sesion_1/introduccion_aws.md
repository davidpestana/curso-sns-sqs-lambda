### Sesión 1: Introducción a AWS y Fundamentos de Lambda

#### 1.1. Introducción a AWS

##### ¿Qué es AWS?

**Historia y evolución**

Amazon Web Services (AWS) es la plataforma de servicios en la nube más completa y adoptada en el mundo. Ofrece más de 200 servicios integrales de centros de datos a nivel mundial. AWS se lanzó en 2006, y desde entonces, ha transformado la manera en que las empresas operan, ofreciendo soluciones escalables y de bajo costo. La idea de AWS surgió cuando Amazon decidió aprovechar su infraestructura interna y su experiencia en la gestión de centros de datos para ofrecer servicios tecnológicos a otras empresas.

![AWS Logo](https://a0.awsstatic.com/libra-css/images/logos/aws_logo_smile_1200x630.png)

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

   ![Amazon EC2](https://d1.awsstatic.com/ec2/EC2-Logo.c213f3b4cd2ed53a70f6f7a1a94392f5.png)

2. **Almacenamiento:**
   - **Amazon S3 (Simple Storage Service):** Servicio de almacenamiento de objetos que ofrece escalabilidad, disponibilidad y seguridad de datos a un costo bajo. Es ideal para copias de seguridad, almacenamiento de archivos, y distribución de contenido. S3 garantiza una durabilidad del 99.999999999% para los objetos almacenados.

   ![Amazon S3](https://d1.awsstatic.com/logos/aws-logo-s3.23a1c7afca5a43292ea5dca80f5a1b38.png)

3. **Bases de datos:**
   - **Amazon RDS (Relational Database Service):** Facilita la configuración, operación y escalado de bases de datos relacionales en la nube. Compatible con bases de datos como MySQL, PostgreSQL, MariaDB, Oracle y SQL Server. RDS automatiza tareas administrativas como actualizaciones de software, copias de seguridad y escalado.

   ![Amazon RDS](https://d1.awsstatic.com/product-marketing/RDS/RDS-Logo.0d5b3d3d1e8e1c2b38f503bc24d6b001.png)

4. **Seguridad y gestión de identidades:**
   - **AWS IAM (Identity and Access Management):** Gestiona el acceso a los recursos de AWS de manera segura, permitiendo la creación y administración de usuarios y grupos, y la definición de políticas para controlar el acceso a los servicios y recursos. IAM permite establecer permisos detallados a nivel de recursos y acciones.

   ![AWS IAM](https://d1.awsstatic.com/security-and-compliance/IAM/IAM_1.e7f1a5b9e8e4b6d2a18cdca20d96569d.png)

5. **Redes y entrega de contenido:**
   - **Amazon VPC (Virtual Private Cloud):** Permite provisionar una sección aislada de la nube de AWS donde se pueden lanzar recursos de AWS en una red virtual que se define. Proporciona control total sobre el entorno de red, incluyendo la selección del rango de direcciones IP, creación de subredes y configuración de tablas de rutas y puertas de enlace de red.

   ![Amazon VPC](https://d1.awsstatic.com/overview/Networking%20VPC.png)

##### Servicios principales de AWS

**Amazon EC2**

Amazon EC2 ofrece diferentes tipos de instancias para satisfacer diversas necesidades de computación. Algunos de los tipos de instancias incluyen:

- **Instancias de propósito general:** Ideales para aplicaciones que necesitan un equilibrio de recursos de computación, memoria y redes. Ejemplo: t2.micro, m5.large.
- **Instancias optimizadas para cómputo:** Adecuadas para aplicaciones con altos requisitos de procesamiento, como servidores web de alto rendimiento y análisis científicos. Ejemplo: c5.large, c5n.4xlarge.
- **Instancias optimizadas para memoria:** Diseñadas para aplicaciones que requieren grandes cantidades de memoria, como bases de datos en memoria y análisis en tiempo real. Ejemplo: r5.large, x1e.32xlarge.
- **Instancias optimizadas para almacenamiento:** Indicadas para aplicaciones que necesitan un acceso rápido y masivo a almacenamiento local, como bases de datos NoSQL y procesamiento de datos grandes. Ejemplo: i3.large, d2.8xlarge.

**Tecnología Nitro**

La plataforma Nitro es la tecnología subyacente que potencia las instancias EC2 más recientes. Proporciona varias mejoras clave:

![AWS Nitro](https://d1.awsstatic.com/ec2/nitro/nitro-system.2c2c1e4c22c9e7c7ce74fdb4b82e7a3e.png)

- **Desempeño mejorado:** La tecnología Nitro permite a las instancias EC2 utilizar casi toda la capacidad de la CPU y la memoria sin overhead de hipervisor.
- **Seguridad avanzada:** Nitro incorpora capacidades de seguridad integradas, como cifrado de datos en reposo y en tránsito.
- **Funcionalidad avanzada:** Nitro soporta características avanzadas como instancias de metal desnudo (bare metal), que permiten a las aplicaciones acceder directamente al hardware subyacente.

**Zonas de disponibilidad y regiones**

AWS organiza su infraestructura global en regiones y zonas de disponibilidad (AZs):

- **Regiones:** Son ubicaciones geográficas separadas que contienen múltiples zonas de disponibilidad. Cada región es completamente independiente y está aislada del resto en términos de latencia y fallas.
- **Zonas de disponibilidad:** Son centros de datos discretos dentro de una región, cada uno con energía, redes y conectividad redundantes. Las AZs están conectadas a través de enlaces de baja latencia, permitiendo la replicación de datos y la alta disponibilidad.

![AWS Regions and AZs](https://d1.awsstatic.com/global-infrastructure/Global_Infrastructure_Map.e4a0b3dd8e5a76d36ed8a6d2c3b6de51.png)

**Mecanismos de reservación**

Amazon EC2 ofrece varios modelos de pago y mecanismos de reservación para optimizar costos:

- **On-Demand:** Permite pagar por capacidad de computación por segundo, sin compromisos a largo plazo. Es ideal para cargas de trabajo impredecibles.
- **Reserved Instances:** Ofrece descuentos significativos en comparación con On-Demand al comprometerse a utilizar instancias por uno o tres años. Existen tres tipos de instancias reservadas:
  - **Standard Reserved Instances:** Ofrecen el mayor descuento y flexibilidad limitada en términos de cambiar atributos de la instancia.
  - **Convertible Reserved Instances:** Permiten cambiar los atributos de la instancia (como el tipo de instancia) a cambio de un menor descuento en comparación con las Standard.
  - **Scheduled Reserved Instances:** Permiten reservar instancias para períodos específicos durante la semana.
- **Spot Instances:** Ofrecen capacidad de computación no utilizada con descuentos significativos, ideales para cargas de trabajo flexibles y tolerantes a fallos.

![AWS EC2 Pricing](https://d1.awsstatic.com/pricing/reserved-instances/RI-Pricing-Graphic.4a8c5b7c108e3d88cf87bdfabe376ef4.png)

**Amazon S3**

Amazon S3 está diseñado para ofrecer una durabilidad del 99.999999999% y una alta disponibilidad. Proporciona diferentes clases de almacenamiento para optimizar costos según las necesidades de acceso a los datos:

![Amazon S3 Storage Classes](https://d1.awsstatic.com/s3/s3-storage-classes.14e4a7a6fa43f679a1f50586f9e1d6b7.png)

- **S3 Standard:** Para datos que se acceden con frecuencia.
- **S3 Intelligent-Tiering:** Mueve automáticamente los datos entre dos niveles de acceso (frecuente e infrecuente) según los patrones de acceso.
- **S3 Standard-IA (Infrequent Access):** Para datos a los que se accede menos frecuentemente, pero

 que aún necesitan estar rápidamente disponibles.
- **S3 One Zone-IA:** Para datos infrecuentes que no necesitan la resiliencia de datos multizona.
- **S3 Glacier:** Almacenamiento de bajo costo para archivado de datos y copias de seguridad a largo plazo.
- **S3 Glacier Deep Archive:** La clase de almacenamiento más económica para archivado de datos que raramente se acceden y necesitan retención a largo plazo.

**Amazon RDS**

Amazon RDS automatiza muchas tareas administrativas tediosas y complejas, como la configuración de hardware, el aprovisionamiento de bases de datos, la aplicación de parches y las copias de seguridad. Los tipos de bases de datos compatibles incluyen:

![Amazon RDS](https://d1.awsstatic.com/product-marketing/RDS/RDS-Logo.0d5b3d3d1e8e1c2b38f503bc24d6b001.png)

- **Amazon Aurora:** Compatible con MySQL y PostgreSQL, ofrece alto rendimiento y disponibilidad con un costo más bajo.
- **MySQL:** Popular sistema de gestión de bases de datos relacional de código abierto.
- **PostgreSQL:** Sistema de gestión de bases de datos relacional avanzado y de código abierto.
- **MariaDB:** Derivado del proyecto MySQL, ofrece características avanzadas y mejoras de rendimiento.
- **Oracle Database:** Base de datos comercial con características avanzadas y soporte de AWS.
- **Microsoft SQL Server:** Sistema de gestión de bases de datos de Microsoft, con soporte completo en AWS.

**AWS IAM**

AWS IAM permite gestionar el acceso a los servicios y recursos de AWS de manera segura. Las características principales incluyen:

![AWS IAM](https://d1.awsstatic.com/security-and-compliance/IAM/IAM_1.e7f1a5b9e8e4b6d2a18cdca20d96569d.png)

- **Usuarios y grupos:** Permite crear y gestionar usuarios individuales y agruparlos en equipos para facilitar la gestión de permisos.
- **Roles:** Permite definir un conjunto de permisos que pueden ser asumidos por entidades confiables, como instancias EC2 o usuarios de otras cuentas AWS.
- **Políticas:** Documentos JSON que definen permisos y controles de acceso a los recursos de AWS.
- **MFA (Multi-Factor Authentication):** Añade una capa adicional de seguridad al requerir un segundo factor de autenticación, como un dispositivo móvil o una llave de seguridad.

**Amazon VPC**

Amazon VPC permite crear una red virtual aislada en la nube de AWS. Las características clave incluyen:

![Amazon VPC](https://d1.awsstatic.com/overview/Networking%20VPC.png)

- **Subredes:** Permiten segmentar la red en diferentes partes, como subredes públicas y privadas.
- **Tablas de rutas:** Definen cómo se enruta el tráfico dentro de la VPC.
- **Puertas de enlace de Internet:** Permiten la comunicación entre recursos dentro de la VPC y la Internet pública.
- **Puertas de enlace NAT:** Permiten que las instancias en una subred privada accedan a Internet de manera segura.
- **Endpoints de VPC:** Permiten una conexión privada y segura entre la VPC y los servicios de AWS sin usar una puerta de enlace de Internet.
- **Grupos de seguridad y ACLs (Access Control Lists):** Proporcionan control detallado sobre el tráfico entrante y saliente a nivel de instancia y subred.

#### Ejemplo práctico: Implementación de una aplicación web simple usando AWS

Para ilustrar cómo una empresa puede utilizar varios servicios de AWS para implementar y gestionar una aplicación web simple, asegurando escalabilidad, seguridad y disponibilidad, seguimos los siguientes pasos:

1. **Lanzamiento de una instancia EC2 para el servidor web:**
   ```bash
   aws ec2 run-instances --image-id ami-0abcdef1234567890 --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids sg-0123456789abcdef0 --subnet-id subnet-6e7f829e
   ```

   ![Launch EC2 Instance](https://d1.awsstatic.com/ec2/EC2-Logo.c213f3b4cd2ed53a70f6f7a1a94392f5.png)

2. **Configuración de un bucket S3 para almacenar archivos estáticos:**
   ```bash
   aws s3api create-bucket --bucket mi-bucket-web --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2
   aws s3 cp mi-sitio-web/ s3://mi-bucket-web/ --recursive
   ```

   ![S3 Bucket](https://d1.awsstatic.com/logos/aws-logo-s3.23a1c7afca5a43292ea5dca80f5a1b38.png)

3. **Creación de una base de datos RDS para almacenar datos de la aplicación:**
   ```bash
   aws rds create-db-instance --db-instance-identifier mi-base-datos --allocated-storage 20 --db-instance-class db.t2.micro --engine mysql --master-username admin --master-user-password password --backup-retention-period 3 --availability-zone us-west-2a
   ```

   ![RDS Database](https://d1.awsstatic.com/product-marketing/RDS/RDS-Logo.0d5b3d3d1e8e1c2b38f503bc24d6b001.png)

4. **Configuración de roles y permisos con IAM:**
   ```bash
   aws iam create-role --role-name mi-rol-ec2 --assume-role-policy-document file://trust-policy.json
   aws iam attach-role-policy --role-name mi-rol-ec2 --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
   aws iam attach-role-policy --role-name mi-rol-ec2 --policy-arn arn:aws:iam::aws:policy/AmazonRDSFullAccess
   ```

   ![IAM Role](https://d1.awsstatic.com/security-and-compliance/IAM/IAM_1.e7f1a5b9e8e4b6d2a18cdca20d96569d.png)

5. **Configuración de una VPC para aislar la red de la aplicación:**
   ```bash
   aws ec2 create-vpc --cidr-block 10.0.0.0/16
   aws ec2 create-subnet --vpc-id vpc-0abcdef1234567890 --cidr-block 10.0.1.0/24
   aws ec2 create-internet-gateway
   aws ec2 attach-internet-gateway --vpc-id vpc-0abcdef1234567890 --internet-gateway-id igw-0abcdef1234567890
   aws ec2 create-route-table --vpc-id vpc-0abcdef1234567890
   aws ec2 create-route --route-table-id rtb-0abcdef1234567890 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-0abcdef1234567890
   ```

   ![VPC Configuration](https://d1.awsstatic.com/overview/Networking%20VPC.png)

Este ejemplo ilustra cómo una empresa puede utilizar varios servicios de AWS para implementar y gestionar una aplicación web simple, asegurando escalabilidad, seguridad y disponibilidad.