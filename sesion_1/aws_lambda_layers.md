# Uso de Lambda Layers

## Qué son los Lambda Layers
Los Lambda Layers son archivos ZIP que contienen bibliotecas, dependencias u otro código que puede ser reutilizado en múltiples funciones Lambda. Estos Layers permiten mantener el tamaño de tus despliegues de funciones Lambda bajo control al externalizar las dependencias comunes. Al usar Layers, puedes separar el código que cambia frecuentemente de las bibliotecas y dependencias que cambian con menos frecuencia, optimizando así el proceso de desarrollo y despliegue.

### Características Principales
- **Reutilización**: Permiten compartir código común entre múltiples funciones Lambda, evitando duplicación de código.
- **Gestión Simplificada**: Facilitan la gestión y actualización de bibliotecas y dependencias.
- **Reducción del Tamaño de Despliegue**: Ayudan a reducir el tamaño del paquete de despliegue de las funciones Lambda.

## Beneficios de Usar Layers
- **Reutilización de Código**: Puedes crear un Layer una vez y reutilizarlo en múltiples funciones Lambda, lo que facilita la gestión del código compartido.
- **Mantenimiento Simplificado**: Actualizar una biblioteca o dependencia en un solo Layer y no en cada función Lambda individualmente.
- **Optimización del Despliegue**: Al reducir el tamaño del paquete de despliegue, las funciones Lambda pueden desplegarse más rápidamente y con menos errores.
- **Organización del Código**: Mejora la estructura del código al separar las dependencias de la lógica principal.

## Casos de Uso Comunes
### 1. Bibliotecas Compartidas
Cuando múltiples funciones Lambda requieren la misma biblioteca, puedes empaquetar esta biblioteca en un Layer. Por ejemplo, si tienes varias funciones que utilizan `requests` para realizar llamadas HTTP, puedes crear un Layer con esta biblioteca y asociarlo a todas esas funciones.

### 2. Modelos de Machine Learning
Si estás utilizando modelos de machine learning que requieren bibliotecas pesadas como TensorFlow o PyTorch, puedes empaquetar estas bibliotecas en un Layer. Esto es especialmente útil si necesitas actualizar el modelo o las bibliotecas sin cambiar la lógica de la función Lambda.

### 3. Configuración de Entornos
Para funciones Lambda que requieren configuraciones específicas del entorno, como variables de entorno, archivos de configuración o scripts de inicio, puedes usar Layers para gestionar estos componentes de manera centralizada.

## Pasos para Crear un Lambda Layer
### 1. Crear un Directorio Local y Agregar Dependencias
Primero, crea un directorio en tu máquina local que contendrá las dependencias necesarias para tu función Lambda.

```sh
mkdir python
pip install requests -t python/
```

### 2. Empaquetar el Directorio en un Archivo ZIP
Empaqueta el directorio en un archivo ZIP. Este archivo contendrá todas las dependencias que tu función Lambda necesitará.

```sh
zip -r layer.zip python/
```

### 3. Subir el Archivo ZIP a AWS Lambda como un Layer
Publica el archivo ZIP como un Layer en AWS Lambda usando la AWS CLI.

```sh
aws lambda publish-layer-version --layer-name requests-layer --zip-file fileb://layer.zip --compatible-runtimes python3.8
```

## Adjuntar un Layer a una Función Lambda
### 1. En la Consola de AWS Lambda
- Ve a la configuración de tu función Lambda.
- En la sección de Layers, selecciona "Add a layer".
- Elige el Layer creado anteriormente.

### 2. Usando la AWS CLI
También puedes adjuntar un Layer a una función Lambda utilizando la AWS CLI.

```sh
aws lambda update-function-configuration --function-name my-function --layers arn:aws:lambda:us-west-2:123456789012:layer:requests-layer:1
```

## Ejemplo de Código
Aquí tienes un ejemplo de una función Lambda que utiliza la biblioteca `requests` desde un Layer.

```python
import requests

def lambda_handler(event, context):
    response = requests.get("https://api.github.com")
    return {
        'statusCode': 200,
        'body': response.json()
    }
```

En este ejemplo, la función Lambda realiza una solicitud HTTP a la API de GitHub y devuelve la respuesta en formato JSON. Este código es más eficiente al utilizar un Layer, ya que la biblioteca `requests` está incluida en el Layer y no en el paquete de despliegue de la función Lambda, reduciendo así el tamaño del despliegue y mejorando la gestión de dependencias.