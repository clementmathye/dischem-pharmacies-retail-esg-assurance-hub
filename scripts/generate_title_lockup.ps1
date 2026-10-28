Add-Type -AssemblyName System.Drawing

$logoPath = "C:\Users\Clement\.gemini\antigravity\brain\fe7a3bda-38ec-4858-aaad-676acb87463d\.user_uploaded\media_1793131579346_99961c03.png"
$origLogo = [System.Drawing.Bitmap]::FromFile($logoPath)

# --------------------------------------------------------------------------------------------------
# VARIANT 1: CUTOUT LOGO (Transparent green background, preserving white D and yellow +)
# --------------------------------------------------------------------------------------------------
$logoWidth = $origLogo.Width
$logoHeight = $origLogo.Height
$cutoutLogo = New-Object System.Drawing.Bitmap($logoWidth, $logoHeight, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

for ($x = 0; $x -lt $logoWidth; $x++) {
    for ($y = 0; $y -lt $logoHeight; $y++) {
        $pixel = $origLogo.GetPixel($x, $y)
        # Identify green background: High green, lower red and blue
        # Green is around R=2, G=159, B=74
        if ($pixel.G -gt 100 -and $pixel.R -lt 120 -and $pixel.B -lt 120) {
            # Make transparent
            $cutoutLogo.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        } else {
            $cutoutLogo.SetPixel($x, $y, $pixel)
        }
    }
}

# --------------------------------------------------------------------------------------------------
# RENDER TITLE LOCKUP 1 (Cutout Logo + Crisp Typography at 2x DPI: 1200 x 220)
# --------------------------------------------------------------------------------------------------
$canvasW = 1200
$canvasH = 220
$bmp1 = New-Object System.Drawing.Bitmap($canvasW, $canvasH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g1 = [System.Drawing.Graphics]::FromImage($bmp1)
$g1.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g1.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g1.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g1.Clear([System.Drawing.Color]::Transparent)

# Draw Cutout Logo on Left: size 160x160 at X: 20, Y: 30
$logoDestRect = New-Object System.Drawing.Rectangle(20, 30, 160, 160)
$g1.DrawImage($cutoutLogo, $logoDestRect)

# Fonts
$fontFamily = "Segoe UI"
$fTitle1 = New-Object System.Drawing.Font($fontFamily, 28, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
$fTitle2 = New-Object System.Drawing.Font($fontFamily, 22, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
$fSub = New-Object System.Drawing.Font($fontFamily, 16, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)

# Brushes
$bWhite = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 255, 255))
$bEmerald = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 52, 211, 153)) # Light Emerald Glow #34D399
$bSlate = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 203, 213, 225)) # Light Slate #CBD5E1

# Draw Text Lines
$textStartX = 205
$g1.DrawString("DIS-CHEM PHARMACIES", $fTitle1, $bWhite, $textStartX, 32)
$g1.DrawString("GROUP ESG PERFORMANCE & AUDIT ASSURANCE SUITE", $fTitle2, $bEmerald, $textStartX, 82)
$g1.DrawString("JSE Sustainability Guidance & GRI Standards | Clement Mathye (BCIS)", $fSub, $bSlate, $textStartX, 130)

$outPath1 = "c:\Users\Clement\Downloads\ESG-project\DisChem_Title_Header_Lockup.png"
$bmp1.Save($outPath1, [System.Drawing.Imaging.ImageFormat]::Png)

# --------------------------------------------------------------------------------------------------
# VARIANT 2: ROUNDED EMBLEM BADGE (With the official green square styled with rounded corners)
# --------------------------------------------------------------------------------------------------
$bmp2 = New-Object System.Drawing.Bitmap($canvasW, $canvasH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g2 = [System.Drawing.Graphics]::FromImage($bmp2)
$g2.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g2.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g2.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g2.Clear([System.Drawing.Color]::Transparent)

# Create Rounded Badge for origLogo
$badgeSize = 150
$badgeRect = New-Object System.Drawing.Rectangle(25, 35, $badgeSize, $badgeSize)
$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$radius = 32
$diameter = $radius * 2
$arc = New-Object System.Drawing.Rectangle($badgeRect.X, $badgeRect.Y, $diameter, $diameter)
$path.AddArc($arc, 180, 90)
$arc.X = $badgeRect.Right - $diameter
$path.AddArc($arc, 270, 90)
$arc.Y = $badgeRect.Bottom - $diameter
$path.AddArc($arc, 0, 90)
$arc.X = $badgeRect.Left
$path.AddArc($arc, 90, 90)
$path.CloseFigure()

$g2.SetClip($path)
$g2.DrawImage($origLogo, $badgeRect)
$g2.ResetClip()

# Draw subtle white border around badge
$pen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 255, 255, 255), 3)
$g2.DrawPath($pen, $path)

# Text Lines for Variant 2
$g2.DrawString("DIS-CHEM PHARMACIES", $fTitle1, $bWhite, $textStartX, 32)
$g2.DrawString("GROUP ESG PERFORMANCE & AUDIT ASSURANCE SUITE", $fTitle2, $bEmerald, $textStartX, 82)
$g2.DrawString("JSE Sustainability Guidance & GRI Standards | Clement Mathye (BCIS)", $fSub, $bSlate, $textStartX, 130)

$outPath2 = "c:\Users\Clement\Downloads\ESG-project\DisChem_Title_Header_Badge.png"
$bmp2.Save($outPath2, [System.Drawing.Imaging.ImageFormat]::Png)

# Cleanup
$g1.Dispose()
$bmp1.Dispose()
$g2.Dispose()
$bmp2.Dispose()
$cutoutLogo.Dispose()
$origLogo.Dispose()

Write-Host "SUCCESS: Both transparent PNG title lockups generated in ESG-project!"
