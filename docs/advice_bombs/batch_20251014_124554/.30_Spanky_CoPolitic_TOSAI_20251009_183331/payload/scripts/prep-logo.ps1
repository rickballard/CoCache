param([Parameter(Mandatory)][string]$Src,[Parameter(Mandatory)][string]$Out,[int]$Size=160,[int]$Pad=12)
$ErrorActionPreference='Stop'
$hasMagick = $null -ne (Get-Command magick -ErrorAction SilentlyContinue)
if ($hasMagick) {
  $target = $Size - 2*$Pad
  magick "$Src" -background none -colorspace sRGB -resize "${target}x${target}" `
         -gravity center -extent "${Size}x${Size}" -alpha on -strip "$Out"
} else {
  Add-Type -AssemblyName System.Drawing
  $img=[Drawing.Image]::FromFile($Src)
  $bmp=New-Object Drawing.Bitmap($Size,$Size,[Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g=[Drawing.Graphics]::FromImage($bmp)
  $g.Clear([Drawing.Color]::FromArgb(0,0,0,0))
  $g.SmoothingMode='HighQuality';$g.InterpolationMode='HighQualityBicubic';$g.PixelOffsetMode='HighQuality'
  $mw=$Size-2*$Pad;$mh=$Size-2*$Pad
  $s=[Math]::Min($mw/$img.Width,$mh/$img.Height)
  $nw=[int]([Math]::Round($img.Width*$s));$nh=[int]([Math]::Round($img.Height*$s))
  $x=[int](($Size-$nw)/2);$y=[int](($Size-$nh)/2)
  $g.DrawImage($img,(New-Object Drawing.Rectangle $x,$y,$nw,$nh),0,0,$img.Width,$img.Height,[Drawing.GraphicsUnit]::Pixel)
  $g.Dispose();$img.Dispose()
  $bmp.Save($Out,[Drawing.Imaging.ImageFormat]::Png);$bmp.Dispose()
}
Write-Host "Wrote $Out"

