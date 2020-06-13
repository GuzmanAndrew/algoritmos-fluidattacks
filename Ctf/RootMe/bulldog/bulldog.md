# Machine Bulldog

## Informtion Gathering

1. Primero realizo un escaneo de puerto asi:

```
$ nmap -sV 212.83.175.138
``` 
2. El resultado es el siguiente:

```
PORT     STATE SERVICE VERSION
23/tcp   open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.2
80/tcp   open  http    WSGIServer 0.1 (Python 2.7.12)
8080/tcp open  http    WSGIServer 0.1 (Python 2.7.12)
```

## Analisis de vulnerabilidades

- Luego ejecute **Dirb** de esta manera
```
$ dirb http://212.83.175.138:80
```
- El resultado que me genero son varias URL y la mas importante es esta
```
http://212.83.175.138:80/admin/
http://212.83.175.138:80/dev/
http://212.83.175.138:80/dev/shell/
```
- ya que contiene la URL del panel admin
- Ejecute tambien **Dirb** en el puerto 8080 y el resultado fue el mismo que el del puerto 80
- Tambien ejecute **Gobuster**
```
$ gobuster dir -u http://212.83.175.138/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -x php,txt,html
```
- El resultado de **Gobuster** es este:
```
/admin (Status: 301)
/dev (Status: 301)
/robots.txt (Status: 200)
/notice (Status: 301)
```

## Exploiting

- Probe el puerto **80** y tenia como con una pagina sencilla
- Entonces use el directorio **/dev** que obtuve con **Dirb** y es una pagina con la configuracion y correos de varios usuarios
- Luego ingreso al directorio **/dev/shell** pero tengo que estar autenticado para usarlo
- Reviso el codigo fuente de todas las paginas que encontre y solo la pagina dentro del directorio **/dev** tiene algo muy interesante y son HASH
```
Back End: ashley@bulldogindustries.com<br><!--553d917a396414ab99785694afd51df3a8a8a3e0-->
Back End: nick@bulldogindustries.com<br><br><!--ddf45997a7e18a25ad5f5cf222da64814dd060d5-->
Database: sarah@bulldogindustries.com<br><!--d8b8dd5e7f000b8dea26ef8428caf38c04466b3e-->
```
- Utilizo el **hash-identifier** para ver de ue tipo de HASH son y es de SHA-1
- Luego uso **John the ripper** para decifrar el HASH de esta manera:
```
$ sudo john hash.txt --format=Raw-SHA1
```
- Me genero una contraseña y es **bulldog** así que la probe con varios usuarios y funciono con el usuario **nick**
- Luego fui al directorio **http://212.83.175.138/admin** pero no tiene nada interesante, entonces decido ir otra vez al directorio **/dev/shell** y obtengo un **shell** muy limitada, decido buscar una manera de poder hacer una conexion remota de la **shell**
- Empiezo a buscar en todos los directorios para ver si hay un archivo que sea interesante y encontre uno de nombre **customPermissionApp** y al ejecutar un **Cat** veo que no es de texto asi que uso el comando **strings** y aparece una palabras que al juntarlas forma esto **SUPERultimatePASSWORDyouCANTget**
- Entonces decido usar esa palabra en el **SSH** con el usuario **django**, así:
```
$ ssh -p 23 django@212.83.175.138
```
- Con esto ya tengo una **Shell**, luego ejecuto el comando **sudo -l** para ver los binarios que tiene el usuario **django** y como resultado me sale **(ALL : ALL) ALL**
- Entonces ejecuto un **sudo /bin/bash** y ya soy **root** solo me queda sacar la **Flag**

## Glosario

**APT:** https://latam.kaspersky.com/blog/que-es-apt/761/
**&&:** En pocas palabras sirve para ejecutar una segunda intruccion es similar al comando **;**, ejemplo seria este:
```
Cual es la diferencia entre ; y &&&:
echo "Hello " ; echo "world"
echo "Hello " && echo "world"
```
- **Respuesta:** En el **echo "Hello" ; echo "world"** significa ejecutar **echo "world"** sin importar el estado de salida del comando anterior, **echo "Hello"** es decir, **echo "world"** se ejecutará independientemente del éxito o el fracaso del comando **echo "Hello"**. Pero en el **echo "Hello" && echo "world"**, solo el **echo "world"** se ejecutará si el primer comando **echo "Hello"** es un éxito (es decir, el estado de salida 0).

