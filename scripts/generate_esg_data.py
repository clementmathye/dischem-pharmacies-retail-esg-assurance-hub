"""
========================================================================================
ENTERPRISE PHARMACY RETAIL ESG & ASSURANCE DATA ENGINE
Target: Dis-Chem / JSE-Listed Retail Group Sustainability & Audit Assurance Portfolio
Author: Clement Mathye (BCIS)
Standards: JSE Sustainability Disclosure Guidance, GRI 302/305/306, GHG Protocol
========================================================================================
"""

import pandas as pd
import numpy as np
from datetime import datetime, timedelta

np.random.seed(42)

# --------------------------------------------------------------------------------------
# 1. DIM_STORES (24 Representative Stores across SA Retail Footprint)
# --------------------------------------------------------------------------------------
stores_data = [
    # Store_ID, Store_Name, Province, Region, Facility_Type, Retail_GLA_SqM, Solar_Capacity_kWp, Generator_kVA, Utility_Provider
    ("DC-JHB-001", "Mall of Africa Flagship", "Gauteng", "Johannesburg North", "Flagship & Clinic", 2850, 180, 500, "City Power"),
    ("DC-JHB-002", "Glen Austin HQ Distribution", "Gauteng", "Midrand Core", "Distribution Centre", 9200, 450, 1250, "Eskom Direct"),
    ("DC-JHB-003", "Sandton City Dispensary", "Gauteng", "Johannesburg Central", "Flagship & Clinic", 2600, 0, 400, "City Power"),
    ("DC-JHB-004", "Rosebank Link", "Gauteng", "Johannesburg Central", "Standard Retail", 1650, 0, 250, "City Power"),
    ("DC-JHB-005", "Fourways Mall Superstore", "Gauteng", "Johannesburg North", "Flagship & Clinic", 3100, 160, 500, "Eskom Direct"),
    ("DC-JHB-006", "Eastgate Shopping Centre", "Gauteng", "Ekurhuleni", "Standard Retail", 1850, 0, 300, "Ekurhuleni Metro"),
    ("DC-PTA-007", "Menlyn Park Dispensary", "Gauteng", "Pretoria East", "Flagship & Clinic", 2700, 140, 450, "City of Tshwane"),
    ("DC-PTA-008", "Centurion Mall Store", "Gauteng", "Centurion", "Standard Retail", 1950, 90, 300, "City of Tshwane"),
    ("DC-PTA-009", "Woodlands Boulevard", "Gauteng", "Pretoria East", "Standard Retail", 1750, 0, 250, "City of Tshwane"),
    ("DC-CPT-010", "Canal Walk Superstore", "Western Cape", "Cape Town Metro", "Flagship & Clinic", 2900, 175, 450, "City of Cape Town"),
    ("DC-CPT-011", "V&A Waterfront Dispensary", "Western Cape", "Cape Town Central", "Standard Retail", 1700, 0, 250, "City of Cape Town"),
    ("DC-CPT-012", "Tyger Valley Centre", "Western Cape", "Northern Suburbs", "Standard Retail", 1800, 85, 300, "City of Cape Town"),
    ("DC-CPT-013", "Somerset Mall West", "Western Cape", "Helderberg", "Standard Retail", 1650, 75, 250, "City of Cape Town"),
    ("DC-DUR-014", "Gateway Theatre of Shopping", "KwaZulu-Natal", "eThekwini North", "Flagship & Clinic", 2950, 190, 500, "eThekwini Metro"),
    ("DC-DUR-015", "Pavilion Centre Westville", "KwaZulu-Natal", "eThekwini Central", "Standard Retail", 1900, 0, 350, "eThekwini Metro"),
    ("DC-DUR-016", "Ballito Junction Hub", "KwaZulu-Natal", "North Coast", "Standard Retail", 1750, 80, 300, "KwaDukuza"),
    ("DC-BFN-017", "Loch Logan Waterfront", "Free State", "Mangaung", "Standard Retail", 1600, 0, 250, "Centlec"),
    ("DC-BFN-018", "Mimosa Mall Pharmacy", "Free State", "Mangaung", "Standard Retail", 1550, 60, 250, "Centlec"),
    ("DC-NLP-019", "Ilanga Mall Nelspruit", "Mpumalanga", "Ehlanzeni", "Standard Retail", 1700, 70, 300, "City of Mbombela"),
    ("DC-POL-020", "Mall of the North", "Limpopo", "Capricorn", "Standard Retail", 1800, 85, 300, "Polokwane Metro"),
    ("DC-PLZ-021", "Baywest Mall Dispensary", "Eastern Cape", "Nelson Mandela Bay", "Standard Retail", 1750, 0, 250, "Nelson Mandela Bay"),
    ("DC-NW-022",  "Waterfall Mall Rustenburg", "North West", "Bojanala", "Standard Retail", 1650, 70, 250, "Rustenburg Local"),
    ("DC-KBY-023", "Diamond Pavilion Kimberley", "Northern Cape", "Frances Baard", "Standard Retail", 1500, 0, 200, "Sol Plaatje"),
    ("DC-JHB-024", "Cresta Shopping Centre", "Gauteng", "Johannesburg West", "Standard Retail", 1900, 95, 300, "City Power")
]

