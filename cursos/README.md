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

Este archivo existe para que la carpeta se trackee en git aunque esté
vacía; bórralo o déjalo, es indistinto una vez haya contenido real.
