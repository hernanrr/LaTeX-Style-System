# AGENTS.md

Instrucciones para cualquier agente (ChatGPT/Codex, Claude Code u otro) que
trabaje en este repo. Es corto a propósito: las reglas completas están en los
archivos que enlaza. **Léelos antes de escribir o mover nada.**

1. Lee [`CLAUDE.md`](CLAUDE.md) (proceso) y [`STYLE.md`](STYLE.md) (reglas de
   estilo). No los repitas de memoria.
2. Los documentos de clase viven en `cursos/` (repo aparte, privado). Su
   estructura de carpetas está en [`cursos/README.md`](cursos/README.md).

## Reglas duras

- Compila con `latexmk -lualatex` **desde la raíz** (`make doc FILE=<ruta>`). Nunca
  `cd` a la carpeta del documento, nunca `pdflatex`/`xelatex`.
- Parte de una plantilla de `templates/<tipo>/` o de un ejemplo de `examples/`.
  Usa `\icvsetup{...}`; no declares `\hypersetup` ni fuentes ni colores propios.
- No modifiques `icv/icv.sty`, no agregues paquetes que no estén en
  `docs/packages.md`, no crees una clase `.cls`, no copies el logo al repo.
- Si falta un dato de metadata, deja `TODO` visible; no lo inventes.
- **Un documento = una carpeta** (`cursos/<ciclo>/<curso>/Exams/Parcial 02/`). No dejes
  archivos sueltos en la carpeta del tipo.
- **Nunca pongas datos de estudiantes en el repo** (listas, IDs, correos, entregas,
  notas). Van en `~/Documents/Academics/00-PUCMM/02-Año/<ciclo>/<curso>/`.
- No guardes transcripciones de chat, cachés (`__pycache__`, `.venv`), archivos
  vacíos ni residuos de comandos (un archivo llamado `-`).
- No hagas commit ni push sin que el usuario lo pida.

## Antes de dar algo por terminado

1. El documento compila sin errores y lo viste renderizado.
2. `make check-cursos` no reporta errores (los avisos, revísalos).
3. Dile al usuario qué archivos creaste o moviste y dónde quedaron.
