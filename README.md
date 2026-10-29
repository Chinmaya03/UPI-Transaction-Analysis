# UPI Transaction Analysis — Capstone Project

**Author:** Chinmaya Panigrahi   
**Project Title:** UPI Transaction Analysis  
**Programme:** Data Analytics with GenAI — Capstone Project

---

## 1. Project Overview

In this project, I analyzed seven UPI-related datasets using Excel, MySQL, Python and Power BI. I first validated the data, then created the SQL database, performed EDA and statistical tests in Python, and finally built a two-page Power BI dashboard. My main focus was transaction failures, fraud flags, rooted-device risk and fraud-alert resolution.

---

## What I Learned
One important learning from this project was that a difference visible in a dashboard is not always statistically significant. For example, channel-level fraud rates looked slightly different, but the Chi-square test gave p = 0.143. Because of this, I did not recommend channel-specific controls. I also learned the importance of checking null values in business context instead of automatically deleting them.

---

## 2. Business Problem

A UPI platform requires reliable visibility into transaction performance, failed transactions, fraud-flagged activity, device and merchant risk signals, and fraud-alert handling.

The core business objective of this project is to transform the supplied operational datasets into a validated analytical system that can:

- monitor transaction performance and reliability;
- identify meaningful fraud-risk signals;
- analyze failure patterns and operational issues;
- evaluate fraud-alert resolution performance;
- compare device, merchant, region, and transaction-channel patterns;
- support data-driven operational and fraud-control recommendations.

---

## 3. Project Objectives

- Validate all supplied datasets before analysis.
- Build a structured relational database with primary keys, foreign keys, and integrity checks.
- Ingest and validate the source data in MySQL.
- Connect SQL data to Python for cleaning, transformation, EDA, and statistical analysis.
- Test business hypotheses using appropriate inferential statistical methods.
- Build an interactive Power BI dashboard for executive and operational monitoring.
- Produce analytical findings, recommendations, executive reporting, and presentation materials.

---

## 4. Dataset Description

The project uses seven supplied datasets containing **140,500 total source records**.

| Dataset | Records | Purpose |
|---|---:|---|
| `customer_master.csv` | 10,000 | Customer profile, demographics, business-user flag, and risk score |
| `device_info.csv` | 12,000 | Device profile, device type, app version, and rooted-device status |
| `upi_account_details.csv` | 12,000 | UPI account, bank, account type, date added, and account status |
| `merchant_info.csv` | 500 | Merchant profile, merchant type, region, and risk score |
| `upi_transaction_history.csv` | 100,000 | Main transaction fact table |
| `customer_feedback_surveys.csv` | 4,000 | Customer feedback, issue type, satisfaction, and resolution status |
| `fraud_alert_history.csv` | 2,000 | Fraud alerts, alert type, resolution status, and resolution date |

---

## 5. Tools & Technologies

- **Microsoft Excel** — source-data validation, duplicate checks, null review, outlier identification, validation summary, and data-quality log.
- **MySQL / MySQL Workbench** — relational schema design, DDL, constraints, source-data ingestion, validation queries, and referential-integrity checks.
- **Python / Jupyter Notebook** — SQL extraction, cleaning, transformation, EDA, visualization, and statistical analysis.
- **Python libraries** — Pandas, NumPy, Matplotlib, Seaborn, SciPy, Statsmodels, SQLAlchemy, and PyMySQL.
- **Power BI** — interactive executive and fraud/operations dashboards.
- **PowerPoint** — analytical report deck and live presentation deck.
- **Word / PDF** — two-page executive report.

---

## 6. Project Workflow

1. Business understanding and analytical objective definition.
2. Data validation and quality assessment in Excel.
3. Relational database design and table creation in MySQL.
4. Data ingestion and SQL validation.
5. SQL-to-Python extraction in Jupyter Notebook.
6. Data cleaning, transformation, and exploratory analysis.
7. Statistical hypothesis testing and interpretation.
8. Interactive dashboard development in Power BI.
9. Executive reporting, recommendations, and presentation preparation.

---

## 7. Repository Structure

```text
ChinmayaPanigrahi_UPITransactionAnalysis/
│
├── README.md
│
├── 01_Business_Understanding/
│   └── UPI_Capstone_Business_Understanding_and_Data_Validation.pptx
│
├── 02_Data_Validation/
│   └── UPI_Capstone_Data_Validation.xlsx
│
├── 03_SQL/
│   ├── UPI_Capstone_Step3_DDL.sql
│   └── UPI_Capstone_Step4_Data_Ingestion.sql
│
├── 04_Python_Analysis/
│   └── UPI_Capstone_Python_Analysis.ipynb
│
├── 05_Dashboard/
│   └── UPI_Capstone_Transaction_Analysis.pbix
│
├── 06_Analytical_Report/
│   ├── UPI_Transaction_Analysis_Analytical_Report_Deck.pptx
│   └── UPI_Transaction_Analysis_Executive_Report.pdf
│
├── 07_Live_Presentation/
│   └── UPI_Transaction_Analysis_Live_Presentation.pptx
```

