# ========================================================================================
# DIS-CHEM ENTERPRISE ESG DATA ENGINE (EXACT 16-COLUMN SCHEMA, 60 STORES, 24 MONTHS)
# Total Records: 1,440 Rows (FY2024 Baseline + FY2025 Current)
# ========================================================================================
$ErrorActionPreference = "Stop"

# 1. 60 Stores
$provinces = @(
    @{Prov="Gauteng"; Reg="Johannesburg North"; Util="City Power"},
    @{Prov="Gauteng"; Reg="Johannesburg Central"; Util="City Power"},
    @{Prov="Gauteng"; Reg="Johannesburg South"; Util="City Power"},
    @{Prov="Gauteng"; Reg="Ekurhuleni"; Util="Ekurhuleni Metro"},
    @{Prov="Gauteng"; Reg="Pretoria East"; Util="City of Tshwane"},
    @{Prov="Gauteng"; Reg="Centurion"; Util="City of Tshwane"},
    @{Prov="Gauteng"; Reg="Midrand Core"; Util="Eskom Direct"},
    @{Prov="Western Cape"; Reg="Cape Town Metro"; Util="City of Cape Town"},
    @{Prov="Western Cape"; Reg="Cape Town Central"; Util="City of Cape Town"},
    @{Prov="Western Cape"; Reg="Northern Suburbs"; Util="City of Cape Town"},
    @{Prov="Western Cape"; Reg="Helderberg"; Util="City of Cape Town"},
    @{Prov="Western Cape"; Reg="Garden Route"; Util="George Municipality"},
    @{Prov="KwaZulu-Natal"; Reg="eThekwini North"; Util="eThekwini Metro"},
    @{Prov="KwaZulu-Natal"; Reg="eThekwini Central"; Util="eThekwini Metro"},
    @{Prov="KwaZulu-Natal"; Reg="North Coast"; Util="KwaDukuza"},
    @{Prov="KwaZulu-Natal"; Reg="Midlands"; Util="Msunduzi"},
    @{Prov="Free State"; Reg="Mangaung"; Util="Centlec"},
    @{Prov="Mpumalanga"; Reg="Ehlanzeni"; Util="City of Mbombela"},
    @{Prov="Limpopo"; Reg="Capricorn"; Util="Polokwane Metro"},
    @{Prov="Eastern Cape"; Reg="Nelson Mandela Bay"; Util="Nelson Mandela Bay"},
    @{Prov="North West"; Reg="Bojanala"; Util="Rustenburg Local"},
    @{Prov="Northern Cape"; Reg="Frances Baard"; Util="Sol Plaatje"}
)

$storeNames = @(
    "Mall of Africa Flagship", "Glen Austin Midrand Distribution Hub", "Sandton City Dispensary",
    "Rosebank Link Superstore", "Fourways Mall Superstore", "Eastgate Shopping Centre",
    "Menlyn Park Flagship", "Centurion Mall Store", "Woodlands Boulevard", "Cresta Shopping Centre",
    "The Glen Mall", "Clearwater Mall Pharmacy", "Bedford Centre Dispensary", "Southgate Mall Store",
    "Kolonnade Centre", "Wonderpark Shopping Centre", "Brooklyn Mall Dispensary", "Cradlestone Mall",
    "Canal Walk Flagship", "V&A Waterfront Dispensary", "Tyger Valley Centre", "Somerset Mall West",
    "Cavendish Square", "Blue Route Mall", "Table Bay Mall", "Paarl Mall Dispensary", "Whale Coast Mall Hermanus",
    "Garden Route Mall George", "Gateway Theatre of Shopping", "Pavilion Centre Westville",
    "Ballito Junction Hub", "Galleria Mall Amanzimtoti", "Midlands Mall Pietermaritzburg",
    "Richards Bay Boardwalk", "Cornubia Mall Hub", "Loch Logan Waterfront", "Mimosa Mall Bloemfontein",
    "Goldfields Mall Welkom", "Ilanga Mall Nelspruit", "Riverside Mall Nelspruit", "Highveld Mall Witbank",
    "Middelburg Mall", "Mall of the North Polokwane", "Savannah Mall", "Tzaneen Mall Dispensary",
    "Thavhani Mall Thohoyandou", "Baywest Mall Dispensary", "Greenacres Shopping Centre",
    "Vincent Park East London", "Hemingways Mall", "Waterfall Mall Rustenburg", "Matlosana Mall Klerksdorp",
    "Mooi River Mall Potchefstroom", "Diamond Pavilion Kimberley", "Kalahari Mall Upington",
    "Bayside Mall Table View", "N1 City Goodwood", "Westgate Roodepoort", "Heidelberg Mall", "Secunda Mall"
)

