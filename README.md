# osam-controldeversions-iOS

# README

## ¿Com fer servir el mòdul?
- Per fer servir el mòdul de control de versions, cal afegir al fitxer Podfile la ubicació del repositori:

```
pod 'VersionControl', :git => 'https://github.com/AjuntamentdeBarcelona/osam-controldeversions-ios.git'
```
- i actualitzar mitjançant la comanda 'pod update' les dependències.

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

