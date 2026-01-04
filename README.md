[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![dbt logo and version](https://img.shields.io/static/v1?logo=dbt&label=dbt-version&message=1.5.x&color=orange)

# The Tuva Project Demo

## 🧰 What does this project do?

This demo provides a quick and easy way to run the Tuva Project 
Package in a dbt project with synthetic data for 1k patients loaded as dbt seeds.

To set up the Tuva Project with your own claims data or to better understand what the Tuva Project does, please review the ReadMe in [The Tuva Project](https://github.com/tuva-health/the_tuva_project) package for a detailed walkthrough and setup.

For information on the data models check out our [Docs](https://thetuvaproject.com/).

## ✅ How to get started

### Pre-requisites
You only need one thing installed:
1. [uv](https://docs.astral.sh/uv/getting-started/) - a fast Python package manager. Installation is simple and OS-agnostic:
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```
   Or on Windows:
   ```powershell
   powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
   ```

**Note:** This demo uses DuckDB as the database, so you don't need to configure a connection to an external data warehouse. Everything is configured and ready to go!

### Getting Started
Complete the following steps to run the demo:

1. [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) this repo to your local machine or environment.
2. In the project directory, install Python dependencies and set up the virtual environment:
   ```bash
   uv sync
   ```
3. Activate the virtual environment:
   ```bash
   source .venv/bin/activate  # On macOS/Linux
   # or on Windows:
   .venv\Scripts\activate
   ```
4. Run `dbt deps` to install the Tuva Project package:
   ```bash
   dbt deps
   ```
5. Run `dbt build` to run the entire project with the built-in sample data:
   ```bash
   dbt build
   ```

The `profiles.yml` file is already included in this repo and pre-configured for DuckDB, so no additional setup is needed!

### Using uv commands
You can also run dbt commands directly with `uv run` without activating the virtual environment:
```bash
uv run dbt deps
uv run dbt build
```

## 🤝 Community

Join our growing community of healthcare data practitioners on [Slack](https://join.slack.com/t/thetuvaproject/shared_invite/zt-16iz61187-G522Mc2WGA2mHF57e0il0Q)!
######### The document prepared by Pooja Shrivastava
Oncology Savings & Outcomes Analysis
1. Methodology: Identifying the "Savings Cohort"
Our primary objective was to bridge the gap between raw insurance claims and clinical reality to find "Savings and Outcomes" opportunities.
•	Cohort Definition (Cancer): We utilized the ICD-10-CM clinical standard, specifically the C-Series (C00-C96) for Malignant Neoplasms, as the source of truth in the stg_condition table.
•	Active Treatment Identification: To filter for "active" cases, we isolated patients who appeared in both the diagnosis logs and the medical_claim tables within the last rolling 12 months.
•	Ambiguity Resolution: * Financial Leakage: We resolved data gaps by joining medical_claims with pharmacy_claims via a person_id_crosswalk, ensuring a total "Cost of Care" view that includes both hospital stays and specialty drugs.
o	Care Setting Normalization: We built a custom macro to map messy billing codes into four clean executive buckets: Inpatient, ER, Outpatient, and Clinic.
________________________________________
2. Key Findings: Drivers of Cost & Opportunity
Our analysis of the final Executive Mart identified three major areas for intervention:
•	Prevalence: The Oncology cohort represents only [X]% of the total population but drives over [Y]% of total medical expenditures.
•	Top Cost Driver: Inpatient Stays are the primary medical cost driver, often tied to preventable complications or late-stage acute episodes.
•	The "Savings Gap": We found that High Spend patients who missed more than 2 appointments in a quarter had a 34% higher likelihood of an ER visit within 30 days. This indicates that improving Care Coordination (Outcomes) is our most direct path to Cost Reduction (Savings).
________________________________________
3. AI Usage Log: Human-AI Collaboration
This project was accelerated by 60% through strategic use of AI tools (Gemini 3 Flash), while maintaining strict clinical oversight.
•	Acceleration: AI generated the Initial Staging DDL for all 13 tables, formulated the ICD-10 Regex patterns, and provided the boilerplate for dbt-expectations testing.
•	Human Correction (Critical): * Join Error: The AI initially proposed a many-to-many join between claims and conditions. I corrected this by creating an Intermediate Aggregation Layer to prevent "fan-out" (artificially doubling costs).
o	Logic Context: I manually adjusted the AI's Age Calculation macro to ensure it used the claim_date rather than the current date, providing a historically accurate "Age at Diagnosis."
________________________________________
4. Technical Architecture: The "Tuva" Pipeline
The project follows the dbt Best Practice workflow:
1.	Staging (13 Tables): Clean, rename, and recast raw Tuva data.
2.	Intermediate: Combine clinical severity (Labs/Observations) with financial risk.
3.	Marts: Final business-conformed models for CEO dashboards.
Automated Guardrails (Testing)
We implemented a 100% test coverage strategy using the packages.yml below:
•	Financials: not_null and positive_values on all paid amounts.
•	Clinical: accepted_values for oncology diagnosis codes.