$stores = @()
$rand = New-Object System.Random(42)

for ($i=0; $i -lt 60; $i++) {
    $sId = ("DC-SA-{0:D3}" -f ($i + 1))
    $sName = $storeNames[$i]
    $pInfo = $provinces[$i % $provinces.Count]
    
    $isDC = ($sName -like "*Distribution*")
    $isFlagship = ($sName -like "*Flagship*" -or $sName -like "*Superstore*")
    
    $fType = if ($isDC) { "Central Distribution Hub" } elseif ($isFlagship) { "Flagship Dispensary & Clinic" } else { "Standard Retail Pharmacy" }
    $gla = if ($isDC) { 9500 } elseif ($isFlagship) { 2600 + ($rand.Next(0, 7) * 100) } else { 1500 + ($rand.Next(0, 6) * 100) }
    $solarKwp = if ($isDC) { 450 } elseif ($isFlagship -and $rand.NextDouble() -lt 0.75) { 140 + ($rand.Next(0, 6) * 10) } elseif ($rand.NextDouble() -lt 0.35) { 70 + ($rand.Next(0, 4) * 10) } else { 0 }
    $genKva = if ($isDC) { 1250 } elseif ($isFlagship) { 450 + ($rand.Next(0, 3) * 50) } else { 250 + ($rand.Next(0, 3) * 50) }
    
    $stores += [PSCustomObject]@{
        Store_ID = $sId
        Store_Name = $sName
        Province = $pInfo.Prov
        Region = $pInfo.Reg
        Facility_Type = $fType
        Retail_GLA_SqM = $gla
        Solar_Capacity_kWp = $solarKwp
        Generator_kVA = $genKva
        Utility_Provider = $pInfo.Util
    }
}
$stores | Export-Csv -Path "Dim_Stores.csv" -NoTypeInformation -Encoding utf8

# 2. 24-Month Calendar (FY2024 Oct 2023 - Sep 2024, FY2025 Oct 2024 - Sep 2025)
$cal = @()
$calStart = [datetime]"2023-10-01"
for ($m=0; $m -lt 24; $m++) {
    $curD = $calStart.AddMonths($m)
    $fy = if ($m -lt 12) { "FY2024" } else { "FY2025" }
    $qNum = [math]::Floor(($m % 12) / 3) + 1
    $fq = "FQ$qNum"
    $cal += [PSCustomObject]@{
        Reporting_Date = $curD.ToString("yyyy-MM-dd")
        Year = $curD.Year
        Month_No = $curD.Month
        Month_Name = $curD.ToString("MMMM")
        Month_Year = $curD.ToString("MMM-yyyy")
        Fiscal_Year = $fy
        Fiscal_Quarter = $fq
        YearMonth_Sort = [int]$curD.ToString("yyyyMM")
    }
}
$cal | Export-Csv -Path "Dim_Calendar.csv" -NoTypeInformation -Encoding utf8

