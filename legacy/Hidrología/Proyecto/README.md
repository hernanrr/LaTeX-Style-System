# Análisis de precipitación

La carpeta sigue la misma separación entre fuentes y resultados usada en otros
materiales del curso.

- `tex/`: fuentes LaTeX de A1--A3, tutorial y preámbulos.
- `tex/Rúbricas de evaluación/`: fuentes de R1--R3 y su preámbulo.
- `img/`: imágenes utilizadas por el tutorial de QGIS.
- `build/`: PDF y archivos auxiliares generados por LuaLaTeX.
- `build/Rúbricas de evaluación/`: PDF y auxiliares de R1--R3.
- `build/_obsoletos/`: duplicados antiguos retirados de la estructura activa.

## Compilación

Ejecutar desde esta carpeta:

```powershell
.\compilar.ps1
```

El script usa `latexmk -lualatex` y mantiene todos los productos de compilación
dentro de `build/`.