### Final ZIP name

```text
ChinmayaPanigrahi_UPITransactionAnalysis.zip
```

---

## 8. Data Validation Summary

The Excel validation phase confirmed the overall structural quality of the supplied data.

- Total datasets validated: **7**
- Total source records: **140,500**
- Duplicate primary identifiers: **0**
- Orphan foreign-key records: **0**
- Referential-integrity checks: **Passed**
- Transaction amount IQR outliers retained for analysis: **5,457**
- Contextual missing `merchant_id` values: **69,851**
- Contextual missing `failure_reason` values: **94,129**
- Unresolved fraud alerts with blank `resolution_date`: **248**

Contextual nulls were retained where they represent valid business conditions rather than data-quality defects. Statistical outliers were reviewed and retained rather than automatically deleted.

---

## 9. SQL Database Design

The MySQL database contains seven related tables with defined primary keys, foreign keys, and validation constraints.

### Key design results

- Tables: **7**
- Primary keys: **7**
- Foreign keys: **8**
- CHECK constraints: **11**
- Post-load orphan records: **0**

### SQL files

- `UPI_Capstone_Step3_DDL.sql`
- `UPI_Capstone_Step4_Data_Ingestion.sql`

The ingestion script loads all seven datasets in dependency order and validates row counts, data-type transformations, contextual null handling, and referential integrity.

---

## 10. Python Analysis

The notebook `UPI_Capstone_Python_Analysis.ipynb` covers Steps 5–7 of the analytical workflow:

### Step 5 — SQL Extraction

- secure MySQL connection using `getpass()`;
- extraction of all seven SQL tables into Pandas DataFrames;
- schema and record-count validation;
- confirmation that extracted row counts match the expected source counts.

### Step 6 — Cleaning, Transformation & EDA

- data-type review and transformation;
- contextual-null treatment;
- duplicate and integrity checks;
- exploratory analysis of transaction performance, fraud flags, failures, devices, merchants, regions, and alerts;
- supporting visualizations and descriptive statistics.

### Step 7 — Statistical Analysis

Six business hypotheses were tested using:

- Chi-square tests;
- Welch ANOVA;
- Spearman rank correlation;
- Cramér's V and eta-squared effect sizes;
- confidence intervals where appropriate;
- Holm multiple-testing correction.

The notebook is fully executed and contains saved analytical outputs without exposing the MySQL password.

---

## 11. Statistical Analysis Summary

The strongest statistically supported relationship in the tested hypotheses is between **rooted-device status and fraud occurrence**.

- Rooted-device observed fraud rate: **20.69%**
- Non-rooted-device observed fraud rate: **1.39%**
- Estimated risk ratio: **14.90**
- 95% confidence interval: **13.67–16.25**

The analysis did **not** find statistically significant evidence that:

- fraud occurrence differs systematically by transaction channel;
- transaction status is associated with device type;
- merchant-region differences explain transaction failure;
- mean transaction amount differs by device type;
- customer risk score has a meaningful monotonic relationship with customer fraud rate.

The Holm multiple-testing correction did not change these conclusions.

These findings are associations observed within the supplied dataset and are **not interpreted as causal effects**.

---

## 12. Power BI Dashboard

The Power BI report contains two interactive pages.

### Executive Overview

Key KPIs:

- Total Transactions: **100,000**
- Total Transaction Amount: **approximately ₹4.24M**
- Average Transaction Amount: **approximately ₹42.42**
- Transaction Failure Rate: **5.87%**
- Fraud Rate: **2.00%**

Supporting visuals include:

- monthly transaction trend;
- transaction-type breakdown;
- customer-region analysis;
- device-type analysis;
- Top 10 merchants by transaction volume;
- Date, Region, Device Type, Merchant, and Status slicers.

### Operations & Fraud Analysis

Key monitoring areas include:

- Failed Transactions: **5,871**
- Fraud-Flagged Transactions: **2,000**
- Rooted Device Fraud Rate: **20.69%**
- Unresolved Fraud Alerts: **248**
- failure reasons;
- rooted versus non-rooted device fraud rates;
- descriptive channel-level fraud-rate comparison;
- fraud-alert trend and alert types;
- device and merchant observed fraud-ratio monitoring;
- fraud-alert resolution status.

