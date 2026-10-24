---
name: lista-ejercicios
description: Genera la lista maestra de ejercicios del portafolio de una asignatura (referencias a problemas de libros de texto, por subtema del programa) con el sistema icv. Úsalo cuando el usuario pida una lista, banco o batería de ejercicios para una asignatura, p.ej. "/lista-ejercicios Hidráulica Aplicada".
---

# Lista maestra de ejercicios

Produce un documento `assignment` con **todos** los ejercicios del portafolio
de un ciclo, categorizados por subtema del programa oficial. Cada entrada es
una referencia (libro + número impreso) y una línea de enfoque redactada por
ti. Ejemplo de referencia (léelo antes de escribir nada):
`cursos/1930/Hidráulica Básica/Assignments/lista-maestra-ejercicios-1930-hidraulica-basica.tex`.

Sigue también `CLAUDE.md` y `STYLE.md`; este skill no los reemplaza.

## 1. Datos que hay que pedir (no inventar)

Pregunta con AskUserQuestion solo lo que no esté en el mensaje del usuario:

- Asignatura (código canónico de `STYLE.md`) y ciclo.
- Ruta del PDF del programa oficial (de él salen unidades y subtemas).
- Libro primario y libros complementarios (PDFs, normalmente en
  `/Users/ricardo/Documents/Books/`).
- Temas obligatorios fuera del programa o con mínimo exigido (p.ej. en
  Hidráulica Básica: estabilidad de presas y cuerpo rígido, ≥ 1 ejercicio
  de cada libro donde aparezcan).
- Límites por tema (p.ej. ≤ 2 ejercicios por propiedad de los fluidos) y
  unidades con más peso.
- Semanas del ciclo para el tope.

## 2. Criterios fijos (ya acordados; no volver a preguntar)

- **Tope**: ≤ 15 ejercicios/semana × semanas del ciclo (14 → 210). No hace
  falta llegar al máximo; avisa si el total excede 15/semana en las semanas
  que quedan del ciclo.
- **Lista maestra** de todo el programa, sin atarse al calendario.
- **Sin FlowLab**: excluir todo problema que lo mencione **o lleve el ícono**
  (el ícono es una imagen; el texto extraído no lo muestra -- búscalo en el
  PDF, p.ej. con `pdfimages -list`, o por el hueco tras el número).
- **Sin software obligatorio**: excluir estudios paramétricos que piden EES o
  computadora.
- **SI** preferente; unidades inglesas («I»/«E») solo si no hay alternativa.
- Problemas conceptuales («C») permitidos con moderación.
- **No transcribir enunciados ni figuras** (derechos de autor): solo
  referencia + enfoque propio.
- Libro primario primero; los complementarios cubren lo que el primario no
  trata o trata poco (revisa siempre que el primario tenga problemas
  *numéricos* de cada tema: el Çengel, p.ej., no tiene de altura
  metacéntrica ni de Hazen-Williams).
- Temas vistos en clase pero ausentes del programa: subtema marcado
  «(complementario)».
- Erratas detectadas en los enunciados/respuestas: recuadro `icvwarning`.

## 3. Flujo

1. Lee `STYLE.md`, el ejemplo de referencia y el programa (`pdftotext
   -layout`).
2. **Cataloga en paralelo** con agentes Explore (máx. 3, `very thorough`):
   libro primario por bloques de capítulos y uno para los complementarios
   por tema. Pide tablas: número impreso | página impresa | sección del
   libro | resumen propio ≤ 15 palabras | figura | marcas (FlowLab, EES, I,
   C, Repaso, respuesta dada). Pide también el desfase página PDF ↔
   impresa y que verifiquen números de selecciones previas si existen.
   Libros escaneados sin texto: leer páginas como imagen.
3. **Selecciona** y presenta al usuario la distribución (tabla por subtema
   con números y conteos) antes de escribir el `.tex`. En modo plan, eso va
   en el plan.
4. **Verifica puntualmente** en el PDF los casos dudosos (OCR ilegible,
   unidades de la figura, dependencia de otro problema) y reemplaza por un
   vecino de la misma sección si falla.
5. **Bibliografía**: usa `bib/referencias.bib`; agrega las entradas que
   falten con datos de la página de derechos del PDF (sin ISBN si no la
   hay; comenta de dónde salen los datos). Confirma que la edición del PDF
   coincide con la entrada citada.
6. **Escribe** `cursos/<ciclo>/<asignatura>/Assignments/lista-maestra-ejercicios-<ciclo>-<slug>.tex`
   copiando la estructura del ejemplo de referencia:
   - `\usepackage[biblatex]{icv}` + `\addbibresource{referencias.bib}`.
   - `icvobjectives` desde las competencias del programa.
   - Instrucciones (fechas de entrega parcial: «se especifican en la PVA»
     salvo que el usuario dé otra cosa), `icvnote` «Cómo leer la lista»,
     `icvwarning` de erratas, tabla resumen por unidad con columna `S`.
   - `\addsec` por unidad, `\subsection*` por subtema, entorno local
     `ejercicios` (tabla booktabs Ejercicio | Enfoque).
   - Números de problema con `\nobreakdash-` (`Çengel 3\nobreakdash-73`),
     que además evita el aviso 8 de chktex.
7. **Compila** desde la raíz: `make doc FILE="<ruta>"` (nunca silenciar la
   salida). Confirma 0 citas indefinidas en `build/*.log`. Los overfull de
   ~11pt al cierre de las cajas `icv` son del paquete (también salen en la
   plantilla) y se ignoran.
8. `chktex -l .chktexrc -q <archivo>` limpio; renderiza páginas con
   `pdftoppm -r 60` al scratchpad y revísalas.
9. **Commit solo si el usuario lo pide.** Son dos repositorios:
   - `cursos/` (repo privado `cursos-icv-pucmm`): solo el `.tex`.
   - Raíz (repo público `LaTeX-Style-System`): `bib/referencias.bib`.
   Nunca PDFs, `build/` ni temporales de Emacs (`#f#`, `.#f`, `f~`).
