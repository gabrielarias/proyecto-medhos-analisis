## ⚙️ Configuración del ETL (n8n)

El flujo de trabajo `MEDHOS.json` utiliza el módulo nativo `fs` de Node.js para leer los archivos, debido a que los reportes de SIGA utilizan codificación `Latin1` y separadores de Tabulación inconsistentes que los nodos estándar no procesan correctamente.

**Requisito de Despliegue:**
El contenedor de Docker de n8n debe tener la siguiente variable de entorno habilitada para permitir la ejecución de librerías nativas:
```bash
NODE_FUNCTION_ALLOW_BUILTIN=*