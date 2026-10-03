//----------------------------------------------------------------------
//                                                     _
//                    ~ FDI TIPPEX ~                  |_|
//                                                   /   \
// fdi-tippex.typ                                   |  T  |
//                                                   \___/
//
// Plantilla Typst para Trabajos de Fin de Grado y Fin de Máster de la
// Facultad de Informática de la Universidad Complutense de Madrid.
// Hermana de fdi-simplex (LaTeX): mismas opciones, mismo aspecto.
// No es obligatoria, pero intenta cumplir con la normativa a la vez que
// proporcionar un estilo elegante y un uso sencillo y mínimamente intrusivo.
//
// Licenciada bajo la Licencia Pública de la Unión Europea (EUPL-1.2 or later)
// Autores: - Daniel Pantoja Joaristi
//          - Antonio F. G. Sevilla <afgs@ucm.es>
// Versión: 26.10.3
//
// Uso mínimo:
//
//   #import "fdi-tippex.typ": *
//   #show: fdi-tippex.with(
//     tipo: "tfg",                          // o "tfm"
//     titulo: "Título",
//     titulo-en: "English title",
//     autores: ("Nombre Apellidos",),
//     directores: ("Nombre del Director",), // TFG
//     // tutor: "Nombre del Tutor",         // TFM
//     titulacion: "Ingeniería Informática",
//     curso-academico: "2024/2025",
//     palabras-clave: ("palabra1", "palabra2"),
//     keywords: ("keyword1", "keyword2"),
//   )
//   #resumen[...]
//   #abstract[...]
//   #outline()
//   #show: principal
//   = Introducción
//   ...
//   #bibliography("bibliografia.bib")
//   #show: apendices                        // si hay apéndices
//   = Un apéndice
//
// Opciones:
//   tipo: "tfg" | "tfm"               Tipo de documento (defecto: "tfg")
//   estilo: "digital" | "minimo" | "clasico"
//                                     Estilo del cuerpo (defecto: "digital")
//   portada: "normativa" | "elegante" | none
//                                     Estilo de la portada (defecto:
//                                     "normativa"). Ortogonal a `estilo`.
//                                     Con none no se genera portada.
//   idioma: "es" | "en"               Idioma principal (defecto: "es")
//   estilobib: <estilo CSL>           Estilo bibliográfico (defecto:
//                                     "chicago-author-date"). Otros
//                                     habituales: "apa", "ieee", "nature".
//   colorenlace: <color>              Color de enlaces, citas y referencias
//                                     (sólo estilo digital).
//   logo: auto | <imagen> | none      Escudo de la portada (defecto: auto,
//                                     Escudo_UCM.png junto a la plantilla).
//                                     Para usar otra ruta:
//                                     logo: image("img/escudo.png").
//----------------------------------------------------------------------

#let _estilo = state("fdi-tippex-estilo", "digital")
// Palabras clave en castellano e inglés, para `resumen` y `abstract`.
#let _claves = state("fdi-tippex-claves", (es: (), en: ()))

// Tamaños de fuente: los de fdi-simplex (KOMA-Script a 11pt), de \small
// a \huge, redondeados (el punto de Typst es un 0.4% mayor que el de TeX).
#let _tam = (
  small: 10pt,
  normal: 11pt,
  large: 12pt,
  Large: 14.4pt,
  LARGE: 17.3pt,
  huge: 20.7pt,
)

