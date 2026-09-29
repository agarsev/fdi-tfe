#import "../fdi-tippex.typ": fdi-tippex, resumen, abstract, principal

#show: fdi-tippex.with(
  tipo: "tfm",
  estilo: "digital",                    // "digital", "clasico" o "minimo"
  portada: "normativa",                 // "normativa", "elegante" o none

  titulo: "Un sistema para ilustrar la plantilla fdi-tippex",
  titulo-en: "A system to showcase the fdi-tippex template",

  autores: "Meriadoc Brandigamo",
  tutor: "Gandalf el Gris",
  cotutor: "Elrond Medio-elfo",
  colaborador-externo: "Aragorn hijo de Arathorn (Gondor S.A.)",

  // `titulacion` recibe solo el nombre del máster, sin el prefijo "Máster
  // en": la portada añade "Máster en ..." automáticamente en el TFM.
  titulacion: "Ingeniería Informática",
  curso-academico: "2098/2099",

  // --- Campos de la VERSIÓN FINAL (normativa) ---
  // `convocatoria` y `calificaciones` solo se rellenan al depositar la
  // versión definitiva; aquí van activos para mostrar cómo aparecen.
  convocatoria: "Junio de 2099",
  calificaciones: "10 (Sobresaliente)",

  // - OPCIONES DE PERSONALIZACIÓN -

  // Usar si se guarda el escudo en otra ubicación
  // logo: image("img/Escudo_UCM.png"),
)

// Para cambiar las fuentes tipográficas
// #set text(font: "Source Serif 4")
// #show raw: set text(font: "Source Code Pro")

// Normativa (TFM, punto 6): en el TFM el resumen en INGLÉS va primero, al
// contrario que en el TFG. Por eso `abstract` precede a `resumen`.
#abstract(keywords: [Typst, template, master's thesis, Computer Science Faculty, Complutense University of Madrid])[
  This document demonstrates the `fdi-tippex` template for writing the report
  of a Master's Thesis at the Faculty of Computer Science of the Complutense
  University of Madrid. The template provides a normalized cover page,
  bilingual abstract and keyword sections, and bibliography support. For a
  Master's thesis the regulations ask for an English abstract of roughly half
  a page, placed before the Spanish one.
]

#resumen(palabras-clave: [Typst, plantilla, TFM, Facultad de Informática, Universidad Complutense de Madrid])[
  Este documento demuestra el uso de la plantilla `fdi-tippex` para redactar
  la memoria de un Trabajo de Fin de Máster en la Facultad de Informática de
  la Universidad Complutense de Madrid. La plantilla incluye la portada
  normalizada, secciones bilingües para resumen y palabras clave, y
  bibliografía.
]

#outline()

#show: principal

#include "capitulos/introduccion.typ"
#include "capitulos/desarrollo.typ"
#include "capitulos/conclusiones.typ"
#include "capitulos/conclusiones-en.typ"

// A diferencia del TFG, el TFM es individual: no lleva `contribucion`
// (reservada a los trabajos en grupo).

#bibliography("bibliografia.bib")
