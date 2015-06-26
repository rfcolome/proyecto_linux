# proyecto_linux
**proyecto de "Introducción a la Administración de Sistemas GNU/Linux", ciclo 01/2015**

**Proyecto grupal: programando en Bash**

Integrantes
------------

- Ricardo Francisco Colome Altamirano, 00054809
- Diego Alberto Arana Vaquerano, 00017912


Trabajo por realizar
--------------------

El proyecto consiste en elaborar un pequeño shell script en Bash, que realice
la siguiente tarea:

Monitorear el uso de CPU durante un lapso de tiempo determinado.


Sobre el archivo de configuracion
-------------------------------------

El script realizado lee el archivo de configuracion /etc/monitorear_cpu.conf, el cual podría
no haberse creado al ejecutar el script. En caso de no encontrarse, el script intenta crearlo
con ciertos parametros por defecto.