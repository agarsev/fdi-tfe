# fdi-tippex — Plantilla Typst para TFG/TFM

Plantilla [Typst](https://typst.app) para la memoria del Trabajo de Fin de
Grado (TFG) o de Máster (TFM) de la Facultad de Informática de la Universidad
Complutense de Madrid. Es la hermana de [fdi-simplex](../fdi-simplex) (LaTeX):
mismas opciones y mismo aspecto, pero en Typst.

## Archivos

| Archivo | Descripción |
|---|---|
| `fdi-tippex.typ` | Plantilla. Copiar junto al `.typ` principal. |
| `Escudo_UCM.png` | Escudo UCM para la portada. Copiar junto a `fdi-tippex.typ`. |
| `ejemplo-tfg/` | Ejemplo de **TFG**: trabajo en grupo, director/codirector, contribuciones individuales (`tfg.typ`, `Makefile`...). |
| `ejemplo-tfm/` | Ejemplo de **TFM**: trabajo individual, tutor/cotutor, colaborador externo, convocatoria, resumen en inglés primero (`tfm.typ`, `Makefile`...). |

## Uso rápido

```typst
#import "fdi-tippex.typ": fdi-tippex, resumen, abstract, contribucion, principal

#show: fdi-tippex.with(
  tipo: "tfg",                          // "tfg" o "tfm"
  titulo: "Título del trabajo",
  titulo-en: "Work title in English",
  autores: ("Nombre Apellidos",),
  directores: ("Prof. Nombre Director",), // tutor: "..." para TFM
  titulacion: "Ingeniería Informática",
  curso-academico: "2024/2025",
)

#resumen(palabras-clave: [palabra1, palabra2, ...])[
  Texto del resumen en castellano.
]

#abstract(keywords: [keyword1, keyword2, ...])[
  Abstract text in English.
]

#outline()

#show: principal   // numeración arábiga desde aquí

= Introducción
...

#bibliography("bibliografia.bib")
```

Compilar con:

```
typst compile memoria.typ
```

o `typst watch memoria.typ` para recompilar al guardar. También se puede usar
directamente en la [aplicación web de Typst](https://typst.app), subiendo
`fdi-tippex.typ` y `Escudo_UCM.png` al proyecto.

Los ejemplos importan la plantilla desde el directorio padre, por lo que
necesitan `--root ..` (el `Makefile` ya lo hace). Si copias la plantilla junto
a tu documento no hace falta.

## Opciones

| Opción | Valores | Defecto | Descripción |
|---|---|---|---|
| `tipo` | `"tfg"` \| `"tfm"` | `"tfg"` | Tipo de documento |
| `estilo` | `"digital"` \| `"minimo"` \| `"clasico"` | `"digital"` | Estilo del cuerpo del documento |
| `portada` | `"normativa"` \| `"elegante"` \| `none` | `"normativa"` | Estilo de la portada (`none`: sin portada, para diseñar una propia) |
| `idioma` | `"es"` \| `"en"` | `"es"` | Idioma principal |
| `estilobib` | cualquier estilo de Typst o archivo `.csl` | `"chicago-author-date"` | Estilo bibliográfico |
| `colorenlace` | un color | `rgb("00559e")` | Color de enlaces, citas y referencias (sólo `digital`) |
| `logo` | una imagen o `none` | `image("Escudo_UCM.png")` | Escudo de la portada |

### Combinar estilo y portada

`estilo` (cuerpo del documento) y `portada` son ortogonales: cualquier
combinación es válida. Ejemplos:

```typst
#show: fdi-tippex.with(tipo: "tfg", ...)                                        // digital + normativa
#show: fdi-tippex.with(tipo: "tfm", estilo: "clasico", portada: "elegante", ...) // inspirado por TeXiS
#show: fdi-tippex.with(tipo: "tfg", estilo: "minimo", ...)                      // base para personalizar
```

El estilo `digital` usa las fuentes [Lora](https://fonts.google.com/specimen/Lora)
e [IBM Plex Mono](https://fonts.google.com/specimen/IBM+Plex+Mono). Si no están
instaladas, Typst avisa y usa las suyas; instálalas o cambia la fuente con
`#set text(font: "...")` tras el `#show: fdi-tippex.with(...)`. En la
aplicación web basta con subir los archivos de la fuente al proyecto.

El estilo `clasico` es a dos caras: los capítulos empiezan en página impar.

### Cambiar el estilo bibliográfico

El estilo por defecto es autor-año (p. ej. «García 2023»). Para usar otro:

```typst
#show: fdi-tippex.with(estilobib: "ieee", ...)          // citas numéricas [1]
#show: fdi-tippex.with(estilobib: "apa", ...)           // estilo APA
```

Los estilos disponibles se listan en la
[documentación de Typst](https://typst.app/docs/reference/model/bibliography/#parameters-style).
Se cita con `@clave` (entre paréntesis) o `#cite(<clave>, form: "prose")`
(cuando el autor forma parte de la frase).

### Cambiar el escudo

La ruta de `image(...)` es relativa al archivo donde se escribe, así que para
usar un escudo guardado en otro sitio hay que pasar la imagen ya creada:

```typst
#show: fdi-tippex.with(logo: image("img/Escudo_UCM.png"), ...)
```

## Metadatos obligatorios

La normativa exige los siguientes campos en la portada:

- `titulo` — título en castellano
- `titulo-en` — título en inglés
- `autores` — autor/a o lista de autores
- `directores` (TFG) o `tutor` (TFM) — uno o varios directores, o el tutor
- `titulacion` — nombre de la titulación, sin «Grado en» ni «Máster en»
- `curso-academico` — curso académico (p. ej. `"2024/2025"`)

Para la versión final:

- `convocatoria` — convocatoria de defensa
- `calificaciones` — calificación obtenida (una por autor, en el mismo orden)
- `codirector` / `cotutor` — codirector o cotutor
- `colaborador-externo` — colaborador externo (TFM)

## Otras funciones

- `resumen(palabras-clave: ..)[...]` y `abstract(keywords: ..)[...]`: resumen
  en castellano e inglés. En el TFG va primero el resumen, en el TFM el
  abstract.
- `contribucion("Autor")[...]`: contribución individual de cada autor en los
  TFG en grupo.
- `#show: principal`: empieza la parte principal (equivale a `\mainmatter`),
  con numeración de páginas arábiga desde 1. Lo anterior va en romanos.

## Crédito y contacto

Licenciado bajo la Licencia Pública de la Unión Europea (EUPL-1.2 or later).

- Antonio F. G. Sevilla <afgs@ucm.es> (Despacho 420bis)
- Versión Typst inicial: [@danpanto](https://github.com/danpanto)
