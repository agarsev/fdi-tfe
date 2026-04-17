%%----------------------------------------------------------------------
%% fdi-memoria.cls
%%
%% Plantilla LaTeX para Trabajos de Fin de Grado y Fin de Máster
%% de la Facultad de Informática de la Universidad Complutense de Madrid.
%%
%% Pensada para LuaLaTeX (soporte moderno de Unicode / fontspec),
%% con compatibilidad razonable con pdfLaTeX como alternativa.
%%
%% Uso mínimo:
%%
%%   \documentclass[tfg]{fdi-memoria}         % o [tfm]
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
%%   tfg | tfm              Tipo de documento (defecto: tfg)
%%   estilo=minimo|texis    Estilo visual (defecto: minimo)
%%   idioma=es|en           Idioma principal (defecto: es)
%%   estilobib=<style>      Estilo biblatex (defecto: authoryear)
%%                          Otros valores habituales: numeric, alphabetic.
%%                          Véase https://biblatex-biber.sourceforge.net/
%%   cualquier otra opción se pasa a scrreport.
%%----------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{fdi-memoria}[2026/04/17 v0.2 Plantilla TFG/TFM Facultad de Informática UCM]

%%----------------------------------------------------------------------
%% 1. Opciones de clase
%%----------------------------------------------------------------------
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=tfe, prefix=tfe@}

\DeclareBoolOption[true]{tfg}
\DeclareBoolOption{tfm}
\DeclareStringOption[minimo]{estilo}
\DeclareStringOption[es]{idioma}
\DeclareStringOption[authoryear]{estilobib}

\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{scrreport}}
\ProcessKeyvalOptions*\relax

% tfm implica !tfg
\iftfe@tfm \tfe@tfgfalse \fi

%%----------------------------------------------------------------------
%% 2. Clase base: scrreport (KOMA-Script). parskip=half- da media
%%    línea de separación entre párrafos sin sangría, adecuado para PDF
%%    digital. DIV=12 da márgenes generosos estándar KOMA.
%%----------------------------------------------------------------------
\LoadClass[11pt, a4paper, DIV=12, parskip=half-, numbers=noenddot]{scrreport}

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

