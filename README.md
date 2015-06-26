# proyecto_linux
**proyecto de "Introducción a la Administración de Sistemas GNU/Linux", ciclo 01/2015**

**Proyecto grupal: programando en Bash**

Integrantes
------------

- Ricardo Francisco Colomé Altamirano, 00054809
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
con ciertos parametros por defecto. Si la creacion falla, el script muestra el error y termina.

Este archivo puede aceptar comentarios y lineas en blanco. Los comentarios inician con un
simbolo de numeral (#) y deben ir en una linea vacia.

El archivo especifica tres parametros: SLEEP, ITER, y PROCS. por ejemplo, un archivo de configuracion con:

```
# este es un comentario!
SLEEP=1
ITER=10
PROCS=5
```

indica que el programa va a mostrar el uso de CPU (aproximadamente) una vez por segundo, que
va a ejecutar 10 iteraciones antes de detenerse, y que va a mostrar los 5 procesos que usen
mas CPU. Si el valor de PROCS es cero, no se muestran los procesos.


El archivo podria estar mal escrito, en cuyo caso el script muestra el error y se detiene.
Por ejemplo, si un archivo dice:

```
# este es un comentario!
SLEP=1
ITER=10
PROCS=0
```

El script detecta el error y muestra el siguiente mensaje:

```
ERROR (/etc/monitorear_cpu.conf): error en las siguientes lineas
SLEP=1
```

luego de lo cual se detiene para que el usuario pueda arreglar el error.

Por ultimo, si hay varias  lineas con la misma instruccion (por ejemplo, asignando valores
diferentes a SLEEP), el script toma la ultima instruccion como la instruccion a ejecutar:

```
SLEEP=1
ITER=2
SLEEP=3
ITER=5
PROCS=1
```

en este caso, SLEEP tendra el valor 3, ITER el valor 5, y PROCS el valor de 1.

si estos valores se especifican mediante la linea de comandos (con las opciones -s, -i, y -n),
estas toman precedencia sobre los valores en el archivo de configuracion