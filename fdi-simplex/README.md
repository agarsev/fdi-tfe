# fdi-simplex — Plantilla LaTeX para TFG/TFM

(Otra) plantilla LaTeX para la memoria del Trabajo de Fin de Grado (TFG) o de
Máster (TFM) de la Facultad de Informática de la Universidad Complutense de
Madrid.

## Archivos

| Archivo | Descripción |
|---|---|
| `fdi-simplex.cls` | Clase LaTeX. Copiar junto al `.tex` principal. |
| `Escudo_UCM.png` | Escudo UCM para la portada. Copiar junto al `.tex` principal. |

Hay dos ejemplos completos:

- **TFG** (`tfg.tex`): trabajo en grupo, director/codirector, contribuciones
  individuales.
- **TFM** (`tfm.tex`): trabajo individual, tutor/cotutor, colaborador externo,
  `\convocatoria`, resumen en inglés primero.

En el repositorio cada ejemplo está en su carpeta (`ejemplo-tfg/`,
`ejemplo-tfm/`), con un `Makefile` que busca la plantilla en el directorio
padre. En los zips de release la plantilla y el escudo ya están junto al
documento.

## Uso rápido

```latex
\documentclass[tfg]{fdi-simplex}   % tfg o tfm

\titulo{Título del trabajo}
\tituloEN{Work title in English}
\autor{Nombre Apellidos}
\director{Prof. Nombre Director}   % \tutor{...} para TFM
\titulacion{Ingeniería Informática}
\cursoAcademico{2024/2025}
\palabrasClave{palabra1, palabra2, ...}
\keywords{keyword1, keyword2, ...}

\addbibresource{bibliografia.bib}

\begin{document}
\makeportada

\frontmatter      % páginas en números romanos hasta \mainmatter

\begin{resumen}
  Texto del resumen en castellano.
\end{resumen}

\begin{abstract}
  Abstract text in English.
\end{abstract}

\tableofcontents

\mainmatter       % numeración arábiga desde aquí

\chapter{Introducción}
...

\printbibliography[heading=bibintoc]
\end{document}
```

Compilar con **LuaLaTeX** (recomendado) o pdfLaTeX, y **Biber** para la
bibliografía:

```
lualatex memoria.tex
biber memoria
lualatex memoria.tex
lualatex memoria.tex
```

## Opciones de clase

| Opción | Valores | Defecto | Descripción |
|---|---|---|---|
| *(primera)* | `tfg` \| `tfm` | `tfg` | Tipo de documento |
| `estilo` | `digital` \| `minimo` \| `clasico` | `digital` | Estilo del cuerpo del documento |
| `portada` | `normativa` \| `elegante` | `normativa` | Estilo de la portada |
| `idioma` | `es` \| `en` | `es` | Idioma principal |
| `estilobib` | cualquier estilo biblatex | `authoryear` | Estilo bibliográfico |
| `colorenlace` | un color de xcolor o definido con `\definecolor` | `fdiLink` | Color de enlaces, citas y URLs (sólo `digital`) |

Cualquier otra opción se pasa a `scrbook` (p. ej. `twoside`, `12pt`, `DIV=9`).

### Combinar estilo y portada

`estilo` (cuerpo del documento) y `portada` son ortogonales: cualquier
combinación es válida. Ejemplos:

```latex
\documentclass[tfg]{fdi-simplex}                                   % digital + normativa
\documentclass[tfm, estilo=clasico, portada=elegante]{fdi-simplex} % inspirado por TeXiS
\documentclass[tfg, estilo=minimo]{fdi-simplex}                    % KOMA puro para personalizar
```

### Cambiar el estilo bibliográfico

El estilo por defecto es `authoryear` (citas autor-año, p. ej. «García, 2023»).
Para usar otro estilo, pásalo como opción de clase:

```latex
\documentclass[tfg, estilobib=numeric]{fdi-simplex}   % citas numéricas [1]
\documentclass[tfg, estilobib=alphabetic]{fdi-simplex} % citas alfabéticas [Gar23]
```

Los estilos disponibles son los de biblatex; consúltese la
[documentación de biblatex](https://ctan.org/pkg/biblatex).

### Cambiar el escudo

La portada busca `Escudo_UCM` junto al documento. Si se guarda en otro sitio,
se indica la ruta en el preámbulo:

```latex
\logo{img/Escudo_UCM}
```

## Metadatos obligatorios

La normativa exige los siguientes campos en la portada:

- `\titulo{...}` — título en castellano
- `\tituloEN{...}` — título en inglés
- `\autor{...}` — autor/a (repetir para varios autores)
- `\director{...}` o `\tutor{...}` — director (TFG) o tutor (TFM)
- `\titulacion{...}` — nombre de la titulación
- `\cursoAcademico{...}` — curso académico (p. ej. `2024/2025`)

Para la versión final:

- `\convocatoria{...}` — convocatoria de defensa
- `\calificacion{...}` — calificación obtenida
- `\codirector{...}` / `\cotutor{...}` — codirector o cotutor
- `\colaboradorExterno{...}` — colaborador externo (TFM)

## Otros comandos y entornos

- `resumen` y `abstract`: resumen en castellano e inglés. Al final imprimen
  las palabras clave declaradas en el preámbulo con `\palabrasClave` y
  `\keywords`, que van también a los metadatos del PDF. En el TFG va primero
  el resumen, en el TFM el abstract.
- `\begin{contribucion}{Autor} ... \end{contribucion}`: contribución
  individual de cada autor en los TFG en grupo.
- `\frontmatter` y `\mainmatter`: separan las páginas preliminares (resumen,
  índice...), numeradas en romanos, de la parte principal, con numeración
  arábiga desde 1. Sin ellos todo el documento se numera seguido en arábigos.
  `\backmatter` deja sin numerar los capítulos finales.
- `\appendix`: empieza los apéndices. Los capítulos que siguen se numeran
  con letras («Apéndice A», «Figura A.1»...). Normalmente va después de la
  bibliografía.

## Versiones

Las versiones siguen la fecha de publicación, en formato `AA.M.D` (sin ceros a
la izquierda): la `26.10.3` es la del 3 de octubre de 2026. La versión de una
copia de la plantilla se puede consultar en la línea `\ProvidesClass` de
`fdi-simplex.cls`, o en el `.log` de la compilación.

## Crédito y contacto

Licenciado bajo la Licencia Pública de la Unión Europea (EUPL-1.2 or later).

- Antonio F. G. Sevilla <afgs@ucm.es> (Despacho 420bis)