% Autor: almacén propio que admite varias llamadas (una por autor) o
% una sola con \\ como separador. Mantenemos una versión sin \\ en
% \@author para los metadatos PDF.
\def\tfe@autores{}
\def\tfe@autoresPlain{}
\newcommand{\autor}[1]{%
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

% Curso académico, convocatoria y calificación (estos dos últimos,
% solo en la versión final según normativa).
\newcommand{\cursoAcademico}[1]{\def\tfe@curso{#1}}
\newcommand{\convocatoria}[1]{\def\tfe@convocatoria{#1}}
\newcommand{\calificacion}[1]{\def\tfe@calificacion{#1}}
\def\tfe@curso{}
\def\tfe@convocatoria{}
\def\tfe@calificacion{}

% Palabras clave
\newcommand{\palabrasClave}[1]{\def\tfe@palabrasClave{#1}}
\newcommand{\keywords}[1]{\def\tfe@keywords{#1}}
\def\tfe@palabrasClave{}
\def\tfe@keywords{}

% Tipo de documento (derivado de las opciones)
\iftfe@tfg
  \def\tfe@tipoDoc{Trabajo de Fin de Grado}
  \def\tfe@tipoDocEN{Bachelor's Thesis}
\else
  \def\tfe@tipoDoc{Trabajo de Fin de Máster}
  \def\tfe@tipoDocEN{Master's Thesis}
\fi

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
  \includegraphics[height=3.5cm]{Escudo_UCM}%
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
      \ClassWarning{fdi-memoria}{Falta \string\titulacion{...}}%
    }{ en \tfe@titulacion}%
  \else
    \tfe@tipoDoc\\
    \ifdefempty{\tfe@titulacion}{%
      \ClassWarning{fdi-memoria}{Falta \string\titulacion{...}}%
    }{Máster en \tfe@titulacion}%
  \fi
  \\
  Facultad de Informática, Universidad Complutense de Madrid%
}

\newcommand{\tfe@portadaDirector}{%
  \iftfe@tfg
    \ifdefempty{\tfe@director}{%
      \ClassWarning{fdi-memoria}{Falta \string\director{...}}%
    }{Director:\\ \tfe@director}%
    \ifdefempty{\tfe@codirector}{}{\\[0.4em] Codirector:\\ \tfe@codirector}%
  \else
    \ifdefempty{\tfe@tutor}{%
      \ClassWarning{fdi-memoria}{Falta \string\tutor{...}}%
    }{Tutor:\\ \tfe@tutor}%
    \ifdefempty{\tfe@cotutor}{}{\\[0.4em] Cotutor:\\ \tfe@cotutor}%
    \ifdefempty{\tfe@colabExt}{}{\\[0.4em] Colaborador externo:\\ \tfe@colabExt}%
  \fi
}

\newcommand{\tfe@portadaFinal}{%
  \ifdefempty{\tfe@convocatoria}{}{Convocatoria: \tfe@convocatoria\par}%
  \ifdefempty{\tfe@calificacion}{}{Calificación: \tfe@calificacion\par}%
}

\newcommand{\makeportada}{%
  \begin{titlepage}
    \centering
    \tfe@portadaEscudo\par
    \vspace{1.2cm}
    {\large \tfe@portadaRotulo \par}
    \vfill
    \ifdefstring{\tfe@estilo}{texis}{%
      \rule{0.75\textwidth}{0.4pt}\\[0.8em]
      {\huge\bfseries \@title \par}%
      \ifdefempty{\@tituloEN}{}{\vspace{0.5em}{\Large\itshape \@tituloEN \par}}%
      \vspace{0.8em}\rule{0.75\textwidth}{0.4pt}%
    }{%
      {\huge\bfseries \@title \par}%
      \ifdefempty{\@tituloEN}{}{\vspace{0.6em}{\Large\itshape \@tituloEN \par}}%
    }
    \vfill
    {\large \tfe@autores \par}
    \vspace{0.8cm}
    {\tfe@portadaDirector \par}
    \vfill
    \ifdefempty{\tfe@curso}{%
      \ClassWarning{fdi-memoria}{Falta \string\cursoAcademico{...}}%
    }{{Curso académico \tfe@curso\par}}%
    \tfe@portadaFinal
  \end{titlepage}
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

% Redefinimos abstract (KOMA lo tiene como entorno de titlepage): lo
% queremos como capítulo bilingüe paralelo a `resumen`.
\renewenvironment{abstract}{%
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

\ifdefstring{\tfe@estilo}{texis}{%
  % Estilo reminiscente de TeXiS: párrafos con sangría tradicional
  % y separación mínima, línea ligeramente más holgada.
  \KOMAoptions{parskip=false}%
  \setlength{\parskip}{0.2ex}%
  \linespread{1.05}%
}{%
  % minimo: defaults de KOMA (parskip=half-, sin sangría)
}

%%----------------------------------------------------------------------
%% 8. Bibliografía: biblatex con backend biber
%%----------------------------------------------------------------------
\RequirePackage[backend=biber, style=\tfe@estilobib]{biblatex}

%%----------------------------------------------------------------------
%% 9. hyperref al final del preámbulo (debe ir el último)
%%----------------------------------------------------------------------
\AtEndPreamble{%
  \RequirePackage[pdfusetitle, hidelinks, pdfdisplaydoctitle]{hyperref}%
  \AtBeginDocument{%
    \hypersetup{%
      pdfsubject={\tfe@tipoDoc},%
      pdfkeywords={\tfe@palabrasClave; \tfe@keywords}%
    }%
  }%
}

\endinput
