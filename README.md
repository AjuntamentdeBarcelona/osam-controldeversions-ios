# osam-controldeversions-iOS

# README
# CA
## Com utilitzar el mòdul?
- Per utilitzar el mòdul de control de versions, cal afegir l'arxiu Podfile la ubicació del repositori:

```
pod 'VersionControl', :git => 'https://github.com/AjuntamentdeBarcelona/osam-controldeversions-ios.git', :tag => '1.3.3'
```

- Actualitzar mitjançant el comandament 'pod update' les dependències.


## Introducció
Aquest mòdul mostrarà un popup a la pantalla quan el servei detecti que hi ha una nova versió de l'app.

Aquesta alerta la podem mostrar amb un missatge i amb o sense botons de confirmació d'accions.

Tindrem tres diferents tipus d'alerta:
  1. popup amb un missatge i / o un títol, sense botons que vaig bloquejar l'app completament.
  2. popup amb un missatge i / o un títol, amb botó de "ok" que un cop fet clic redirigirà l'usuari a una url.
  3. popup amb un missatge i / o un títol, amb botons de "ok" i "cancel". Si fem clic al botó de cancel·lar l'alerta desapareixerà, i si ho fem al de confirmar s'obrirà una url.
  
## Descàrrega dels mòduls
Des Osam es proporcionen mòduls per realitzar un conjunt de tasques comunes a totes les apps publicades per l'Ajuntament de Barcelona.
El mòdul de Control de Versions (IOS / Android) està disponible com a repositori a:

https://github.com/AjuntamentdeBarcelona/osam-controldeversions-ios


## Implementació
Per crear el missatge d'alerta, únicament hem de Cridar a la funció indicada a continuació, i aquesta descarregarà el json amb les variables ja definides i mostrarà l'alerta segons els valors rebuts:

```
  NSString *actionURL = @”http://serviceurl.com”;
  [_T2 1GenericAlert showAlertWithService:actionURL withLanguage:@"es" andCompletionBlock:^(NSError *error) {
      if (error) {
        NSLog(@"%@", error);
      }
  }];
```
Nota: "http://serviceurl.com" serà la url on es troba el json amb la configuració de l'alerta a mostrar. Substituir per la URL correcta.

## Format fitxer JSON
```
    {
        "version": "2.1.1",
        "comparisonMode": "0",
        "minSystemVersion": "5.0",
        "title": {
            "es": "Título de la alerta",
            "cat": "Títol de la alerta",
            "en": "Alert title"
        },
        "message": {
           "es": "Prueba en castellano.",
           "cat": "Prova en català.",
           "en": "Test in english."
       },
      "okButtonTitle": {
          "es": "Vale",
          "cat": "Val",
          "en": "Ok"
     },
     "cancelButtonTitle": {
          "es": "Cancelar",
          "cat": "Cancel·lar",
          "en": "Cancel"
     },
     "okButtonActionURL": "http://www.apple.com <http://www.apple.com/> "
   }
```

## Paràmetres
- versio
  - Obligatori
  - Especifica la versió mínima de l'aplicació que volem que es comprovi, per a totes aquelles versions menors (estrictament) a aquesta, es mostrarà l'alerta de control de versió i per a la resta no es mostrarà res.
- comparisonMode
  - Obligatori
  - Especifica la manera de comparació de la versió de l'app amb el mòdul
- minSystemVersion
  - Obligatori
  - Especifica a partir que versió del sistema es mostrarà l'alerta.
- title
  - Obligatori
  - Títol de l'alerta en el cas que s'hagi de mostrar.
- message
  - Obligatori
  - Missatge de l'alerta en cas que s'hagi de mostrar.
- okButtonTitle
  - Opcional
  - Títol del botó d'acceptar.
  - Si es rep aquest paràmetre juntament amb el paràmetre okButtonActionURL, es mostrarà en l'alerta un botó d'acceptar que obrirà el link que s'ha especificat en el paràmetre okButtonActionURL.
- okButtonActionURL
  - Opcional
  - Link que s'obrirà quan l'usuari seleccioni el botó d'acceptar. Per exemple: link de la nova versió de l'aplicació a l'App Store / Google Play.
  - Si es rep aquest paràmetre juntament amb el paràmetre okButtonTitle, es mostrarà en l'alerta un botó d'acceptar que obrirà el link que s'hagi especificat.
- cancelButtonTitle
  - Opcional
  - Títol del botó de cancel·lar.
  - Si es rep aquest paràmetre es mostrarà en l'alerta un botó de cancel·lar que permetrà a l'usuari tancar l'alerta i continuar utilitzant l'aplicació amb normalitat.
  
## Com funciona el mòdul de control de versions
Depenent del valor del paràmetre "comparisonMode" mostrarem l'alerta.

Aquest paràmetre compararà la versió instal·lada amb la qual rebem del json, en funció de tres valors:

  0. -> Mostra l'alerta a les apps amb un nombre de versió menor que el rebut de l'json
  1. -> Mostra l'alerta en les apps que tinguin el mateix valor que el rebut de l'json
  2. -> Mostra l'alerta en les apps amb un nombre de versió major que el rebut de l'json

