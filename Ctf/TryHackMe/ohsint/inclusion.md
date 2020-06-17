# Machine Inclusion

## Informtion Gathering

1. Primero descargo la imagen que me dan en **TryHackMe**

## Solucion del Reto

- El reto se trata de poder buscar informacion en Google para responder ciertas preguntas que son estas:
```
1. What is this users avatar of?

2. What city is this person in?

3. Whats the SSID of the WAP he connected to?

4. What is his personal email address?

5. What site did you find his email address on?

6. Where has he gone on holiday?

7. What is this persons password?
```
- Primero vamos hacer un escaneo de metadatos de la imagen con la herramienta "Exiftool", asì:
```
$ exiftool WindowsXP.jpg
```
- Hay varios datos y uno mas importante es este
```
Copyright : OWoodflint
```
- Voy a ir a buscar informacion de "OWoodflint" y vemos que tiene un perfil de Twitter, Un Blog y GitHub
- En el perfil de Twitter Hay un "gato" Entonces encontramos la respuesta **1**
- Busco informacion en las redes sociales que encontre y veo que el vive en "London" entonces ya tenemos la **2** respuesta
- La tercera pregunta es ver el **SSID** y para eso vamos a usar la web **https://wigle.net/** que nos da la respuesta de la pregunta **3** es este **UnileverWiFi**
- La respusta de la pregunta **4** es muy facil ya que se encuntra en **Github** el correo y a su vez **Github** es la respuesta de la pregunta **5**
- En el blog puedo ver que esta la respuesta de la pregunta **6** y es **New York**
- Voy al codigo fuente para ver que interesante hay y encontre esto **d19880efda6c951cf284409705cf9fd7503e0938** entonces lo pruebo para la respuesta de la pregunta **7** y no funciona entonces segui buscando y encontre este **pennYDr0pper.!** entonces la probe con la respuesta **7** y funciono

## Glosario

- **SSID:** 
