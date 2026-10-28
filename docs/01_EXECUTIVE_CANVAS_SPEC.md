# Power BI Executive Canvas Blueprint & Visual Specification
**Project:** Pharmacy Retail ESG Performance & Assurance Audit Hub  
**Target Brand Feel:** Dis-Chem Corporate Healthcare (`#00563B` Pharmacy Green, `#0F172A` Deep Slate, `#FFFFFF` Card White, `#F8FAFC` Canvas Canvas)  
**Canvas Dimensions:** 1920 × 1080 px (16:9 Standard High Definition)

---

## 1. Palette & Formatting Rules

| Element | Hex Code | Purpose |
| :--- | :--- | :--- |
| **Primary Brand Accent** | `#00563B` | Header bar background, primary totals, corporate identity |
| **Secondary Accent** | `#0D9488` | Solar generation, clean energy offset, renewable mix |
| **Canvas Background** | `#F8FAFC` | Clean modern off-white background |
| **Card Container Fill** | `#FFFFFF` | Visual container card background with subtle shadow |
| **Card Border** | `#E2E8F0` | 1px border stroke with 6px rounded corners |
| **Primary Text** | `#0F172A` | KPI callout values, chart titles, table headers |
| **Secondary Text** | `#64748B` | Sub-labels, captions, axes titles |
| **Audit Status: Clean** | `#10B981` | Emerald Green for verified invoices / compliant manifests |
| **Audit Status: Warning** | `#F59E0B` | Amber Warning for pending reconciliations / estimates |
| **Audit Status: Alert** | `#EF4444` | Red Alert for >20% unexplained variance / high risk |

---

## 2. Grid Coordinates & Canvas Architecture

```
+---------------------------------------------------------------------------------------------------+
| ZONE 1: TOP EXECUTIVE HEADER & SLICERS (Y: 0, H: 85)                                              |
| Title: GROUP ESG PERFORMANCE & ASSURANCE AUDIT HUB (SIMULATED PHARMACY PORTFOLIO)                 |
| Subtitle: Aligned with JSE Sustainability Guidance & GRI 302/305/306 | By: Clement Mathye (BCIS)   |
| Slicers: Province | Facility Type | Fiscal Quarter | Assurance Status                             |
+---------------------------------------------------------------------------------------------------+
| ZONE 2: FIVE EXECUTIVE KPI CARDS (Y: 95, H: 130)                                                  |
| [ CARD 1 ]      | [ CARD 2 ]       | [ CARD 3 ]      | [ CARD 4 ]       | [ CARD 5 ]              |
| Total Carbon    | Energy Intensity | Waste Recycling | Medical Waste    | Audit Readiness         |
| Scope 1 & 2 GHG | kWh / SqM        | Diversion Rate  | Manifests %      | Pre-Assurance Rate      |
+---------------------------------------------------------------------------------------------------+
| ZONE 3: CORE ANALYTICAL INSIGHTS (Y: 235, H: 410)                                                 |
| LEFT VISUAL (W: 1040, H: 410):                     | RIGHT VISUAL (W: 820, H: 410):               |
| Combo Clustered Column & Line Chart                | Horizontal Clustered Bar Chart               |
| Monthly Scope 1 vs Scope 2 GHG Emissions (tCO2e)   | Store Energy Intensity Benchmarking (kWh/m2) |
| with Solar Renewable Mix % Overlay Trend           | with Group Target Reference Line (16.5 kWh)  |
+---------------------------------------------------------------------------------------------------+
| ZONE 4: AUDIT ASSURANCE & SUPPLIER GOVERNANCE (Y: 655, H: 405)                                    |
| BOTTOM-LEFT VISUAL (W: 1040, H: 405):              | BOTTOM-RIGHT VISUAL (W: 820, H: 405):        |
| Matrix / Table: Audit Exception & Variance Log     | Table: Supplier ESG Risk & B-BBEE Exposure   |
| Columns: Store, Province, Provider, Bill Type,     | Columns: Supplier Name, Category, Tier,      |
| Grid kWh, Diesel L, Assurance Audit Status         | ESG Score, BBBEE Level, Spend (ZAR M), Risk  |
| (Conditional formatting on Audit Status)           | (Conditional formatting on Risk & BBBEE)     |
+---------------------------------------------------------------------------------------------------+
```

---

## 3. Visual Field Bindings & Configuration

