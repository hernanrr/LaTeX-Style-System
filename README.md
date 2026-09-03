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

Tus documentos nuevos deben vivir en `cursos/<nombre del curso>/` --
**dentro del repo**, no en una carpeta aparte del disco. La razón está en
la sección 6 (cómo encuentra `latexmk` su configuración). `legacy/` es
material previo intocable y `examples/` son los ejemplos dorados del
sistema, no un lugar para trabajar. Antes de poner contenido real ahí,
lee la sección 5 -- este repo es público.

1. Copia la plantilla del tipo que necesitas a tu carpeta de curso, p. ej.:

   ```bash
   mkdir -p "cursos/Acueductos y Alcantarillados/Handouts"
   cp templates/handout/handout.tex \
      "cursos/Acueductos y Alcantarillados/Handouts/mi-handout-nuevo.tex"
   ```

   (También puedes partir de un ejemplo dorado en `examples/` si tu
   documento se parece más a uno de esos que a la plantilla en blanco --
   cópialo igual a `cursos/...`, no lo edites en `examples/`.)

2. Llena `\icvsetup{...}` al inicio del archivo: título, asignatura,
   período académico (usa `\icvciclo{año}{cuatrimestre}`, ver
   `STYLE.md` § Metadata para la tabla de códigos de asignatura), versión.
   Si algún dato no lo tienes a mano todavía, dejar `TODO: ...` como valor
   en vez de inventarlo.

3. Escribe el contenido usando los entornos semánticos del sistema
   (`icvnote`, `icvwarning`, `icvobjectives`, `icvproblem`, etc. -- ver
   `STYLE.md` § Entornos semánticos) en vez de maquetación ad hoc.

## 5. Privacidad de tus materiales de curso

**Este repositorio (`LaTeX-Style-System`) es público en GitHub.** El
sistema de estilo, las plantillas y los ejemplos dorados están pensados
para serlo. Tus materiales reales de curso -- exámenes, asignaciones con
contenido real, cualquier cosa con calificaciones o datos de
estudiantes -- no deben estarlo.

Por eso `cursos/*` está en `.gitignore` (con una única excepción:
`cursos/README.md`, que solo documenta la convención de carpetas y no
tiene nada sensible). Nada de lo que pongas dentro de `cursos/` se sube
jamás a este repo público, sin importar cuántos `git add -A` hagas por
accidente.

Pero eso solo evita la fuga -- no te da versionado ni sincronización entre
máquinas para ese contenido. Para eso, `cursos/` es un **repo git anidado
independiente**, apuntando a un repo privado aparte:

**Configuración inicial (una vez):**

```bash
# 1. Crea un repo privado en GitHub (ejemplo con gh, o hazlo desde la web)
gh repo create hernanrr/cursos-icv-pucmm --private

# 2. Dentro de cursos/, inicializa un repo git propio (independiente del
#    repo del sistema de estilo -- este .git vive DENTRO de cursos/)
cd cursos
git init
git remote add origin https://github.com/hernanrr/cursos-icv-pucmm.git
git add .
git commit -m "material inicial"
git push -u origin main
```

Como `cursos/` ya está ignorado por el `.gitignore` del repo padre, git no
se queja de "repositorio embebido" -- para el repo del sistema de estilo,
`cursos/` simplemente no existe (salvo su `README.md`).

**En una máquina nueva:**

```bash
git clone https://github.com/hernanrr/LaTeX-Style-System.git
cd LaTeX-Style-System/cursos
git init
git remote add origin https://github.com/hernanrr/cursos-icv-pucmm.git
git fetch origin
git checkout main
```

Esto no interfiere con `latexmk` -- la búsqueda de `.latexmkrc` (ver
sección 6) es puramente de sistema de archivos, no le importa cuántos
`.git` haya anidados en el camino.

## 6. Compilar

Desde la raíz del repo, con `make`:

```bash
make handout        # o assignment, exam, project-spec, rubric, slides
```

Eso compila `templates/<tipo>/<tipo>.tex`. Para compilar **tu** documento
(no la plantilla), entra a su carpeta y usa `latexmk` directamente:

```bash
cd "cursos/Acueductos y Alcantarillados/Handouts"
latexmk mi-handout-nuevo.tex
```

El PDF queda en `build/` (relativo a donde invocaste `latexmk`/`make`),
junto con los artefactos de compilación -- todo eso está en `.gitignore`.

`make all` compila todas las plantillas; `make examples` compila todos los
ejemplos dorados; `make clean` borra los `build/` generados.

### Cómo encuentra `latexmk` su configuración

