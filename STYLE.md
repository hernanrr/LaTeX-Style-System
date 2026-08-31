# STYLE.md — Reglas normativas del sistema de estilo `icv`

Este documento es la fuente de verdad de cómo se ven y se construyen los
materiales de clase de la Escuela de Ingeniería Civil y Ambiental (PUCMM).
Está escrito para humanos y para LLMs por igual. Si un documento generado
contradice esto, el documento está mal, no esta guía.

Para el flujo de trabajo de un agente (qué leer primero, qué no tocar sin
permiso), ver [`CLAUDE.md`](CLAUDE.md). Este archivo es sobre **reglas**,
no sobre **proceso**.

## Motor y compilación

- **LuaLaTeX + `latexmk` exclusivamente.** Nunca `pdflatex`, nunca `xelatex`.
  `icv.sty` rechaza compilar si no detecta LuaLaTeX.
- Compila con `make <tipo>` desde la raíz del repo (`make handout`,
  `make assignment`, `make handout-example`...), o con `latexmk archivo.tex`
  directamente desde la carpeta del documento — `.latexmkrc` se autoconfigura
  sin importar desde dónde se invoque, buscando hacia arriba desde el cwd.
- `make clean` borra los `build/` generados. Nunca commitear `build/`.
- Probado en TeX Live 2024/2026, macOS y Windows.

## Arquitectura

- `icv.sty` es un **paquete**, no una clase. Clase base: `scrartcl`
  (KOMA-Script), tamaño único **11pt**.
- Excepción: documentos que necesiten preguntas de opción múltiple con
  puntaje automático y solucionario derivado usan la clase `exam`, que
  también carga `icv.sty`. No crear una clase `.cls` nueva sin preguntar
  primero.
- `icv.sty` está "cerrado" salvo permiso explícito una vez estable para la
  fase actual — ver `CLAUDE.md`.
- Mecanismos de KOMA-Script en vez de paquetes genéricos cuando ambos
  existen: `scrlayer-scrpage` (no `fancyhdr`), `\KOMAoptions{parskip=half}`
  (no el paquete `parskip`), `\addtokomafont` (no `titlesec`). KOMA avisa
  explícitamente si detecta esos paquetes cargados junto a su clase — si
  ves ese warning, es que algo se desvió de esta regla.

## Nomenclatura