#let fdi-tippex(
  tipo: "tfg",
  estilo: "digital",
  portada: "normativa",
  idioma: "es",
  estilobib: "chicago-author-date",
  colorenlace: rgb("00559e"),

  titulo: none,
  titulo-en: none,
  autores: (),
  directores: (),
  codirector: none,
  tutor: none,
  cotutor: none,
  colaborador-externo: none,
  titulacion: none,
  curso-academico: none,
  convocatoria: none,
  calificaciones: (),
  palabras-clave: (),
  keywords: (),
  logo: auto,

  body,
) = {
  assert(tipo in ("tfg", "tfm"), message: "fdi-tippex: tipo debe ser \"tfg\" o \"tfm\"")
  assert(estilo in ("digital", "minimo", "clasico"),
    message: "fdi-tippex: estilo debe ser \"digital\", \"minimo\" o \"clasico\"")
  assert(portada in ("normativa", "elegante", none),
    message: "fdi-tippex: portada debe ser \"normativa\", \"elegante\" o none")
  assert(idioma in ("es", "en"), message: "fdi-tippex: idioma debe ser \"es\" o \"en\"")

  // Admitimos tanto un valor suelto como una lista.
  let como-lista(x) = if type(x) == array { x } else if x == none { () } else { (x,) }
  let autores = como-lista(autores)
  let directores = como-lista(directores)
  let calificaciones = como-lista(calificaciones)
  let palabras-clave = como-lista(palabras-clave)
  let keywords = como-lista(keywords)

  let es-en = idioma == "en"
  let es-tfg = tipo == "tfg"
  let digital = estilo == "digital"
  let clasico = estilo == "clasico"

  //--------------------------------------------------------------------
  // Rótulos según idioma. Resumen y abstract no los usan: por normativa
  // van siempre en castellano e inglés respectivamente.
  //--------------------------------------------------------------------
  let rot = if es-en { (
    tfg: "Bachelor's Thesis",
    tfm: "Master's Thesis",
    en: " in ",
    master: "Master's in ",
    facultad: "Faculty of Computer Science, Complutense University of Madrid",
    director: "Supervisor",
    directores: "Supervisors",
    codirector: "Co-supervisor",
    tutor: "Supervisor",
    cotutor: "Co-supervisor",
    colab: "External collaborator",
    curso: "Academic year",
    convocatoria: "Session",
    calificacion: "Grade",
    capitulo: "Chapter",
  ) } else { (
    tfg: "Trabajo de Fin de Grado",
    tfm: "Trabajo de Fin de Máster",
    en: " en ",
    master: "Máster en ",
    facultad: "Facultad de Informática, Universidad Complutense de Madrid",
    director: "Director",
    directores: "Directores",
    codirector: "Codirector",
    tutor: "Tutor",
    cotutor: "Cotutor",
    colab: "Colaborador externo",
    curso: "Curso académico",
    convocatoria: "Convocatoria",
    calificacion: "Calificación",
    capitulo: "Capítulo",
  ) }

  let tipo-doc = if es-tfg { rot.tfg } else { rot.tfm }

  //--------------------------------------------------------------------
  // Metadatos y tipografía base
  //--------------------------------------------------------------------
  set document(
    title: titulo,
    author: autores.filter(a => type(a) == str),
    description: tipo-doc,
    keywords: palabras-clave + keywords,
  )

  // Si las fuentes no están instaladas Typst avisa y usa las suyas.
  // Lora: https://fonts.google.com/specimen/Lora
  // IBM Plex Mono: https://fonts.google.com/specimen/IBM+Plex+Mono
  let fuente = if digital { "Lora" } else if clasico { "New Computer Modern" } else { "Libertinus Serif" }
  let fuente-mono = if digital { "IBM Plex Mono" } else { "DejaVu Sans Mono" }

  set text(font: fuente, lang: idioma, size: _tam.normal)
  show raw: set text(font: fuente-mono)
  // Typst reduce el texto monoespaciado al 80%, que ya iguala la altura
  // de la x de DejaVu Sans Mono con la del cuerpo. IBM Plex Mono es más
  // pequeña: con Lora se igualan al 97% (0.8 × 1.21).
  show raw: set text(size: 1.21em) if digital

  // Interlineado y separación entre párrafos. Digital: holgado. Clasico:
  // poca separación. Minimo (KOMA parskip=half-): media línea entre
  // párrafos.
  let interlineado = if digital { 0.85em } else if clasico { 0.62em } else { 0.58em }
  let entre-parrafos = if digital { 1.1em } else if clasico { 0.71em } else { 1.2em }

  // Márgenes: los de KOMA con DIV=12 (DIV=8 en el estilo clasico). El
  // estilo digital baja 1cm el bloque de texto.
  let margen = if clasico {
    (inside: 3.24cm, outside: 5.08cm, top: 4.63cm, bottom: 4.76cm)
  } else if digital {
    (x: 2.625cm, top: 3.59cm, bottom: 4.85cm)
  } else {
    (x: 2.625cm, top: 2.59cm, bottom: 4.85cm)
  }

  //--------------------------------------------------------------------
  // Portadas
  //
  // Contienen la información obligatoria exigida por la normativa:
  // - Título (castellano e inglés)
  // - Autor(es)
  // - Director/Tutor (+ codirector/cotutor/colaborador externo)
  // - "Tipo en Titulación, Facultad de Informática, UCM"
  // - Curso académico
  // - Convocatoria y calificación si se han definido (versión final)
  //--------------------------------------------------------------------
  // El escudo por defecto se carga aquí, y no como valor por defecto del
  // parámetro, para que la plantilla se pueda importar sin tenerlo al lado.
  let escudo = if portada != none and logo != none {
    set image(height: 3.5cm)
    if logo == auto { image("Escudo_UCM.png") } else { logo }
  }

  // Para TFG "Trabajo de Fin de Grado en X"; para TFM "Máster en X".
  // `titulacion` recibe sólo el nombre, sin "Grado en" ni "Máster en".
  let rotulo = {
    if es-tfg {
      tipo-doc
      if titulacion != none { rot.en + titulacion }
    } else if titulacion != none {
      rot.master + titulacion
    } else {
      tipo-doc
    }
    linebreak()
    rot.facultad
  }

  let bloque-autores = autores.join(linebreak())

  let bloque-direccion = {
    let rol(etiqueta, nombres) = [#etiqueta:\ #nombres.join(linebreak())]
    let partes = if es-tfg {
      (
        if directores.len() > 0 {
          rol(if directores.len() > 1 { rot.directores } else { rot.director }, directores)
        },
        if codirector != none { rol(rot.codirector, (codirector,)) },
      )
    } else {
      (
        if tutor != none { rol(rot.tutor, (tutor,)) },
        if cotutor != none { rol(rot.cotutor, (cotutor,)) },
        if colaborador-externo != none { rol(rot.colab, (colaborador-externo,)) },
      )
    }
    partes.filter(p => p != none).join(v(0.4em))
  }

  // Con una calificación: "Calificación: X". Con varias, emparejadas con
  // los autores: "Autor — Nota" (la i-ésima nota es del i-ésimo autor).
  let bloque-final = {
    if curso-academico != none [#rot.curso #curso-academico \ ]
    if convocatoria != none [#rot.convocatoria: #convocatoria \ ]
    if calificaciones.len() == 1 [
      #rot.calificacion: #calificaciones.first()
    ] else if calificaciones.len() > 1 {
      autores.zip(calificaciones).map(((a, c)) => [#a --- #c]).join(linebreak())
    }
  }

  let pagina-portada(contenido) = page(
    margin: margen,
    header: none,
    footer: none,
    numbering: none,
    {
      set par(leading: interlineado, spacing: 0pt)
      align(center, contenido)
    },
  )

  if portada == "normativa" {
    // Layout limpio y funcional con los campos de la normativa.
    pagina-portada({
      escudo
      v(1.5cm)
      text(size: _tam.large, rotulo)
      v(1fr)
      // Algo más estrecho que la caja de texto para que los títulos
      // largos partan en varias líneas legibles.
      block(width: 82%, {
        text(size: _tam.huge, weight: "bold", titulo)
        if titulo-en != none {
          v(2.1em)
          text(size: _tam.Large, style: "italic", titulo-en)
        }
      })
      v(1fr)
      text(size: _tam.large, bloque-autores)
      v(1.2cm)
      bloque-direccion
      v(1fr)
      bloque-final
    })
  } else if portada == "elegante" {
    // Reminiscente de TeXiS: título flanqueado por reglas, escudo y tipo
    // de documento en mayúsculas. Mismos campos que la normativa.
    pagina-portada({
      v(1fr)
      line(length: 75%, stroke: 0.5mm)
      v(0.4em)
      text(size: _tam.huge, weight: "bold", titulo)
      if titulo-en != none {
        v(0.2em)
        text(size: _tam.Large, style: "italic", titulo-en)
      }
      v(0.4em)
      line(length: 75%, stroke: 0.5mm)
      v(1fr)
      escudo
      v(0.8em)
      text(size: _tam.Large, weight: "bold", upper(tipo-doc))
      v(1fr)
      text(size: _tam.large, bloque-autores)
      v(0.6cm)
      bloque-direccion
      v(1fr)
      rotulo
      v(0.4cm)
      bloque-final
    })
  }
  // En el estilo clasico (a dos caras) la portada lleva el dorso en blanco.
  if clasico and portada != none {
    page(header: none, footer: none, numbering: none, [])
  }

  //--------------------------------------------------------------------
  // Página y cabeceras
  //
  // En las páginas donde empieza un capítulo no hay cabecera. El resto
  // lleva el título del capítulo en curso, salvo las páginas en blanco
  // que deja el estilo clasico para que los capítulos empiecen en impar.
  //--------------------------------------------------------------------
  let abre-capitulo() = query(heading.where(level: 1))
    .any(h => h.location().page() == here().page())

  // En blanco: el capítulo anterior acaba en la página previa y el
  // siguiente empieza en la posterior. La marca de fin tiene que ser la del
  // capítulo que empieza en la posterior: si el salto de página no llega a
  // producirse, la marca cae en la misma página que su capítulo.
  let en-blanco() = {
    let p = here().page()
    query(<fdi-tippex-fin>).any(m => m.location().page() == p - 1 and {
      let sig = query(heading.where(level: 1).after(m.location()))
      sig.len() > 0 and sig.first().location().page() == p + 1
    })
  }

  // Número de un título con su propio patrón ("1.1.", "A.1."...) y sin el
  // punto final. `niveles` lo recorta (1: sólo el número de capítulo).
  let numero-de(el, niveles: none) = {
    let nums = counter(heading).at(el.location())
    if niveles != none { nums = nums.slice(0, niveles) }
    let n = numbering(el.numbering, ..nums)
    if type(n) == str { n.trim(".", at: end) } else { n }
  }

  let capitulo-actual() = {
    let previos = query(heading.where(level: 1).before(here()))
    if previos.len() == 0 { return none }
    let cap = previos.last()
    if cap.numbering != none [#numero-de(cap).#h(0.5em)]
    cap.body
  }

  let num-pagina = context counter(page).display()

  // Cabecera con un filete fino debajo.
  let filete(grosor, contenido) = block(
    width: 100%,
    inset: (bottom: 4.6pt),
    stroke: (bottom: grosor),
    contenido,
  )

  let (cabecera, pie) = if digital {
    (
      context if not abre-capitulo() {
        set text(size: _tam.small)
        filete(0.4pt, capitulo-actual())
      },
      align(center, text(size: _tam.small, num-pagina)),
    )
  } else if clasico {
    (
      context if not abre-capitulo() and not en-blanco() {
        let par = calc.even(here().page())
        let marca = smallcaps(capitulo-actual())
        filete(0.2pt, if par { num-pagina; h(1fr); marca } else { marca; h(1fr); num-pagina })
      },
      context if abre-capitulo() {
        let par = calc.even(here().page())
        align(if par { left } else { right }, num-pagina)
      },
    )
  } else {
    (none, align(center, num-pagina))
  }

  set page(
    paper: "a4",
    numbering: "i",
    header: cabecera,
    footer: pie,
    header-ascent: 23.3pt,
    footer-descent: if digital { 41pt } else if clasico { 37.5pt } else { 40pt },
    margin: margen,
  )
  counter(page).update(1)

  //--------------------------------------------------------------------
  // Párrafos
  //--------------------------------------------------------------------
  // Digital y clasico: sangría en todos los párrafos, también el primero
  // tras un título (como hace babel en castellano). Minimo: sin sangría.
  set par(
    justify: true,
    leading: interlineado,
    spacing: entre-parrafos,
    first-line-indent: (amount: if digital or clasico { 1em } else { 0em }, all: true),
  )

  // Listas: sangradas y con la misma separación que los párrafos.
  set list(indent: 1.6em, body-indent: 0.5em, spacing: entre-parrafos)
  set enum(indent: 1.22em, body-indent: 0.5em, spacing: entre-parrafos)
  show list: set block(spacing: entre-parrafos)
  show enum: set block(spacing: entre-parrafos)

  //--------------------------------------------------------------------
  // Títulos
  //
  // Nivel 1 = capítulo: empieza página (impar en el estilo clasico) y
  // reinicia la numeración de figuras, que pasa a ser "capítulo.n".
  //--------------------------------------------------------------------
  set heading(numbering: "1.1.")
  show heading: set text(weight: if digital { "semibold" } else { "bold" }, size: _tam.normal)
  show heading.where(level: 1): set text(size: _tam.huge)
  show heading.where(level: 2): set text(size: _tam.Large)
  show heading.where(level: 3): set text(size: _tam.large)
  show heading.where(level: 1): set heading(supplement: rot.capitulo)

  // Secciones y niveles inferiores: espacio antes y después del título,
  // por nivel, y un cuadratín entre el número y el texto.
  let aire = if digital {
    ((34pt, 24.5pt), (30pt, 20pt), (29.5pt, 20pt))
  } else if clasico {
    ((26pt, 18.5pt), (22.5pt, 14.5pt), (22.5pt, 14.5pt))
  } else {
    ((31pt, 23.5pt), (27.5pt, 20pt), (27pt, 20pt))
  }
  show heading: it => {
    if it.level == 1 { return it }
    let (antes, despues) = aire.at(calc.min(it.level, 4) - 2)
    block(above: antes, below: despues, sticky: true, {
      if it.numbering != none {
        counter(heading).display(it.numbering)
        h(1em)
      }
      it.body
    })
  }

  show heading.where(level: 1): it => {
    [#metadata(none)<fdi-tippex-fin>]
    pagebreak(weak: true, to: if clasico { "odd" })
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)
    set par(justify: false, first-line-indent: 0em)
    set block(spacing: 0pt)
    let numero = if it.numbering != none { numero-de(it) }
    if clasico {
      v(53.5pt)
      if numero != none {
        block[#it.supplement #numero]
        v(26pt)
      }
      block(it.body)
      v(32.5pt, weak: true)
    } else {
      v(if digital { 66pt } else { 57.5pt })
      block({
        if numero != none [#numero.#h(0.5em)]
        it.body
      })
      if digital {
        v(13.5pt)
        line(length: 100%, stroke: 0.5pt)
      }
      v(if digital { 41.5pt } else { 36pt }, weak: true)
    }
  }

  // Referencias a capítulos y secciones sin el punto final de la
  // numeración ("sección 2.1", no "Sección 2.1.").
  show ref: it => {
    let el = it.element
    if el == none or el.func() != heading { return it }
    // Títulos sin numerar y referencias a la página: lo que haga Typst.
    if el.numbering == none or it.form != "normal" { return it }
    let sup = it.supplement
    if sup == auto {
      // Sólo el rótulo automático va en minúscula en castellano; uno
      // explícito (`@sec[Sección]`) se respeta tal cual.
      sup = el.supplement
      if not es-en and type(sup) == content { sup = lower(sup) }
    } else if type(sup) == function {
      sup = sup(el)
    }
    let n = numero-de(el)
    link(el.location(), if sup in (none, []) { n } else [#sup~#n])
  }

  // Las figuras flotan (arriba o abajo de la página), como en LaTeX.
  // Se numeran por capítulo, con el número del capítulo tal como salga en
  // su título ("Figura 2.1", "Figura A.1" en un apéndice).
  set figure(placement: auto, numbering: n => {
    let caps = query(heading.where(level: 1).before(here()))
    let cap = if caps.len() > 0 and caps.last().numbering != none {
      numero-de(caps.last(), niveles: 1)
    } else {
      counter(heading).get().first()
    }
    [#cap.#n]
  })

  //--------------------------------------------------------------------
  // Índice: capítulos en negrita sin puntos, como en KOMA. Los índices
  // de figuras y tablas (entradas que no son títulos) quedan como están.
  //--------------------------------------------------------------------
  show outline.entry.where(level: 1): it => {
    if it.element.func() != heading { return it }
    v(interlineado + 1em, weak: true)
    let pre = if it.prefix() != none { strong(it.prefix()) }
    link(it.element.location(),
      it.indented(pre, strong(it.body() + h(1fr) + it.page())))
  }

  //--------------------------------------------------------------------
  // Enlaces, citas y referencias
  //
  // Estilo digital: en color, y las URLs además subrayadas. El índice
  // queda sin decorar.
  //--------------------------------------------------------------------
  show link: it => if digital and type(it.dest) == str {
    underline(stroke: 0.5pt + colorenlace, offset: 2pt, text(fill: colorenlace, it))
  } else { it }
  show ref: set text(fill: colorenlace) if digital
  show cite: set text(fill: colorenlace) if digital

  //--------------------------------------------------------------------
  // Bibliografía
  //--------------------------------------------------------------------
  // Algo de aire entre las entradas, que si no quedan apretadas.
  set bibliography(style: estilobib)
  show bibliography: set par(first-line-indent: 0em, spacing: interlineado + 0.6em)

  _estilo.update(estilo)
  _claves.update((es: palabras-clave, en: keywords))
  body
}

//----------------------------------------------------------------------
// Parte principal del documento (equivale a \mainmatter): numeración de
// páginas arábiga empezando en 1. Se usa como
//
//   #show: principal
//
// justo antes del primer capítulo.
//----------------------------------------------------------------------
#let principal(body) = {
  [#metadata(none)<fdi-tippex-fin>]
  context pagebreak(weak: true, to: if _estilo.get() == "clasico" { "odd" })
  set page(numbering: "1")
  counter(page).update(1)
  body
}

//----------------------------------------------------------------------
// Apéndices (equivale a \appendix): los capítulos pasan a numerarse con
// letras y a llamarse "Apéndice". Se usa como
//
//   #show: apendices
//
// antes del primer apéndice, normalmente después de la bibliografía.
//----------------------------------------------------------------------
#let apendices(body) = {
  counter(heading).update(0)
  set heading(numbering: "A.1.")
  show heading.where(level: 1): set heading(
    supplement: context if text.lang == "en" [Appendix] else [Apéndice],
  )
  body
}

//----------------------------------------------------------------------
// Resumen / Abstract, palabras clave y contribuciones
//
// La normativa exige ambos, en castellano y en inglés, cada uno con su
// lista de ≤ 10 palabras clave. Aparecen en el índice sin numerar. Las
// palabras clave se declaran en `fdi-tippex` (van también a los metadatos
// del PDF) y aquí sólo se imprimen.
//----------------------------------------------------------------------
#let _seccion-previa(titulo, idioma: auto, body) = {
  show heading.where(level: 1): it => context {
    let clasico = _estilo.get() == "clasico"
    [#metadata(none)<fdi-tippex-fin>]
    pagebreak(weak: true, to: if clasico { "odd" })
    set block(spacing: 0pt)
    v(if clasico { 53.5pt } else { 59.5pt })
    block(width: 100%, align(center, text(size: _tam.LARGE, it.body)))
    v(if clasico { 36pt } else { 40.5pt }, weak: true)
  }
  heading(level: 1, numbering: none, titulo)
  // En el estilo digital el bloque es ligeramente más estrecho.
  let texto = if idioma == auto { body } else { text(lang: idioma, body) }
  context {
    // El primer párrafo va sin sangría.
    set par(first-line-indent: (amount: par.first-line-indent.amount, all: false))
    pad(x: if _estilo.get() == "digital" { 1cm } else { 0pt }, texto)
  }
}

#let _palabras-clave(rotulo, idioma) = context {
  let palabras = _claves.get().at(idioma)
  if palabras.len() > 0 {
    // Son cadenas, no marcado: sin esto el apóstrofo saldría recto.
    show "'": smartquote(double: false)
    v(0.55em)
    par(first-line-indent: 0em)[*#rotulo:* #palabras.join(", ")]
  }
}

#let resumen(body) = _seccion-previa("Resumen", idioma: "es", {
  body
  _palabras-clave("Palabras clave", "es")
})

#let abstract(body) = _seccion-previa("Abstract", idioma: "en", {
  body
  _palabras-clave("Keywords", "en")
})

// Contribución personal (TFG en grupo: la normativa exige al menos 2
// páginas por autor describiendo su aportación individual al proyecto).
// El `context` va fuera del título para que el marcador del PDF tenga texto.
#let contribucion(autor, body) = context _seccion-previa(
  if text.lang == "en" [Contribution of #autor] else [Contribución de #autor],
  body,
)
