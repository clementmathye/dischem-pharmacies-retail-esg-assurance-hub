# PowerShell Generator for Enterprise Pharmacy ESG Datasets
$ErrorActionPreference = "Stop"

# 1. Dim_Stores
$stores = @(
    [PSCustomObject]@{Store_ID="DC-JHB-001"; Store_Name="Mall of Africa Flagship"; Province="Gauteng"; Region="Johannesburg North"; Facility_Type="Flagship & Clinic"; Retail_GLA_SqM=2850; Solar_Capacity_kWp=180; Generator_kVA=500; Utility_Provider="City Power"},
    [PSCustomObject]@{Store_ID="DC-JHB-002"; Store_Name="Glen Austin HQ Distribution"; Province="Gauteng"; Region="Midrand Core"; Facility_Type="Distribution Centre"; Retail_GLA_SqM=9200; Solar_Capacity_kWp=450; Generator_kVA=1250; Utility_Provider="Eskom Direct"},
    [PSCustomObject]@{Store_ID="DC-JHB-003"; Store_Name="Sandton City Dispensary"; Province="Gauteng"; Region="Johannesburg Central"; Facility_Type="Flagship & Clinic"; Retail_GLA_SqM=2600; Solar_Capacity_kWp=0; Generator_kVA=400; Utility_Provider="City Power"},
    [PSCustomObject]@{Store_ID="DC-JHB-004"; Store_Name="Rosebank Link"; Province="Gauteng"; Region="Johannesburg Central"; Facility_Type="Standard Retail"; Retail_GLA_SqM=1650; Solar_Capacity_kWp=0; Generator_kVA=250; Utility_Provider="City Power"},
    [PSCustomObject]@{Store_ID="DC-JHB-005"; Store_Name="Fourways Mall Superstore"; Province="Gauteng"; Region="Johannesburg North"; Facility_Type="Flagship & Clinic"; Retail_GLA_SqM=3100; Solar_Capacity_kWp=160; Generator_kVA=500; Utility_Provider="Eskom Direct"},
    [PSCustomObject]@{Store_ID="DC-JHB-006"; Store_Name="Eastgate Shopping Centre"; Province="Gauteng"; Region="Ekurhuleni"; Facility_Type="Standard Retail"; Retail_GLA_SqM=1850; Solar_Capacity_kWp=0; Generator_kVA=300; Utility_Provider="Ekurhuleni Metro"},
    [PSCustomObject]@{Store_ID="DC-PTA-007"; Store_Name="Menlyn Park Dispensary"; Province="Gauteng"; Region="Pretoria East"; Facility_Type="Flagship & Clinic"; Retail_GLA_SqM=2700; Solar_Capacity_kWp=140; Generator_kVA=450; Utility_Provider="City of Tshwane"},
    [PSCustomObject]@{Store_ID="DC-PTA-008"; Store_Name="Centurion Mall Store"; Province="Gauteng"; Region="Centurion"; Facility_Type="Standard Retail"; Retail_GLA_SqM=1950; Solar_Capacity_kWp=90; Generator_kVA=300; Utility_Provider="City of Tshwane"},
    [PSCustomObject]@{Store_ID="DC-PTA-009"; Store_Name="Woodlands Boulevard"; Province="Gauteng"; Region="Pretoria East"; Facility_Type="Standard Retail"; Retail_GLA_SqM=1750; Solar_Capacity_kWp=0; Generator_kVA=250; Utility_Provider="City of Tshwane"},
    [PSCustomObject]@{Store_ID="DC-CPT-010"; Store_Name="Canal Walk Superstore"; Province="Western Cape"; Region="Cape Town Metro"; Facility_Type="Flagship & Clinic"; Retail_GLA_SqM=2900; Solar_Capacity_kWp=175; Generator_kVA=450; Utility_Provider="City of Cape Town"},
    [PSCustomObject]@{Store_ID="DC-CPT-011"; Store_Name="V&A Waterfront Dispensary"; Province="Western Cape"; Region="Cape Town Central"; Facility_Type="Standard Retail"; Retail_GLA_SqM=1700; Solar_Capacity_kWp=0; Generator_kVA=250; Utility_Provider="City of Cape Town"},
    [PSCustomObject]@{Store_ID="DC-CPT-012"; Store_Name="Tyger Valley Centre"; Province="Western Cape"; Region="Northern Suburbs"; Facility_Type="Standard Retail"; Retail_GLA_SqM=1800; Solar_Capacity_kWp=85; Generator_kVA=300; Utility_Provider="City of Cape Town"},
    [PSCustomObject]@{Store_ID="DC-CPT-013"; Store_Name="Somerset Mall West"; Province="Western Cape"; Region="Helderberg"; Facility_Type="Standard Retail"; Retail_GLA_SqM=1650; Solar_Capacity_kWp=75; Generator_kVA=250; Utility_Provider="City of Cape Town"},
    [PSCustomObject]@{Store_ID="DC-DUR-014"; Store_Name="Gateway Theatre of Shopping"; Province="KwaZulu-Natal"; Region="eThekwini North"; Facility_Type="Flagship & Clinic"; Retail_GLA_SqM=2950; Solar_Capacity_kWp=190; Generator_kVA=500; Utility_Provider="eThekwini Metro"},
    [PSCustomObject]@{Store_ID="DC-DUR-015"; Store_Name="Pavilion Centre Westville"; Province="KwaZulu-Natal"; Region="eThekwini Central"; Facility_Type="Standard Retail"; Retail_GLA_SqM=1900; Solar_Capacity_kWp=0; Generator_kVA=350; Utility_Provider="eThekwini Metro"},
    [PSCustomObject]@{Store_ID="DC-DUR-016"; Store_Name="Ballito Junction Hub"; Province="KwaZulu-Natal"; Region="North Coast"; Facility_Type="Standard Retail"; Retail_GLA_SqM=1750; Solar_Capacity_kWp=80; Generator_kVA=300; Utility_Provider="KwaDukuza"},
    [PSCustomObject]@{Store_ID="DC-BFN-017"; Store_Name="Loch Logan Waterfront"; Province="Free State"; Region="Mangaung"; Facility_Type="Standard Retail"; Retail_GLA_SqM=1600; Solar_Capacity_kWp=0; Generator_kVA=250; Utility_Provider="Centlec"},
    [PSCustomObject]@{Store_ID="DC-BFN-018"; Store_Name="Mimosa Mall Pharmacy"; Province="Free State"; Region="Mangaung"; Facility_Type="Standard Retail"; Retail_GLA_SqM=1550; Solar_Capacity_kWp=60; Generator_kVA=250; Utility_Provider="Centlec"},
    [PSCustomObject]@{Store_ID="DC-NLP-019"; Store_Name="Ilanga Mall Nelspruit"; Province="Mpumalanga"; Region="Ehlanzeni"; Facility_Type="Standard Retail"; Retail_GLA_SqM=1700; Solar_Capacity_kWp=70; Generator_kVA=300; Utility_Provider="City of Mbombela"},
    [PSCustomObject]@{Store_ID="DC-POL-020"; Store_Name="Mall of the North"; Province="Limpopo"; Region="Capricorn"; Facility_Type="Standard Retail"; Retail_GLA_SqM=1800; Solar_Capacity_kWp=85; Generator_kVA=300; Utility_Provider="Polokwane Metro"},
    [PSCustomObject]@{Store_ID="DC-PLZ-021"; Store_Name="Baywest Mall Dispensary"; Province="Eastern Cape"; Region="Nelson Mandela Bay"; Facility_Type="Standard Retail"; Retail_GLA_SqM=1750; Solar_Capacity_kWp=0; Generator_kVA=250; Utility_Provider="Nelson Mandela Bay"},
    [PSCustomObject]@{Store_ID="DC-NW-022";  Store_Name="Waterfall Mall Rustenburg"; Province="North West"; Region="Bojanala"; Facility_Type="Standard Retail"; Retail_GLA_SqM=1650; Solar_Capacity_kWp=70; Generator_kVA=250; Utility_Provider="Rustenburg Local"},
    [PSCustomObject]@{Store_ID="DC-KBY-023"; Store_Name="Diamond Pavilion Kimberley"; Province="Northern Cape"; Region="Frances Baard"; Facility_Type="Standard Retail"; Retail_GLA_SqM=1500; Solar_Capacity_kWp=0; Generator_kVA=200; Utility_Provider="Sol Plaatje"},
    [PSCustomObject]@{Store_ID="DC-JHB-024"; Store_Name="Cresta Shopping Centre"; Province="Gauteng"; Region="Johannesburg West"; Facility_Type="Standard Retail"; Retail_GLA_SqM=1900; Solar_Capacity_kWp=95; Generator_kVA=300; Utility_Provider="City Power"}
)
$stores | Export-Csv -Path "Dim_Stores.csv" -NoTypeInformation -Encoding utf8

