= Introduction

This chapter presents the background, objectives, and work plan of the
report, as required by the regulations for the final-year project of the
Faculty of Computer Science
(#link("https://informatica.ucm.es/normativa-tfg-2425")[informatica.ucm.es/normativa-tfg-2425]).

== Regulations

- Minimum length: 25 pages for a single-author Bachelor's thesis (plus 5 per
  additional co-author); 50 pages for a Master's thesis.
- At most 10 keywords in each language.
- The English abstract of the Master's thesis must be approximately half a
  page long.
- All non-original material (text, figures, code) must be cited and respect
  its license.
- *Master's thesis only*: the student must sign and attach the _responsible
  declaration on authorship and ethical use of artificial intelligence
  tools_.

== Background

The Faculty of Computer Science at UCM has used the TeXiS @texis system for
over a decade for its thesis reports and final-year projects. This shell
helps prepare complex documents with good practices, but being a shell rather
than a template, it is more difficult to integrate with other systems, and it
does not encourage users to learn LaTeX. Typst @madje2022 is a modern
alternative, easier to learn and much faster to compile.

== Objectives

The objectives of this work are:

- Provide a modern template based on Typst.
- Separate normative aspects from aesthetic ones.
- Offer a minimal base that does not interfere with the packages each student
  chooses to use.
