$ssmsDir = 'C:\Program Files\Microsoft SQL Server Management Studio 22\Release\Common7\IDE'
[System.Reflection.Assembly]::LoadFrom((Join-Path $ssmsDir 'Microsoft.AnalysisServices.Core.dll')) | Out-Null
[System.Reflection.Assembly]::LoadFrom((Join-Path $ssmsDir 'Microsoft.AnalysisServices.Tabular.dll')) | Out-Null

$srv = New-Object Microsoft.AnalysisServices.Tabular.Server
$srv.Connect('localhost:52730')
$model = $srv.Databases[0].Model

if (-not $model.Tables.Contains('Fact_DisChem_Foundation_Social')) {
    $tbl = New-Object Microsoft.AnalysisServices.Tabular.Table
    $tbl.Name = 'Fact_DisChem_Foundation_Social'
    $part = New-Object Microsoft.AnalysisServices.Tabular.Partition
    $part.Name = 'Fact_DisChem_Foundation_Social'
    $part.Source = New-Object Microsoft.AnalysisServices.Tabular.CalculatedPartitionSource
    $part.Source.Expression = @"
ADDCOLUMNS(
    SUMMARIZE(
        Fact_Store_ESG_Monthly,
        Fact_Store_ESG_Monthly[Store_ID],
        Fact_Store_ESG_Monthly[Reporting_Date]
    ),
    "Free_Clinic_Consultations", 
        IF(RELATED(Dim_Stores[Facility_Type]) <> "Central Distribution Hub",
           ROUND(45 + (1.2 * INT(RIGHT(Fact_Store_ESG_Monthly[Store_ID], 2))), 0), 
           0),
    "Preventative_Health_Screenings", 
        IF(RELATED(Dim_Stores[Facility_Type]) <> "Central Distribution Hub",
           ROUND(120 + (2.5 * INT(RIGHT(Fact_Store_ESG_Monthly[Store_ID], 2))), 0), 
           0),
    "Foundation_Mobile_Clinic_Hours", 
        IF(RELATED(Dim_Stores[Facility_Type]) = "Flagship Dispensary & Clinic", 18, 8)
)
"@
    $tbl.Partitions.Add($part)
    $model.Tables.Add($tbl)
    $model.SaveChanges()
    $tbl.RequestRefresh([Microsoft.AnalysisServices.Tabular.RefreshType]::Calculate)
    $model.SaveChanges()
    Write-Host 'Fact_DisChem_Foundation_Social created and calculated successfully!'
} else {
    Write-Host 'Table Fact_DisChem_Foundation_Social already exists.'
}
$srv.Disconnect()
