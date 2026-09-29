// fdi-simplex.typ — Plantilla para Typst

#let fdi-simplex(
  tipo: "tfg",
  estilo: "digital",
  portada: "normativa",
  idioma: "es",
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
  logo: "Escudo_UCM.png",
  
  body
) = {

  let list-autores = if type(autores) == array { autores } else if autores != "" { (autores,) } else { () }
  let list-directores = if type(directores) == array { directores } else if directores != "" { (directores,) } else { () }
  let list-calificaciones = if type(calificaciones) == array { calificaciones } else if calificaciones != "" { (calificaciones,) } else { () }

  let is-en = idioma == "en"
  let is-tfg = tipo == "tfg"

  let text-tipo-doc = if is-tfg {
    if is-en { "Bachelor's Thesis" } else { "Trabajo de Fin de Grado" }
  } else {
    if is-en { "Master's Thesis" } else { "Trabajo de Fin de Máster" }
  }

  let text-rotulo = {
    if is-tfg {
      let prefijo = if is-en { " in " } else { " en " }
      text-tipo-doc + if titulacion != "" { prefijo + titulacion } else { "" }
    } else {
      let prefijo = if is-en { "Master's in " } else { "Máster en " }
      if titulacion != "" { prefijo + titulacion } else { text-tipo-doc }
    }
  }

  let text-facultad = if is-en {
    "Faculty of Computer Science, Complutense University of Madrid"
  } else {
    "Facultad de Informática, Universidad Complutense de Madrid"
  }

  let text-director-label = if is-en {
    if list-directores.len() > 1 { "Supervisors:" } else { "Supervisor:" }
  } else {
    if list-directores.len() > 1 { "Directores:" } else { "Director:" }
  }

  let text-codirector-label = if is-en { "Co-supervisor:" } else { "Codirector:" }
  let text-tutor-label = if is-en { "Supervisor:" } else { "Tutor:" }
  let text-cotutor-label = if is-en { "Co-supervisor:" } else { "Cotutor:" }
  let text-colab-label = if is-en { "External collaborator:" } else { "Colaborador externo:" }
  let text-curso-label = if is-en { "Academic year" } else { "Curso académico" }
  let text-convocatoria-label = if is-en { "Session:" } else { "Convocatoria:" }
  let text-calificacion-label = if is-en { "Grade:" } else { "Calificación:" }

  // Tipografías
  let font-body = if estilo == "digital" { "Lora" } else if estilo == "clasico" { "Linux Libertine" } else { "Liberation Serif" }
  let font-mono = if estilo == "digital" { "IBM Plex Mono" } else { "DejaVu Sans Mono" }

  set document(title: titulo, author: list-autores.join(", "))

  let render-directores = [
    #if is-tfg [
      #if list-directores.len() > 0 [
        #text-director-label \
        #list-directores.join("\n") \
      ]
      #if codirector != "" [
        #v(0.4em)
        #text-codirector-label \ #codirector \
      ]
    ] else [
      #if tutor != "" [
        #text-tutor-label \ #tutor \
      ]
      #if cotutor != "" [
        #v(0.4em)
        #text-cotutor-label \ #cotutor \
      ]
      #if colaborador-externo != "" [
        #v(0.4em)
        #text-colab-label \ #colaborador-externo \
      ]
    ]
  ]

  let render-final = [
    #if convocatoria != "" [#text-convocatoria-label #convocatoria \ ]
    #if list-calificaciones.len() > 0 [
      #if list-autores.len() > 1 and list-calificaciones.len() > 1 [
        #for i in range(0, calc.min(list-autores.len(), list-calificaciones.len())) [
          #list-autores.at(i) --- #list-calificaciones.at(i) \
        ]
      ] else [
        #text-calificacion-label #list-calificaciones.at(0) \
      ]
    ]
  ]

  // ----------------------------------------------------------------------
  // PORTADA ---------------------------------------------------------
  if portada == "normativa" {
    page(
      paper: "a4",
      margin: (top: 2.8cm, bottom: 2.5cm, left: 3cm, right: 3cm),
      header: none,
      footer: none
    )[
      #set align(center)
      #set text(font: font-body)
      
      // Escudo
      #if logo != "" {
        image(logo, height: 3.5cm)
      }
      
      #v(1.2cm)
      
      // Rótulo
      #text(size: 1.15em)[
        #text-rotulo \
        #text-facultad
      ]
      
      #v(1.8fr)
      
      // Títulos
      #block(width: 82%)[
        #text(size: 2em, weight: "bold", titulo)
        
        #if titulo-en != "" {
          v(0.8em)
          // Misma fuente Serif, romana/normal (sin cursiva)
          text(size: 1.3em, weight: "regular", titulo-en)
        }
      ]
      
      #v(2fr)
      
      // Autores
      #text(size: 1.2em, list-autores.join("\n"))
      
      #v(0.8cm)
      
      // Directores
      #text(size: 1em, render-directores)
      
      #v(1.5fr)
      
      // Curso y Calificación
      #text(size: 1em)[
        #if curso-academico != "" [#text-curso-label #curso-academico \ ]
        #render-final
      ]
    ]
  }

  // Resto del documento
  set text(font: font-body, lang: idioma, size: 11pt)
  show raw: set text(font: font-mono)

  show link: it => {
    if estilo == "digital" {
      text(fill: colorenlace, underline(stroke: 0.5pt + colorenlace, evade: true, it))
    } else {
      it
    }
  }

  set par(justify: true, leading: 0.7em, first-line-indent: 1.2em)

  set page(
    paper: "a4",
    margin: (top: 2.8cm, bottom: 2.8cm, left: 3cm, right: 3cm),
    header: context {
      if estilo == "minimo" { return none }
      let page-num = counter(page).get().first()
      let headings = query(heading.where(level: 1))
      let is-chapter = headings.any(h => h.location().page() == page-num)
      
      if not is-chapter {
        set text(size: 9pt, style: "italic")
        grid(
          columns: (1fr, auto),
          align(left)[#titulo],
          align(right)[#counter(page).display()]
        )
        v(-0.4em)
        line(length: 100%, stroke: 0.4pt + luma(120))
      }
    },
    footer: context {
      let page-num = counter(page).get().first()
      let headings = query(heading.where(level: 1))
      let is-chapter = headings.any(h => h.location().page() == page-num)

      if is-chapter or estilo == "minimo" {
        align(center, text(size: 10pt, counter(page).display()))
      }
    }
  )

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(2em)
    text(size: 1.8em, weight: "bold", fill: black, it)
    v(-0.2em)
    line(length: 100%, stroke: 1.2pt + black)
    v(1.5em)
  }

  body
}

#let resumen(palabras-clave: "", body) = {
  pagebreak(weak: true)
  v(2em)
  align(center, text(size: 1.5em, weight: "bold", "Resumen"))
  v(1.2em)
  block(width: 100%, body)
  if palabras-clave != "" {
    v(1em)
    text(weight: "bold", "Palabras clave: ") + palabras-clave
  }
}

#let abstract(keywords: "", body) = {
  pagebreak(weak: true)
  v(2em)
  align(center, text(size: 1.5em, weight: "bold", "Abstract"))
  v(1.2em)
  block(width: 100%, body)
  if keywords != "" {
    v(1em)
    text(weight: "bold", "Keywords: ") + keywords
  }
}

#let contribucion(autor: "", body) = {
  pagebreak(weak: true)
  v(2em)
  align(center, text(size: 1.5em, weight: "bold", [Contribución de #autor]))
  v(1.2em)
  block(width: 100%, body)
}