- Los siguientes comandos dan un ejemplo de cómo el shell maneja la cadena de comandos usando los diferentes operadores:
```
$ false ; echo "OK"
OK
$ true ; echo "OK"
OK
$ false && echo "OK"
$ true && echo "OK"
OK
$ false || echo "OK"
OK
```
**String:** muestra las cadenas de caracteres imprimibles que haya en ficheros, es decir que Para  cada fichero  dado, strings de GNU muestra las secuencias de caracteres imprimibles que sean de al menos 4 caracteres de largo (o del número dado  con  las  opciones  de  más abajo)  y  que  vayan  seguidas por algún carácter no imprimible. De forma predeterminada, sólo muestra las cadenas de las secciones inicializadas y  cargadas  de  ficheros  objeto para otros tipos de ficheros, muestra las cadenas de todo el fichero entero. **strings**  es  útil principalmente para determinar los contenidos de ficheros que no sean de texto plano y un ejemplo es este:
```
$ strings -n 10 ls.ps //muestra secuencias de caracteres que sean de al menos 10 caracteres de largo, en vez de 4 (que es el valor predeterminado).
```
**File:** File determina el tipo de un archivo y te imprime en pantalla el resultado. No hace falta que el archivo tenga una extensión para que File determine su tipo, pues la aplicación ejecuta una serie de pruebas sobre el mismo para tratar de clasificarlo. Un ejemplo seria este:
```
$ file un_archivo_de_texto.txt
```
**LN:** es una aplicación que permite crear enlaces a los archivos, tanto físicos (hard links) como simbólicos (soft links). En pocas palabras, un enlace simbólico es como un acceso directo en Windows o un alias en OSX mientras que un enlace físico es un nombre diferente para la misma información en disco. Para crear un enlace físico ejecutamos:
```
Para crear un enlace físico ejecutamos:

$ ln archivo_origen nombre_enlace

Para crear un enlace simbólico:

$ ln -s archivo_origen nombre_enlace
```
**CPM:** compara el contenido de dos archivos y devuelve 0 si los archivos son idénticos ó 1 si los archivos tienen diferencias. En caso de error devuelve -1.
```
Para ejecutarlo basta con:

$ cmp -s archivo1 archivo2

Cmp también puede mostrar algo de información sobre las diferencias pero para un reporte más detallado tenemos el siguiente comando.
```
**DIFF:** al igual que cmp, compara el contenido de dos archivos pero en lugar de devolver un valor imprime en pantalla un resumen detallado línea a línea de las diferencias. Ejecutarlo es tan simple como:
```
$ diff archivo1.txt archivo2.txt

Diff también puede usarse con directorios. En este caso comparará los nombres de los archivos correspondientes en cada directorio por orden alfabético e imprimirá en pantalla los archivos que estén en un directorio pero no estén en el otro.
```
**WC:** imprime en pantalla la cantidad de saltos de línea, palabras y bytes totales que contenga un archivo. Para usarlo con un archivo cualquiera ejecutamos:
```
$ wc archivo.txt
```
**SORT:** imprime en pantalla las líneas de un archivo ordenadas alfabéticamente. Para ejecutarlo basta con:
```
$ sort archivo.txt
```
**TAIL:** muestra en pantalla las últimas líneas de un archivo.
```
$ tail archivo.txt

Por defecto siempre muestra 10 pero podemos indicarle un número diferente de líneas a visualizar usando el parámetro -n:

$ tail -n 50 archivo.txt
```
**HEAD:** Head es el comando opuesto a tail, muestra las primeras líneas de un archivo.
```
$ head archivo.txt

Al igual que tail, muestra por defecto las 10 primeras líneas pero podemos indicarle un número diferente usando el parámetro -n:

$ head -n archivo.txt
```
**MORE:** More es un filtro que permite paginar el contenido de un archivo para que se vea a razón de una pantalla a la vez. Era muy usado en las viejas terminales cuya resolución era de 80×25 para visualizar archivos muy grandes. Para utilizarlo simplemente ejecutamos:
```
$ more archivo.txt

More permite navegar a través del contenido del archivo usando las flechas direccionales arriba y abajo, Espacio o la tecla Enter. Para salir de more usamos la tecla Q
```
**LESS**
Aunque su nombre es lo opuesto de more es realmente una versión mejorada de éste último. Less es otro filtro que permite paginar el contenido de un archivo pero que además de permitir la navegación hacia adelante y hacia atrás, está optimizado para trabajar con archivos muy grandes.
```
Ejecutarlo es tan simple como escribir:

$ less archivo.txt

Less permite navegar a través del contenido del archivo usando las flechas direccionales arriba y abajo, Espacio o la tecla Enter. Para salir de less también usamos la tecla Q.

Recuerda que para obtener más información sobre los parámetros y la sintaxis de los comandos puedes usar la aplicación man desde la terminal. Por ejemplo:

$ man less
```
## Investigación

http://systemadmin.es/2009/12/diferencia-entre-open-closed-y-filtered-en-nmap

https://www.alvarolara.com/2013/05/24/ejecutar-comandos-en-segundo-plano-en-linux/

https://www.linux-party.com/15-documentacion/10175-ampersands-y-descriptores-de-archivos-en-bash

https://unix.stackexchange.com/questions/187145/whats-the-difference-between-semicolon-and-double-ampersand

## Explotación maquina Ignite

https://hack-ed.net/2017/11/09/bulldog-ctf-walkthrough/