df_dim_stores = pd.DataFrame(stores_data, columns=[
    "Store_ID", "Store_Name", "Province", "Region", "Facility_Type", 
    "Retail_GLA_SqM", "Solar_Capacity_kWp", "Generator_kVA", "Utility_Provider"
])

# --------------------------------------------------------------------------------------
# 2. DIM_CALENDAR (Oct 2024 - Sept 2025: Full 12-Month South African Fiscal Year)
# --------------------------------------------------------------------------------------
start_date = pd.to_datetime("2024-10-01")
end_date = pd.to_datetime("2025-09-30")
date_range = pd.date_range(start_date, end_date, freq="D")

calendar_records = []
for d in date_range:
    fy = f"FY{d.year if d.month < 10 else d.year + 1}"
    fq = f"FQ{((d.month - 10) % 12) // 3 + 1}"
    calendar_records.append([
        d.strftime("%Y-%m-%d"),
        d.year,
        d.month,
        d.strftime("%B"),
        d.strftime("%b-%Y"),
        fy,
        fq,
        d.strftime("%Y%m")
    ])

df_dim_calendar = pd.DataFrame(calendar_records, columns=[
    "Date", "Year", "Month_No", "Month_Name", "Month_Year", "Fiscal_Year", "Fiscal_Quarter", "YearMonth_Sort"
]).drop_duplicates(subset=["YearMonth_Sort"])

# --------------------------------------------------------------------------------------
# 3. FACT_STORE_MONTHLY_ESG (24 Stores x 12 Months = 288 Rows)
# --------------------------------------------------------------------------------------
# Real South African ESG Factors:
# Eskom Grid Emission Factor = 0.93 tCO2e / MWh -> 0.00093 tCO2e / kWh (0.93 kg CO2e / kWh)
# Diesel Stationary Factor   = 2.68 kg CO2e / L -> 0.00268 tCO2e / L
# Water Scarcity Baseline    = City Power/Joburg Water & eThekwini municipal tariff structures
# Municipal Billing Reality  = Disputed/Estimated vs Actual meter readings

months = pd.date_range("2024-10-01", "2025-09-01", freq="MS")
fact_records = []

