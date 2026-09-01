# CLAUDE.md

Instrucciones para Claude Code (u otro agente) trabajando en este repo.
Este archivo es sobre **proceso**. Las reglas de estilo (colores,
tipografía, metadata, qué entorno usar) viven en [`STYLE.md`](STYLE.md) --
léelo también, no lo repitas de memoria.

## Qué es este repo

Sistema de estilo LaTeX versionado para material de clase (handouts,
asignaciones, exámenes, project specs, slides, rúbricas) de la Escuela de
Ingeniería Civil y Ambiental, PUCMM. Un paquete (`icv.sty`), no una clase
nueva -- ver `STYLE.md` § Arquitectura para la excepción de la clase `exam`.

## Flujo de trabajo obligatorio al generar un documento nuevo

1. **Lee `STYLE.md`** antes de escribir una sola línea de LaTeX, aunque
   creas recordarlo de una sesión anterior.
2. **Identifica el tipo de documento** (handout, assignment, ...). Si no
   existe una plantilla para ese tipo en `templates/`, dilo explícitamente
   y pregunta antes de improvisar una estructura nueva.
3. **Parte de la plantilla correspondiente** (`templates/<tipo>/<tipo>.tex`)
   o, si existe, de un ejemplo dorado en `examples/`. No empieces un
   documento en blanco con `\documentclass` a mano.
4. **Usa `\icvsetup{...}`** para toda la metadata -- nunca declares
   `\hypersetup` a mano (ya es automático desde `\icvsetup`, ver
   `icv.sty`), nunca hardcodees el nombre de la universidad/escuela fuera
   de `\icvmaketitle`.
5. **Compila con `latexmk -lualatex`** (`make <tipo>` desde la raíz, o
   `latexmk archivo.tex` desde la carpeta del documento) y corrige
   cualquier error antes de dar el documento por terminado. Un documento
   que no compila no está listo, sin importar cuánto contenido tenga.
6. **Verifica el resultado visualmente** (renderiza el PDF a imagen y
   revísalo) antes de reportar que algo "ya funciona" -- un log limpio no
   garantiza que el layout se vea bien.

## Si falta metadata

**No inventes el valor.** Si al generar un documento falta un campo de
`\icvsetup` (período académico, versión, título...) que el usuario no dio,
dejar un `TODO` visible en el propio valor del campo, por ejemplo:

```latex
periodo = {TODO: falta período académico},
```

y avisar explícitamente en la respuesta. Nunca asumir un período, una
versión, o un código de asignatura -- ver la tabla de códigos canónicos en
`STYLE.md`.

## No hagas esto sin preguntar primero

- Modificar `icv.sty` una vez esté "cerrado" para la fase actual del
  proyecto (pregunta si no estás seguro de si sigue abierto).
- Agregar un paquete no listado en `docs/packages.md`.
- Crear una clase `.cls` nueva.
- Cambiar fuentes o colores fuera de lo ya definido en `icv/tokens.tex`.
- Tomar una decisión visual subjetiva en silencio -- pregunta.
- Usar `-shell-escape` sin necesidad explícita (p.ej. `minted`).
- Copiar el logo institucional o el manual de marca al repo (es público en
  GitHub y el logo no se redistribuye -- ver `STYLE.md` § Logo).
- Comitear o hacer push sin que el usuario lo pida explícitamente.

## Estructura del repo

```text
icv/                   # paquete núcleo: icv.sty, tokens.tex
  icv-local.cfg.tex.example  # plantilla de config local (logo), gitignored el real
templates/<tipo>/       # una plantilla por tipo de documento
examples/                # documentos reales completos, ejemplo dorado por tipo
legacy/                  # preámbulos/documentos previos del profesor, sin tocar --
                          # solo como referencia histórica, nunca como fuente para copiar/pegar sin pasar por icv.sty
docs/packages.md          # lista cerrada de paquetes permitidos
bib/                       # .bib compartido entre materias (citas opt-in)
.latexmkrc, Makefile        # compilación -- ver STYLE.md § Motor y compilación
```

## Verificación antes de dar algo por terminado

- ¿Compila con `latexmk -lualatex` sin errores?
- ¿El PDF se ve bien (renderízalo y revísalo, no asumas)?
- ¿`chktex -l .chktexrc -q archivo.tex` (o `make lint`) sale limpio?
- ¿La metadata (`\icvsetup`) está completa o tiene `TODO` explícito donde
  falta?
- ¿Toda figura de contenido usa `\icvincludegraphics` con `alt=`?
- ¿Los números usan `\num`/`\qty`/columnas `S`, no formato manual?
- ¿Se usó un entorno semántico existente (`icvnote`, `icvwarning`,
  `icvobjectives`, `icvproblem`) en vez de maquetación ad hoc?
- ¿Cualquier distinción por color (caja semántica nueva, resaltado)
  también se distingue por texto? El sistema debe ser accesible para
  daltonismo de todo tipo -- ver STYLE.md § Accesibilidad para daltonismo.
  No depender solo del matiz.
