%%----------------------------------------------------------------------
%% fdi-simplex.cls
%%
%% Plantilla LaTeX para Trabajos de Fin de Grado y Fin de Máster
%% de la Facultad de Informática de la Universidad Complutense de Madrid.
%%
%% Pensada para LuaLaTeX (soporte moderno de Unicode / fontspec),
%% con compatibilidad razonable con pdfLaTeX como alternativa.
%%
%% Uso mínimo:
%%
%%   \documentclass[tfg]{fdi-simplex}         % o [tfm]
%%   \titulo{Título}
%%   \tituloEN{English title}
%%   \autor{Nombre Apellidos}
%%   \director{Nombre del Director}          % TFG
%%   % \tutor{Nombre del Tutor}              % TFM
%%   \titulacion{Grado en Ingeniería Informática}
%%   \cursoAcademico{2024/2025}
%%   \addbibresource{bibliografia.bib}
%%   \begin{document}
%%   \makeportada
%%   \begin{resumen} ... \palabrasClave{...} \end{resumen}
%%   \begin{abstract} ... \keywords{...} \end{abstract}
%%   \tableofcontents
%%   \chapter{Introducción} ...
%%   \printbibliography
%%   \end{document}
%%
%% Opciones de clase:
%%   tfg | tfm               Tipo de documento (defecto: tfg)
%%   estilo=minimo|texis     Estilo del cuerpo (defecto: minimo)
%%   portada=normativa|texis Estilo de la portada (defecto: normativa).
%%                           Es ortogonal a `estilo`: puede combinarse
%%                           cualquier portada con cualquier estilo.
%%   idioma=es|en            Idioma principal (defecto: es)
%%   estilobib=<style>       Estilo biblatex (defecto: authoryear)
%%                           Otros valores habituales: numeric, alphabetic.
%%                           Véase https://biblatex-biber.sourceforge.net/
%%   cualquier otra opción se pasa a scrbook.
%%----------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{fdi-simplex}[2026/04/17 v0.2 Plantilla TFG/TFM Facultad de Informática UCM]

%%----------------------------------------------------------------------
%% 1. Opciones de clase
%%----------------------------------------------------------------------
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=tfe, prefix=tfe@}

\DeclareBoolOption[true]{tfg}
\DeclareBoolOption{tfm}
\DeclareStringOption[minimo]{estilo}
\DeclareStringOption[normativa]{portada}
\DeclareStringOption[es]{idioma}
\DeclareStringOption[authoryear]{estilobib}

\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{scrbook}}
\ProcessKeyvalOptions*\relax

% tfm implica !tfg
\iftfe@tfm \tfe@tfgfalse \fi

%%----------------------------------------------------------------------
%% 2. Clase base: scrbook (KOMA-Script). Usamos scrbook en lugar de
%%    scrreport para disponer de \frontmatter/\mainmatter/\backmatter.
%%    Por defecto forzamos oneside para un aspecto digital; el estilo
%%    texis reactiva twoside más abajo. parskip=half- da media línea
%%    entre párrafos sin sangría; DIV=12 da márgenes generosos.
%%----------------------------------------------------------------------
\LoadClass[11pt, a4paper, oneside, DIV=12, parskip=half-, numbers=noenddot]{scrbook}

%%----------------------------------------------------------------------
%% 3. Motor y paquetes base
%%----------------------------------------------------------------------
\RequirePackage{iftex}
\RequirePackage{etoolbox}

\ifluatex
  \RequirePackage{fontspec}
\else\ifxetex
  \RequirePackage{fontspec}
\else
  % Fallback pdfLaTeX
  \RequirePackage[utf8]{inputenc}
  \RequirePackage[T1]{fontenc}
  \RequirePackage{lmodern}
\fi\fi

\RequirePackage{microtype}

% Babel: idioma principal configurable
\ifdefstring{\tfe@idioma}{en}{%
  \RequirePackage[spanish, main=english]{babel}%
}{%
  \RequirePackage[english, main=spanish, es-tabla, es-noshorthands]{babel}%
}

\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{csquotes}

%%----------------------------------------------------------------------
%% 4. Almacén de metadatos
%%----------------------------------------------------------------------

% Título en castellano: reutilizamos \title de KOMA.
\let\titulo\title