# 3. 1,440 Monthly Records with EXACT 16 Column Names
$facts = @()
foreach ($st in $stores) {
    $area = [double]$st.Retail_GLA_SqM
    $solarKwp = [double]$st.Solar_Capacity_kWp
    $hasSolar = $solarKwp -gt 0
    $isDC = $st.Facility_Type -like "*Distribution*"

    for ($m=0; $m -lt 24; $m++) {
        $curD = $calStart.AddMonths($m)
        $mStr = $curD.ToString("yyyy-MM-dd")
        $mNum = $curD.Month
        $isFY25 = ($m -ge 12)

        $efficiencyGain = if ($isFY25) { 0.965 } else { 1.0 }
        $rawBase = if ($isDC) { 11.0 } else { 17.2 }
        $baseKwh = $rawBase * $efficiencyGain
        $season = if ($mNum -in 11, 12, 1, 2) { 1.12 } elseif ($mNum -in 6, 7) { 1.07 } else { 0.96 }
        $fluct = 0.93 + ($rand.NextDouble() * 0.14)
        $grossKwh = [math]::Round($area * $baseKwh * $season * $fluct, 0)

        $solarKwh = 0
        if ($hasSolar) {
            $yieldFactor = if ($isFY25) { 1.08 } else { 0.95 }
            $yield = if ($mNum -in 10, 11, 12, 1, 2, 3) { 118 + ($rand.NextDouble() * 24) } else { 88 + ($rand.NextDouble() * 22) }
            $rawSolar = $solarKwp * $yield * $yieldFactor
            $solarKwh = [math]::Round([math]::Min($rawSolar, $grossKwh * 0.44), 0)
        }
        $gridKwh = $grossKwh - $solarKwh

        $loadShedFactor = if ($isFY25) { 0.65 } else { 1.25 }
        $dieselHrs = (8 + ($rand.NextDouble() * 26)) * $loadShedFactor
        $dieselL = [math]::Round($dieselHrs * ($st.Generator_kVA * 0.21), 1)

        $rawWater = if ($isDC) { 0.024 } else { 0.055 }
        $waterMult = if ($isFY25) { 0.96 } else { 1.0 }
        $waterIntensity = $rawWater * $waterMult
        $waterKl = [math]::Round($area * $waterIntensity * (0.88 + ($rand.NextDouble() * 0.24)), 1)

        $pkgWasteKg = [math]::Round($area * (0.65 + ($rand.NextDouble() * 0.32)), 1)
        $baseRecy = if ($isFY25) { 0.68 } else { 0.60 }
        $recyRatio = $baseRecy + ($rand.NextDouble() * 0.15)
        $recyKg = [math]::Round($pkgWasteKg * [math]::Min($recyRatio, 0.92), 1)

        $medWasteKg = if ($isDC) { [math]::Round(10 + ($rand.NextDouble() * 12), 1) } else { [math]::Round(42 + ($rand.NextDouble() * 68), 1) }
        $manifestProb = if ($isFY25) { 0.96 } else { 0.90 }
        $manifestStatus = if ($isDC) { "Compliant - Manifest on File" } else {
            if ($rand.NextDouble() -lt $manifestProb) { "Compliant - Manifest on File" } else { "Pending Safe Destruction Cert" }
        }

        $billProb = if ($isFY25) { 0.85 } else { 0.74 }
        $billType = if ($rand.NextDouble() -lt $billProb) { "Actual Meter Read" } else { "Municipal Estimate" }
        $auditStatus = if ($billType -eq "Municipal Estimate") {
            if ($rand.NextDouble() -lt 0.60) { "Flagged - Municipal Estimate Variance" } else { "Pending Reconciliation" }
        } else {
            if ($rand.NextDouble() -lt 0.93) { "Verified - Audit Trail Clear" } else { "Flagged - Unexplained Consumption Spike (>20%)" }
        }

        # Carbon Emissions
        $scope1 = [math]::Round(($dieselL * 2.68) / 1000.0, 3)
        $scope2 = [math]::Round(($gridKwh * 0.93) / 1000.0, 3)
        $solarAvoided = [math]::Round(($solarKwh * 0.93) / 1000.0, 3)

        $facts += [PSCustomObject]@{
            Reporting_Date = $mStr
            Store_ID = $st.Store_ID
            Grid_Electricity_kWh = $gridKwh
            Solar_Generated_kWh = $solarKwh
            Total_Electricity_Demand_kWh = $grossKwh
            Generator_Diesel_Litres = $dieselL
            Municipal_Water_kL = $waterKl
            Packaging_Waste_kg = $pkgWasteKg
            Recycled_Packaging_kg = $recyKg
            Hazardous_Clinical_Waste_kg = $medWasteKg
            Clinical_Waste_Manifest_Status = $manifestStatus
            Municipal_Billing_Type = $billType
            Assurance_Audit_Status = $auditStatus
            Scope_1_Emissions_tCO2e = $scope1
            Scope_2_Emissions_tCO2e = $scope2
            Solar_Avoided_Emissions_tCO2e = $solarAvoided
        }
    }
}
$facts | Export-Csv -Path "Fact_Store_ESG_Monthly.csv" -NoTypeInformation -Encoding utf8

Write-Host "CLEAN 16-COLUMN EXPANDED DATASET (1,440 ROWS, 60 STORES) REGENERATED!"