A més, es comprovarà que la versió del SO sigui com a mínim la indicada en el fitxer de configuració.

# ES
## ¿Cómo utilizar el módulo?
- Para utilizar el módulo de control de versiones, hay que añadir al archivo Podfile la ubicación del repositorio:

```
pod 'VersionControl', :git => 'https://github.com/AjuntamentdeBarcelona/osam-controldeversions-ios.git'
```
- Actualizar mediante el comando 'pod update' las dependencias.

## Introducción
Este módulo mostrará un popUp en la pantalla cuando el servicio detecte que hay una nueva versión de la app.

Esta alerta la podemos mostrar con un mensaje y con o sin botones de confirmación de acciones.

Tendremos tres diferentes tipos de alerta:
  1. popUp con un mensaje y/o un título, sin botones que bloqueé la app completamente.
  2. popUp con un mensaje y/o un título, con botón de “ok” que una vez hecho click redirigirá al usuario a una url.
  3. popUp con un mensaje y/o un título, con botones de “ok” y “cancel”. Si hacemos click al botón de cancelar la alerta desaparecerá, y si lo hacemos al de confirmar se abrirá una url.


## Descarga de los módulos
Desde Osam se proporcionan módulos para realizar un conjunto de tareas comunes a todas las apps publicadas por el Ayuntamiento de Barcelona.
El módulo de Control de Versiones (IOS / Android) está disponible como repositorio en:

https://github.com/AjuntamentdeBarcelona/osam-controldeversions-ios

## Implementación
Para crear el mensaje de alerta, únicamente tenemos que cridar a la función indicada a continuación, y esta descargará el json con las variables ya definidas y mostrará la alerta según los valores recibidos:

```
  NSString *actionURL = @”http://serviceurl.com”;
  [_T2 1GenericAlert showAlertWithService:actionURL withLanguage:@"es" andCompletionBlock:^(NSError *error) {
      if (error) {
        NSLog(@"%@", error);
      }
  }];
```
Nota: “http://serviceurl.com” será la url donde se encuentra el json con la configuración de la alerta a mostrar. Sustituir por la url correcta.

## Formato fichero JSON

```
    {
        "version": "2.1.1",
        "comparisonMode": "0",
        "minSystemVersion": "5.0",
        "title": {
            "es": "Título de la alerta",
            "cat": "Títol de la alerta",
            "en": "Alert title"
        },
        "message": {
           "es": "Prueba en castellano.",
           "cat": "Prova en català.",
           "en": "Test in english."
       },
      "okButtonTitle": {
          "es": "Vale",
          "cat": "Val",
          "en": "Ok"
     },
     "cancelButtonTitle": {
          "es": "Cancelar",
          "cat": "Cancel·lar",
          "en": "Cancel"
     },
     "okButtonActionURL": "http://www.apple.com <http://www.apple.com/> "
   }
```

## Parámetros
- version
  - Obligatorio
  - Especifica la versión mínima de la aplicación que queremos que se compruebe, para todas aquellas versiones menores (estrictamente) a esta, se mostrará la alerta de control de versión y para el resto no se mostrará nada.
- comparisonMode
  - Obligatorio
  - Especifica el modo de comparación de la versión de la app con el módulo
- minSystemVersion
  - Obligatorio
  - Especifica a partir de que versión del sistema se mostrará la alerta.
- title
  - Obligatorio
  - Título de la alerta en el caso que se tenga que mostrar.
- message
  - Obligatorio
  - Mensaje de la alerta en caso que se tenga que mostrar.
- okButtonTitle
  - Opcional
  - Título del botón de aceptar.
  - Si se recibe este parámetro juntamente con el parámetro okButtonActionURL, se mostrará en la alerta un botón de aceptar que abrirá el link que se ha especificado en el parámetro okButtonActionURL.
- okButtonActionURL
  - Opcional
  - Link que se abrirá cuando el usuario seleccione el botón de aceptar. Por ejemplo: link de la nueva versión de la aplicación a l'App Store / Google Play.
  - Si se recibe este parámetro juntamente con el parámetro okButtonTitle, se mostrará en la alerta un botón de aceptar que abrirá el link que se haya especificado.
- cancelButtonTitle
  - Opcional
  - Título del botón de cancelar.
  - Si se recibe este parámetro se mostrará en la alerta un botón de cancelar que permitirá al usuario cerrar la alerta y continuar utilizando la aplicación con normalidad.

## Cómo funciona el módulo de control de versiones
Dependiendo del valor del parámetro “comparisonMode” mostraremos la alerta.

Este parámetro comparará la versión instalada con la que recibimos del json, en función de tres valores:

  0. --> Muestra la alerta en las apps con un número de versión menor que el recibido del json
  1. --> Muestra la alerta en les apps que tengan el mismo valor que el recibido del json
  2. --> Muestra la alerta en les apps con un número de versión mayor que el recibido del json

Además, se comprobará que la versión del SO sea como mínimo la indicada en el fichero de configuración.

