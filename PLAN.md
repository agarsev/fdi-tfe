# Plan

Estamos creando una plantilla latex para trabajos de fin
de estudios de la facultad de informatica.

0. La plantilla es para estudiantes que no sepan LaTeX ni quieran/puedan
   aprender mucho, si algún estudiante quiere hacer cosas chulas de latex, que
   no esta plantilla, sino que investigue y aprenda.
1. Código mínimo y entendible, poco invasivo
2. Que todo sea fácil de cambiar por el usuario, no poner nada demasiado
   restrictivo en el cls
3. Se pueden poner cosas en el ejemplo .tex para indicar al estudiante la manera
   "preferida" de hacerlo sin contaminar el .cls

## Estructura

- PLAN.md: este fichero
- fdi-simplex: directorio con la plantilla
   - fdi-simplex.cls: plantilla
   - ejemplo: ejemplos de uso de la plantilla, se compilan con el Makefile

## Por hacer

- [ ] Añadir licencia: European open license v3 EUPL
      Añadir `LICENSE` en la raíz del repo y referencia desde la
      cabecera del `.cls`.
- [ ] Reescribir texto del ejemplo para ser más neutral y didáctico
- [ ] Pasada por `ejemplo/tfg.tex` y `ejemplo/tfm.tex`: convertir los
      comentarios en mini-guías de uso ("para añadir un segundo
      director, repite `\director{...}`", "comenta esta línea hasta
      la entrega final", etc.).
- [ ] Verificar que README cubre el flujo "copiar carpeta y compilar"
      sin que el estudiante tenga que abrir el `.cls`.
- [ ] Etiquetar primera versión (`v0.2` ya está en el `.cls`; pasar
      a `v1.0` cuando esté listo).
