# Paquetes permitidos

Lista cerrada de paquetes que `icv.sty` carga. No agregar un paquete a un
documento (ni a `icv.sty`) que no esté aquí sin preguntar primero — ver
`CLAUDE.md`.

## Núcleo (siempre cargados por `icv.sty`)

| Paquete | Para qué |
|---|---|
| `fontspec` | Motor de fuentes Unicode (obligatorio con LuaLaTeX) |
| `babel` `[spanish,es-noshorthands]` | Español, sin atajos de puntuación que chocan con siunitx/URLs |
| `geometry` | Márgenes de página |
| `microtype` `[expansion=false]` | Protrusión tipográfica |
| `amsmath`, `amssymb` | Matemática (cargados ANTES de `unicode-math`, ver comentario en `icv.sty`) |
| `unicode-math` | Matemática con fuente Unicode (TeX Gyre Pagella Math) |
| `booktabs`, `array` | Tablas profesionales |
| `enumitem` | Listas |
| `xcolor` `[dvipsnames,table]` | Color, incluida paleta institucional |
| `tcolorbox` `[breakable]` | Cajas semánticas (`icvnote`, `icvwarning`, `icvobjectives`, `icvproblem`) |
| `caption` | Leyendas de figuras/tablas |
| `scrlayer-scrpage` `[automark]` | Encabezado/pie -- nativo KOMA, no `fancyhdr` |
| `longtable` | Tablas que cruzan página (rúbricas) |
| `makecell` | Saltos de línea dentro de celdas |
| `graphicx` | Base de `\icvincludegraphics` |
| `siunitx` (v3) | Unidades y números -- `\qty`, `\num`, columnas `S` |
| `hyperref` | Enlaces y metadata PDF |
| `pgfkeys` | Motor de `\icvsetup` |
| `etoolbox` | `\ifdefempty`/`\ifdefstring` para campos opcionales |
| `xkeyval` | `points=` de `icvproblem`, `alt=` de `\icvincludegraphics` |

## Opt-in (vía opción de paquete)

| Paquete | Cómo se activa | Para qué |
|---|---|---|
| `biblatex` `[backend=biber,style=apa,sorting=nyt,language=spanish]` + `csquotes` | `\usepackage[biblatex]{icv}` | Citas APA 7 |

## Aún no incorporados (candidatos para tipos de documento futuros)

Estos paquetes aparecen en `legacy/` pero no están en `icv.sty` todavía
porque ningún template los necesita aún. Al construir `exam`,
`project-spec` o `slides`, evaluar si hacen falta -- no agregarlos por
adelantado:

- `pgfplots`, `pgfplotstable`, `tikz` -- gráficas y esquemas
- `tabularx` -- tablas de ancho fijo
- `pdflscape` -- anexos apaisados
- `pdfpages` -- compilados/anexos de PDFs externos
- `multicol` -- opciones de selección múltiple
- `xfp` -- aritmética en línea

## Explícitamente descartados

- `fancyhdr`, `parskip`, `titlesec` -- KOMA-Script los desaconseja junto a
  una clase KOMA; se usan sus equivalentes nativos (ver `STYLE.md`).
- `mdframed` -- estaba cargado en `legacy/` sin un solo uso real.
- `\SI{}{}`/`\si{}` (sintaxis siunitx v2) -- se usa siunitx v3 exclusivamente.
