# cursos/

Aquí viven los documentos de clase **nuevos**, generados con este sistema
de estilo -- a diferencia de `legacy/` (material previo, solo de
referencia histórica, no se toca) y `examples/` (ejemplos dorados del
sistema mismo, no material de un curso real).

Convención: una subcarpeta por curso, dentro una por tipo de documento, y
**dentro una por documento**:

```text
cursos/
  1930/
    1930 Hidráulica Aplicada/
      Pruebines/
        Pruebin 01/
          pruebin-01-lge-lgp.tex     # fuente
          pruebin-01-lge-lgp.pdf     # entregable
          build/                     # auxiliares (ignorado)
        Pruebin 02/
          ...
      Handouts/
      Assignments/
```

La carpeta por documento no es burocracia: cada documento acumula sus
propias figuras, datos y su `build/`, y sin ella todo eso se mezcla en la
carpeta del tipo. Con varios documentos por tipo, los auxiliares de uno
enmascaran los del otro.

Los nombres de subcarpeta por curso no están normativizados en `STYLE.md`
-- usa el mismo criterio que ya existe en `legacy/`. Lo único que importa
para que `latexmk` funcione es que cualquier carpeta aquí sea una
subcarpeta del repo, y que **compiles desde la raíz** del sistema de
estilo: latexmk no lee `.latexmkrc` desde subcarpetas (ver
[`README.md`](../README.md) § Compilar y `STYLE.md` § Motor y compilación).

```bash
make doc FILE="cursos/1930/1930 Hidráulica Aplicada/Pruebines/Pruebin 01/pruebin-01-lge-lgp.tex"
```

**Privacidad:** este repo (`LaTeX-Style-System`) es público. Todo lo
demás dentro de `cursos/` está en `.gitignore` -- solo este `README.md`
se sube aquí. Tu contenido real vive en un repo git privado *anidado*
dentro de esta carpeta; ver [`README.md`](../README.md) § Privacidad de
tus materiales de curso para la configuración.

## Convención de un examen o pruebín

Cada examen o pruebín es una carpeta con el nombre del documento (`Parcial 02`,
`Pruebin 01`). Todo lo que el documento necesita vive ahí y nada queda suelto en
la carpeta del tipo (`Exams/`, `Pruebines/`):

```text
Exams/
  Parcial 02/
    parcial-02-<tema>.tex          # fuente (nombre en minúsculas y guiones, sin acentos)
    solucionario-parcial-02-<tema>.tex   # opcional: clave o rúbrica como documento
    moodle-rubrica.md              # opcional: rúbrica lista para configurar en Moodle
    generar-<algo>.py              # opcional: genera una versión derivada (p.ej. .docx)
    clave/                         # script que genera la clave y sus tablas (se versiona)
    plantillas/                    # lo que recibe el estudiante (plantilla de script, memoria)
    figuras/  datos/               # solo si el documento los necesita
    build/                         # auxiliares de LaTeX (ignorado)
    parcial-02-<tema>.pdf          # entregable generado: se regenera, no se versiona
```

- Los PDF y los `.docx` generados no se versionan; se regeneran desde la fuente.
- Las herramientas de calificación (revisar canarios, protocolos, resultados) no
  van aquí: viven con la calificación, en Academics (ver abajo).
- `make check-cursos` (desde la raíz del sistema de estilo) verifica estas reglas.
  Los **errores** bloquean el commit; los **avisos** señalan desviaciones de formato.

### Qué NO va en `cursos/`

- **Datos de estudiantes**: listas de clase, IDs, correos, entregas, notas,
  retroalimentación. Van fuera del repo, en
  `~/Documents/Academics/00-PUCMM/02-Año/<ciclo>/<curso>/`.
- Transcripciones de conversaciones con herramientas de IA.
- Cachés y entornos (`__pycache__`, `.venv`), archivos vacíos o con nombre accidental.

### Dónde se corrige

Cada examen tiene una carpeta de calificación con su mismo nombre, fuera del repo:

```text
~/Documents/Academics/00-PUCMM/02-Año/<ciclo>/<curso>/
  <ciclo> Lista de Estudiantes.xls     # una por curso
  Parcial 02/
    README.md                          # código de Moodle, estado, herramientas
    00-enunciado/                      # instantánea de lo aplicado: PDF, .docx, moodle-rubrica.md
    01-clave/                          # clave en PDF, clave-fuente/, clave-por-d/
    02-entregas/                       # descarga de Moodle, solo lectura, sin renombrar
    03-calificacion/                   # protocolo, resultados, herramientas de calificación
    04-moodle/                         # hoja de calificación y retroalimentación para subir
```

Los nombres de las carpetas de examen coinciden entre el repo y Academics
(`Parcial 02` en ambos). Las copias de `00-enunciado/` y `01-clave/` son
instantáneas: si cambia el examen, hay que recopiarlas.
