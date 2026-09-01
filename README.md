# LaTeX Style System

Sistema de estilo LaTeX versionado para material de clase (handouts,
asignaciones, exámenes, project specs, slides, rúbricas) de la Escuela de
Ingeniería Civil y Ambiental, PUCMM.

Este README cubre **cómo usar el sistema** en una máquina nueva. Para las
reglas de estilo (colores, tipografía, metadata, qué entorno usar en cada
caso) ver [`STYLE.md`](STYLE.md). Para el flujo de trabajo al generar
documentos con un agente de IA, ver [`CLAUDE.md`](CLAUDE.md).

## 1. Requisitos

- **TeX Live 2024 o más reciente** (macOS: MacTeX; Windows: TeX Live o
  MiKTeX con los paquetes de TeX Live disponibles).
- **LuaLaTeX** -- el sistema usa `\DocumentMetadata` (etiquetado PDF/UA) y
  `unicode-math`, que requieren LuaLaTeX. Nunca pdflatex/xelatex.
- **`make`** (opcional pero recomendado). En macOS/Linux ya está. En
  Windows viene con Git Bash/MSYS2; si no lo tienes, compila directo con
  `latexmk` (ver más abajo), sin necesidad del Makefile.
- **`chktex`** (opcional, para `make lint`) -- normalmente viene incluido
  con TeX Live.

## 2. Clonar el repositorio

```bash
git clone https://github.com/hernanrr/LaTeX-Style-System.git
cd LaTeX-Style-System
```

Todo lo que necesitas para compilar (paquete `icv.sty`, plantillas,
configuración de `latexmk`) está dentro del repo. No hay que instalar nada
del repo por separado -- `.latexmkrc` agrega automáticamente `icv/` al
camino de búsqueda de LaTeX sin importar desde qué subcarpeta compiles.

## 3. Configurar el logo institucional (una vez por máquina)

El logo de PUCMM **no está en el repo** (no se redistribuye públicamente).
Cada máquina necesita su propia copia local y su propia ruta:

1. Descarga el logo en líneas (monocromo) desde
   <https://pucmm.edu.do/somos/recursos/logosimbolo/>.
2. Copia `icv/icv-local.cfg.tex.example` a `icv/icv-local.cfg.tex` (sin
   `.example`) -- ese archivo está en `.gitignore`, nunca se sube.
3. Edita `icv/icv-local.cfg.tex` y pon la ruta absoluta a tu copia del
   logo, por ejemplo:

   ```latex
   % macOS
   \renewcommand{\icvlogopath}{/Users/ricardo/ruta/a/logo_pucmm_lineas-Negras.png}

   % Windows -- usa siempre "/" aunque sea Windows, kpathsea las acepta
   \renewcommand{\icvlogopath}{C:/Users/ricardo/ruta/a/logo_pucmm_lineas-Negras.png}
   ```

Si te saltas este paso, los documentos compilan igual -- solo que
`\icvmaketitle` no muestra el logo.

## 4. Crear un documento nuevo (ejemplo: un handout)

1. Copia la plantilla del tipo que necesitas a donde vayas a trabajar,
   p. ej.:

   ```bash
   cp templates/handout/handout.tex "ICV 442 - Acueductos/mi-handout-nuevo.tex"
   ```

   (También puedes partir de un ejemplo dorado en `examples/` si tu
   documento se parece más a uno de esos que a la plantilla en blanco.)

2. Llena `\icvsetup{...}` al inicio del archivo: título, asignatura,
   período académico (usa `\icvciclo{año}{cuatrimestre}`, ver
   `STYLE.md` § Metadata para la tabla de códigos de asignatura), versión.
   Si algún dato no lo tienes a mano todavía, dejar `TODO: ...` como valor
   en vez de inventarlo.

3. Escribe el contenido usando los entornos semánticos del sistema
   (`icvnote`, `icvwarning`, `icvobjectives`, `icvproblem`, etc. -- ver
   `STYLE.md` § Entornos semánticos) en vez de maquetación ad hoc.

## 5. Compilar

Desde la raíz del repo, con `make`:

```bash
make handout        # o assignment, exam, project-spec, rubric, slides
```

Eso compila `templates/<tipo>/<tipo>.tex`. Para compilar **tu** documento
(no la plantilla), entra a su carpeta y usa `latexmk` directamente -- la
configuración de `.latexmkrc` aplica sin importar el directorio:

```bash
cd "ICV 442 - Acueductos"
latexmk mi-handout-nuevo.tex
```

El PDF queda en `build/` (relativo a donde invocaste `latexmk`/`make`),
junto con los artefactos de compilación -- todo eso está en `.gitignore`.

`make all` compila todas las plantillas; `make examples` compila todos los
ejemplos dorados; `make clean` borra los `build/` generados.

## 6. Verificar antes de dar el documento por terminado

```bash
make lint                              # chktex sobre todo el repo, o:
chktex -l .chktexrc -q mi-handout-nuevo.tex   # solo tu archivo
```

Además del lint, revisa el checklist de `CLAUDE.md` § Verificación (PDF
generado sin errores, metadata completa o con `TODO` explícito, figuras
con `alt=`, números con `\num`/`\qty`/columnas `S`, ninguna distinción que
dependa solo del color).

## Estructura del repo

```text
icv/                     # paquete núcleo: icv.sty, tokens.tex
  icv-local.cfg.tex.example  # plantilla de config local (logo), gitignored el real
templates/<tipo>/        # una plantilla en blanco por tipo de documento
examples/                 # documentos reales completos, ejemplo dorado por tipo
legacy/                   # material previo del profesor, solo como referencia histórica
docs/packages.md           # lista cerrada de paquetes LaTeX permitidos
bib/                        # .bib compartido entre materias (citas opt-in)
.latexmkrc, Makefile         # compilación -- ver STYLE.md § Motor y compilación
.chktexrc                     # configuración de chktex (higiene básica)
```