The common Date dimension is used for time filtering so transaction, device, merchant, and fraud-alert visuals respond consistently to the page-level time context.

---

## 13. Key Findings

1. **Rooted devices are the strongest validated fraud-risk signal.** Rooted-device transactions represent a small share of transaction volume but show a substantially higher observed fraud rate than non-rooted transactions.

2. **Transaction failures are distributed across multiple operational causes.** The 5,871 failed transactions are spread across incorrect PIN, network error, blocked account, and bank-down categories rather than being dominated by a single cause.

3. **Fraud-alert resolution is strong but incomplete.** Of 2,000 fraud alerts, **1,752 were resolved (87.60%)** and **248 remained unresolved (12.40%)**.

4. **Channel-level fraud-rate differences should not be overinterpreted.** Observed channel fraud rates differ slightly, but the completed Chi-square test did not establish a statistically significant association.

5. **Entity-level fraud ratios require denominator context.** Device and merchant fraud ratios are interpreted alongside transaction volume and fraud-flag counts to avoid misleading conclusions from small transaction counts.

---

## 14. Strategic Recommendations

- Strengthen rooted-device controls through device-integrity checks, enhanced monitoring, and step-up authentication for higher-risk activity.
- Improve transaction reliability through a multi-cause failure-reduction programme rather than focusing on only one failure reason.
- Reduce unresolved fraud alerts using alert ageing, ownership assignment, escalation rules, and SLA tracking.
- Avoid unsupported channel-specific restrictions unless future evidence establishes a meaningful channel effect.
- Review merchant and device fraud ratios together with transaction volume and fraud-flag counts before escalation or intervention.

### Illustrative impact scenarios

The following are scenario calculations based on the observed dataset and are **not forecasts**:

- A 25% reduction in rooted-device fraud flags would correspond to approximately **164 fewer fraud-flagged transactions**, reducing the overall observed fraud rate to approximately **1.84%**.
- A 10% reduction in failed transactions would correspond to approximately **587 fewer failures**, reducing the failure rate to approximately **5.28%**.
- Resolving half of the current unresolved fraud-alert backlog would reduce unresolved alerts from **248 to 124** and increase the alert-resolution rate to approximately **93.80%**.

---

## 15. Environment & Technical Notes

Power BI Desktop was executed in a **Windows ARM64 virtual machine on macOS**.

Because the MySQL connector setup was incompatible with that environment, the final Power BI dashboard was built using **validated CSV extracts from the same supplied source tables**.

This environment constraint applies only to the Power BI connectivity layer. The project still includes:

- successful MySQL schema creation;
- SQL data ingestion;
- relational and row-count validation;
- SQL-to-Python extraction and analysis.

No analytical dataset was substituted or expanded beyond the supplied project data.

---

## 16. How to Run the Project

### SQL

1. Run `UPI_Capstone_Step3_DDL.sql` in MySQL 8+ / MySQL Workbench.
2. Update local CSV paths in `UPI_Capstone_Step4_Data_Ingestion.sql` if running on a different machine.
3. Execute the ingestion script in the documented loading order.
4. Review row-count, transformation, and orphan-record validation outputs.

### Python

1. Open `UPI_Capstone_Python_Analysis.ipynb` in JupyterLab/Jupyter Notebook.
2. Install the required Python libraries if necessary.
3. Enter the MySQL password securely when prompted.
4. Run the notebook from top to bottom.

### Power BI

1. Open `UPI_Capstone_Transaction_Analysis.pbix` in Power BI Desktop.
2. Review the Executive Overview and Operations & Fraud Analysis pages.
3. Use the provided slicers to interact with the report.

---

## 17. Final Deliverables

The submission package contains:

- `README.md`
- Business Understanding presentation
- Excel data-validation workbook
- MySQL DDL script
- MySQL data-ingestion script
- Fully executed Python/Jupyter notebook
- Interactive Power BI dashboard
- 10–15 slide analytical report deck
- 10–15 slide live presentation deck
- Two-page executive report PDF
- ERD / supporting database documentation

---

## 18. Project Quality & Reproducibility Notes

- All seven source datasets are represented in the analytical workflow.
- No external data was introduced into the analysis.
- No database password is stored in the notebook, SQL scripts, README, or presentation materials.
- SQL referential-integrity checks returned zero orphan records.
- Python statistical conclusions distinguish association from causation.
- Channel fraud-rate comparisons are presented descriptively because the tested association was not statistically significant.
- Power BI entity-level fraud ratios are displayed with transaction-volume context.
- The dashboard is saved with **Executive Overview** as the opening page.

---

## 19. Author

**Chinmaya Panigrahi**   
**Programme:** Data Analytics with GenAI — Capstone Project  
**Project:** UPI Transaction Analysis

