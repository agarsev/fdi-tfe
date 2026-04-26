%%----------------------------------------------------------------------
%%
%%                    ~ FDI SIMPLEX ~                 /\
%%                                                   /__\
%% fdi-simplex.cls                                  /\  /\
%%                                                 /__\/__\
%%
%% Plantilla LaTeX para Trabajos de Fin de Grado y Fin de Máster
%% de la Facultad de Informática de la Universidad Complutense de Madrid.
%% No es obligatoria, pero intenta cumplir con la normativa a la vez que
%% proporcionar un estilo elegante y un uso sencillo y mínimamente intrusivo.
%%
%% Pensada para LuaLaTeX (soporte moderno de Unicode / fontspec),
%% con compatibilidad razonable con pdfLaTeX como alternativa.
%%
%% Licenciada bajo la Licencia Pública de la Unión Europea (EUPL-1.2 or later)
%% Autor: Antonio F. G. Sevilla <afgs@ucm.es>
%%
%% Uso mínimo:
%%
%%   \documentclass[tfg]{fdi-simplex}        % o [tfm]
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
%%   estilo=digital|minimo|clasico
%%                           Estilo del cuerpo (defecto: digital)
%%   portada=normativa|elegante
%%                           Estilo de la portada (defecto: normativa).
%%                           Es ortogonal a `estilo`: puede combinarse
%%                           cualquier portada con cualquier estilo.
%%   idioma=es|en            Idioma principal (defecto: es)
%%   estilobib=<style>       Estilo biblatex (defecto: authoryear)
%%                           Otros valores habituales: numeric, alphabetic.
%%                           Véase https://biblatex-biber.sourceforge.net/
%%   colorenlace=<color>     Color de enlaces, citas y URLs (defecto:
%%                           fdiLink, un azul marino sobrio). Sólo aplica
%%                           al estilo `digital'. El nombre debe ser un
%%                           color definido (built-in de xcolor o vía
%%                           \definecolor en el preámbulo).
%%   cualquier otra opción se pasa a scrbook.
%%----------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{fdi-simplex}[2026/04/24 v1.0 Plantilla SIMPLEX para TFG/TFM Facultad de Informática UCM]

%%----------------------------------------------------------------------
%% 1. Opciones de clase
%%----------------------------------------------------------------------
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=tfe, prefix=tfe@}

\DeclareBoolOption[true]{tfg}
\DeclareBoolOption{tfm}
\DeclareStringOption[digital]{estilo}
\DeclareStringOption[normativa]{portada}
\DeclareStringOption[es]{idioma}
\DeclareStringOption[authoryear]{estilobib}
\DeclareStringOption[fdiLink]{colorenlace}

\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{scrbook}}
\ProcessKeyvalOptions*\relax

% tfm implica !tfg
\iftfe@tfm \tfe@tfgfalse \fi

%%----------------------------------------------------------------------
%% 2. Clase base: scrbook (KOMA-Script). Usamos scrbook en lugar de
%%    scrreport para disponer de \frontmatter/\mainmatter/\backmatter.
%%    Por defecto forzamos oneside para un aspecto digital; el estilo
%%    clasico reactiva twoside más abajo. parskip=half- da media línea
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

% Color por defecto de enlaces.
\definecolor{fdiLink}{HTML}{00559e}


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
  \csdef{tfe@autor@\the\value{tfe@nautores}}{#1}%
  \ifdefempty{\tfe@autores}{%
    \def\tfe@autores{#1}%
    \def\tfe@autoresPlain{#1}%
  }{%
    \appto\tfe@autores{\\#1}%
    \appto\tfe@autoresPlain{, #1}%
  }%
  \def\@author{\tfe@autoresPlain}%
}

% Director / Codirector (TFG)
% \director admite varias llamadas: con una sola se renderiza como
% "Director: X"; con varias como "Directores: X \\ Y \\ ...". El uso
% de \codirector se conserva para el caso habitual de un director
% principal y un codirector distinguido.
\newcounter{tfe@ndirectores}
\def\tfe@directores{}
\newcommand{\director}[1]{%
  \stepcounter{tfe@ndirectores}%
  \ifdefempty{\tfe@directores}{%
    \def\tfe@directores{#1}%
  }{%
    \appto\tfe@directores{\\#1}%
  }%
}
\newcommand{\codirector}[1]{\def\tfe@codirector{#1}}
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
  \csdef{tfe@cal@\the\value{tfe@ncalificaciones}}{#1}%
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
  \def\tfe@text@directores{Supervisors}%
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
  \def\tfe@text@directores{Directores}%
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
%% 5. Portadas
%%
%% Contienen la información obligatoria exigida por la normativa:
%% - Título (castellano e inglés)
%% - Autor(es)
%% - Director/Tutor (+ codirector/cotutor/colaborador externo)
%% - "Tipo en Titulación, Facultad de Informática, UCM"
%% - Curso académico
%% - Convocatoria y calificación si se han definido (versión final)
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
    \ifnumequal{\value{tfe@ndirectores}}{0}{%
      \ClassWarning{fdi-simplex}{Falta \string\director{...}}%
    }{%
      \ifnumequal{\value{tfe@ndirectores}}{1}{\tfe@text@director}{\tfe@text@directores}:\\ \tfe@directores%
    }%
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
      \tfe@text@calificacion: \csuse{tfe@cal@1}\par
    }{%
      \setcounter{tfe@ical}{0}%
      \whileboolexpr{test {\ifnumless{\value{tfe@ical}}{\value{tfe@ncalificaciones}}}}{%
        \stepcounter{tfe@ical}%
        \csuse{tfe@autor@\the\value{tfe@ical}}~---~\csuse{tfe@cal@\the\value{tfe@ical}}\par
      }%
    }%
  }%
}

% Portada "normativa": layout limpio y funcional con los campos que
% exige la normativa de la FDI, sin decoraciones.
\newcommand{\tfe@portadaNormativa}{%
  \begin{titlepage}
    % Sin destinos page.* en la portada: evita colisión con page.1/2
    % cuando \mainmatter (o \frontmatter en twoside) reinicia el contador.
    \hypersetup{pageanchor=false}%
    \centering
    \tfe@portadaEscudo\par
    \vspace{1.2cm}
    {\large \tfe@portadaRotulo \par}
    \vfill
    % El título va en un bloque algo más estrecho que la caja de texto
    % para que los títulos largos partan en varias líneas legibles en
    % lugar de ocupar toda la anchura de la página.
    {\huge\bfseries
      \begin{minipage}{0.82\textwidth}\centering \@title \par\end{minipage}\par}%
    \ifdefempty{\@tituloEN}{}{\vspace{1.2em}%
      {\Large\itshape
        \begin{minipage}{0.82\textwidth}\centering \@tituloEN \par\end{minipage}\par}}%
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
\newcommand{\tfe@portadaElegante}{%
  \begin{titlepage}
    \hypersetup{pageanchor=false}%
    \centering
    \mbox{}\vfill
    \rule{0.75\textwidth}{0.5mm}\\[0.8em]
    {\huge\bfseries \@title \par}%
    \ifdefempty{\@tituloEN}{}{\vspace{1em}{\Large\itshape \@tituloEN \par}}%
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
  \ifdefstring{\tfe@portada}{elegante}{\tfe@portadaElegante}{%
  \ifdefstring{\tfe@portada}{normativa}{\tfe@portadaNormativa}{%
    \ClassError{fdi-simplex}{%
      Opción `portada=\tfe@portada' desconocida.%
    }{Valores válidos: normativa, elegante.}%
  }}%
}
\let\maketitle\makeportada