for _, st in df_dim_stores.iterrows():
    area = st["Retail_GLA_SqM"]
    solar_kwp = st["Solar_Capacity_kWp"]
    has_solar = solar_kwp > 0
    is_dc = "Distribution" in st["Facility_Type"]
    
    # Baseline intensity per m2 per month
    base_kwh_per_sqm = 17.5 if not is_dc else 11.2
    
    for m in months:
        m_str = m.strftime("%Y-%m-%d")
        
        # Seasonality: higher HVAC in summer (Nov-Feb), high lighting/heating in winter (Jun-Aug)
        seasonality = 1.12 if m.month in [11, 12, 1, 2] else (1.08 if m.month in [6, 7] else 0.96)
        
        # Gross Electricity demand
        gross_demand_kwh = round(area * base_kwh_per_sqm * seasonality * np.random.uniform(0.92, 1.08), 0)
        
        # Solar generation (depends on sunshine hours: High in summer, slightly lower in winter)
        if has_solar:
            solar_yield_factor = np.random.uniform(115, 140) if m.month in [10, 11, 12, 1, 2, 3] else np.random.uniform(85, 110)
            solar_kwh = round(min(solar_kwp * solar_yield_factor, gross_demand_kwh * 0.42), 0)
        else:
            solar_kwh = 0
            
        grid_kwh = gross_demand_kwh - solar_kwh
        
        # Generator Diesel: SA grid load shedding / substation failures
        # Summer storms or substation breakdowns in Joburg/Ekurhuleni trigger random spikes
        base_diesel_hrs = np.random.uniform(8, 35)
        diesel_litres = round(base_diesel_hrs * (st["Generator_kVA"] * 0.22), 1)
        
        # Municipal Water (kL): Dispensary cleaning, public restrooms, clinic sterilization
        water_intensity = 0.055 if not is_dc else 0.025
        water_kl = round(area * water_intensity * np.random.uniform(0.85, 1.25), 1)
        
        # Waste Streams (kg):
        # 1. Total packaging (cardboard, shrink wrap, transport totes)
        packaging_waste_kg = round(area * np.random.uniform(0.65, 1.1), 1)
        
        # 2. Recycled waste (cardboard bale pickups, paper recycling)
        recycle_ratio = np.random.uniform(0.58, 0.82)
        recycled_waste_kg = round(packaging_waste_kg * recycle_ratio, 1)
        
        # 3. Hazardous Clinical & Medical Waste (Sharps, expired schedule drugs, clinic swabs)
        # Highly regulated under National Environmental Management: Waste Act (NEMWA)
        if is_dc:
            medical_waste_kg = round(np.random.uniform(12.0, 28.0), 1)
            manifest_status = "Compliant - Manifest on File"
        else:
            medical_waste_kg = round(np.random.uniform(45.0, 115.0), 1)
            # 94% compliance; 6% missing destruction certificates
            manifest_status = np.random.choice(
                ["Compliant - Manifest on File", "Pending Safe Destruction Cert"],
                p=[0.94, 0.06]
            )
            
        # Billing Verification & Internal Assurance Status:
        # A true ESG assurance audit nightmare: Municipal bills are frequently "Estimated" by City Power / Tshwane
        bill_type = np.random.choice(["Actual Meter Read", "Municipal Estimate"], p=[0.78, 0.22])
        
        # Assurance Status:
        # Invoices verified, flagged for >20% unexplained variance, or missing invoice
        if bill_type == "Municipal Estimate":
            assurance_status = np.random.choice(
                ["Flagged - Municipal Estimate Variance", "Pending Reconciliation"],
                p=[0.65, 0.35]
            )
        else:
            # For actual reads, 92% clean, 8% flagged variance
            assurance_status = np.random.choice(
                ["Verified - Audit Trail Clear", "Flagged - Unexplained Consumption Spike (>20%)"],
                p=[0.92, 0.08]
            )
            
        # Carbon Accounting:
        # Scope 1 (Diesel): 2.68 kg CO2e / L
        # Scope 2 (Eskom Grid): 0.93 kg CO2e / kWh
        scope1_tco2e = round((diesel_litres * 2.68) / 1000.0, 3)
        scope2_tco2e = round((grid_kwh * 0.93) / 1000.0, 3)
        solar_avoided_tco2e = round((solar_kwh * 0.93) / 1000.0, 3)
        
        fact_records.append([
            m_str,
            st["Store_ID"],
            grid_kwh,
            solar_kwh,
            gross_demand_kwh,
            diesel_litres,
            water_kl,
            packaging_waste_kg,
            recycled_waste_kg,
            medical_waste_kg,
            manifest_status,
            bill_type,
            assurance_status,
            scope1_tco2e,
            scope2_tco2e,
            solar_avoided_tco2e
        ])

df_fact_esg = pd.DataFrame(fact_records, columns=[
    "Reporting_Date", "Store_ID", "Grid_Electricity_kWh", "Solar_Generated_kWh",
    "Total_Electricity_Demand_kWh", "Generator_Diesel_Litres", "Municipal_Water_kL",
    "Packaging_Waste_kg", "Recycled_Packaging_kg", "Hazardous_Clinical_Waste_kg",
    "Clinical_Waste_Manifest_Status", "Municipal_Billing_Type", "Assurance_Audit_Status",
    "Scope_1_Emissions_tCO2e", "Scope_2_Emissions_tCO2e", "Solar_Avoided_Emissions_tCO2e"
])