% Título en inglés
\newcommand{\tituloEN}[1]{\def\@tituloEN{#1}}
\def\@tituloEN{}

% Autor: almacén propio que admite varias llamadas (una por autor).
% Guarda lista con \\ para portada y versión plana para metadatos PDF.
% Cada autor también se almacena en \tfe@autor@N para emparejar con notas.
\def\tfe@autores{}
\def\tfe@autoresPlain{}
\newcounter{tfe@nautores}
\newcommand{\autor}[1]{%
  \stepcounter{tfe@nautores}%
  \expandafter\def\csname tfe@autor@\the\value{tfe@nautores}\endcsname{#1}%
  \ifx\tfe@autores\@empty
    \def\tfe@autores{#1}%
    \def\tfe@autoresPlain{#1}%
  \else
    \expandafter\def\expandafter\tfe@autores\expandafter{\tfe@autores\\#1}%
    \expandafter\def\expandafter\tfe@autoresPlain\expandafter{\tfe@autoresPlain, #1}%
  \fi
  \def\@author{\tfe@autoresPlain}%
}

% Director / Codirector (TFG)
\newcommand{\director}[1]{\def\tfe@director{#1}}
\newcommand{\codirector}[1]{\def\tfe@codirector{#1}}
\def\tfe@director{}
\def\tfe@codirector{}

% Tutor / Cotutor / Colaborador externo (TFM)
\newcommand{\tutor}[1]{\def\tfe@tutor{#1}}
\newcommand{\cotutor}[1]{\def\tfe@cotutor{#1}}
\newcommand{\colaboradorExterno}[1]{\def\tfe@colabExt{#1}}
\def\tfe@tutor{}
\def\tfe@cotutor{}
\def\tfe@colabExt{}

% Titulación (grado o máster concreto)
\newcommand{\titulacion}[1]{\def\tfe@titulacion{#1}}
\def\tfe@titulacion{}

% Curso académico y convocatoria (solo en versión final según normativa).
\newcommand{\cursoAcademico}[1]{\def\tfe@curso{#1}}
\newcommand{\convocatoria}[1]{\def\tfe@convocatoria{#1}}
\def\tfe@curso{}
\def\tfe@convocatoria{}

% Calificación: admite varias llamadas (una por autor), paralelas a \autor.
% La i-ésima \calificacion corresponde al i-ésimo \autor.
% Si hay varios autores y sólo una calificación se emite un aviso.
\newcounter{tfe@ncalificaciones}
\newcounter{tfe@ical}   % contador de iteración para portadaFinal
\newcommand{\calificacion}[1]{%
  \stepcounter{tfe@ncalificaciones}%
  \expandafter\def\csname tfe@cal@\the\value{tfe@ncalificaciones}\endcsname{#1}%
}

% Palabras clave
\newcommand{\palabrasClave}[1]{\def\tfe@palabrasClave{#1}}
\newcommand{\keywords}[1]{\def\tfe@keywords{#1}}
\def\tfe@palabrasClave{}
\def\tfe@keywords{}

%%----------------------------------------------------------------------
%% 4.b Rótulos según idioma
%%
%% Textos que aparecen en la portada y otros elementos generados por la
%% plantilla. Se eligen en carga de clase según \tfe@idioma. Los entornos
%% `resumen` y `abstract` NO usan estos macros: por normativa siempre van
%% en castellano e inglés respectivamente.
%%----------------------------------------------------------------------
\ifdefstring{\tfe@idioma}{en}{%
  \def\tfe@text@tipoDocTFG{Bachelor's Thesis}%
  \def\tfe@text@tipoDocTFM{Master's Thesis}%
  \def\tfe@text@enTitulacion{ in }%
  \def\tfe@text@prefijoMaster{Master's in }%
  \def\tfe@text@facultad{Faculty of Computer Science, Complutense University of Madrid}%
  \def\tfe@text@director{Supervisor}%
  \def\tfe@text@codirector{Co-supervisor}%
  \def\tfe@text@tutor{Supervisor}%
  \def\tfe@text@cotutor{Co-supervisor}%
  \def\tfe@text@colabExt{External collaborator}%
  \def\tfe@text@cursoAcademico{Academic year}%
  \def\tfe@text@convocatoria{Session}%
  \def\tfe@text@calificacion{Grade}%
}{%
  \def\tfe@text@tipoDocTFG{Trabajo de Fin de Grado}%
  \def\tfe@text@tipoDocTFM{Trabajo de Fin de Máster}%
  \def\tfe@text@enTitulacion{ en }%
  \def\tfe@text@prefijoMaster{Máster en }%
  \def\tfe@text@facultad{Facultad de Informática, Universidad Complutense de Madrid}%
  \def\tfe@text@director{Director}%
  \def\tfe@text@codirector{Codirector}%
  \def\tfe@text@tutor{Tutor}%
  \def\tfe@text@cotutor{Cotutor}%
  \def\tfe@text@colabExt{Colaborador externo}%
  \def\tfe@text@cursoAcademico{Curso académico}%
  \def\tfe@text@convocatoria{Convocatoria}%
  \def\tfe@text@calificacion{Calificación}%
}

% Tipo de documento (derivado de las opciones e idioma)
\iftfe@tfg
  \let\tfe@tipoDoc\tfe@text@tipoDocTFG
\else
  \let\tfe@tipoDoc\tfe@text@tipoDocTFM
\fi

% Logo de portada. El estudiante puede redefinir la ruta con \logo{...}
% si guarda el escudo en otra ubicación (p. ej. \logo{img/Escudo_UCM}).
\newcommand{\logo}[1]{\def\tfe@logo{#1}}
\def\tfe@logo{Escudo_UCM}

%%----------------------------------------------------------------------
%% 5. Portada normativa
%%
%% Contiene la información obligatoria exigida por la normativa:
%% - Título (castellano e inglés)
%% - Autor(es)
%% - Director/Tutor (+ codirector/cotutor/colaborador externo)
%% - "Tipo en Titulación, Facultad de Informática, UCM"
%% - Curso académico
%% - Convocatoria y calificación si se han definido (versión final)
%%
%% El aspecto visual varía ligeramente según la opción `estilo`.
%%----------------------------------------------------------------------

\newcommand{\tfe@portadaEscudo}{%
  \includegraphics[height=3.5cm]{\tfe@logo}%
}

% Rótulo según normativa: para TFG "Trabajo de Fin de Grado en X",
% para TFM se mantiene el tipo y se añade "Máster en X".
% Nótese que `\titulacion` recibe solo el nombre de la titulación
% (p. ej. "Ingeniería Informática"), sin el prefijo "Grado en" ni
% "Máster en".
\newcommand{\tfe@portadaRotulo}{%
  \iftfe@tfg
    \tfe@tipoDoc%
    \ifdefempty{\tfe@titulacion}{%
      \ClassWarning{fdi-simplex}{Falta \string\titulacion{...}}%
    }{\tfe@text@enTitulacion \tfe@titulacion}%
  \else
    \ifdefempty{\tfe@titulacion}{%
      \ClassWarning{fdi-simplex}{Falta \string\titulacion{...}}%
    }{\tfe@text@prefijoMaster \tfe@titulacion}%
  \fi
  \\
  \tfe@text@facultad%
}

\newcommand{\tfe@portadaDirector}{%
  \iftfe@tfg
    \ifdefempty{\tfe@director}{%
      \ClassWarning{fdi-simplex}{Falta \string\director{...}}%
    }{\tfe@text@director:\\ \tfe@director}%
    \ifdefempty{\tfe@codirector}{}{\\[0.4em] \tfe@text@codirector:\\ \tfe@codirector}%
  \else
    \ifdefempty{\tfe@tutor}{%
      \ClassWarning{fdi-simplex}{Falta \string\tutor{...}}%
    }{\tfe@text@tutor:\\ \tfe@tutor}%
    \ifdefempty{\tfe@cotutor}{}{\\[0.4em] \tfe@text@cotutor:\\ \tfe@cotutor}%
    \ifdefempty{\tfe@colabExt}{}{\\[0.4em] \tfe@text@colabExt:\\ \tfe@colabExt}%
  \fi
}

% Renderiza calificaciones emparejadas con autores.
% Con una sola calificación: "Calificación: X". Con varias: "Autor — Nota"
% por pares (la i-ésima calificación corresponde al i-ésimo autor).
\newcommand{\tfe@portadaFinal}{%
  \ifdefempty{\tfe@convocatoria}{}{\tfe@text@convocatoria: \tfe@convocatoria\par}%
  \ifnumequal{\value{tfe@ncalificaciones}}{0}{}{%
    \ifnumgreater{\value{tfe@nautores}}{1}{%
      \ifnumless{\value{tfe@ncalificaciones}}{\value{tfe@nautores}}{%
        \ClassWarning{fdi-simplex}{%
          Hay \the\value{tfe@nautores}\space autores pero solo
          \the\value{tfe@ncalificaciones}\space calificacion(es).
          Use \string\calificacion{} una vez por cada autor.}%
      }{}%
    }{}%
    \ifnumequal{\value{tfe@ncalificaciones}}{1}{%
      \tfe@text@calificacion: \csname tfe@cal@1\endcsname\par
    }{%
      \setcounter{tfe@ical}{0}%
      \loop
        \stepcounter{tfe@ical}%
        \csname tfe@autor@\the\value{tfe@ical}\endcsname~---~%
        \csname tfe@cal@\the\value{tfe@ical}\endcsname\par
      \ifnum\value{tfe@ical}<\value{tfe@ncalificaciones}%
      \repeat
    }%
  }%
}

% Portada "normativa": layout limpio y funcional con los campos que
% exige la normativa de la FDI, sin decoraciones.
\newcommand{\tfe@portadaNormativa}{%
  \begin{titlepage}
    \centering
    \tfe@portadaEscudo\par
    \vspace{1.2cm}
    {\large \tfe@portadaRotulo \par}
    \vfill
    {\huge\bfseries \@title \par}%
    \ifdefempty{\@tituloEN}{}{\vspace{0.6em}{\Large\itshape \@tituloEN \par}}%
    \vfill
    {\large \tfe@autores \par}
    \vspace{0.8cm}
    {\tfe@portadaDirector \par}
    \vfill
    \ifdefempty{\tfe@curso}{%
      \ClassWarning{fdi-simplex}{Falta \string\cursoAcademico{...}}%
    }{{\tfe@text@cursoAcademico\ \tfe@curso\par}}%
    \tfe@portadaFinal
  \end{titlepage}
}

% Portada reminiscente de TeXiS: título flanqueado por reglas, tipo de
% documento en versalitas justo debajo del escudo, bloques separados
% por \vfill. Sigue cumpliendo la normativa (mismos campos).
\newcommand{\tfe@portadaTeXiS}{%
  \begin{titlepage}
    \centering
    \mbox{}\vfill
    \rule{0.75\textwidth}{0.5mm}\\[0.8em]
    {\huge\bfseries \@title \par}%
    \ifdefempty{\@tituloEN}{}{\vspace{0.5em}{\Large\itshape \@tituloEN \par}}%
    \vspace{0.8em}\rule{0.75\textwidth}{0.5mm}%
    \vfill
    \tfe@portadaEscudo\par
    \vspace{0.8em}
    {\Large\bfseries\MakeUppercase{\tfe@tipoDoc} \par}
    \vfill
    {\large \tfe@autores \par}
    \vspace{0.6cm}
    {\tfe@portadaDirector \par}
    \vfill
    {\tfe@portadaRotulo \par}
    \vspace{0.4cm}
    \ifdefempty{\tfe@curso}{%
      \ClassWarning{fdi-simplex}{Falta \string\cursoAcademico{...}}%
    }{{\tfe@text@cursoAcademico\ \tfe@curso\par}}%
    \tfe@portadaFinal
  \end{titlepage}
}

% Dispatcher: elige la portada según la opción `portada`.
\newcommand{\makeportada}{%
  \ifdefstring{\tfe@portada}{texis}{\tfe@portadaTeXiS}{%
  \ifdefstring{\tfe@portada}{normativa}{\tfe@portadaNormativa}{%
    \ClassError{fdi-simplex}{%
      Opción `portada=\tfe@portada' desconocida.%
    }{Valores válidos: normativa, texis.}%
  }}%
}
\let\maketitle\makeportada

%%----------------------------------------------------------------------
%% 6. Resumen / Abstract y palabras clave
%%
%% Normativa exige ambos: en castellano y en inglés, cada uno con su
%% lista de ≤ 10 palabras clave. Los implementamos como capítulos sin
%% numerar, incluidos en el TOC.
%%----------------------------------------------------------------------

\newenvironment{resumen}{%
  \chapter*{Resumen}%
  \addcontentsline{toc}{chapter}{Resumen}%
}{%
  \ifdefempty{\tfe@palabrasClave}{}{%
    \par\medskip\noindent\textbf{Palabras clave:} \tfe@palabrasClave\par
  }%
}

% scrbook no define `abstract` (a diferencia de scrreport). Lo creamos
% como capítulo bilingüe paralelo a `resumen`.
\newenvironment{abstract}{%
  \chapter*{Abstract}%
  \addcontentsline{toc}{chapter}{Abstract}%
  \ifdefempty{\@tituloEN}{}{\noindent\textit{\@tituloEN}\par\medskip}%
}{%
  \ifdefempty{\tfe@keywords}{}{%
    \par\medskip\noindent\textbf{Keywords:} \tfe@keywords\par
  }%
}

%%----------------------------------------------------------------------
%% 7. Estilos visuales
%%
%% Los estilos son deliberadamente pequeños: un par de ajustes
%% tipográficos, no una hoja de estilo completa.
%%----------------------------------------------------------------------

% Definimos los comandos de marca aquí fuera porque dentro del cuerpo de
% \ifdefstring el carácter # requiere un escapado incómodo (##).
\newcommand{\tfe@chaptermarkTeXiS}[1]{%
  \markboth{\textsc{\chaptername\ \thechapter.}\ #1}{}%
}
\newcommand{\tfe@sectionmarkTeXiS}[1]{\markright{\thesection.\ #1}}

\ifdefstring{\tfe@estilo}{texis}{%
  % Estilo reminiscente de TeXiS. Replica los rasgos visuales más
  % característicos de la plantilla clásica sin cambiar la clase base.

  % Párrafos: sangría tradicional, separación mínima, interlineado holgado.
  % twoside = páginas pares/impares distintas y saltos a recto al cambiar
  % de capítulo (como un libro).
  \KOMAoptions{parskip=false, twoside=true, open=right, chapterprefix=true, DIV=8, BCOR=7mm}%
  % Ajuste vertical fino: KOMA DIV=8 da top≈37mm y bottom≈74mm (ratio 1:2);
  % desplazamos el bloque 10mm hacia abajo y lo extendemos 20mm para aproximar
  % el layout de TeXiS (book 11pt a4paper): top≈47mm, bottom≈44mm.
  \addtolength{\topmargin}{8mm}%
  \addtolength{\textheight}{14mm}%
  \setlength{\parskip}{0.2ex}%
  \linespread{1.05}%

  % Títulos en serif (KOMA los pone sans por defecto).
  \addtokomafont{disposition}{\rmfamily}%

  % Cabeceras estilo TeXiS: regla fina, capítulo en versalitas en páginas
  % pares, sección en impares, número de página en el borde exterior.
  \RequirePackage{fancyhdr}%
  \pagestyle{fancy}%
  \fancyhf{}%
  \renewcommand{\headrulewidth}{0.2pt}%
  \renewcommand{\footrulewidth}{0pt}%
  \addtolength{\headheight}{2pt}%
  \let\chaptermark\tfe@chaptermarkTeXiS
  \let\sectionmark\tfe@sectionmarkTeXiS
  \fancyhead[LO]{\rightmark}%
  \fancyhead[RE]{\leftmark}%
  \fancyhead[RO,LE]{\thepage}%
  % Primera página de capítulo: sin regla superior, nº al pie borde exterior.
  \fancypagestyle{plain}{%
    \fancyhf{}%
    \fancyfoot[RO,LE]{\thepage}%
    \renewcommand{\headrulewidth}{0pt}%
    \renewcommand{\footrulewidth}{0pt}%
  }%
}{%
  % minimo: defaults de KOMA (parskip=half-, sin sangría, titulares sans)
}

%%----------------------------------------------------------------------
%% 9. Bibliografía: biblatex con backend biber
%%----------------------------------------------------------------------
\RequirePackage[backend=biber, style=\tfe@estilobib]{biblatex}

%%----------------------------------------------------------------------
%% 10. hyperref al final del preámbulo (debe ir el último)
%%
%% La carga de hyperref se extrae a \tfe@hyperrefSetup para que un estilo
%% pueda redefinirla (p. ej. `colorlinks` con paleta propia en el estilo
%% "moderno"). Por defecto: sin color, enlaces ocultos.
%%----------------------------------------------------------------------
\newcommand{\tfe@hyperrefSetup}{%
  \RequirePackage[pdfusetitle, hidelinks, pdfdisplaydoctitle]{hyperref}%
}

\AtEndPreamble{%
  \tfe@hyperrefSetup
  \AtBeginDocument{%
    \hypersetup{%
      pdfsubject={\tfe@tipoDoc},%
      pdfkeywords={\tfe@palabrasClave; \tfe@keywords}%
    }%
  }%
}

\endinput
