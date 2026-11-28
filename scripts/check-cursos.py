#!/usr/bin/env python3
"""Verifica que cursos/ siga la convención de carpetas (cursos/README.md).

Uso, desde la raíz del repo:
    python3 -I scripts/check-cursos.py [ruta ...]   (o: make check-cursos)

Sin argumentos revisa todo cursos/. Sale con código 1 si hay ERRORES; los
AVISOS (desviaciones de formato) no fallan salvo con --estricto.
Python puro, sin dependencias.

ERROR  = algo que no debe estar en el repo (datos de estudiantes, transcripciones
         de chat, cachés, archivos vacíos o sueltos donde no corresponde).
AVISO  = el documento no sigue el esquema de carpeta de un examen/pruebín.
"""
import os
import re
import sys
import unicodedata

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CURSOS = os.path.join(RAIZ, "cursos")

IGNORAR = {".DS_Store", "Thumbs.db", ".git", "build"}
DIRS_PROHIBIDOS = {"privado", "fichas", "__pycache__", ".venv", "venv", "node_modules"}
# Tipo de carpeta -> patrón del nombre de cada documento dentro de ella.
TIPOS = {
    "Exams": re.compile(r"^(Parcial|Examen) (\d{2})$|^Final$"),
    "Pruebines": re.compile(r"^Pruebin (\d{2})$"),
}
PERMITIDO_ARRIBA = [
    re.compile(r".+\.tex$"), re.compile(r".+\.pdf$"), re.compile(r".+\.docx$"),
    re.compile(r".+\.synctex\.gz$"), re.compile(r"^moodle-rubrica\.md$"),
    re.compile(r"^generar-[a-z0-9-]+\.py$"), re.compile(r"^\.gitignore$"),
]
DIRS_PERMITIDOS = {"clave", "plantillas", "figuras", "datos", "build"}
NOMBRE_TEX = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*\.tex$")
DATOS_ESTUDIANTES_NOMBRE = re.compile(
    r"(lista[ _-]*de[ _-]*estudiantes|estudiantes|calificaci|ids)\.?.*\.(csv|xls|xlsx|json|txt)$|^ps\.xls$|^ids\.txt$",
    re.I)
NOTAS_NOMBRE = re.compile(r"^notas[_-].*\.(csv|xls|xlsx)$", re.I)
TRANSCRIPCION = re.compile(r"^(conversaci|transcrip|chat[-_ ]).*\.(md|txt|html)$", re.I)
HUELLAS = ("Número de ID", "Numero de ID", "Dirección Email", "Direccion Email")
EXT_TEXTO = {".csv", ".xls", ".txt", ".html", ".md", ".json"}

errores, avisos = [], []


def nfc(s):
    return unicodedata.normalize("NFC", s)


def rel(p):
    return os.path.relpath(p, RAIZ)


def err(p, msg):
    errores.append(f"ERROR  {rel(p)}: {msg}")


def aviso(p, msg):
    avisos.append(f"AVISO  {rel(p)}: {msg}")


def huella(path):
    try:
        if os.path.getsize(path) > 2_000_000:
            return False
        with open(path, "r", encoding="utf-8", errors="ignore") as fh:
            cabeza = fh.read(4096)
        return any(h in cabeza for h in HUELLAS)
    except OSError:
        return False


def revisar_archivo(path, nombre):
    if nombre == "-":
        err(path, "archivo llamado «-» (residuo de un comando mal redirigido)")
    if os.path.getsize(path) == 0 and nombre not in (".gitkeep", "__init__.py"):
        err(path, "archivo vacío")
    if DATOS_ESTUDIANTES_NOMBRE.search(nfc(nombre)) or NOTAS_NOMBRE.search(nfc(nombre)):
        err(path, "parece un dato de estudiantes; va en Academics/.../<curso>/, no en el repo")
    elif os.path.splitext(nombre)[1].lower() in EXT_TEXTO and huella(path):
        err(path, "contiene columnas de lista de estudiantes (ID, correo); va en Academics/")
    if TRANSCRIPCION.search(nfc(nombre)):
        err(path, "transcripción de chat; no se versiona en cursos/")


def revisar_documento(carpeta_tipo, doc_dir, nombre_doc, patron):
    m = patron.match(nombre_doc)
    numero = next((g for g in (m.groups() if m else ()) if g and g.isdigit()), None)
    tex = [f for f in os.listdir(doc_dir) if f.endswith(".tex")]
    if numero is not None:
        prefijo = re.compile(rf"^(parcial|examen|pruebin)-{numero}-")
        if not any(prefijo.match(f) for f in tex):
            aviso(doc_dir, f"falta un .tex llamado «{nombre_doc.split()[0].lower()}-{numero}-<tema>.tex»")
    for f in sorted(os.listdir(doc_dir)):
        p = os.path.join(doc_dir, f)
        if f in IGNORAR and not os.path.isdir(p):
            continue
        if os.path.isdir(p):
            if f not in DIRS_PERMITIDOS and f not in DIRS_PROHIBIDOS:
                aviso(p, f"subcarpeta no prevista (permitidas: {', '.join(sorted(DIRS_PERMITIDOS))})")
            continue
        if not any(r.match(f) for r in PERMITIDO_ARRIBA):
            aviso(p, "archivo no previsto en la raíz del documento (¿va en clave/ o plantillas/?)")
        if f.endswith(".tex") and not NOMBRE_TEX.match(nfc(f)) and f != "enunciado.tex":
            aviso(p, "nombre de .tex fuera del patrón: minúsculas, números y guiones, sin acentos ni espacios")


def revisar(base):
    for dirpath, dirnames, filenames in os.walk(base):
        for d in list(dirnames):
            if d in IGNORAR:
                dirnames.remove(d)
            elif d in DIRS_PROHIBIDOS:
                err(os.path.join(dirpath, d), "carpeta que no va en el repo (datos de estudiantes o caché)")
                dirnames.remove(d)
        for f in filenames:
            if f in IGNORAR:
                continue
            revisar_archivo(os.path.join(dirpath, f), f)
        tipo = os.path.basename(dirpath)
        if tipo in TIPOS:
            patron = TIPOS[tipo]
            for f in filenames:
                if f not in IGNORAR:
                    err(os.path.join(dirpath, f), f"archivo suelto en «{tipo}/»: debe ir dentro de la carpeta de un documento")
            for d in sorted(dirnames):
                p = os.path.join(dirpath, d)
                if not patron.match(nfc(d)):
                    err(p, f"nombre de documento fuera del patrón de «{tipo}/» (p.ej. «Parcial 01», «Pruebin 02»)")
                else:
                    revisar_documento(dirpath, p, nfc(d), patron)


if __name__ == "__main__":
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    objetivos = [os.path.abspath(a) for a in args] or [CURSOS]
    for o in objetivos:
        if not os.path.isdir(o):
            sys.exit(f"No existe: {o}")
        revisar(o)
    for linea in errores + avisos:
        print(linea)
    print(f"\n{len(errores)} error(es), {len(avisos)} aviso(s).")
    sys.exit(1 if errores or (avisos and "--estricto" in sys.argv) else 0)
