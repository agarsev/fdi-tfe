# fdi-memoria — Plantilla LaTeX para TFG/TFM

Plantilla LaTeX para la memoria del Trabajo de Fin de Grado (TFG) o de
Máster (TFM) de la Facultad de Informática de la Universidad Complutense
de Madrid.

## Archivos

| Archivo | Descripción |
|---|---|
| `fdi-memoria.cls` | Clase LaTeX. Copiar junto al `.tex` principal. |
| `Escudo_UCM.png` | Escudo UCM para la portada. Copiar junto al `.tex` principal. |
| `ejemplo/` | Documentos de ejemplo compilables (`tfg.tex`, `tfm.tex`). |

## Uso rápido

```latex
\documentclass[tfg]{fdi-memoria}   % tfg o tfm

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
| `estilo` | `minimo` \| `texis` | `minimo` | Estilo visual |
| `idioma` | `es` \| `en` | `es` | Idioma principal |
| `estilobib` | cualquier estilo biblatex | `authoryear` | Estilo bibliográfico |

### Cambiar el estilo bibliográfico

El estilo por defecto es `authoryear` (citas autor-año, p. ej. «García, 2023»).
Para usar otro estilo, pásalo como opción de clase:

```latex
\documentclass[tfg, estilobib=numeric]{fdi-memoria}   % citas numéricas [1]
\documentclass[tfg, estilobib=alphabetic]{fdi-memoria} % citas alfabéticas [Gar23]
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
