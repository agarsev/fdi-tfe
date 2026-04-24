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


## Por hacer

### 1. Decidir nombre del paquete

- [x] Elegir nombre definitivo: **`fdi-simplex`** (marca SIMPLEX, guiño a
      TeXiS, scope `fdi-` para evitar colisión con `simplex.sty` y dar
      contexto/SEO sin implicar oficialidad).
- [x] Renombrar `fdi-memoria.cls` → `fdi-simplex.cls` y carpeta
      `plantilla-memoria/` → `fdi-simplex/`.
- [x] Actualizar `\ProvidesClass`, `\ClassWarning`, README, ejemplos
      (`tfg.tex`, `tfm.tex`) y Makefile.
- [ ] (Opcional, antes de publicar) Verificación final de colisiones
      en CTAN — `simplex` existe (paquete para ejemplos numerados) pero
      `fdi-simplex` debería estar libre.

### 2. Refactor previo (prerrequisito de #3 y #4)

Cosas que conviene tocar **antes** de añadir portadas y estilo nuevos,
porque si no habrá que retocarlas en cada portada/estilo nuevo.

- [ ] Verificar qué pasa hoy con `idioma=en`: rótulos hardcoded en
      castellano dentro de portada y entornos
      (`Resumen`/`Abstract`, `Palabras clave`/`Keywords`,
      `Curso académico`, `Director`/`Tutor`, `Codirector`,
      `Calificación`, `Convocatoria`, `Colaborador externo`,
      `Facultad de Informática...`).
- [ ] Internacionalizar dichos rótulos con `\addto\captions<lang>` o
      con macros tipo `\tfe@text@director` que se redefinan según
      `\tfe@idioma`. Con esto las portadas nuevas no tienen que
      preocuparse por el idioma.
- [ ] Parametrizar la carga de `hyperref` (`fdi-simplex.cls:385`):
      hoy va con `hidelinks` para todos los estilos. Extraerlo a una
      macro `\tfe@hyperrefSetup` que cada estilo pueda redefinir
      (e. g. `colorlinks` + paleta para `moderno`).
- [ ] (Pequeño preparativo) Extraer la portada actual a una macro
      `\tfe@portadaNormativa` aunque siga siendo la única, para que
      añadir las otras dos en #3 sea sólo "añadir un comando más".
- [ ] Hacer configurable la ruta del logo UCM. Hoy
      `\tfe@portadaEscudo` hardcodea `Escudo_UCM`
      (`fdi-simplex.cls:194`); añadir un comando `\logo{<path>}` (con
      default `Escudo_UCM`) para que el estudiante pueda colocar el
      escudo donde quiera dentro de su proyecto (p. ej. en una
      subcarpeta `img/`). Esto deja la API lista para que cada portada
      de #3 use `\logo` en lugar de la ruta literal.

### 3. Separar portadas del estilo

Hoy la portada está acoplada al `.cls` y sólo cambia un detalle según
`estilo=texis|minimo`. Se quiere desacoplar para poder combinar
libremente estilo (cuerpo del documento) y portada.

- [ ] Añadir opción de clase `portada=normativa|texis|moderna`
      (default: `normativa`).
