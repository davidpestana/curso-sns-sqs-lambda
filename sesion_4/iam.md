### IAM: Usuarios, Roles y Políticas

AWS Identity and Access Management (IAM) es el servicio que permite gestionar el acceso a los recursos de AWS de manera segura. A continuación se describen los conceptos clave: usuarios, roles y políticas.

#### Usuarios

**Usuarios de IAM** son entidades creadas en AWS que representan a una persona o una aplicación que interactúa con AWS. Cada usuario tiene credenciales de seguridad y permisos que definen lo que pueden y no pueden hacer dentro de AWS.

- **Tipos de Credenciales:**
  - **Contraseña:** Para acceder a la Consola de Administración de AWS.
  - **Claves de Acceso:** Para acceder a la API de AWS, la CLI o el SDK.
  
- **Grupos de Usuarios:**
  - Los usuarios pueden ser agrupados en grupos de IAM para facilitar la gestión de permisos comunes.

#### Roles

**Roles de IAM** son entidades que definen un conjunto de permisos para realizar acciones en los recursos de AWS. Los roles pueden ser asumidos por usuarios, aplicaciones o servicios que necesiten realizar tareas específicas con los permisos asignados.

- **Asunción de Roles:**
  - Los roles son asumidos temporalmente, lo que permite a las entidades ejecutar acciones con los permisos del rol sin requerir credenciales permanentes.
  
- **Tipos de Roles:**
  - **Roles para Servicios de AWS:** Permiten a los servicios de AWS realizar acciones en nombre del usuario.
  - **Roles para Usuarios Federados:** Permiten a usuarios externos autenticarse en AWS utilizando un proveedor de identidad externo.
  - **Roles para Asunción entre Cuentas:** Permiten a los usuarios de una cuenta AWS acceder a recursos en otra cuenta AWS.

#### Políticas

**Políticas de IAM** son documentos JSON que definen los permisos y restricciones para los usuarios, grupos y roles. Las políticas determinan qué acciones están permitidas en qué recursos y bajo qué condiciones.

- **Tipos de Políticas:**
  - **Políticas Gestionadas por AWS:** Predefinidas y mantenidas por AWS, cubren casos de uso comunes.
  - **Políticas Gestionadas por el Cliente:** Creadas y gestionadas por el cliente para necesidades específicas.
  - **Políticas Inline:** Directamente asociadas a un único usuario, grupo o rol, y no pueden ser reutilizadas.

- **Elementos de una Política:**
  - **Version:** Especifica la versión de la política.
  - **Statement:** Define uno o más permisos.
    - **Effect:** Puede ser "Allow" o "Deny".
    - **Action:** Especifica las acciones que se permiten o deniegan.
    - **Resource:** Especifica los recursos a los que se aplican las acciones.
    - **Condition:** Define las condiciones bajo las cuales se permiten o deniegan las acciones.

#### Buenas Prácticas de IAM

1. **Principio de Privilegios Mínimos:**
   - Asignar solo los permisos necesarios para realizar las tareas requeridas.

2. **Uso de Grupos:**
   - Agrupar usuarios con permisos similares para simplificar la gestión.

3. **Rotación de Claves de Acceso:**
   - Implementar la rotación regular de claves de acceso para mejorar la seguridad.

4. **Multi-Factor Authentication (MFA):**
   - Habilitar MFA para agregar una capa adicional de seguridad.

5. **Revisión y Auditoría:**
   - Revisar y auditar regularmente los permisos y actividades de IAM para asegurar el cumplimiento de las políticas de seguridad.

IAM proporciona una estructura robusta para gestionar de manera segura el acceso a los recursos de AWS, asegurando que solo las entidades autorizadas puedan realizar acciones específicas en los recursos de la nube.