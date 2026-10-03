= Desarrollo

El cuerpo principal de la memoria describe el trabajo realizado. En este
ejemplo, demostramos algunas construcciones típicas: una cita bibliográfica
@knuth1986 y referencias cruzadas a la @sec:arquitectura. La cita anterior es
parentética (autor y año dentro del paréntesis); cuando el autor ya forma
parte de la frase conviene usar `#cite(..., form: "prose")`, que sólo encierra
el año: #cite(<tolkien1954lord>, form: "prose") cuenta cómo Bilbo decía a
menudo que solo había un camino y que era como un río caudaloso; nacía en el
umbral de todas las puertas, y todos los senderos eran ríos tributarios. «Es
muy peligroso, Frodo, cruzar la puerta», solía decirme. «Vas hacia el Camino,
y si no cuidas tus pasos no sabes hacia donde te arrastrarán».

Las imágenes se guardan en la carpeta `img/` y se incluyen con `#image(...)`
dentro de una `#figure(...)`, que les añade un pie y una etiqueta para poder
referenciarlas, como en la @fig:bolson-cerrado. Si la imagen no es propia, el
pie debe indicar su autoría y procedencia.

// Las rutas son relativas al archivo actual, de ahí el `../`.
#figure(
  image("../img/bolson_cerrado.jpg", width: 80%),
  caption: [Bolsón Cerrado, residencia de los Bolsón, en el decorado de
    Hobbiton (Matamata, Nueva Zelanda). Fotografía de Pseudopanax (2018),
    en dominio público. Fuente: Wikimedia Commons,
    #link("https://commons.wikimedia.org/wiki/File:Baggins_residence_'Bag_End'.jpg").],
) <fig:bolson-cerrado>

== Arquitectura <sec:arquitectura>

La arquitectura del sistema sigue el patrón de separación entre normativa y
estilo. La plantilla `fdi-tippex` implementa los requisitos obligatorios de
la normativa UCM-FDI; el aspecto visual concreto queda delegado a la opción
`estilo`, como resume la @tab:estilos.

#figure(
  table(
    columns: 2,
    align: left,
    table.header[*Estilo*][*Descripción*],
    [`digital`], [Lora, enlaces en color, pensado para leer en pantalla],
    [`clasico`], [Reminiscente de TeXiS, a dos caras],
    [`minimo`], [Casi sin personalizar, para partir de él],
  ),
  caption: [Estilos disponibles en la plantilla.],
) <tab:estilos>

== Implementación

La implementación es un único archivo Typst @madje2022, sin dependencias
externas, que se importa desde el documento principal.
