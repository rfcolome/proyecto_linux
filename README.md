# proyecto_linux
proyecto de "Introducción a la Administración de Sistemas GNU/Linux", ciclo 01/2015

Introducción a la Administración de Sistemas GNU/Linux ­ ciclo 01/2015

Proyecto grupal: programando en Bash

Introducción

Un shell script es un programa que debe ser ejecutado por una consola (Bash,
usualmente) y que contiene un conjunto de comandos con determinado fin.

La gran ventaja de los shell scripts en Bash es que se puede combinar todo el
potencial de los comandos y las ventajas de Bash, como patrones,
redireccionamiento y listas de procesos, con estructuras de control propias 
de un lenguaje de programación. 

Los shell scripts son muy comunes en un sistema GNU/Linux y su uso es tan
diverso que va desde tareas tan cruciales como el arranque del sistema hasta
la configuración o instalación de alguna aplicación utilitaria.

Trabajo por realizar

El proyecto consiste en elaborar un pequeño shell script en Bash, que realice
una tarea específica de las siguientes:

1. Monitorear el uso de CPU durante un lapso de tiempo determinado.

2. Monitorear el uso de memoria durante un lapso de tiempo determinado.

3. Monitorear el uso del espacio en disco durante un lapso de tiempo
determinado.

4. Monitorear los procesos en ejecución por usuario durante un lapso de
tiempo determinado.

5. Monitorear el tráfico de la red durante un lapso de tiempo determinado.

6. Generar estadísticas del espacio utilizado en disco por un determinado
directorio en un momento específico.

7. Generar estadísticas de los archivos existentes en un determinado
directorio en un momento específico, agrupando los resultados por similitud
(imágenes, documentos, etc.).

8. Generar estadísticas a partir de archivos de log de algún servidor, por
ejemplo un servidor web, proxy, etc.

9. Algún otro tema similar propuesto por el grupo que deberá ser sometido a
aprobación del profesor del curso.

Importante: cada grupo deberá elegir uno de los temas previos y notificarlo al
profesor de la materia con copia a todos los compañeros del curso.

El shell script debe incluir lo siguiente:

- Validar que todo lo que el script necesite para funcionar correctamente está
presente en el sistema, por ejemplo, permisos de lectura o escritura sobre
archivos o directorios, presencia de un determinado comando requerido,
etc. Por ejemplo, podría validarse permisos de escritura sobre /var o la
presencia del comando convert.

- Leer y verificar al menos un archivo de configuración propio ubicado en el
directorio /etc y que contenga al menos 3 variables configurables en dicho
archivo y que modifiquen el comportamiento del script; el archivo deberá
soportar comentarios. Por ejemplo, el archivo de configuración puede
contener la siguiente línea indicando que su comportamiento será recursivo
(1) o no (0):

recursivo 1

- Analizar (“parsear”) al menos 3 parámetros cortos o largos utilizando
getopts. Dos de estos parámetros pueden tener el mismo significado que las
variables del punto anterior y en ese caso tendrán precedencia sobre dichas
variables. Obligatoriamente uno de los parámetros debe ser ­h ó ­­help y
debe mostrar una breve explicación del shell script y sus posibles
parámetros.

- Generar datos propios del programa relacionados con la tarea que éste
realice y almacenarlos en /var, según convenga.

- Escribir mensajes de error y auditoría utilizando las facilidades y niveles
adecuados del comando logger.

Por ejemplo, ante un error encontrado en el archivo de configuración, el
programa deberá dejar registro en los logs de dicha anomalía.

- Puntos extra: subir, desde un inicio, el proyecto a alguna plataforma de
gestión de código fuente como Github, Assembla u otro similar, de tal forma
que pueda verse ahí la evolución del proyecto y la participación de todos
los integrantes del grupo. Entregar, vía correo electrónico o memoria USB:

- Código del shell script desarrollado.

- Ejemplos de archivos de configuración documentando las variables soportadas
y sus posibles valores.

- Ejemplos de archivos de salida generados por el shell script.

- Alguna breve documentación sobre el shell script que consideren necesaria.

- Ruta del repositorio donde pueda clonarse (en el caso de optar por los
puntos extras).

Fecha de entrega: viernes 26/junio.

Evaluación

- Cada uno de los ítems listados anteriormente (validaciones, archivos de
configuración, parámetros, generar datos y uso de logs): 2% (total 10%).

- Cumplimiento de la tarea encomendada: 5%.

- Puntos extra: 3%.

