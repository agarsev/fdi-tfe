#import "../fdi-tippex.typ": fdi-tippex, resumen, abstract, contribucion, principal

#show: fdi-tippex.with(
  tipo: "tfg",
  estilo: "digital",                    // "digital", "clasico" o "minimo"
  portada: "normativa",                 // "normativa", "elegante" o none

  titulo: "Un sistema para ilustrar la plantilla fdi-tippex",
  titulo-en: "A system to showcase the fdi-tippex template",
  autores: ("Frodo Bolsón", "Samsagaz Gamyi"),
  // calificaciones: ("Notable (8)", "Sobresaliente (10)"),  // Poner en la versión final
  directores: ("Gandalf el Gris",),
  // directores: ("Gandalf el Gris", "Elrond Medio-elfo"),   // Puede haber varios,
  // codirector: "Elrond Medio-elfo",                        // o poner uno como codirector

  titulacion: "Ingeniería y esas cosas",
  curso-academico: "2098/2099",
  // convocatoria: "Junio 2099",                             // Poner en la versión final

  // - OPCIONES DE PERSONALIZACIÓN -

  // Usar si se guarda el escudo en otra ubicación
  // logo: image("img/Escudo_UCM.png"),
)

// Para cambiar las fuentes tipográficas
// #set text(font: "Source Serif 4")
// #show raw: set text(font: "Source Code Pro")

#resumen(palabras-clave: [Typst, plantilla, TFG, Facultad de Informática, Universidad Complutense de Madrid])[
  Este documento demuestra el uso de la plantilla `fdi-tippex` para redactar
  la memoria de un Trabajo de Fin de Grado en la Facultad de Informática de la
  Universidad Complutense de Madrid. La plantilla incluye la portada
  normalizada, secciones bilingües para resumen y palabras clave, y
  bibliografía.
]

// En TFG el resumen en castellano va primero. (En TFM, por normativa punto 6,
// el abstract en inglés precede al resumen: véase ../ejemplo-tfm.)
#abstract(keywords: [Typst, template, bachelor's thesis, Computer Science Faculty, Complutense University of Madrid])[
  This document demonstrates the `fdi-tippex` template for writing the report
  of a Bachelor's Thesis at the Faculty of Computer Science of the Complutense
  University of Madrid. The template provides a normalized cover page,
  bilingual abstract and keyword sections, and bibliography support.
]

#outline()

// A partir de aquí la numeración de páginas es arábiga y empieza en 1.
#show: principal

#include "capitulos/introduccion.typ"
#include "capitulos/desarrollo.typ"
#include "capitulos/conclusiones.typ"
// Normativa (TFG, V.4): se requieren conclusiones en inglés.
#include "capitulos/conclusiones-en.typ"

// Normativa (TFG, V.5): en trabajos en grupo cada autor debe incluir al menos
// dos páginas describiendo su contribución personal al proyecto.
#contribucion("Frodo Bolsón")[
  - Aceptar la carga del Anillo
  - Viaje a Rivendel
  - Liderar la Comunidad del Anillo
  - Continuar hacia Mordor en solitario
  - Navegar por terrenos hostiles
  - Resistir la influencia del Anillo
  - Alcanzar la Montaña de la Perdición
  - La Purga de la Comarca
]

#contribucion("Samsagaz Gamyi")[
  - Unirse a la misión de Frodo en la Comarca
  - Cuidar de Frodo durante el viaje
  - Rescatar a Frodo de la telaraña de Ella-Laraña
  - Salvar a Frodo de la Torre de Cirith Ungol
  - Ayudar a Frodo a escalar la Montaña de la Perdición
  - Participar en la Purga de la Comarca
]

#bibliography("bibliografia.bib")