# 2. Dim_Calendar
$cal = @()
$startDate = [datetime]"2024-10-01"
for ($i=0; $i -lt 12; $i++) {
    $curDate = $startDate.AddMonths($i)
    $fy = "FY2025"
    $qNum = [math]::Floor($i / 3) + 1
    $fq = "FQ$qNum"
    $cal += [PSCustomObject]@{
        Reporting_Date = $curDate.ToString("yyyy-MM-dd")
        Year = $curDate.Year
        Month_No = $curDate.Month
        Month_Name = $curDate.ToString("MMMM")
        Month_Year = $curDate.ToString("MMM-yyyy")
        Fiscal_Year = $fy
        Fiscal_Quarter = $fq
        YearMonth_Sort = [int]$curDate.ToString("yyyyMM")
    }
}
$cal | Export-Csv -Path "Dim_Calendar.csv" -NoTypeInformation -Encoding utf8

# 3. Fact_Store_ESG_Monthly
$fact = @()
$rand = New-Object System.Random(42)

foreach ($st in $stores) {
    $area = [double]$st.Retail_GLA_SqM
    $solarKwp = [double]$st.Solar_Capacity_kWp
    $hasSolar = $solarKwp -gt 0
    $isDC = $st.Facility_Type -like "*Distribution*"
    $baseKwh = if ($isDC) { 11.2 } else { 17.5 }

    for ($i=0; $i -lt 12; $i++) {
        $curDate = $startDate.AddMonths($i)
        $mStr = $curDate.ToString("yyyy-MM-dd")
        $mNum = $curDate.Month

        $season = if ($mNum -in 11, 12, 1, 2) { 1.12 } elseif ($mNum -in 6, 7) { 1.08 } else { 0.96 }
        $fluct = 0.92 + ($rand.NextDouble() * 0.16)
        $grossKwh = [math]::Round($area * $baseKwh * $season * $fluct, 0)

        $solarKwh = 0
        if ($hasSolar) {
            $yield = if ($mNum -in 10, 11, 12, 1, 2, 3) { 115 + ($rand.NextDouble() * 25) } else { 85 + ($rand.NextDouble() * 25) }
            $rawSolar = $solarKwp * $yield
            $solarKwh = [math]::Round([math]::Min($rawSolar, $grossKwh * 0.42), 0)
        }
        $gridKwh = $grossKwh - $solarKwh

        $dieselHrs = 10 + ($rand.NextDouble() * 28)
        $dieselL = [math]::Round($dieselHrs * ($st.Generator_kVA * 0.22), 1)

        $waterIntensity = if ($isDC) { 0.026 } else { 0.058 }
        $waterKl = [math]::Round($area * $waterIntensity * (0.88 + ($rand.NextDouble() * 0.25)), 1)

        $pkgWasteKg = [math]::Round($area * (0.68 + ($rand.NextDouble() * 0.35)), 1)
        $recyRatio = 0.58 + ($rand.NextDouble() * 0.22)
        $recyKg = [math]::Round($pkgWasteKg * $recyRatio, 1)

        $medWasteKg = if ($isDC) { [math]::Round(12 + ($rand.NextDouble() * 14), 1) } else { [math]::Round(45 + ($rand.NextDouble() * 65), 1) }
        $manifestStatus = if ($isDC) { "Compliant - Manifest on File" } else {
            if ($rand.NextDouble() -lt 0.94) { "Compliant - Manifest on File" } else { "Pending Safe Destruction Cert" }
        }

        $billType = if ($rand.NextDouble() -lt 0.78) { "Actual Meter Read" } else { "Municipal Estimate" }
        $auditStatus = if ($billType -eq "Municipal Estimate") {
            if ($rand.NextDouble() -lt 0.65) { "Flagged - Municipal Estimate Variance" } else { "Pending Reconciliation" }
        } else {
            if ($rand.NextDouble() -lt 0.92) { "Verified - Audit Trail Clear" } else { "Flagged - Unexplained Consumption Spike (>20%)" }
        }

        # Emission calculations
        $scope1 = [math]::Round(($dieselL * 2.68) / 1000.0, 3)
        $scope2 = [math]::Round(($gridKwh * 0.93) / 1000.0, 3)
        $solarAvoided = [math]::Round(($solarKwh * 0.93) / 1000.0, 3)

        $fact += [PSCustomObject]@{
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
$fact | Export-Csv -Path "Fact_Store_ESG_Monthly.csv" -NoTypeInformation -Encoding utf8

# 4. Dim_Suppliers_ESG
$categories = @("Pharmaceuticals & Vaccines", "Vitamins, Sports & Supplements", "Personal Care, Baby & Beauty", "Store Consumables & Eco-Packaging", "Cold-Chain Logistics & Distribution")
$bbbeeLevels = @("Level 1", "Level 2", "Level 3", "Level 4", "Non-Compliant")
$suppliers = @()

for ($i=1; $i -le 50; $i++) {
    $supId = ("SUP-SA-{0:D3}" -f $i)
    $cat = $categories[$rand.Next(0, $categories.Length)]
    $tier = if ($i -le 20) { "Tier 1 Strategic" } elseif ($i -le 40) { "Tier 2 Key Partner" } else { "Tier 3 Specialist" }
    $score = [math]::Round(54.0 + ($rand.NextDouble() * 41.5), 1)

    $coc = if ($score -gt 64) { "Executed & Active" } elseif ($score -gt 58) { "Under Review" } else { "Overdue / Non-Responsive" }
    $risk = if ($score -ge 82) { "Low Risk - ESG Benchmark" } elseif ($score -ge 68) { "Moderate Risk - Continuous Monitoring" } else { "High Risk - Corrective Action Plan Required" }
    
    $pkgShare = if ($cat -like "*Packaging*" -or $cat -like "*Personal*") { [math]::Round(45 + ($rand.NextDouble() * 50), 1) } else { [math]::Round(20 + ($rand.NextDouble() * 55), 1) }
    
    $bRoll = $rand.NextDouble()
    $bbbee = if ($bRoll -lt 0.45) { "Level 1" } elseif ($bRoll -lt 0.80) { "Level 2" } elseif ($bRoll -lt 0.92) { "Level 3" } elseif ($bRoll -lt 0.98) { "Level 4" } else { "Non-Compliant" }
    $spend = [math]::Round(4.5 + ($rand.NextDouble() * 78.5), 2)

    $suppliers += [PSCustomObject]@{
        Supplier_ID = $supId
        Supplier_Name = "Healthcare Partner SA $i"
        Procurement_Category = $cat
        Supplier_Tier = $tier
        ESG_Audit_Score = $score
        Code_of_Conduct_Status = $coc
        ESG_Risk_Rating = $risk
        Sustainable_Packaging_Share_Pct = $pkgShare
        BBBEE_Level = $bbbee
        Annual_Spend_ZAR_Millions = $spend
    }
}
$suppliers | Export-Csv -Path "Dim_Suppliers_ESG.csv" -NoTypeInformation -Encoding utf8

Write-Host "ALL 4 CSVs GENERATED SUCCESSFULLY IN ESG-PROJECT WORKSPACE!"
