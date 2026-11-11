# Extraer curvas de una ficha técnica en PDF

Método usado para los datos de la bomba ANDRITZ ACP65-330.4S en los
handouts de máquinas hidráulicas de ICV 441-T (curvas de altura, potencia y
NPSH requerido). Sirve para cualquier ficha cuyo PDF sea **vectorial**: da
la curva con exactitud, sin digitalizar a ojo.

Los scripts no se guardan en el repo; las cifras de cada handout salen de
un script propio fuera de él (ver el comentario al inicio de cada `.tex`).
Este documento fija el método para poder repetirlo.

## 1. Comprobar que el PDF es vectorial

```bash
pdfimages -list ficha.pdf          # solo logos/fotos = bien; la gráfica no debe aparecer
pdftocairo -svg -f 1 -l 1 ficha.pdf pagina1.svg
grep -c "<path" pagina1.svg        # cientos de trazos = vectorial
```

Si la gráfica aparece en `pdfimages -list` como una imagen grande, el PDF
es raster y este método no sirve.

## 2. Identificar los trazos

Cada trazo del SVG lleva `stroke="rgb(...)"`, `stroke-width` y una
`transform="matrix(a, 0, 0, d, e, f)"`. Las curvas de cada diámetro de
impulsor son trazos de un mismo color; el color y el grosor distinguen
curvas, cuadrícula y la curva seleccionada (más gruesa). Un script que
agrupe los trazos por color y los convierta con la matriz
(`x_pt = a·x + e`, `y_pt = d·y + f`) da los puntos en coordenadas de página.
En la ficha de ejemplo, una misma curva aparece partida en varios trazos
(tramos de distinto grosor): hay que unirlos y ordenarlos por abscisa.

## 3. Calibrar los ejes

1. Posición de las etiquetas de los ejes:
   `pdftotext -bbox -f 1 -l 1 ficha.pdf -` da el recuadro de cada número.
   Con dos etiquetas por eje se obtiene la escala (puntos por unidad).
2. **Validar contra valores impresos en la propia ficha** (la ficha trae un
   punto de selección con su caudal, altura, potencia y NPSH). Si el
   punto extraído no coincide, se corrige el desfase; la altura de la
   ACP65 quedó a 0.03 m de los valores impresos, la potencia a 0.8 % y el
   NPSH a 0.16 m (corregidos con el punto impreso).
3. Los ejes de las tres gráficas de la página (altura, potencia, NPSH) son
   independientes: se separan por la franja vertical de la página.

## 4. Lo que se calcula y lo que se lee

- Se **lee** de las curvas: altura $H(Q)$, potencia al eje $P(Q)$ y NPSH
  requerido, para cada diámetro.
- Se **calcula**: la eficiencia, $\eta=\rho gQH/P$ (reproduce el valor que
  imprime la ficha: 66.63 % a 22 l/s). Las isolíneas de eficiencia de la
  ficha no se extraen.
- Cada handout dice qué datos son del fabricante y cuáles se calcularon
  (ver `STYLE.md` § Convenciones de notación).

## 5. Límites

- La curva del NPSH requerido sube casi vertical al final del intervalo de
  la bomba; los puntos allí son poco fiables. Se usa solo hasta donde la
  curva es una función razonable del caudal.
- El número de cifras no puede superar el de la gráfica: una lectura al
  0.1 m de altura es lo que justifica el trazo, no más.
- La ficha de un fabricante es un material de catálogo; el handout la cita
  como tal y no copia el logo ni el diseño de la hoja.
