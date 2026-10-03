#!/usr/bin/env fish
# Empaqueta fdi-simplex y fdi-tippex para release. Deja en release/:
#   - las plantillas crudas (fdi-simplex.cls, fdi-tippex.typ)
#   - un zip por cada ejemplo (TFG/TFM x latex/typst), listo para descomprimir
#     y compilar: incluye la plantilla y el escudo junto al documento.

set raiz (path resolve (status dirname))
set salida $raiz/release
set tmp (mktemp -d)

function empaquetar -a tipo lenguaje plantilla fichero
    set -l nombre (string upper $tipo)-$lenguaje-$plantilla
    set -l origen $raiz/$plantilla
    set -l destino $tmp/$nombre

    cp -r $origen/ejemplo-$tipo $destino
    rm -rf $destino/build $destino/Makefile
    cp $origen/$fichero $origen/Escudo_UCM.png $origen/README.md $destino/

    # En el repo la plantilla está en el directorio padre; en el zip va junto
    # al documento. LaTeX la encuentra sola, pero Typst importa por ruta (y
    # necesita --root .. para compilar, que en el zip sobra).
    if test $lenguaje = typst
        sed -i -e "s|\"\.\./$fichero\"|\"$fichero\"|" -e 's| --root \.\.||' $destino/$tipo.typ
    end

    rm -f $salida/$nombre.zip
    pushd $tmp
    zip -qrX $salida/$nombre.zip $nombre
    popd
    echo "  $nombre.zip"
end

mkdir -p $salida
echo "Generando en $salida:"

cp $raiz/fdi-simplex/fdi-simplex.cls $raiz/fdi-tippex/fdi-tippex.typ $salida/
echo "  fdi-simplex.cls"
echo "  fdi-tippex.typ"

for tipo in tfg tfm
    empaquetar $tipo latex fdi-simplex fdi-simplex.cls
    empaquetar $tipo typst fdi-tippex fdi-tippex.typ
end

rm -rf $tmp