- [ ] Hacer que `\makeportada` despache a `\tfe@portadaNormativa` /
      `\tfe@portadaTeXiS` / `\tfe@portadaModerna` según la opción
      (la primera ya existe tras #2).
- [ ] Bajarse TeXiS (ya hay un `TeXiS-NightlyBuild-ManualSrc.zip` y
      carpeta `TeXiS_original/`) y replicar su portada respetando
      campos obligatorios de la normativa.
- [ ] Diseñar una portada "moderna" alternativa (limpia, con bloque de
      color, tipografía a juego con el nuevo estilo del punto 4).
- [ ] Documentar en README las combinaciones estilo/portada y dejar
      ejemplos en `tfg.tex` / `tfm.tex` de al menos dos combinaciones.

### 4. Nuevo estilo "moderno"

Tercer estilo (además de `minimo` y `texis`), pensado para TFGs/TFMs
que quieran algo más actual sin volverse extravagantes.

- [ ] Añadir valor `estilo=moderno` a la opción `estilo`.
- [ ] Decidir paleta (un color de acento sobrio: granate UCM, azul
      petróleo o verde oscuro). Definirlo con `xcolor`.
- [ ] Activar URLs/citas/refs coloreadas en este estilo redefiniendo
      el `\tfe@hyperrefSetup` introducido en #2.
- [ ] Elegir tipografía (sans humanista para títulos, p. ej. Lato /
      Source Sans / Fira; serif legible para texto si procede).
- [ ] Diseño de capítulo más visual (regla de color, número grande,
      etc.) usando `\addtokomafont`/`\setkomafont` o `titlesec` si KOMA
      no llega.
- [ ] Cabeceras limpias (probar `scrlayer-scrpage` de KOMA en lugar
      de `fancyhdr`, que sólo hace falta para `texis`).
- [ ] Compilar `tfg.tex` y `tfm.tex` con el nuevo estilo y revisar
      visualmente.

### 5. Refactor interno del `.cls`

Limpieza posterior, una vez todas las features están en su sitio. No
bloquea nada y conviene hacerla cuando ya hay claridad sobre cómo se
usa cada pieza.

- [ ] Revisar la maquinaria de `\autor` + `\calificacion` con
      contadores y `\csname` (`fdi-simplex.cls:114-162`); valorar si
      `xparse` (`\NewDocumentCommand`) o `etoolbox` (`\listadd`) lo
      simplifican sin perder funcionalidad.
- [ ] Sustituir el `\loop ... \repeat` de `\tfe@portadaFinal`
      (`fdi-simplex.cls:249-256`) por un `\foreach` o equivalente más
      legible.
- [ ] Confirmar reemplazo de `fancyhdr` por `scrlayer-scrpage`
      (decidido en #4 si encaja también para `moderno`).
- [ ] Revisar orden de carga de paquetes y eliminar los que no se usen.
- [ ] Numerar bien las secciones del `.cls` (saltamos del 7 al 9, no
      hay 8) — corregir la numeración o renombrar a propósito.

### 6. Comentarios didácticos

Cambiar el tono de los comentarios: hoy explican *cómo* se ha hecho la
plantilla; el destinatario es un estudiante que no sabe LaTeX y sólo
quiere usarla.

- [ ] Pasada por `fdi-simplex.cls`: dejar sólo comentarios que ayuden
      a un futuro mantenedor; quitar justificaciones de diseño tipo
      "decidimos X porque...".
- [ ] Pasada por `ejemplo/tfg.tex` y `ejemplo/tfm.tex`: convertir los
      comentarios en mini-guías de uso ("para añadir un segundo
      director, repite `\director{...}`", "comenta esta línea hasta
      la entrega final", etc.).
- [ ] Pasada por `ejemplo/capitulos/*.tex`: que muestren las
      construcciones recomendadas (figuras, citas, código,
      enumeraciones) con un comentario corto al lado.
- [ ] Verificar que README cubre el flujo "copiar carpeta y compilar"
      sin que el estudiante tenga que abrir el `.cls`.

### 7. Licencia, créditos y publicación

- [ ] Elegir licencia. Para una plantilla LaTeX lo habitual es
      **LPPL 1.3c**; alternativa permisiva: MIT o CC-BY 4.0.
- [ ] Añadir `LICENSE` en la raíz del repo y referencia desde la
      cabecera del `.cls`.
- [ ] Añadir sección de créditos en README: inspiración en TeXiS
      (Marco Antonio Gómez Martín y Pedro Pablo Gómez Martín, UCM),
      autoría actual, contacto.
- [ ] Decidir dónde publicar: repo público en GitHub bajo la cuenta
      personal o de la facultad. Confirmar con el resto del
      profesorado interesado antes de hacerlo público.
- [ ] Limpiar el repo antes de publicar:
      - mover `TeXiS-NightlyBuild-ManualSrc.zip` y `TeXiS_original/`
        fuera del repo o a un `.gitignore` (sólo son material de
        referencia).
      - decidir qué hacer con `normativa.pdf` (¿incluirlo o enlazar?).
      - revisar `ejemplo/build/` y añadir al `.gitignore`.
- [ ] Etiquetar primera versión (`v0.2` ya está en el `.cls`; pasar
      a `v1.0` cuando esté listo).
- [ ] (Opcional) Subir a CTAN una vez estable.