%%----------------------------------------------------------------------
%% 6. Resumen / Abstract, palabras clave y contribuciones
%%
%% Normativa exige ambos: en castellano y en inglés, cada uno con su
%% lista de ≤ 10 palabras clave. Los implementamos como capítulos sin
%% numerar, incluidos en el TOC.
%%----------------------------------------------------------------------

% Margen extra lateral para resumen, abstract y contribuciones.
% El estilo `digital` lo reduce a 1cm (sutil); otros estilos lo dejan en 0pt.
\newlength{\tfe@marginextra}
\setlength{\tfe@marginextra}{0pt}

% Encabezado común para resumen, abstract y contribución: centrado,
% sin regla horizontal, con un tamaño menor que un título de capítulo
% normal.
\newcommand{\tfe@abschead}[1]{%
  \cleardoublepage
  \thispagestyle{plain}%
  \phantomsection
  \addcontentsline{toc}{chapter}{#1}%
  \markboth{#1}{#1}%
  \vspace*{2em}%
  \begin{center}%
    {\usekomafont{disposition}\LARGE #1\par}%
  \end{center}%
  \vspace{1.5em}%
}

\newenvironment{resumen}{%
  \tfe@abschead{Resumen}%
  \begin{addmargin}[\tfe@marginextra]{\tfe@marginextra}%
}{%
  \ifdefempty{\tfe@palabrasClave}{}{%
    \par\medskip\noindent\textbf{Palabras clave:} \tfe@palabrasClave\par
  }%
  \end{addmargin}%
}

% scrbook no define `abstract` (a diferencia de scrreport). Lo creamos
% como capítulo bilingüe paralelo a `resumen`.
\newenvironment{abstract}{%
  \tfe@abschead{Abstract}%
  \begin{addmargin}[\tfe@marginextra]{\tfe@marginextra}%
}{%
  \ifdefempty{\tfe@keywords}{}{%
    \par\medskip\noindent\textbf{Keywords:} \tfe@keywords\par
  }%
  \end{addmargin}%
}

% Contribución personal (TFG en grupo: normativa exige al menos 2 páginas
% por autor describiendo su aportación individual al proyecto).
\newenvironment{contribucion}[1]{%
  \tfe@abschead{Contribución de #1}%
  \begin{addmargin}[\tfe@marginextra]{\tfe@marginextra}%
}{%
  \end{addmargin}%
}

%%----------------------------------------------------------------------
%% 7. Estilos visuales
%%
%% Los estilos son deliberadamente pequeños: un par de ajustes
%% tipográficos, no una hoja de estilo completa.
%%
%% Punto de extensión para hyperref: un estilo puede redefinirlo para
%% cambiar cómo se carga hyperref (p. ej. con `colorlinks`). Se carga
%% luego desde \AtEndPreamble (sección 10).
%%----------------------------------------------------------------------
\newcommand{\tfe@hyperrefSetup}{%
  \RequirePackage[pdfusetitle, hidelinks, pdfdisplaydoctitle]{hyperref}%
}

% Formato de título de capítulo para el estilo digital: cuelga el número
% y añade una regla horizontal fina pegada debajo del título. Definidos
% fuera del bloque \ifdefstring porque \newcommand con # da problemas
% dentro del argumento de \ifdefstring.
\newcommand{\tfe@chapterlinesDigital}[3]{%
  \@hangfrom{#2}{#3}%
  \par\nobreak\vskip-0.6ex\rule{\linewidth}{0.5pt}%
}

% Comandos de marca para el estilo clasico; ídem.
\newcommand{\tfe@chaptermarkClasico}[1]{%
  \markboth{\textsc{\chaptername\ \thechapter.}\ #1}{}%
}
\newcommand{\tfe@sectionmarkClasico}[1]{\markright{\thesection.\ #1}}

\ifdefstring{\tfe@estilo}{digital}{%
  % Estilo digital (defecto): Lora serif en cuerpo y títulos (SemiBold
  % para encabezados), interlineado onehalf con sangría de párrafo,
  % cabecera limpia con el título de capítulo/sección, número de página
  % centrado al pie en todas las páginas. Enlaces coloreados (sin
  % bordes ni subrayados).

  % Fuente: Lora. Si no está instalada, avisamos fuerte para que el
  % estudiante lo sepa (nada de fallback silencioso). Usamos la versión
  % variable del archivo para poder pedir un peso SemiBold (600) para
  % los encabezados y Bold (700) para el \textbf normal.
  \IfFontExistsTF{Lora}{%
    \setmainfont{Lora}[%
      Ligatures=TeX,
      BoldFont={Lora}, BoldFeatures={RawFeature={axis={wght=700}}},
      ItalicFont={Lora}, ItalicFeatures={RawFeature={axis={wght=400}}},
      BoldItalicFont={Lora}, BoldItalicFeatures={RawFeature={axis={wght=700}}},
    ]%
    \newfontfamily\tfe@dispfont{Lora}[%
      Ligatures=TeX,
      UprightFeatures={RawFeature={axis={wght=600}}},
      BoldFont={Lora}, BoldFeatures={RawFeature={axis={wght=700}}},
    ]%
    \setkomafont{disposition}{\normalcolor\tfe@dispfont}%
    % Variante para URLs: ligeramente más pesada que el cuerpo (semibold).
    \newfontfamily\tfe@urlfont{Lora}[%
      Ligatures=TeX,
      UprightFeatures={RawFeature={axis={wght=500}}},
    ]%
  }{%
    \ClassWarningNoLine{fdi-simplex}{%
      La fuente Lora no se ha encontrado.\MessageBreak
      Instalala desde https://fonts.google.com/specimen/Lora, o\MessageBreak
      cambia la fuente con \protect\setmainfont{...} en tu preambulo%
    }%
    \addtokomafont{disposition}{\rmfamily}%
  }%

  % Monoespaciada: IBM Plex Mono. Aviso fuerte si no está instalada.
  \IfFontExistsTF{IBM Plex Mono}{%
    \setmonofont{IBM Plex Mono}[Scale=MatchLowercase]%
  }{%
    \ClassWarningNoLine{fdi-simplex}{%
      La fuente IBM Plex Mono no se ha encontrado.\MessageBreak
      Instalala desde https://fonts.google.com/specimen/IBM+Plex+Mono, o\MessageBreak
      cambia la fuente con \protect\setmonofont{...} en tu preambulo%
    }%
  }%

  % Interlineado onehalf y sangría tradicional de párrafo en vez del
  % espacio entre párrafos que trae KOMA por defecto (parskip=half-).
  \KOMAoptions{parskip=false}%
  \linespread{1.25}%
  \setlength{\parindent}{1em}%
  \setlength{\parskip}{0.2\baselineskip}%

  % 1cm extra de margen superior en las páginas del cuerpo (la titlepage
  % usa su propio layout y no se ve afectada). Reducimos textheight en
  % la misma cantidad para preservar el margen inferior.
  \addtolength{\topmargin}{1cm}%
  \addtolength{\textheight}{-1cm}%

  % scrlayer-scrpage: cabecera con el título del capítulo o sección,
  % número de página centrado al pie. El `*' en \cfoot* mantiene el
  % número también en la apertura de capítulo (pagestyle plain).
  \RequirePackage[automark, headsepline]{scrlayer-scrpage}%
  \clearpairofpagestyles%
  \ihead{\headmark}%
  \cfoot*{\pagemark}%
  \setkomafont{pageheadfoot}{\normalfont\small}%
  \setkomafont{pagenumber}{\normalfont\small}%

  % Número de capítulo con punto explícito.
  \renewcommand*\chapterformat{%
    \chapappifchapterprefix{\nobreakspace}%
    \thechapter.\enskip
  }%
  % Punto también en las marcas de cabecera.
  \renewcommand*{\chaptermarkformat}{\thechapter.\enskip}%
  \renewcommand*{\sectionmarkformat}{\thesection.\enskip}%
  % Regla pegada bajo el título de capítulo.
  \let\chapterlinesformat\tfe@chapterlinesDigital

  % Resumen, abstract y contribución ligeramente más estrechos que el
  % texto normal.
  \setlength{\tfe@marginextra}{1cm}%

  % ulem para subrayar URLs. `normalem' preserva \emph como cursiva.
  \RequirePackage[normalem]{ulem}%

  % Hyperref con colorlinks (sin bordes ni subrayados):
  %  - Referencias cruzadas, citas y URLs: en color \tfe@colorenlace
  %    (configurable con la opción de clase `colorenlace=<color>').
  %  - URLs (\url y destinos de \href): subrayadas y en peso semibold.
  %  - TOC: sin decoración (se asume que las entradas son pinchables).
  \renewcommand{\tfe@hyperrefSetup}{%
    \RequirePackage[pdfusetitle, pdfdisplaydoctitle,
      colorlinks=true,
      linkcolor=\tfe@colorenlace,
      citecolor=\tfe@colorenlace,
      urlcolor=\tfe@colorenlace]{hyperref}%
    % URLs en la fuente del cuerpo, peso semibold y subrayadas. Patcheamos
    % \hyper@linkurl (afecta a \url y a \href con destino URL) para envolver
    % el texto mostrado en \uline.
    \urlstyle{same}%
    \@ifundefined{tfe@urlfont}{}{\renewcommand{\UrlFont}{\tfe@urlfont}}%
    \let\tfe@orig@hyper@linkurl\hyper@linkurl
    % \ULdepth por defecto (\maxdimen) hace que ulem auto-detecte el
    % descender y la regla quede muy por debajo de las letras (parece
    % una caja). Lo fijamos para que el subrayado quede pegado al texto.
    \def\hyper@linkurl##1##2{%
      \tfe@orig@hyper@linkurl{{\setlength{\ULdepth}{1.8pt}\uline{##1}}}{##2}}%
    % TOC sin decoración de links (restablece al salir del grupo).
    \let\tfe@origtoc\tableofcontents
    \renewcommand{\tableofcontents}{%
      \begingroup\hypersetup{hidelinks}\tfe@origtoc\endgroup}%
  }%
}{%
\ifdefstring{\tfe@estilo}{clasico}{%
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
  % En aperturas de capítulo (pagestyle plain) se omite la cabecera y el
  % número de página baja al pie exterior.
  \RequirePackage[headsepline=0.2pt]{scrlayer-scrpage}%
  \pagestyle{scrheadings}%
  \clearpairofpagestyles%
  \let\chaptermark\tfe@chaptermarkClasico
  \let\sectionmark\tfe@sectionmarkClasico
  \ihead[]{\headmark}%
  \ohead[]{\pagemark}%
  \ofoot[\pagemark]{}%
}{%
\ifdefstring{\tfe@estilo}{minimo}{%
  % minimo: KOMA puro, sin customización adicional.
}{%
  \ClassError{fdi-simplex}{%
    Opción `estilo=\tfe@estilo' desconocida.%
  }{Valores válidos: digital, minimo, clasico.}%
}}}

%%----------------------------------------------------------------------
%% 8. Bibliografía: biblatex con backend biber
%%----------------------------------------------------------------------
\RequirePackage[backend=biber, style=\tfe@estilobib]{biblatex}

% Con authoryear, la cita por defecto es «Autor Año». Envolvemos el año
% entre paréntesis para dar la forma habitual «Autor (Año)». Mantenemos
% el `bibhyperref` para que la referencia siga siendo pinchable.
\ifdefstring{\tfe@estilobib}{authoryear}{%
  \renewbibmacro*{cite:labeldate+extradate}{%
    \iffieldundef{labelyear}%
      {}%
      {\printtext[bibhyperref]{\printtext[parens]{\printlabeldateextra}}}%
  }%
}{}

% Damos un poco más de aire entre las entradas
% de la bibliografía, que en authoryear quedan demasiado apretadas.
\setlength{\bibitemsep}{0.6em plus 0.1em}%

%%----------------------------------------------------------------------
%% 9. hyperref al final del preámbulo (debe ir el último)
%%
%% \tfe@hyperrefSetup se define en la sección 7 para que los estilos
%% puedan redefinirlo. Aquí sólo lo invocamos en \AtEndPreamble.
%%----------------------------------------------------------------------
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