- Prefijo del paquete y de la infraestructura: **`icv`** (por "Ingeniería
  Civil"), en inglés: `\icvsetup`, `\icvmaketitle`, `\icvincludegraphics`.
- Contenido pedagógico en español: `\icvobjectives`, `\icvproblem`,
  `\icvnote`, `\icvwarning`.
- No introducir un segundo prefijo ni nombres alternativos para lo mismo
  (legacy/ tenía `\DocShort`/`\ExamShort`/`\AsignaturaCorta` para una sola
  idea — no se repite ese patrón).

## Tipografía

- Cuerpo: **TeX Gyre Pagella** (serif).
- Títulos, encabezados y bloque de portada: **TeX Gyre Heros** (sans) —
  KOMA ya usa la fuente sans para `\section`/`\subsection` por defecto
  (`disposition font`), no hace falta forzarlo por documento.
- Matemática: **TeX Gyre Pagella Math**, vía `unicode-math`.
- Nunca declarar `\setmainfont`/`\setsansfont`/`\setmathfont` dentro de un
  documento — ya están fijados en `icv.sty`. Si un documento necesita una
  fuente distinta, es una señal de que hay que discutirlo, no de que hay
  que sobreescribirlo en silencio.

## Color

Paleta institucional PUCMM (manual de marca, dupla de la Facultad de
Ciencias de la Ingeniería), definida en `icv/tokens.tex`:

| Token | Valor | Pantone | Uso |
|---|---|---|---|
| `icvblue` | `#005DAA` | 286C | Títulos, reglas de portada, `icvnote`/`icvproblem` |
| `icvcyan` | `#009DDC` | 299C | `icvobjectives` |
| `icvyellow` | `#FFEA00` | Yellow 012C | **Solo fondo** (falla WCAG como texto) — `icvwarning` |
| `icvgray` | `#C8CCCB` | Cool Gray 4C | **Solo fondo/filete** — usa `icvgray-text` para texto |
| `icvred` | `#EF3026` | 1795C | Reservado, sin macro asignada todavía |
| `icvblack` | `#231F20` | K100 | Color de texto por defecto |

Tintes de fondo (`icvblue-bg`, `icvcyan-bg`, `icvyellow-bg`, `icvgray-bg`,
`icvred-bg`) ya están derivados en `tokens.tex` para cajas semánticas — no
mezclar colores ad hoc con `!` en el cuerpo de un documento.

**No introducir colores nuevos** sin pasar por `tokens.tex` y sin
verificar contraste WCAG AA (ratio ≥ 4.5:1 para texto normal). Esta paleta
reemplaza por completo la paleta previa de `legacy/` (`medblue`,
`darkblue`, `teal`, `olive`...), que no correspondía a la identidad
institucional.

## Logo

- Aparece **solo en la portada** (`\icvmaketitle`), nunca en cada página.
- **Nunca se redistribuye dentro del repo** — es propiedad de PUCMM y el
  repo es público. Cada máquina configura su propia ruta en
  `icv/icv-local.cfg.tex` (gitignored; plantilla en
  `icv/icv-local.cfg.tex.example`). Sin ese archivo, el documento compila
  igual, sin logo.
- Logo en líneas (monocromo), no a color — coherente con la regla del
  manual de marca para impresos internos.

## Metadata (`\icvsetup`)

```latex
\icvsetup{
  asignatura  = {ICV 442-T -- Acueductos y Alcantarillados},
  titulocorto = {Acueductos y Alcantarillados}, % encabezado de página
  titulo      = {Título del documento},
  subtitulo   = {Opcional},
  profesor    = {Dr. Ricardo Hernández Moreira}, % ya es el valor por defecto
  periodo     = {2026-1},
  version     = {v1},
}
```

- `pdftitle`/`pdfauthor`/`pdfsubject` se derivan **automáticamente** de
  estos campos vía `\AtBeginDocument` — nunca declarar `\hypersetup` a
  mano en un documento para duplicar lo mismo.
- **Versión**: contador simple `vN`, reiniciado en cada período académico
  nuevo (no es una fecha ni un hash).
- Códigos canónicos de asignatura:

  | Código | Asignatura |
  |---|---|
  | ICV 342-T | Hidrología |
  | ICV 343-T | Hidráulica Básica |
  | ICV 343-P | Laboratorio de Hidráulica Básica |
  | ICV 441-T | Hidráulica Aplicada |
  | ICV 441-P | Laboratorio de Hidráulica Aplicada |
  | ICV 442-T | Acueductos y Alcantarillados |

- Si falta un campo de metadata al generar un documento nuevo: **no
  inventar el valor**. Dejar `TODO` visible y avisar — ver `CLAUDE.md`.

## Figuras (texto alternativo obligatorio)

```latex
\icvincludegraphics[width=4cm,alt={Descripción del contenido para
  lectores de pantalla.}]{ruta/figura.png}
```

- Usar **siempre** `\icvincludegraphics`, nunca `\includegraphics`
  directo, para cualquier figura de contenido (no aplica al logo de
  portada, que es decorativo).
- `alt=` es obligatorio: sin él, la compilación falla con un error
  explícito. No es opcional ni se puede omitir "por ahora".

## Unidades y tablas numéricas

- **siunitx v3 exclusivamente** — `\qty{}{}`, `\unit{}`, `\num{}`. Nunca
  `\SI{}{}`/`\si{}` (sintaxis v2, no se usa en este sistema).
- Tablas con columnas numéricas usan columnas `S` de siunitx, alineadas al
  separador decimal:

  ```latex
  \begin{tabular}{l S[table-format=6.0]}
    \toprule
    {Año} & {Población} \\
    \midrule
    1970  & 112400 \\
    \bottomrule
  \end{tabular}
  ```

  El valor numérico va crudo (`112400`), sin comas ni formato manual — la
  coma de miles la pone `\sisetup{group-separator={,}}`, ya configurado en
  `icv.sty`.
- No escribir números con formato manual (`112,400` como texto literal) en
  ningún lugar del documento; siempre `\num{112400}` o una columna `S`.

## Citas (opt-in)

```latex
\usepackage[biblatex]{icv}
```

- Activa `biblatex` + `biber`, estilo **APA 7**, español.
- Opt-in por documento — la mayoría de handouts/asignaciones no citan.
- `.bib` compartido entre materias: `bib/` (pendiente de poblar).

## Entornos semánticos disponibles

| Entorno | Uso | Color |
|---|---|---|
| `icvobjectives` | Lista de objetivos de aprendizaje (itemize implícito) | `icvcyan` |
| `icvnote[Título]` | Nota informativa de título libre (reemplaza `\handoutintro`/`\excelnote` de legacy/) | `icvblue` |
| `icvwarning[Título]` | Advertencia o resultado clave de título libre (reemplaza `\weightednote`/`\resultbox`) | `icvyellow` |
| `icvproblem[points=N]{Título}` | Problema numerado, puntaje opcional (asignaciones) | `icvblue` |

No crear una caja semántica nueva por documento — si un caso de uso no
encaja en `icvnote`/`icvwarning`, es una señal para extender `icv.sty`
(con permiso), no para maquetar algo ad hoc en el documento.

## Reglas por tipo de documento

### Handout (`templates/handout/handout.tex`)

Estructura esperada: Objetivos de aprendizaje → Introducción → desarrollo
(Ecuaciones/Procedimiento) → Ejemplo resuelto → Observaciones de uso. Ver
`examples/handout-example.tex` para un caso real completo.

### Assignment (`templates/assignment/assignment.tex`)

Estructura esperada: Objetivos de aprendizaje → Instrucciones → Problemas
(`icvproblem`, con o sin `points=`).

### Exam, project-spec, slides, rubric

Aún no implementados (carpetas creadas, sin plantilla). No inventar su
estructura por adelantado — se diseñan cuando toque esa fase.

## PDF etiquetado

- Todo documento empieza con `\DocumentMetadata{lang=es-DO,testphase=
  {phase-III,math}}` como primerísima línea, antes de `\documentclass`.
- Sin cebreado automático de tablas (`\rowcolors` global) — si una tabla
  específica lo necesita, se activa localmente alrededor de esa tabla, no
  para todo el documento.
- El soporte de etiquetado (`testphase=math`) es experimental y puede
  emitir warnings benignos de KOMA-Script sobre `\@startsection` — no son
  errores, no bloquean, no hace falta perseguirlos.
- Exportar a HTML: descartado por ahora ("algún día", no un requisito
  activo de este sistema).
