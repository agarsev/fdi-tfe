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

### 2. Refactor previo (prerrequisito de #3 y #4)

Cosas que conviene tocar **antes** de añadir portadas y estilo nuevos,
porque si no habrá que retocarlas en cada portada/estilo nuevo.

- [x] Verificar qué pasa hoy con `idioma=en`: rótulos hardcoded en
      castellano dentro de portada y entornos
      (`Resumen`/`Abstract`, `Palabras clave`/`Keywords`,
      `Curso académico`, `Director`/`Tutor`, `Codirector`,
      `Calificación`, `Convocatoria`, `Colaborador externo`,
      `Facultad de Informática...`). Los entornos `resumen` y
      `abstract` se quedan fijos (normativa exige ambos idiomas); el
      resto sí se internacionaliza.
- [x] Internacionalizar dichos rótulos con macros `\tfe@text@*` que se
      eligen según `\tfe@idioma` en el bloque §4.b del `.cls`. Con
      esto las portadas nuevas no tienen que preocuparse por el
      idioma.
- [x] Parametrizar la carga de `hyperref`: extraído a
      `\tfe@hyperrefSetup`. Un estilo puede redefinirlo (e. g.
      `colorlinks` + paleta para `moderno`).
- [x] Extraer la portada actual a una macro `\tfe@portadaNormativa`;
      `\makeportada` la llama. Añadir otra portada en #3 es sólo
      "definir su macro y que `\makeportada` haga dispatch".
- [x] Hacer configurable la ruta del logo UCM: `\logo{<path>}` con
      default `Escudo_UCM`.

### 3. Separar portadas del estilo

Hoy la portada está acoplada al `.cls` y sólo cambia un detalle según
`estilo=texis|minimo`. Se quiere desacoplar para poder combinar
libremente estilo (cuerpo del documento) y portada.

- [x] Añadir opción de clase `portada=normativa|texis` (default:
      `normativa`). La variante `moderna` se añadirá junto con el
      estilo moderno (#4).
- [x] Hacer que `\makeportada` despache a `\tfe@portadaNormativa` /
      `\tfe@portadaTeXiS` según la opción. La portada normativa pasa
      a ser limpia (sin decoración de reglas); las reglas alrededor
      del título están ahora en `portada=texis`.
- [x] Replicar portada de TeXiS: `\tfe@portadaTeXiS` imita los rasgos
      principales del original (título flanqueado por reglas, tipo de
      documento en versalitas bajo el escudo, rótulo y facultad al
      pie). Sigue respetando los campos de la normativa.
- [ ] Diseñar una portada "moderna" alternativa (limpia, con bloque de
      color, tipografía a juego con el nuevo estilo del punto 4).
      **Aplazado a #4** porque la tipografía/paleta depende del nuevo
      estilo.
- [x] Documentar en README las combinaciones estilo/portada. Ejemplos:
      `tfg.tex` (minimo + normativa), `tfm.tex` (texis + texis).

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
