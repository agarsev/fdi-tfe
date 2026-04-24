# fdi-simplex — Plantilla LaTeX para TFG/TFM

Plantilla LaTeX para la memoria del Trabajo de Fin de Grado (TFG) o de
Máster (TFM) de la Facultad de Informática de la Universidad Complutense
de Madrid.

## Archivos

| Archivo | Descripción |
|---|---|
| `fdi-simplex.cls` | Clase LaTeX. Copiar junto al `.tex` principal. |
| `Escudo_UCM.png` | Escudo UCM para la portada. Copiar junto al `.tex` principal. |
| `ejemplo/` | Documentos de ejemplo compilables (`tfg.tex`, `tfm.tex`). |

## Uso rápido

```latex
\documentclass[tfg]{fdi-simplex}   % tfg o tfm

\titulo{Título del trabajo}
\tituloEN{Work title in English}
\autor{Nombre Apellidos}
\director{Prof. Nombre Director}   % \tutor{...} para TFM
\titulacion{Ingeniería Informática}
\cursoAcademico{2024/2025}

\addbibresource{bibliografia.bib}

\begin{document}
\makeportada

\begin{resumen}
  Texto del resumen en castellano.
  \palabrasClave{palabra1, palabra2, ...}
\end{resumen}

\begin{abstract}
  Abstract text in English.
  \keywords{keyword1, keyword2, ...}
\end{abstract}

\tableofcontents

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
| `estilo` | `minimo` \| `texis` | `minimo` | Estilo del cuerpo del documento |
| `portada` | `normativa` \| `texis` | `normativa` | Estilo de la portada |
| `idioma` | `es` \| `en` | `es` | Idioma principal |
| `estilobib` | cualquier estilo biblatex | `authoryear` | Estilo bibliográfico |

### Combinar estilo y portada

`estilo` (cuerpo del documento) y `portada` son ortogonales: cualquier
combinación es válida. Ejemplos:

```latex
\documentclass[tfg]{fdi-simplex}                              % minimo + normativa
\documentclass[tfm, estilo=texis, portada=texis]{fdi-simplex} % clásico TeXiS
\documentclass[tfg, portada=texis]{fdi-simplex}               % cuerpo sobrio, portada clásica
```

- `estilo=minimo` — defaults de KOMA: oneside, sans-serif en títulos,
  cabeceras limpias.
- `estilo=texis` — twoside, serif, cabeceras con regla y versalitas
  (reminiscente de la plantilla TeXiS).
- `portada=normativa` — portada limpia con los campos de la normativa.
- `portada=texis` — título flanqueado por reglas, tipo de documento en
  versalitas bajo el escudo (inspirada en TeXiS).

### Cambiar el estilo bibliográfico

El estilo por defecto es `authoryear` (citas autor-año, p. ej. «García, 2023»).
Para usar otro estilo, pásalo como opción de clase:

```latex
\documentclass[tfg, estilobib=numeric]{fdi-simplex}   % citas numéricas [1]
\documentclass[tfg, estilobib=alphabetic]{fdi-simplex} % citas alfabéticas [Gar23]
```

Los estilos disponibles son los de biblatex; consúltese la
[documentación de biblatex](https://ctan.org/pkg/biblatex).

## Metadatos obligatorios

La normativa exige los siguientes campos en la portada:

- `\titulo{...}` — título en castellano
- `\tituloEN{...}` — título en inglés
- `\autor{...}` — autor/a (repetir para varios autores)
- `\director{...}` o `\tutor{...}` — director (TFG) o tutor (TFM)
- `\titulacion{...}` — nombre de la titulación
- `\cursoAcademico{...}` — curso académico (p. ej. `2024/2025`)

Opcionales para la versión final:

- `\convocatoria{...}` — convocatoria de defensa
- `\calificacion{...}` — calificación obtenida
- `\codirector{...}` / `\cotutor{...}` — codirector o cotutor
- `\colaboradorExterno{...}` — colaborador externo (TFM)
