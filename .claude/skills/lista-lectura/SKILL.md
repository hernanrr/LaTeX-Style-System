---
name: lista-lectura
description: Genera la lista de lectura de una asignatura (por unidad y tema del programa: libro base, secciones y páginas impresas, más 1-3 lecturas complementarias) como handout icv. Úsalo cuando el usuario pida una lista, guía o plan de lecturas por tema, libro y página para una asignatura, p.ej. "/lista-lectura Hidráulica Aplicada".
---

# Lista de lectura

Produce un `handout` con una tabla por unidad del programa: *Tema | libro
base | lecturas complementarias*, cada celda con sección y páginas del libro
**impreso**. Es el trabajo de catalogar y **verificar páginas** lo que vale;
el `.tex` es corto. Ejemplo de referencia (léelo antes de escribir nada):
`cursos/1930/Hidráulica Básica/Handouts/Lista de lectura/lista-lectura-1930-hidraulica-basica.tex`.

Sigue también `CLAUDE.md` y `STYLE.md`; este skill no los reemplaza.

## 1. Datos que hay que pedir (no inventar)

Pregunta con AskUserQuestion solo lo que no esté en el mensaje del usuario:

- Asignatura (código canónico de `STYLE.md`) y ciclo.
- Ruta del PDF del programa oficial (de él salen unidades y temas).
- Libro base.
- Complementarios permitidos: bibliografía del programa, carpeta
  `references/` de la asignatura y cualquier otro libro de
  `~/Documents/Books` que el usuario quiera incluir.
- Densidad (1-3 por tema o todos los libros por tema) y organización (por
  unidad o por sesión del calendario).
- Si lleva `periodo` (por defecto no; ver abajo).

## 2. Criterios fijos (ya acordados; no volver a preguntar)

- **Páginas del libro impreso**, no del PDF; rango de la primera a la última
  página de la sección (la página compartida cuenta). Sin transcribir
  contenido.
- Libro base primero; **1-3 complementarias por tema**. Si el libro base no
  trata un tema, su celda lleva «---» y la complementaria cubre el vacío. Si
  un complementario no trata un tema, no se lista (nunca rellenar); lo que
  ningún libro cubre se dice en una línea bajo la tabla.
- **Omitir `periodo`**: material reutilizable entre ciclos (STYLE.md §
  Metadata). Es decisión explícita, no lleva `TODO`.
- Libros que nombran distinto lo mismo (factor α/β vs. coeficientes de
  Coriolis/Boussinesq) → una viñeta en el `icvwarning` final.
- **Enumera todas las fuentes candidatas** antes de catalogar: bibliografía
  del programa, `references/`, `bib/referencias.bib` y
  `ls ~/Documents/Books | grep -i <tema/autor>`. (Un libro en `bib/` y en
  Books pero ausente del programa se nos pasó una vez.)
- Si existe calendario de la asignatura, **cotéjalo** con el libro base
  (mismas secciones y páginas) y reporta discrepancias; no lo corrijas sin
  que el usuario lo pida.

## 3. Flujo

1. Lee `STYLE.md`, el ejemplo de referencia y el programa (`pdftotext
   -layout`).
2. **Verifica cada PDF antes de catalogar**: `pdfinfo` (páginas),
   `pdftotext` de una página (¿tiene capa de texto?) y la **edición real**
   en la página de derechos frente a la que cita el programa (el PDF manda;
   anota la diferencia). Si es un escaneo sin texto, propón una versión con
   texto (p.ej. archive.org): confirma con el usuario nombre, fuente y
   tamaño antes de descargar; baja a un directorio vacío del scratchpad
   (si un nodo da 500, prueba otro); comprueba que tenga texto y las mismas
   páginas; respalda el original en el scratchpad y solo entonces reemplaza.
   Si el PDF está incompleto, di qué capítulos faltan.
3. **Cataloga en paralelo** con agentes Explore (máx. 3, solo lectura, un
   grupo de libros por agente). Pide tabla *tema | sección | título | pp.
   impresas*, el desfase PDF↔impresa **y si es constante** (hay libros con
   saltos por capítulo o con páginas sin numerar), verificación contra
   páginas reales y no solo contra el índice, y «no trata» cuando
   corresponda. Repite el pase de un libro si su archivo cambia.
4. **Selecciona** y presenta al usuario la distribución (tabla por unidad)
   antes de escribir el `.tex`. En modo plan, eso va en el plan.
5. **Bibliografía**: agrega a `bib/referencias.bib` solo lo que falte, con
   datos de la página de derechos (ISBN solo si está impreso), comentario
   de procedencia y de la diferencia con el programa. Si la edición
   difiere, clave nueva (`white2011` junto a `white2016`).
6. **Escribe** `cursos/<ciclo>/<asignatura>/Handouts/Lista de lectura/lista-lectura-<ciclo>-<slug>.tex`
   copiando la estructura del ejemplo: `\usepackage[biblatex]{icv}` +
   `\addbibresource{referencias.bib}`; `icvobjectives`; introducción con
   `icvnote` «Cómo usar esta lista»; tabla de libros (clave, `\textcite`,
   edición); una `\section` por unidad con el entorno local `lectura`
   (longtable); `icvwarning` «Ediciones y vacíos»; `\printbibliography`.
   Detalles que ya costaron tiempo:
   - Varias lecturas en una celda con `\newline`; filas `& &` descuadran la
     altura de fila.
   - `\endhead%` y `\endfoot}` tal cual; `\endhead` seguido de salto de
     línea da el aviso 1 de chktex y `\endhead{}` rompe `\bottomrule`.
   - `\addlinespace[4pt]` entre temas; secciones del libro base con
     `\nobreakdash-` (`3\nobreakdash-4`); rangos con `pp.\,21--23`.
7. **Verifica páginas puntualmente** antes de compilar: 6-8 rangos al azar
   con `pdftotext -f/-l`, incluidos los libros con desfase irregular o OCR
   ruidoso. Corrige o marca «±1 página» donde el OCR no deje certeza.
8. **Compila** desde la raíz: `make doc FILE="<ruta>"` (nunca silenciar la
   salida). La primera pasada muestra citas indefinidas hasta que corre
   biber; confirma **0** en el `.log` final. Los overfull de ~11 pt al
   cierre de las cajas `icv` son del paquete y se ignoran.
9. `chktex -l .chktexrc -q <archivo>` limpio; renderiza con `pdftoppm -r 60`
   al scratchpad y revisa todas las páginas.
10. **Commit solo si el usuario lo pide.** Son dos repositorios:
    - `cursos/` (repo privado `cursos-icv-pucmm`): solo el `.tex`.
    - Raíz (repo público `LaTeX-Style-System`): `bib/referencias.bib` (y este
      skill o `STYLE.md` si cambiaron).
    Nunca PDFs, `build/` ni temporales de Emacs (`#f#`, `.#f`, `f~`).
