# Makefile -- compilación manual, sin agente/IA de por medio.
#
# Requiere `make` en el PATH (en Windows: Git Bash/MSYS2 lo traen; si no lo
# tienes, compila igual con `latexmk` directamente dentro de cada carpeta de
# templates/ -- .latexmkrc se aplica solo con estar en el repo, sin depender
# de este Makefile).
#
# Uso:
#   make handout        # compila templates/handout/handout.tex
#   make assignment      # compila templates/assignment/assignment.tex
#   make all             # compila todas las plantillas
#   make clean           # borra los build/ generados

LATEXMK := latexmk

TEMPLATES := $(wildcard templates/*/*.tex)
EXAMPLES  := $(wildcard examples/*.tex)
NAMES     := $(basename $(notdir $(TEMPLATES)))
EXNAMES   := $(basename $(notdir $(EXAMPLES)))

.PHONY: all clean examples $(NAMES) $(EXNAMES)

all: $(NAMES)

examples: $(EXNAMES)

$(EXNAMES): %: examples/%.tex
	$(LATEXMK) $<

handout: templates/handout/handout.tex
	$(LATEXMK) $<

assignment: templates/assignment/assignment.tex
	$(LATEXMK) $<

exam: templates/exam/exam.tex
	$(LATEXMK) $<

project-spec: templates/project-spec/project-spec.tex
	$(LATEXMK) $<

slides: templates/slides/slides.tex
	$(LATEXMK) $<

rubric: templates/rubric/rubric.tex
	$(LATEXMK) $<

clean:
	@rm -rf build
	@find templates examples -type d -name build -exec rm -rf {} + 2>/dev/null || true
