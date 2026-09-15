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
