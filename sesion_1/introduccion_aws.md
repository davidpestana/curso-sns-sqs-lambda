# Introducción a AWS

Amazon Web Services (AWS) es una plataforma de servicios en la nube que ofrece una vasta colección de servicios de infraestructura y aplicaciones, lo que permite a las empresas y desarrolladores de todos los tamaños implementar y gestionar aplicaciones de manera más eficiente y escalable. AWS es conocido por su modelo de pago por uso, su flexibilidad y su capacidad de escalado, lo que lo convierte en una opción popular para una amplia gama de aplicaciones y necesidades empresariales.

#### ¿Qué es AWS?

AWS proporciona una serie de servicios de TI bajo demanda a través de la web, que incluye almacenamiento, computación, bases de datos, redes, herramientas de desarrollo, inteligencia artificial, seguridad y mucho más. Los servicios de AWS son accesibles globalmente, permitiendo a las empresas acceder a recursos informáticos en cualquier lugar y en cualquier momento, sin la necesidad de invertir en infraestructura física costosa y compleja.

##### Historia y evolución de AWS

AWS fue lanzado oficialmente en 2006 con la introducción de dos servicios fundamentales: Amazon S3 (Simple Storage Service) y Amazon EC2 (Elastic Compute Cloud). Estos servicios iniciales permitieron a los desarrolladores almacenar datos y acceder a capacidad computacional bajo demanda, estableciendo la base para una plataforma de servicios en la nube extensible.

**Línea de tiempo de AWS:**
- **2006:** Lanzamiento de Amazon S3 y EC2.
- **2007-2008:** Introducción de servicios como Amazon SimpleDB, Amazon Simple Queue Service (SQS) y Amazon CloudFront.
- **2010:** Lanzamiento de Amazon RDS (Relational Database Service).
- **2012:** AWS supera los 30 servicios, incluyendo Elastic Beanstalk y DynamoDB.
- **2014:** Introducción de AWS Lambda, que permite ejecutar código en respuesta a eventos sin aprovisionar servidores.
- **2016:** AWS celebra su décimo aniversario con más de 70 servicios disponibles.
- **2020:** AWS cuenta con más de 200 servicios y una presencia global significativa con múltiples regiones y zonas de disponibilidad.

