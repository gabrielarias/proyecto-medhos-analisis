# proyecto-medhos-analisis

# 🧠 Lógica para el ETL (Python/n8n)

Guarda esto en la documentación de Odoo o en el README, porque es la regla de oro para programar el script de carga en la próxima etapa:

Al leer cada archivo, el código debe preguntar:
¿El nombre empieza con 2_ o 29_?
👉 Mapear columnas 10 y 11 a cod_proveedor y nombre_proveedor.
👉 Dejar deposito_origen como NULL.
¿El nombre empieza con 1_, 17_ o 27_?
👉 Mapear columnas 10 y 11 a deposito_origen_cod y deposito_origen_desc.
👉 Dejar cod_proveedor como NULL.