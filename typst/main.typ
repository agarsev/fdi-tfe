#import "fdi-simplex.typ": fdi-simplex, resumen, abstract, contribucion

// ----------------------------------------------------------------------
// Configuración de metadatos del TFG
// ----------------------------------------------------------------------
#show: fdi-simplex.with(
  tipo: "tfg",
  estilo: "minimo",                  // Opciones: "digital", "clasico", "minimo"
  portada: "normativa",                // Opciones: "normativa", "elegante"
  idioma: "es",

  titulo: "Un sistema para ilustrar la plantilla fdi-simplex",
  titulo-en: "A system to showcase the fdi-simplex template",

  // Múltiples autores (Frodo Bolsón y Samsagaz Gamyi)
  autores: (
    "Frodo Bolsón",
    "Samsagaz Gamyi",
  ),
  // calificaciones: ("Notable (8)", "Sobresaliente (10)"), // Descomentar en versión final

  // Directores / Codirectores
  directores: (
    "Gandalf el Gris",
    // "Elrond Medio-elfo",             // Se pueden añadir más directores
  ),
  // codirector: "Elrond Medio-elfo",   // O establecer como codirector explícito

  titulacion: "Ingeniería y esas cosas",
  curso-academico: "2098/2099",
  // convocatoria: "Junio 2099",         // Descomentar en versión final

  logo: "Escudo_UCM.png",               // Ruta de la imagen del escudo UCM
)

// ----------------------------------------------------------------------
// Resumen y Abstract
// ----------------------------------------------------------------------

#resumen(
  palabras-clave: "LaTeX, plantilla, TFG, Facultad de Informática, Universidad Complutense de Madrid"
)[
  Este documento demuestra el uso de la plantilla `fdi-simplex`
  para redactar la memoria de un Trabajo de Fin de Grado en la
  Facultad de Informática de la Universidad Complutense de Madrid. La
  plantilla incluye la portada normalizada, entornos bilingües para
  resumen y palabras clave, e integración con bibliografía.
]

// En TFG el resumen en castellano va primero. (En TFM el abstract en inglés precede al resumen)
#abstract(
  keywords: "LaTeX, template, bachelor's thesis, Computer Science Faculty, Complutense University of Madrid"
)[
  This document demonstrates the `fdi-simplex` template for
  writing the report of a Bachelor's Thesis at the Faculty of
  Computer Science of the Complutense University of Madrid. The
  template provides a normalized cover page, bilingual abstract and
  keyword environments, and bibliography integration.
]

// ----------------------------------------------------------------------
// Índice de contenidos
// ----------------------------------------------------------------------

#outline(indent: auto)

// ----------------------------------------------------------------------
// Cuerpo principal del TFG (Capítulos)
// ----------------------------------------------------------------------

// Puedes separar los capítulos en archivos externos e incluirlos con #include:
// #include "capitulos/introduccion.typ"
// #include "capitulos/desarrollo.typ"
// #include "capitulos/conclusiones.typ"
// #include "capitulos/conclusiones-en.typ"

= Introducción

En este capítulo se presenta la introducción del proyecto...

= Desarrollo

En este capítulo se detalla el diseño y desarrollo del sistema...

= Conclusiones

En este capítulo se presentan las conclusiones obtenidas...

== Conclusions (en inglés)

// Normativa (TFG, V.4): se requieren conclusiones en inglés.
In this section, the main conclusions of the project are presented in English...

// ----------------------------------------------------------------------
// Contribuciones individuales (Trabajos en grupo)
// ----------------------------------------------------------------------

// Normativa (TFG, V.5): en trabajos en grupo cada autor debe incluir al menos
// dos páginas describiendo su contribución personal al proyecto.

#contribucion(autor: "Frodo Bolsón")[
  - Aceptar la carga del Anillo
  - Viaje a Rivendel
  - Liderar la Comunidad del Anillo
  - Continuar hacia Mordor en solitario
  - Navegar por terrenos hostiles
  - Resistir la influencia del Anillo
  - Alcanzar la Montaña de la Perdición
  - La Purga de la Comarca
]

#contribucion(autor: "Samsagaz Gamyi")[
  - Unirse a la misión de Frodo en la Comarca
  - Cuidar de Frodo durante el viaje
  - Rescatar a Frodo de la telaraña de Ella-Laraña
  - Salvar a Frodo de la Torre de Cirith Ungol
  - Ayudar a Frodo a escalar la Montaña de la Perdición
  - Participar en la Purga de la Comarca
]

// ----------------------------------------------------------------------
// Bibliografía
// ----------------------------------------------------------------------

// Si dispones de tu archivo .bib:
// #bibliography("bibliografia.bib", style: "ieee")
// 