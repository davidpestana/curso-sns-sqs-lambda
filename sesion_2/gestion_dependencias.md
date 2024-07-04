### 2.1. Gestión de Dependencias y Uso de Librerías

---

## Gestión de Dependencias y Uso de Librerías

En esta sección, aprenderás cómo gestionar las dependencias de tu proyecto Java utilizando Maven y cómo integrar bibliotecas externas en tus funciones Lambda. Maven es una herramienta poderosa que simplifica la gestión de dependencias y la construcción de proyectos Java.

### Uso de Maven para Gestionar Dependencias

Maven es una herramienta de gestión de proyectos y comprensión que proporciona un marco completo para el ciclo de vida del desarrollo de software. Te permite gestionar las dependencias de tu proyecto de manera eficiente y asegura que todas las bibliotecas necesarias estén disponibles durante la compilación y el despliegue.

#### Configuración de Maven en el Proyecto

1. **Crear un archivo `pom.xml`:**
   - El archivo `pom.xml` es el archivo de configuración central de Maven. Define las propiedades del proyecto, sus dependencias y los plugins necesarios para la construcción.

   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>

       <groupId>com.example</groupId>
       <artifactId>lambda-project</artifactId>
       <version>1.0-SNAPSHOT</version>

       <dependencies>
           <dependency>
               <groupId>com.amazonaws</groupId>
               <artifactId>aws-lambda-java-core</artifactId>
               <version>1.2.1</version>
           </dependency>
           <dependency>
               <groupId>com.amazonaws</groupId>
               <artifactId>aws-lambda-java-events</artifactId>
               <version>3.9.0</version>
           </dependency>
           <dependency>
               <groupId>com.amazonaws</groupId>
               <artifactId>aws-java-sdk-s3</artifactId>
               <version>1.12.118</version>
           </dependency>
           <dependency>
               <groupId>junit</groupId>
               <artifactId>junit</artifactId>
               <version>4.12</version>
               <scope>test</scope>
           </dependency>
       </dependencies>

       <build>
           <plugins>
               <plugin>
                   <groupId>org.apache.maven.plugins</groupId>
                   <artifactId>maven-compiler-plugin</artifactId>
                   <version>3.8.0</version>
                   <configuration>
                       <source>1.8</source>
                       <target>1.8</target>
                   </configuration>
               </plugin>
               <plugin>
                   <groupId>org.apache.maven.plugins</groupId>
                   <artifactId>maven-shade-plugin</artifactId>
                   <version>3.2.1</version>
                   <executions>
                       <execution>
                           <phase>package</phase>
                           <goals>
                               <goal>shade</goal>
                           </goals>
                           <configuration>
                               <createDependencyReducedPom>false</createDependencyReducedPom>
                               <transformers>
                                   <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                       <mainClass>com.example.LambdaHandler</mainClass>
                                   </transformers>
                               </configuration>
                       </execution>
                   </executions>
               </plugin>
           </plugins>
       </build>
   </project>
   ```

   Este archivo `pom.xml` incluye las dependencias necesarias para AWS Lambda y el SDK de AWS, así como el plugin de compilación y el plugin shade para empaquetar el proyecto en un JAR ejecutable.

#### Manejo de Dependencias Comunes

1. **AWS Lambda Core:**
   - La biblioteca central de AWS Lambda proporciona las clases y interfaces necesarias para crear funciones Lambda.

2. **AWS Lambda Events:**
   - Esta biblioteca contiene las definiciones de los eventos que puede manejar una función Lambda, como eventos de S3, DynamoDB, SNS, etc.

3. **AWS SDK para Java:**
   - El SDK de AWS para Java proporciona bibliotecas para interactuar con otros servicios de AWS desde tus funciones Lambda, como S3, DynamoDB, SQS, etc.

4. **JUnit:**
   - JUnit es una biblioteca de pruebas unitarias para Java que facilita la creación y ejecución de pruebas automatizadas.

### Integración de Bibliotecas Externas en Funciones Lambda

Para integrar bibliotecas externas en tus funciones Lambda, debes asegurarte de incluir todas las dependencias en el archivo JAR desplegado. Maven y el plugin shade hacen este proceso sencillo.

#### Pasos para Integrar Bibliotecas Externas

1. **Agregar la Dependencia en `pom.xml`:**
   - Añade las dependencias necesarias en el archivo `pom.xml` como se muestra en la sección anterior.

2. **Configurar el Plugin Shade:**
   - El plugin shade se utiliza para empaquetar todas las dependencias en un único archivo JAR ejecutable.

   ```xml
   <build>
       <plugins>
           <plugin>
               <groupId>org.apache.maven.plugins</groupId>
               <artifactId>maven-shade-plugin</artifactId>
               <version>3.2.1</version>
               <executions>
                   <execution>
                       <phase>package</phase>
                       <goals>
                           <goal>shade</goal>
                       </goals>
                       <configuration>
                           <createDependencyReducedPom>false</createDependencyReducedPom>
                           <transformers>
                               <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                   <mainClass>com.example.LambdaHandler</mainClass>
                               </transformers>
                           </configuration>
                   </execution>
               </executions>
           </plugin>
       </plugins>
   </build>
   ```

3. **Construir y Empaquetar el Proyecto:**
   - Ejecuta el siguiente comando para construir y empaquetar el proyecto en un archivo JAR:

   ```sh
   mvn clean package
   ```

4. **Desplegar el Archivo JAR en AWS Lambda:**
   - Sube el archivo JAR generado a AWS Lambda a través de la consola de AWS o utilizando AWS CLI.

   ```sh
   aws lambda update-function-code --function-name MyLambdaFunction --zip-file fileb://target/lambda-project-1.0-SNAPSHOT.jar
   ```

### Ejemplo Práctico: Función Lambda que Usa AWS SDK

**Código de Ejemplo:**

```java
package com.example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;

public class LambdaHandler implements RequestHandler<String, String> {

    private final AmazonS3 s3Client = AmazonS3ClientBuilder.defaultClient();

    @Override
    public String handleRequest(String input, Context context) {
        String bucketName = "my-bucket";
        String objectKey = "example.txt";

        // Obtener el objeto desde S3
        String content = s3Client.getObjectAsString(bucketName, objectKey);
        return content.toUpperCase();
    }
}
```

**Instrucciones:**

1. **Agregar Dependencias en `pom.xml`:**
   - Asegúrate de que las dependencias para `aws-lambda-java-core`, `aws-lambda-java-events` y `aws-java-sdk-s3` estén incluidas en tu archivo `pom.xml`.

2. **Construir el Proyecto:**
   - Usa `mvn clean package` para empaquetar el proyecto en un archivo JAR.

3. **Desplegar la Función Lambda:**
   - Usa AWS CLI para desplegar el archivo JAR en AWS Lambda.

---

Este archivo `gestion_dependencias.md` proporciona una guía completa sobre cómo gestionar dependencias en un proyecto Java utilizando Maven y cómo integrar bibliotecas externas en funciones Lambda. Esto incluye la configuración de Maven, el manejo de dependencias comunes y el uso del plugin shade para empaquetar todas las dependencias en un único archivo JAR ejecutable.