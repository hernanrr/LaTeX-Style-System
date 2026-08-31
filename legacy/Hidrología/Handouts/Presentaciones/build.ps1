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
      $_.Name -match ' \d+\.pdf$' -or
      $_.Name -match '\(\d+\)\.pdf$' -or
      (-not $KeepCanonical -and $_.Name -eq $TargetName)
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
  @{ Source = "00_dossier_presentaciones.tex"; Target = "00_Dossier_de_presentaciones.pdf"; UseBiber = $true },
  @{ Source = "01_rubrica_equipo_expositor.tex"; Target = "01_Rubrica_del_equipo_expositor.pdf"; UseBiber = $false },
  @{ Source = "02_anexo_A_revision_audiencia.tex"; Target = "02_Anexo_A_revision_de_audiencia.pdf"; UseBiber = $false },
  @{ Source = "03_calendario_exposiciones_y_examenes.tex"; Target = "03_Calendario_de_exposiciones_y_examenes.pdf"; UseBiber = $false }
)

Push-Location $root
try {
  foreach ($doc in $docs) {
    xelatex -interaction=nonstopmode -halt-on-error $doc.Source | Out-Null
    if ($doc.UseBiber) {
      biber ([System.IO.Path]::GetFileNameWithoutExtension($doc.Source)) | Out-Null
      xelatex -interaction=nonstopmode -halt-on-error $doc.Source | Out-Null
    }
    xelatex -interaction=nonstopmode -halt-on-error $doc.Source | Out-Null

    $generated = [System.IO.Path]::ChangeExtension($doc.Source, ".pdf")
    Publish-CanonicalPdf -SourcePath (Join-Path $root $generated) -Directory $pdfDir -TargetName $doc.Target
  }

  foreach ($doc in $docs) {
    Normalize-CanonicalPdf -Directory $pdfDir -TargetName $doc.Target
  }

  Get-ChildItem -Path $root -File |
    Where-Object {
      $_.Extension -in ".aux", ".log", ".out", ".toc", ".bcf", ".bbl", ".blg", ".pdf" -or
      $_.Name -match '\.run\.xml$'
    } |
    ForEach-Object {
      try {
        Remove-Item -Force -LiteralPath $_.FullName -ErrorAction Stop
      }
      catch {
        Write-Warning "No se pudo eliminar archivo auxiliar bloqueado: $($_.Name)"
      }
    }
}
finally {
  Pop-Location
}
