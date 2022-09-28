Param($Path, $Begin, $Span, $OutputPath, $Bitrate)
. "${PSScriptRoot}\IntervalTrimer.ps1"

if ($Begin -eq '' -or $Begin -eq $null) {
    $Begin = 0
}

if ($Span -eq '' -or $Span -eq $null) {
    $Span = 1
}

Add-Type -AssemblyName System.Windows.Forms
IT-Split -Path $Path -Begin $Begin -Span $Span -OutputPath $OutputPath -Bitrate $Bitrate
[System.Windows.Forms.MessageBox]::Show("ˆ—‚ªŠ®—¹‚µ‚Ü‚µ‚½", "IntervalTrimer")