`latexmk` no tiene nada hardcodeado sobre este proyecto -- lee
`.latexmkrc` en tiempo de ejecución, y lo encuentra por **búsqueda
ascendente automática**: parte del directorio donde lo invocas y sube por
los directorios padre hasta encontrar un `.latexmkrc` (o hasta llegar a la
raíz del sistema de archivos si no hay ninguno). Ese archivo es el que le
dice que use LuaLaTeX, dónde está `icv.sty` (`TEXINPUTS`), y dónde poner
el PDF (`build/`).

Por eso **tu carpeta de trabajo tiene que estar dentro del árbol del
repo** -- cualquier subcarpeta, a cualquier profundidad, funciona sin
configuración adicional. De ahí la convención de la sección 4: todo
documento nuevo va en `cursos/<curso>/...`, una subcarpeta del repo.

Si compilas desde una carpeta **fuera** del repo por completo, `latexmk`
no va a encontrar `.latexmkrc`, no sabrá usar LuaLaTeX, y
`\usepackage{icv}` va a fallar porque no encuentra `icv.sty`. No hay
ningún atajo limpio para ese caso -- simplemente mantén tus documentos
dentro de `cursos/`.

## 7. Verificar antes de dar el documento por terminado

```bash
make lint                              # chktex sobre todo el repo, o:
chktex -l .chktexrc -q mi-handout-nuevo.tex   # solo tu archivo
```

Además del lint, revisa el checklist de `CLAUDE.md` § Verificación (PDF
generado sin errores, metadata completa o con `TODO` explícito, figuras
con `alt=`, números con `\num`/`\qty`/columnas `S`, ninguna distinción que
dependa solo del color).

## 8. Generar un documento con ayuda de un agente de IA

Este repo está preparado para eso: [`CLAUDE.md`](CLAUDE.md) es un archivo
de convención que Claude Code (y agentes compatibles) carga
**automáticamente** como instrucciones de proyecto en cuanto abres una
sesión con directorio de trabajo dentro del repo. No hace falta
explicarle el sistema de estilo desde cero cada vez.

1. **Abre el agente con el directorio de trabajo dentro del repo** --
   idealmente ya en la carpeta destino, p. ej.
   `cursos/Acueductos y Alcantarillados/Handouts/`, para que el archivo
   nuevo caiga donde debe.
2. **`CLAUDE.md` se carga solo.** Ya establece que el agente debe leer
   `STYLE.md` antes de escribir nada, identificar el tipo de documento,
   partir de la plantilla o de un ejemplo dorado (nunca un
   `\documentclass` en blanco), usar `\icvsetup` para toda la metadata,
   compilar con `latexmk -lualatex`, verificar el PDF visualmente y con
   `chktex`, y dejar un `TODO` explícito -- nunca inventar -- si falta
   algún dato de metadata.
3. **Tu prompt solo necesita aportar lo que el agente no puede inventar:**
   el tema/contenido, el tipo de documento, y la metadata real (código de
   asignatura, ciclo académico, versión) si la tienes a mano.

Ejemplo de prompt:

> Crea un handout nuevo sobre el método de Thomas para proyección de
> población, para ICV 442 (Acueductos y Alcantarillados), ciclo 2026
> cuatrimestre 3. Básate en mis notas de clase [las pegas o apuntas a un
> archivo en `legacy/`]. Guárdalo en
> `cursos/Acueductos y Alcantarillados/Handouts/`.

Cosas que el agente **no** debe asumir por su cuenta sin preguntarte
primero (están explícitas en `CLAUDE.md`): tocar `icv.sty`, agregar un
paquete LaTeX no listado en `docs/packages.md`, cambiar colores o
fuentes, o hacer commit/push sin que se lo pidas.

**Si usas un agente que no auto-carga `CLAUDE.md`** (ChatGPT, u otra
herramienta sin esa convención), dilo explícitamente al inicio del
prompt: *"Lee `CLAUDE.md` y `STYLE.md` en la raíz de este repo antes de
hacer nada, y sigue esas reglas al pie de la letra."*

## Estructura del repo

```text
icv/                     # paquete núcleo: icv.sty, tokens.tex
  icv-local.cfg.tex.example  # plantilla de config local (logo), gitignored el real
templates/<tipo>/        # una plantilla en blanco por tipo de documento
examples/                 # documentos reales completos, ejemplo dorado por tipo
cursos/<curso>/           # tus documentos nuevos, organizados por curso -- ver cursos/README.md
legacy/                   # material previo del profesor, solo como referencia histórica
docs/packages.md           # lista cerrada de paquetes LaTeX permitidos
bib/                        # .bib compartido entre materias (citas opt-in)
.latexmkrc, Makefile         # compilación -- ver STYLE.md § Motor y compilación
.chktexrc                     # configuración de chktex (higiene básica)
```