![AWS Evolution](https://upload.wikimedia.org/wikipedia/commons/9/93/Amazon_Web_Services_Logo.svg)

##### Principales servicios y su propósito

AWS proporciona una variedad de servicios que se agrupan en varias categorías, cada una con un propósito específico. A continuación, se describen algunos de los principales servicios y sus usos:

1. **Cómputo:**
   - **Amazon EC2 (Elastic Compute Cloud):** Proporciona capacidad de computación escalable en la nube. Los usuarios pueden lanzar instancias de servidores virtuales según sus necesidades y pagar solo por el tiempo de uso. EC2 permite a los desarrolladores escalar la capacidad de computación hacia arriba o hacia abajo en función de la demanda.
   - **AWS Lambda:** Permite ejecutar código sin aprovisionar ni gestionar servidores. Lambda ejecuta el código solo cuando se desencadenan eventos específicos y cobra solo por el tiempo de computación consumido durante la ejecución del código.

2. **Almacenamiento:**
   - **Amazon S3 (Simple Storage Service):** Servicio de almacenamiento de objetos que ofrece una infraestructura altamente escalable, duradera y segura para almacenar y recuperar cualquier cantidad de datos. S3 se utiliza comúnmente para almacenamiento de datos, copias de seguridad, recuperación ante desastres y distribución de contenido estático.
   - **Amazon EBS (Elastic Block Store):** Proporciona almacenamiento en bloques para uso con instancias EC2. EBS es adecuado para aplicaciones que requieren acceso a almacenamiento de bloques persistente y de baja latencia.

3. **Bases de datos:**
   - **Amazon RDS (Relational Database Service):** Facilita la configuración, operación y escalado de bases de datos relacionales en la nube. RDS soporta varios motores de bases de datos, proporcionando una solución flexible y gestionada para aplicaciones que requieren bases de datos SQL. Las características clave incluyen:
     - **Automatización de tareas administrativas:** Como copias de seguridad, parches de software y escalado de hardware.
     - **Alta disponibilidad:** A través de Multi-AZ (disponibilidad en múltiples zonas) que replica automáticamente los datos en una segunda zona de disponibilidad.
     - **Read replicas:** Permiten escalar horizontalmente las operaciones de lectura.
   - **Amazon DynamoDB:** Servicio de base de datos NoSQL totalmente gestionado que proporciona rendimiento rápido y predecible con escalabilidad automática. DynamoDB es ideal para aplicaciones que requieren baja latencia y escalabilidad a gran escala.

4. **Redes y entrega de contenido:**
   - **Amazon VPC (Virtual Private Cloud):** Permite a los usuarios crear una red virtual privada en la nube de AWS. Los usuarios pueden definir su propio espacio de red y controlar aspectos como la configuración de subredes, tablas de enrutamiento y gateways. VPC proporciona un entorno seguro y aislado para desplegar recursos de AWS.
   - **Amazon CloudFront:** Servicio de red de entrega de contenido (CDN) que distribuye contenido a los usuarios con baja latencia y altas velocidades de transferencia. CloudFront se integra con otros servicios de AWS para proporcionar una distribución de contenido segura y escalable.

5. **Herramientas de desarrollo:**
   - **AWS CodePipeline:** Servicio de entrega continua que automatiza los pasos de construcción, prueba y despliegue de aplicaciones. CodePipeline permite la integración continua y la entrega continua (CI/CD) para acelerar la entrega de software.
   - **AWS CodeBuild:** Servicio de construcción totalmente gestionado que compila el código fuente, ejecuta pruebas y produce paquetes de software listos para el despliegue. CodeBuild escala automáticamente para manejar múltiples compilaciones en paralelo.

6. **Seguridad y gestión de identidades:**
   - **AWS IAM (Identity and Access Management):** Permite a los administradores controlar de manera segura el acceso a los servicios y recursos de AWS. IAM permite la gestión de usuarios y permisos, proporcionando un control granular sobre quién puede acceder a qué recursos y bajo qué condiciones.
   - **AWS KMS (Key Management Service):** Servicio de gestión de claves que facilita la creación y el control de claves de cifrado para proteger los datos. KMS permite cifrar datos fácilmente en una amplia gama de servicios de AWS.

### Servicios principales de AWS

Vamos a profundizar en algunos de los servicios principales de AWS que son fundamentales para cualquier proyecto en la nube:

#### Amazon EC2 (Elastic Compute Cloud)

Amazon EC2 es uno de los servicios de AWS más utilizados. Proporciona capacidad de cómputo escalable en la nube, permitiendo a los usuarios lanzar y gestionar instancias de servidores virtuales. EC2 ofrece una amplia variedad de tipos de instancias optimizadas para diferentes casos de uso, como aplicaciones web, análisis de datos y procesamiento intensivo de gráficos. Las características clave incluyen:

- **Autoscaling:** Permite ajustar automáticamente la capacidad de EC2 en función de la demanda.
- **Elastic Load Balancing:** Distribuye automáticamente el tráfico de aplicaciones entrante entre múltiples instancias EC2.
- **Instancias Spot:** Ofrecen capacidad de EC2 no utilizada a precios reducidos.

**Ejemplo de uso de Amazon EC2:**

Supongamos que tienes una aplicación web que espera un aumento significativo en el tráfico durante un evento promocional. Puedes utilizar Amazon EC2 para lanzar instancias adicionales y configurar el autoescalado para manejar el aumento de la carga.

**Código de ejemplo para lanzar una instancia EC2 usando AWS CLI:**

```sh
aws ec2 run-instances --image-id ami-0abcdef1234567890 --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids sg-12345678 --subnet-id subnet-6e7f829e
```

#### Amazon S3 (Simple Storage Service)

Amazon S3 es un servicio de almacenamiento de objetos diseñado para almacenar y recuperar cualquier cantidad de datos desde cualquier lugar de la web. S3 proporciona durabilidad y disponibilidad elevadas, y se utiliza comúnmente para almacenamiento de datos, copias de seguridad, recuperación ante desastres y distribución de contenido. Las características clave incluyen:

- **Durabilidad del 99.999999999% (11 nueves):** Asegura que los datos estén protegidos contra pérdida.
- **Clases de almacenamiento:** Ofrecen diferentes niveles de durabilidad, disponibilidad y costo para satisfacer diversas necesidades.
- **Gestión de versiones:** Mantiene múltiples versiones de un objeto para recuperar datos antiguos si es necesario.

**Ejemplo de uso de Amazon S3:**

Puedes usar Amazon S3 para almacenar archivos multimedia grandes que se utilizan en tu sitio web o aplicación móvil, permitiendo una distribución rápida y eficiente a los usuarios finales.

**Código de ejemplo para subir un archivo a S3 usando AWS CLI:**

```sh
aws s3 cp myfile.txt s3://mybucket/myfile.txt
```

#### Amazon RDS (Relational Database Service)

Amazon RDS facilita la configuración, operación y escalado de bases de datos relacionales en la nube. RDS soporta varios motores de bases de datos, proporcionando una solución flexible y gestionada para aplicaciones que requieren bases de datos SQL. Las características clave incluyen:

- **Automatización de tareas administrativas:** Como copias de seguridad, parches de software y escalado de hardware.
- **Alta disponibilidad:** A través de Multi-AZ (disponibilidad en múltiples zonas) que replica automáticamente los datos en una segunda zona de disponibilidad.
- **Read replicas:** Permiten escalar horizontalmente las operaciones de lectura.

**Ejemplo de uso de Amazon RDS:**

Si tienes una aplicación que requiere una base de datos SQL para almacenar datos transaccionales, puedes usar Amazon RDS para configurar y gestionar una base de datos relacional sin tener que preocuparte por las tareas administrativas.

**Código de ejemplo para

 lanzar una instancia RDS usando AWS CLI:**

```sh
aws rds create-db-instance --db-instance-identifier mydatabase --db-instance-class db.t2.micro --engine mysql --master-username admin --master-user-password password --allocated-storage 20
```

#### AWS IAM (Identity and Access Management)

AWS IAM permite a los administradores controlar el acceso a los servicios y recursos de AWS de manera segura. IAM facilita la creación y gestión de usuarios y grupos, y el establecimiento de permisos detallados para controlar quién puede acceder a qué recursos. Las características clave incluyen:

- **Políticas basadas en roles:** Definen los permisos para usuarios y grupos.
- **Autenticación multifactor (MFA):** Proporciona una capa adicional de seguridad.
- **Federación de identidades:** Permite a los usuarios acceder a recursos de AWS utilizando credenciales existentes de servicios como Active Directory.

**Ejemplo de uso de AWS IAM:**

Puedes crear un grupo IAM para desarrolladores en tu organización y definir políticas que les permitan acceder solo a los recursos necesarios para sus tareas diarias.

**Código de ejemplo para crear un usuario IAM usando AWS CLI:**

```sh
aws iam create-user --user-name Bob
```

#### Amazon VPC (Virtual Private Cloud)

Amazon VPC permite a los usuarios crear una red virtual privada en la nube de AWS, proporcionando control total sobre el entorno de red, incluida la selección de rangos de IP, la creación de subredes y la configuración de tablas de enrutamiento y gateways. Las características clave incluyen:

- **Subredes:** Pueden ser públicas (con acceso a Internet) o privadas (sin acceso directo a Internet).
- **Seguridad:** Mediante el uso de listas de control de acceso (ACL) y grupos de seguridad para controlar el tráfico entrante y saliente.
- **Conectividad híbrida:** Permite la conexión segura de la VPC a centros de datos locales mediante AWS Direct Connect o VPN.

**Ejemplo de uso de Amazon VPC:**

Puedes usar Amazon VPC para crear una red aislada donde se ejecutan tus aplicaciones críticas, garantizando que solo las instancias dentro de la VPC puedan comunicarse entre sí y con recursos específicos.

**Código de ejemplo para crear una VPC usando AWS CLI:**

```sh
aws ec2 create-vpc --cidr-block 10.0.0.0/16
```

### Conclusión

AWS ofrece una plataforma robusta y flexible que permite a las empresas innovar y escalar sus aplicaciones de manera eficiente. Con una amplia gama de servicios y una comunidad global de usuarios, AWS sigue siendo la opción preferida para muchas organizaciones que buscan aprovechar la potencia de la computación en la nube. Las características avanzadas, la seguridad, la escalabilidad y el modelo de pago por uso hacen de AWS una solución atractiva para una amplia variedad de casos de uso.
