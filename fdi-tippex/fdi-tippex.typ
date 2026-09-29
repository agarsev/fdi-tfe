//----------------------------------------------------------------------
//
//                    ~ FDI TIPPEX ~                  /\
//                                                   /__\
// fdi-tippex.typ                                   /\  /\
//                                                 /__\/__\
//
// Plantilla Typst para Trabajos de Fin de Grado y Fin de Máster de la
// Facultad de Informática de la Universidad Complutense de Madrid.
// Hermana de fdi-simplex (LaTeX): mismas opciones, mismo aspecto.
// No es obligatoria, pero intenta cumplir con la normativa a la vez que
// proporcionar un estilo elegante y un uso sencillo y mínimamente intrusivo.
//
// Licenciada bajo la Licencia Pública de la Unión Europea (EUPL-1.2 or later)
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
//   )
//   #resumen(palabras-clave: [...])[...]
//   #abstract(keywords: [...])[...]
//   #outline()
//   #show: principal
//   = Introducción
//   ...
//   #bibliography("bibliografia.bib")
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
//   logo: <imagen> | none             Escudo de la portada. Para usar otra
//                                     ruta: logo: image("img/escudo.png").
//----------------------------------------------------------------------

#let _estilo = state("fdi-tippex-estilo", "digital")

#let fdi-tippex(
  tipo: "tfg",
  estilo: "digital",
  portada: "normativa",
  idioma: "es",
  estilobib: "chicago-author-date",
  colorenlace: rgb("00559e"),

  titulo: "",
  titulo-en: "",
  autores: (),
  directores: (),
  codirector: "",
  tutor: "",
  cotutor: "",
  colaborador-externo: "",
  titulacion: "",
  curso-academico: "",
  convocatoria: "",
  calificaciones: (),
  logo: image("Escudo_UCM.png"),

  body,
) = {
  assert(tipo in ("tfg", "tfm"), message: "fdi-tippex: tipo debe ser \"tfg\" o \"tfm\"")
  assert(estilo in ("digital", "minimo", "clasico"),
    message: "fdi-tippex: estilo debe ser \"digital\", \"minimo\" o \"clasico\"")
  assert(portada in ("normativa", "elegante", none),
    message: "fdi-tippex: portada debe ser \"normativa\", \"elegante\" o none")
  assert(idioma in ("es", "en"), message: "fdi-tippex: idioma debe ser \"es\" o \"en\"")

  // Admitimos tanto un valor suelto como una lista.
  let como-lista(x) = if type(x) == array { x } else if x in ("", none) { () } else { (x,) }
  let autores = como-lista(autores)
  let directores = como-lista(directores)
  let calificaciones = como-lista(calificaciones)

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
  )

  // Si las fuentes no están instaladas Typst avisa y usa las suyas.
  // Lora: https://fonts.google.com/specimen/Lora
  // IBM Plex Mono: https://fonts.google.com/specimen/IBM+Plex+Mono
  let fuente = if digital { "Lora" } else if clasico { "New Computer Modern" } else { "Libertinus Serif" }
  let fuente-mono = if digital { "IBM Plex Mono" } else { "DejaVu Sans Mono" }

  set text(font: fuente, lang: idioma, size: 11pt)
  show raw: set text(font: fuente-mono)

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
  let escudo = if logo != none {
    set image(height: 3.5cm)
    logo
  }

  // Para TFG "Trabajo de Fin de Grado en X"; para TFM "Máster en X".
  // `titulacion` recibe sólo el nombre, sin "Grado en" ni "Máster en".
  let rotulo = {
    if es-tfg {
      tipo-doc
      if titulacion != "" { rot.en + titulacion }
    } else if titulacion != "" {
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
        if codirector != "" { rol(rot.codirector, (codirector,)) },
      )
    } else {
      (
        if tutor != "" { rol(rot.tutor, (tutor,)) },
        if cotutor != "" { rol(rot.cotutor, (cotutor,)) },
        if colaborador-externo != "" { rol(rot.colab, (colaborador-externo,)) },
      )
    }
    partes.filter(p => p != none).join(v(0.4em))
  }

  // Con una calificación: "Calificación: X". Con varias, emparejadas con
  // los autores: "Autor — Nota" (la i-ésima nota es del i-ésimo autor).
  let bloque-final = {
    if curso-academico != "" [#rot.curso #curso-academico \ ]
    if convocatoria != "" [#rot.convocatoria: #convocatoria \ ]
    if calificaciones.len() == 1 [
      #rot.calificacion: #calificaciones.first()
    ] else if calificaciones.len() > 1 {
      autores.zip(calificaciones).map(((a, c)) => [#a --- #c]).join(linebreak())
    }
  }

  let pagina-portada(contenido) = page(
    margin: (x: 3cm, top: 2.8cm, bottom: 2.5cm),
    header: none,
    footer: none,
    numbering: none,
    align(center, contenido),
  )

  if portada == "normativa" {
    // Layout limpio y funcional con los campos de la normativa.
    pagina-portada({
      escudo
      v(1.2cm)
      text(size: 1.2em, rotulo)
      v(1fr)
      // Algo más estrecho que la caja de texto para que los títulos
      // largos partan en varias líneas legibles.
      block(width: 82%, {
        text(size: 2em, weight: "bold", titulo)
        if titulo-en != "" {
          v(0.4em)
          text(size: 1.45em, style: "italic", titulo-en)
        }
      })
      v(1fr)
      text(size: 1.2em, bloque-autores)
      v(0.8cm)
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
      text(size: 2em, weight: "bold", titulo)
      if titulo-en != "" {
        v(0.2em)
        text(size: 1.45em, style: "italic", titulo-en)
      }
      v(0.4em)
      line(length: 75%, stroke: 0.5mm)
      v(1fr)
      escudo
      v(0.8em)
      text(size: 1.45em, weight: "bold", upper(tipo-doc))
      v(1fr)
      text(size: 1.2em, bloque-autores)
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
  // siguiente empieza en la posterior.
  let en-blanco() = {
    let p = here().page()
    query(<fdi-tippex-fin>).any(m => m.location().page() == p - 1) and query(
      heading.where(level: 1),
    ).any(h => h.location().page() == p + 1)
  }

  let capitulo-actual() = {
    let previos = query(heading.where(level: 1).before(here()))
    if previos.len() == 0 { return none }
    let cap = previos.last()
    if cap.numbering != none [#counter(heading).at(cap.location()).first().#h(0.5em)]
    cap.body
  }

  let num-pagina = context counter(page).display()

  let (cabecera, pie) = if digital {
    (
      context if not abre-capitulo() {
        set text(size: 0.9em)
        capitulo-actual()
        v(-0.6em)
        line(length: 100%, stroke: 0.4pt)
      },
      align(center, text(size: 0.9em, num-pagina)),
    )
  } else if clasico {
    (
      context if not abre-capitulo() and not en-blanco() {
        set text(size: 0.9em)
        let par = calc.even(here().page())
        let marca = smallcaps(capitulo-actual())
        if par { num-pagina; h(1fr); marca } else { marca; h(1fr); num-pagina }
        v(-0.6em)
        line(length: 100%, stroke: 0.2pt)
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
    margin: if clasico {
      (inside: 3.5cm, outside: 2.5cm, top: 3.5cm, bottom: 3cm)
    } else if digital {
      (x: 2.8cm, top: 3.5cm, bottom: 2.8cm)
    } else {
      (x: 2.8cm, y: 2.8cm)
    },
  )
  counter(page).update(1)

  //--------------------------------------------------------------------
  // Párrafos
  //--------------------------------------------------------------------
  // Digital: interlineado holgado y sangría. Clasico: sangría y poca
  // separación. Minimo (KOMA parskip=half-): sin sangría, media línea
  // entre párrafos.
  set par(
    justify: true,
    leading: if digital { 0.8em } else { 0.65em },
    spacing: if digital { 1em } else if clasico { 0.7em } else { 1.2em },
    first-line-indent: if digital { 1em } else if clasico { 1.5em } else { 0em },
  )

  //--------------------------------------------------------------------
  // Títulos
  //
  // Nivel 1 = capítulo: empieza página (impar en el estilo clasico) y
  // reinicia la numeración de figuras, que pasa a ser "capítulo.n".
  //--------------------------------------------------------------------
  set heading(numbering: "1.1.")
  show heading: set text(weight: if digital { "semibold" } else { "bold" })
  show heading.where(level: 1): set heading(supplement: rot.capitulo)

  show heading.where(level: 1): it => {
    [#metadata(none)<fdi-tippex-fin>]
    pagebreak(weak: true, to: if clasico { "odd" })
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)
    set par(justify: false, first-line-indent: 0em)
    let numero = if it.numbering != none { counter(heading).display("1") }
    if clasico {
      v(3em)
      if numero != none {
        text(size: 1.45em, [#rot.capitulo #numero])
        v(0.6em)
      }
      block(text(size: 2em, it.body))
      v(2.5em)
    } else {
      v(if digital { 1em } else { 2em })
      block(text(size: 1.75em, {
        if numero != none [#numero.#h(0.5em)]
        it.body
      }))
      if digital {
        v(-0.5em)
        line(length: 100%, stroke: 0.5pt)
      }
      v(1.5em)
    }
  }

  show heading.where(level: 2): set text(size: 1.2em)
  show heading.where(level: 2): set block(above: 1.8em, below: 1em)
  // Referencias a capítulos y secciones sin el punto final de la
  // numeración ("sección 2.1", no "Sección 2.1.").
  show ref: it => {
    let el = it.element
    if el == none or el.func() != heading { return it }
    let sup = if it.supplement == auto { el.supplement } else { it.supplement }
    if not es-en and type(sup) == content and sup.has("text") { sup = lower(sup.text) }
    let n = counter(heading).at(el.location()).map(str).join(".")
    link(el.location(), [#sup~#n])
  }

  set figure(numbering: n => {
    let cap = counter(heading).get().first()
    numbering("1.1", cap, n)
  })

  //--------------------------------------------------------------------
  // Índice: capítulos en negrita sin puntos, como en KOMA.
  //--------------------------------------------------------------------
  show outline.entry.where(level: 1): it => {
    v(0.9em, weak: true)
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
  set bibliography(style: estilobib)
  show bibliography: set par(first-line-indent: 0em, spacing: 0.8em)

  _estilo.update(estilo)
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
// Resumen / Abstract, palabras clave y contribuciones
//
// La normativa exige ambos, en castellano y en inglés, cada uno con su
// lista de ≤ 10 palabras clave. Aparecen en el índice sin numerar.
//----------------------------------------------------------------------
#let _seccion-previa(titulo, idioma: auto, body) = {
  show heading.where(level: 1): it => {
    [#metadata(none)<fdi-tippex-fin>]
    context pagebreak(weak: true, to: if _estilo.get() == "clasico" { "odd" })
    v(2em)
    align(center, text(size: 1.45em, it.body))
    v(1.5em)
  }
  heading(level: 1, numbering: none, titulo)
  // En el estilo digital el bloque es ligeramente más estrecho.
  let texto = if idioma == auto { body } else { text(lang: idioma, body) }
  context pad(x: if _estilo.get() == "digital" { 1cm } else { 0pt }, texto)
}

#let resumen(palabras-clave: none, body) = _seccion-previa("Resumen", idioma: "es", {
  body
  if palabras-clave != none {
    parbreak()
    par(first-line-indent: 0em)[*Palabras clave:* #palabras-clave]
  }
})

#let abstract(keywords: none, body) = _seccion-previa("Abstract", idioma: "en", {
  body
  if keywords != none {
    parbreak()
    par(first-line-indent: 0em)[*Keywords:* #keywords]
  }
})

// Contribución personal (TFG en grupo: la normativa exige al menos 2
// páginas por autor describiendo su aportación individual al proyecto).
#let contribucion(autor, body) = _seccion-previa([Contribución de #autor], body)
