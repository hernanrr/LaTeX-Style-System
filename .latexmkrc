# .latexmkrc -- LuaLaTeX exclusivo. Nunca pdflatex/xelatex.
#
# Válido en macOS y Windows (TeX Live 2024+). latexmk busca archivos
# `.latexmkrc` subiendo desde el directorio actual hasta la raíz, así que
# esta configuración se carga sin importar desde qué subcarpeta compiles
# (templates/handout/, examples/, etc.) -- no hace falta `cd` a la raíz.
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

$out_dir = 'build'; # relativo al directorio desde donde se invoca latexmk/make; gitignored
