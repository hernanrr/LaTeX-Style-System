# cursos/

Aquí viven los documentos de clase **nuevos**, generados con este sistema
de estilo -- a diferencia de `legacy/` (material previo, solo de
referencia histórica, no se toca) y `examples/` (ejemplos dorados del
sistema mismo, no material de un curso real).

Convención de subcarpetas, una por curso:

```text
cursos/
  Acueductos y Alcantarillados/
    Handouts/
    Assignments/
    Examenes/
    Proyecto/
  Hidrología/
    ...
```

Los nombres de subcarpeta por curso no están normativizados en `STYLE.md`
-- usa el mismo criterio que ya existe en `legacy/`. Lo único que importa
para que `latexmk` funcione es que cualquier carpeta aquí sea una
subcarpeta del repo (ver [`README.md`](../README.md) § Compilar).

**Privacidad:** este repo (`LaTeX-Style-System`) es público. Todo lo
demás dentro de `cursos/` está en `.gitignore` -- solo este `README.md`
se sube aquí. Tu contenido real vive en un repo git privado *anidado*
dentro de esta carpeta; ver [`README.md`](../README.md) § Privacidad de
tus materiales de curso para la configuración.