# --------------------------------------------------------------------------------------
# 4. DIM_SUPPLIERS_ESG (50 Key Sourcing & Distribution Partners)
# Aligned with King IV, JSE Sourcing Governance & B-BBEE Procurement Codes
# --------------------------------------------------------------------------------------
categories = [
    "Pharmaceuticals & Vaccines", 
    "Vitamins, Sports & Supplements", 
    "Personal Care, Baby & Beauty", 
    "Store Consumables & Eco-Packaging", 
    "Cold-Chain Logistics & Distribution"
]

suppliers_data = []
for i in range(1, 51):
    sup_id = f"SUP-SA-{i:03d}"
    cat = np.random.choice(categories)
    
    # Tier 1 are primary pharmaceutical manufacturers; Tier 2 are distribution/packaging
    tier = "Tier 1 Strategic" if i <= 20 else ("Tier 2 Key Partner" if i <= 40 else "Tier 3 Specialist")
    
    # ESG Audit Score (0 - 100)
    base_score = np.random.uniform(55, 96)
    score = round(base_score, 1)
    
    # Code of Conduct
    coc_signed = "Executed & Active" if score > 64 else ("Under Review" if score > 58 else "Overdue / Non-Responsive")
    
    # Risk Rating
    if score >= 82:
        risk = "Low Risk - ESG Benchmark"
    elif score >= 68:
        risk = "Moderate Risk - Continuous Monitoring"
    else:
        risk = "High Risk - Corrective Action Plan Required"
        
    # Recycled packaging commitment %
    packaging_recycled_pct = round(np.random.uniform(40, 95), 1) if "Packaging" in cat or "Personal" in cat else round(np.random.uniform(20, 75), 1)
    
    # B-BBEE Level (Critical South African Governance metric!)
    bbbee = np.random.choice(["Level 1", "Level 2", "Level 3", "Level 4", "Non-Compliant"], p=[0.40, 0.35, 0.15, 0.08, 0.02])
    
    # Annual Procurement Spend (ZAR Millions)
    spend_m_zar = round(np.random.uniform(4.5, 85.0), 2)
    
    suppliers_data.append([
        sup_id,
        f"Healthcare Partner SA {i}",
        cat,
        tier,
        score,
        coc_signed,
        risk,
        packaging_recycled_pct,
        bbbee,
        spend_m_zar
    ])

df_dim_suppliers = pd.DataFrame(suppliers_data, columns=[
    "Supplier_ID", "Supplier_Name", "Procurement_Category", "Supplier_Tier",
    "ESG_Audit_Score", "Code_of_Conduct_Status", "ESG_Risk_Rating",
    "Sustainable_Packaging_Share_Pct", "BBBEE_Level", "Annual_Spend_ZAR_Millions"
])

# --------------------------------------------------------------------------------------
# SAVE ALL DATASETS TO CSV IN WORKSPACE
# --------------------------------------------------------------------------------------
df_dim_stores.to_csv("Dim_Stores.csv", index=False)
df_dim_calendar.to_csv("Dim_Calendar.csv", index=False)
df_fact_esg.to_csv("Fact_Store_ESG_Monthly.csv", index=False)
df_dim_suppliers.to_csv("Dim_Suppliers_ESG.csv", index=False)

print("="*70)
print("SUCCESS: 4 ENTERPRISE JSE/GRI ESG CSV DATASETS GENERATED!")
print(f"- Dim_Stores.csv: {len(df_dim_stores)} stores with Solar kWp, Generator kVA & Utility Providers")
print(f"- Dim_Calendar.csv: {len(df_dim_calendar)} fiscal periods (FY2025 Oct-Sep)")
print(f"- Fact_Store_ESG_Monthly.csv: {len(df_fact_esg)} monthly assurance records with Scope 1/2 GHG, Municipal Billings & Hazardous Waste")
print(f"- Dim_Suppliers_ESG.csv: {len(df_dim_suppliers)} suppliers with ESG scores, B-BBEE ratings & ZAR spend")
print("="*70)
