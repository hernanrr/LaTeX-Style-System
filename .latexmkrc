# .latexmkrc -- LuaLaTeX exclusivo. Nunca pdflatex/xelatex.
#
# Válido en macOS y Windows (TeX Live 2024+).
#
# IMPORTANTE -- latexmk NO busca `.latexmkrc` hacia arriba en el árbol de
# directorios. Solo lee, en este orden: el rc del sistema, `$HOME/.latexmkrc`,
# y `./.latexmkrc` en el directorio actual (ver latexmk 4.88, la llamada
# `read_first_rc_file_in_list("./.latexmkrc", "./latexmkrc")`). Por eso
# **hay que invocar latexmk desde la raíz del repo**: desde una subcarpeta
# este archivo no se lee, TEXINPUTS no se configura e `icv.sty` no resuelve.
#
#   Correcto:   latexmk templates/handout/handout.tex        (desde la raíz)
#               make handout / make doc FILE=...
#   Falla:      cd templates/handout && latexmk handout.tex
use File::Basename;
use Cwd 'abs_path';

my $root = dirname( abs_path(__FILE__) );

$pdf_mode  = 4; # lualatex
$lualatex  = 'lualatex -interaction=nonstopmode -synctex=1 -halt-on-error %O %S';

# icv.sty y tokens.tex viven en icv/ -- se agregan al camino de búsqueda de
# kpathsea para que \usepackage{icv} y \input{tokens} resuelvan sin importar
# el cwd. El .bib compartido vive en bib/.
$ENV{'TEXINPUTS'} = $root . '/icv//:' . ( $ENV{'TEXINPUTS'} // '' ) . ':';
$ENV{'BIBINPUTS'} = $root . '/bib//:' . ( $ENV{'BIBINPUTS'} // '' ) . ':';

# $do_cd hace que latexmk entre a la carpeta del .tex antes de compilar, así
# que `build/` se crea JUNTO AL DOCUMENTO y no en la raíz, sin importar desde
# dónde se invoque. Es lo que `make clean` ya asumía al barrer los build/ de
# templates/ y examples/.
$do_cd = 1;

# Entregables separados de la basura de compilación:
#   $out_dir = '.'      -> el .pdf queda JUNTO al .tex, listo para abrir/imprimir
#   $aux_dir = 'build'  -> .aux/.log/.fls/.fdb_latexmk se esconden en build/
# Ambos son relativos al .tex gracias a $do_cd. Verificado en latexmk 4.88:
# compila en 3 pasadas y la segunda invocación reporta up-to-date -- la
# combinación aux_dir != out_dir no provoca bucle de recompilación aquí.
# Los .pdf generados están en .gitignore; los de legacy/ no se tocan.
$out_dir = '.';
$aux_dir = 'build';
