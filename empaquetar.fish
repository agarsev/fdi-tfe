#!/usr/bin/env fish
# Empaqueta fdi-simplex y fdi-tippex para release. Deja en release/:
#   - las plantillas crudas (fdi-simplex.cls, fdi-tippex.typ) y la licencia
#   - un zip por cada ejemplo (TFG/TFM x latex/typst), listo para descomprimir
#     y compilar: incluye la plantilla y el escudo junto al documento.
# release/ es de usar y tirar: se borra al empezar. Si algo falla, el script
# se para ahí y termina con estado distinto de cero.

set raiz (path resolve (status dirname))
set salida $raiz/release

function empaquetar -a tipo lenguaje plantilla fichero ext
    set -l nombre (string upper $tipo)-$lenguaje-$plantilla
    set -l origen $raiz/$plantilla
    set -l ejemplo $origen/ejemplo-$tipo
    set -l destino $salida/$nombre

    # PDF al día: el Makefile del ejemplo sabe de qué depende.
    make -s -C $ejemplo >/dev/null; or return 1

    # Sólo lo que forma parte del ejemplo: ni build/, ni Makefile, ni
    # .gitignore, ni los auxiliares de una compilación hecha a mano.
    mkdir $destino
    and cp -r $ejemplo/$tipo.$ext $ejemplo/$tipo.pdf $ejemplo/bibliografia.bib \
        $ejemplo/capitulos $ejemplo/img $destino/
    and cp $origen/$fichero $origen/Escudo_UCM.png $origen/README.md \
        $raiz/LICENSE.txt $destino/
    or return 1

    # En el repo la plantilla está en el directorio padre; en el zip va junto
    # al documento. LaTeX la encuentra sola, pero Typst importa por ruta (y
    # necesita --root .. para compilar, que en el zip sobra).
    if test $lenguaje = typst
        sed -i -e "s|\"\.\./$fichero\"|\"$fichero\"|" -e 's| --root \.\.||' $destino/$tipo.typ
        or return 1
    end

    pushd $salida
    zip -qrX $nombre.zip $nombre; and rm -rf $nombre
    set -l estado $status
    popd
    return $estado
end

rm -rf $salida
and mkdir $salida
and cp $raiz/fdi-simplex/fdi-simplex.cls $raiz/fdi-tippex/fdi-tippex.typ $raiz/LICENSE.txt $salida/
or exit 1

for tipo in tfg tfm
    empaquetar $tipo latex fdi-simplex fdi-simplex.cls tex; or exit 1
    empaquetar $tipo typst fdi-tippex fdi-tippex.typ typ; or exit 1
end

echo "Generado en $salida:"
ls $salida | string replace -r '^' '  '
