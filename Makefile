# Makefile -- compilación manual, sin agente/IA de por medio.
#
# Requiere `make` en el PATH (en Windows: Git Bash/MSYS2 lo traen; si no lo
# tienes, compila igual con `latexmk` directamente dentro de cada carpeta de
# templates/ -- .latexmkrc se aplica solo con estar en el repo, sin depender
# de este Makefile).
#
# Uso:
#   make handout        # compila templates/handout/handout.tex
#   make pruebin         # compila templates/pruebin/pruebin.tex
#   make assignment      # compila templates/assignment/assignment.tex
#   make all             # compila todas las plantillas
#   make doc FILE=<ruta> # compila cualquier .tex del repo (p.ej. de cursos/)
#   make lint            # corre chktex sobre templates/ y examples/
#   make clean           # borra los build/ generados

# `time_it` cronometra una compilación e imprime los segundos al terminar,
# pase o falle. Un número en pantalla convierte "esto va lento" en un dato.
LATEXMK := latexmk
define time_it
@start=$$(date +%s); \
$(LATEXMK) $(1); rc=$$?; \
echo "[make] $$(( $$(date +%s) - $$start )) s"; \
exit $$rc
endef
CHKTEX  := chktex -l .chktexrc -q

TEMPLATES := $(wildcard templates/*/*.tex)
EXAMPLES  := $(wildcard examples/*.tex)
NAMES     := $(basename $(notdir $(TEMPLATES)))
EXNAMES   := $(basename $(notdir $(EXAMPLES)))

.PHONY: all clean lint examples doc $(NAMES) $(EXNAMES)

all: $(NAMES)

examples: $(EXNAMES)

$(EXNAMES): %: examples/%.tex
	$(call time_it,$<)

handout: templates/handout/handout.tex
	$(call time_it,$<)

assignment: templates/assignment/assignment.tex
	$(call time_it,$<)

exam: templates/exam/exam.tex
	$(call time_it,$<)

project-spec: templates/project-spec/project-spec.tex
	$(call time_it,$<)

slides: templates/slides/slides.tex
	$(call time_it,$<)

rubric: templates/rubric/rubric.tex
	$(call time_it,$<)

pruebin: templates/pruebin/pruebin.tex
	$(call time_it,$<)

# Compila un .tex arbitrario desde la raíz (necesario porque latexmk no lee
# .latexmkrc desde subcarpetas -- ver .latexmkrc). El build/ queda junto al
# documento gracias a $$do_cd.
#   make doc FILE="cursos/1930/1930 Hidráulica Aplicada/Pruebines/x.tex"
doc:
ifndef FILE
	$(error Falta FILE. Uso: make doc FILE="ruta/al/documento.tex")
endif
	$(call time_it,"$(FILE)")

lint:
	@for f in $(TEMPLATES) $(EXAMPLES); do \
	  echo "-- $$f --"; \
	  $(CHKTEX) "$$f" || true; \
	done

clean:
	@rm -rf build
	@find templates examples cursos -type d -name build -exec rm -rf {} + 2>/dev/null || true
	@# Borra los entregables generados y los auxiliares sueltos. Solo toca los
	@# que tienen un .tex hermano del mismo nombre, así que nunca borra un PDF
	@# de origen (p.ej. los ensayos versionados de legacy/, fuera de alcance).
	@find templates examples cursos -name '*.tex' 2>/dev/null | while read -r f; do \
	  rm -f "$${f%.tex}.pdf" "$${f%.tex}-clave.pdf" "$${f%.tex}.synctex.gz" "$${f%.tex}.aux"; \
	done
