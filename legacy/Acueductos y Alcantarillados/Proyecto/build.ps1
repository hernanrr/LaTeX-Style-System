$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$pdfDir = Join-Path (Split-Path $root -Parent) "pdf"

function Remove-PdfVariants {
  param(
    [string]$Directory,
    [string]$TargetName,
    [switch]$KeepCanonical
  )

  $baseName = [System.IO.Path]::GetFileNameWithoutExtension($TargetName)
  $variants = Get-ChildItem -Path $Directory -File -Filter "$baseName*.pdf" |
    Where-Object {
      $_.Name -match ' \d+\.pdf$' -or (-not $KeepCanonical -and $_.Name -eq $TargetName)
    }

  foreach ($variant in $variants) {
    Remove-Item -Force -LiteralPath $variant.FullName
  }
}

function Normalize-CanonicalPdf {
  param(
    [string]$Directory,
    [string]$TargetName
  )

  $targetPath = Join-Path $Directory $TargetName
  $baseName = [System.IO.Path]::GetFileNameWithoutExtension($TargetName)
  $candidates = Get-ChildItem -Path $Directory -File -Filter "$baseName*.pdf" |
    Sort-Object LastWriteTime -Descending

  if (-not $candidates) {
    throw "No se encontro ningun PDF para normalizar: $TargetName."
  }

  $canonical = $candidates | Where-Object { $_.Name -eq $TargetName } | Select-Object -First 1
  if (-not $canonical) {
    Move-Item -Force -LiteralPath $candidates[0].FullName -Destination $targetPath
    $canonical = Get-Item -LiteralPath $targetPath
  }

  Get-ChildItem -Path $Directory -File -Filter "$baseName*.pdf" |
    Where-Object { $_.Name -ne $TargetName } |
    Remove-Item -Force
}

function Publish-CanonicalPdf {
  param(
    [string]$SourcePath,
    [string]$Directory,
    [string]$TargetName
  )

  $targetPath = Join-Path $Directory $TargetName

  Remove-PdfVariants -Directory $Directory -TargetName $TargetName

  if (Test-Path -LiteralPath $targetPath) {
    Remove-Item -Force -LiteralPath $targetPath
  }

  Move-Item -Force -LiteralPath $SourcePath -Destination $targetPath
  Normalize-CanonicalPdf -Directory $Directory -TargetName $TargetName
}

$docs = @(
  @{ Source = "01_guia_lectura.tex"; Target = "01_Guia_de_lectura_del_proyecto.pdf" },
  @{ Source = "02_terminos_referencia.tex"; Target = "02_Terminos_de_referencia.pdf" },
  @{ Source = "03_especificaciones_tecnicas.tex"; Target = "03_Especificaciones_tecnicas_de_diseno.pdf" },
  @{ Source = "04_cronograma.tex"; Target = "04_Cronograma_del_proyecto.pdf" },
  @{ Source = "05_rubrica.tex"; Target = "05_Rubrica_de_evaluacion.pdf" },
  @{ Source = "06_lista_cotejo.tex"; Target = "06_Lista_de_cotejo_entrega_final.pdf" },
  @{ Source = "07_patron_demanda_epanet.tex"; Target = "07_Anexo_patron_demanda_EPANET.pdf" },
  @{ Source = "08_patron_descarga_swmm.tex"; Target = "08_Anexo_patron_descarga_SWMM.pdf" },
  @{ Source = "09_acta_bitacora.tex"; Target = "09_Anexo_acta_y_bitacora.pdf" },
  @{ Source = "11_espacios_pva.tex"; Target = "11_Espacios_PVA_del_proyecto.pdf" },
  @{ Source = "12_revision_pares.tex"; Target = "12_Formulario_revision_por_pares.pdf" },
  @{ Source = "13_presentacion_semanal.tex"; Target = "13_Formato_presentacion_semanal.pdf" }
)

foreach ($doc in $docs) {
  xelatex -interaction=nonstopmode -halt-on-error $doc.Source | Out-Null
  xelatex -interaction=nonstopmode -halt-on-error $doc.Source | Out-Null
  $generated = [System.IO.Path]::ChangeExtension($doc.Source, ".pdf")
  Publish-CanonicalPdf -SourcePath (Join-Path $root $generated) -Directory $pdfDir -TargetName $doc.Target
}

Get-ChildItem -Path $pdfDir -Force |
  Where-Object { $_.Name -eq "output_pdf" } |
  Remove-Item -Force -Recurse

xelatex -interaction=nonstopmode -halt-on-error 10_compilado_docente.tex | Out-Null
xelatex -interaction=nonstopmode -halt-on-error 10_compilado_docente.tex | Out-Null
Publish-CanonicalPdf -SourcePath (Join-Path $root "10_compilado_docente.pdf") -Directory $pdfDir -TargetName "10_Compilado_docente.pdf"

foreach ($doc in $docs) {
  Normalize-CanonicalPdf -Directory $pdfDir -TargetName $doc.Target
}

Normalize-CanonicalPdf -Directory $pdfDir -TargetName "10_Compilado_docente.pdf"

Get-ChildItem -Path $root -File |
  Where-Object { $_.Extension -in ".aux", ".log", ".out", ".toc" } |
  ForEach-Object {
    try {
      Remove-Item -Force -LiteralPath $_.FullName -ErrorAction Stop
    }
    catch {
      Write-Warning "No se pudo eliminar archivo auxiliar bloqueado: $($_.Name)"
    }
  }