### Zone 2: Five KPI Cards (Card (new) visual or Multi-row Card)
* **Card 1: Total Carbon Footprint**
  * Measure: `[Total Scope 1 & 2 Emissions (tCO2e)]` (Format: `#,##0.0 "tCO2e"`)
  * Subtitle / Accent: "Scope 1 Diesel: [Scope 1 Diesel Emissions (tCO2e)] | Scope 2 Grid: [Scope 2 Grid Electricity Emissions (tCO2e)]"
* **Card 2: Retail Energy Intensity**
  * Measure: `[Energy Intensity (kWh / SqM)]` (Format: `0.0 "kWh/m²"`)
  * Subtitle: "Solar PV Mix: [Renewable Energy Mix %] (Target: 18.0%)"
* **Card 3: Packaging Circularity Rate**
  * Measure: `[Packaging Recycling Diversion Rate %]` (Format: `0.0%`)
  * Subtitle: "Diverted: [Total Recycled Waste (Tonnes)] Tonnes of Cardboard/Plastic"
* **Card 4: Clinical Hazardous Waste Assurance**
  * Measure: `[Medical Waste Manifest Compliance Rate %]` (Format: `0.0%`)
  * Subtitle: "Safe Destruction Manifests On File (NEMWA Regulated)"
* **Card 5: Internal Audit Readiness Score**
  * Measure: `[Assurance Audit Readiness %]` (Format: `0.0%`)
  * Subtitle: "[High Risk Audit Exceptions Count] Exceptions Requiring Store Reconciliation"

### Zone 3: Analytical Visuals
* **Left Chart: Combo Chart (Clustered Column and Line Chart)**
  * **X-Axis:** `Dim_Calendar[Month_Year]` (Sorted by `Dim_Calendar[YearMonth_Sort]`)
  * **Column Y-Axis:** `[Scope 2 Grid Electricity Emissions (tCO2e)]`, `[Scope 1 Diesel Emissions (tCO2e)]`
  * **Line Y-Axis:** `[Renewable Energy Mix %]`
  * **Colors:** Scope 2 = Deep Slate (`#0F172A`), Scope 1 = Amber Red (`#DC2626`), Solar Mix % Line = Teal (`#0D9488`)
* **Right Chart: Clustered Bar Chart**
  * **Y-Axis:** `Dim_Stores[Store_Name]`
  * **X-Axis:** `[Energy Intensity (kWh / SqM)]`
  * **Sort:** By `[Energy Intensity (kWh / SqM)]` descending (high consumption stores at top)
  * **Reference Line:** Constant line at `16.5 kWh/m²` (Label: "Group Target Benchmark: 16.5 kWh/m²", Color: `#DC2626`, Style: Dashed)

### Zone 4: Audit Exception Log & Governance Tables
* **Bottom-Left: Audit Exception Matrix (Table Visual)**
  * **Columns:**
    1. `Dim_Stores[Store_Name]`
    2. `Dim_Stores[Province]`
    3. `Dim_Stores[Utility_Provider]`
    4. `Fact_Store_ESG_Monthly[Municipal_Billing_Type]`
    5. `Fact_Store_ESG_Monthly[Grid_Electricity_kWh]`
    6. `Fact_Store_ESG_Monthly[Generator_Diesel_Litres]`
    7. `Fact_Store_ESG_Monthly[Assurance_Audit_Status]`
  * **Conditional Formatting on `Assurance_Audit_Status`:**
    * Background color based on field value or rules:
      * `"Verified - Audit Trail Clear"` $\rightarrow$ Light Green `#DCFCE7` (Text `#166534`)
      * `"Pending Reconciliation"` $\rightarrow$ Light Yellow `#FEF3C7` (Text `#92400E`)
      * `"Flagged - Municipal Estimate Variance"` $\rightarrow$ Light Rose `#FFE4E6` (Text `#9F1239`)
      * `"Flagged - Unexplained Consumption Spike (>20%)"` $\rightarrow$ Light Red `#FEE2E2` (Text `#991B1B`)
* **Bottom-Right: Supplier ESG & Responsible Sourcing Tracker (Table Visual)**
  * **Columns:**
    1. `Dim_Suppliers_ESG[Supplier_Name]`
    2. `Dim_Suppliers_ESG[Procurement_Category]`
    3. `Dim_Suppliers_ESG[ESG_Audit_Score]`
    4. `Dim_Suppliers_ESG[BBBEE_Level]`
    5. `Dim_Suppliers_ESG[Annual_Spend_ZAR_Millions]`
    6. `Dim_Suppliers_ESG[ESG_Risk_Rating]`
  * **Conditional Formatting:**
    * High Risk $\rightarrow$ Soft Red
    * Moderate Risk $\rightarrow$ Soft Amber
    * Low Risk $\rightarrow$ Soft Emerald
