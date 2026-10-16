# Automated U.S. EV Registration Data Processing Workflow

## Project Overview

This project automates the processing, validation, analysis, and reporting of U.S. electric vehicle (EV) registration data using Microsoft Power Automate Desktop, Python, MySQL, SQL, and Power BI.

The workflow reduces manual data handling by connecting file retrieval, data cleaning, database operations, analytical queries, CSV exports, and dashboard reporting into a coordinated process.

## Dashboard Preview

![U.S. Electric Vehicle Market Overview](images/ev_dashboard.png)

## Business Problem

Manual data processing can introduce errors, require repetitive effort, and make it difficult to maintain consistent reporting. This project demonstrates how desktop automation and data analysis tools can work together to create a repeatable data-processing workflow with validation checks before production data is refreshed.

## Solution

The workflow performs the following steps:

1. **Retrieve the input:** Power Automate Desktop retrieves an email containing the EV registration CSV attachment.
2. **Clean the data:** Python removes thousands separators and converts numeric fields to integers.
3. **Validate the dataset:** The cleaning script checks row counts, duplicate states, blank EV values, and numeric data types.
4. **Load staging data:** Power Automate Desktop loads the cleaned records into a MySQL staging table.
5. **Validate before refresh:** SQL checks the staged data against dataset-specific expectations.
6. **Refresh production data:** The production refresh procedure runs only when the validation result is `PASS`.
7. **Run the analysis:** A Python exporter invokes the MySQL command-line client to execute the analysis queries.
8. **Export results:** Ten analytical result sets are saved as CSV files.
9. **Visualize the results:** Power BI uses the exported CSV files to populate an EV registration overview dashboard.

## Automation Workflow

### 1. Email Retrieval and Input Preparation

![Email retrieval and input preparation](images/ev_workflow_dashboard_1.png)

### 2. Python Cleaning and Database Connection

![Python cleaning and database connection](images/ev_workflow_dashboard_2.png)

### 3. SQL Staging and Data Validation

![SQL staging and data validation](images/ev_workflow_dashboard_3.png)

### 4. Validation and Automated Analysis

![Validation and automated analysis](images/ev_workflow_dashboard_4.png)

### 5. Workflow Completion

![Workflow completion](images/ev_workflow_dashboard_5.png)

## Technology Stack

- **Microsoft Power Automate Desktop:** Workflow orchestration and application automation
- **Python:** CSV cleaning, validation, and automated result exports
- **MySQL:** Staging, production data storage, and analytical queries
- **SQL:** Data validation, controlled refresh, and analysis
- **Power BI Desktop:** Interactive reporting and visualization

## Key Results

The tested workflow produced the following outputs for the included dataset:

- 51 data rows representing U.S. states and the District of Columbia
- 51 unique state/district records
- 3,555,900 registered electric vehicles in the dataset
- 10 exported analytical CSV files
- A Power BI report featuring EV registration KPIs and charts

These figures are specific to the dataset used during development and are not universal validation thresholds.

## Repository Structure

```text
Automated US EV Registration Workflow/
├── .gitignore
├── README.md
├── clean_ev_data.py
├── export_ev_analysis_results.py
├── run_ev_analysis.bat
├── EV_Analysis_Queries_Main.sql
├── ev_registrations_power_automate.sql
├── ev_registrations_power_automate_refresh.sql
├── US_EV_Market_Analysis_Automation_DB.sql
├── ev_automation.cnf.example
├── EV_Flow_GitHub_Sanitized.txt
├── EV_Analysis_Results/
│   ├── analysis_01.csv
│   ├── analysis_02.csv
│   └── ... analysis_10.csv
├── docs/
│   ├── EV_Project_Documentation.docx
│   └── Project Plan for EV Vehicle Automation.docx
└── US_EV_Vechicle_Registrations_Power_Automate.pbix
```

## Prerequisites

To reproduce the workflow, you will need:

- Windows
- Microsoft Power Automate Desktop
- Python 3.11 or a compatible Python installation
- MySQL Server and the MySQL command-line client
- The required MySQL ODBC driver for the database connection used by the desktop flow
- Power BI Desktop to open and refresh the report

Additional setup is required for Outlook email retrieval and the Power Automate Desktop actions.

## Configuration and Setup

### 1. Configure MySQL

Create or configure a MySQL database for the project. The supplied SQL scripts describe database inspection, table setup, the refresh procedure, and analytical queries. The refresh SQL script creates the procedure and runs verification queries; it does not call the refresh procedure automatically.

Review each SQL script before executing it. The refresh procedure modifies production data, so use a test database when learning or adapting the workflow. In the automated flow, Power Automate Desktop calls it only after staging validation returns `PASS`.

### 2. Configure database credentials

The repository includes `ev_automation.cnf.example` as a template.

Create your own local `ev_automation.cnf` using your MySQL username and password. Keep the real credentials file private and do not commit it to GitHub.

The Python exporter supports these environment variables:

- `MYSQL_EXE`: Path to the MySQL command-line executable, if it is not available as `mysql` on your PATH.
- `MYSQL_OPTIONS_FILE`: Path to your private MySQL client options file.

### 3. Prepare the analysis exporter

Keep `export_ev_analysis_results.py`, `EV_Analysis_Queries_Main.sql`, and the `EV_Analysis_Results` output folder in the project directory.

Ensure Python and the MySQL command-line client are installed and configured. Run `run_ev_analysis.bat` from the project directory to execute the exporter.

The exporter creates or updates the ten analytical CSV outputs.

### 4. Configure the Power BI report

Open the included `.pbix` file in Power BI Desktop.

The report uses a `ResultsFolder` parameter to locate the `EV_Analysis_Results` directory. Set this parameter to the full path of that directory on your computer before refreshing the report.

### 5. Configure Power Automate Desktop

The desktop flow requires configuration for your own Outlook account, local folders, Python installation, MySQL connection, and project paths.

Use `EV_Flow_GitHub_Sanitized.txt` and the documents in `docs/` as references. The sanitized text is a reference representation of the flow, not a directly importable Power Automate Desktop package.

Configure and test the flow against a development database before using any production data.

## Validation Rules

The cleaning and validation process includes:

- Expected row count of 51
- 51 unique state/district names
- No blank EV values
- Numeric fuel-registration values converted to integers
- A dataset-specific EV total of 3,555,900 used in the staging validation

The workflow refreshes production only when the staging validation returns `PASS`. If the dataset changes, update the validation expectations and analysis logic deliberately before running the workflow.

## Project Documentation

Additional documentation is available in the `docs/` directory, including the project documentation and project plan.

## Security Notes

- Never commit real database passwords, private connection strings, or personal account details.
- Keep your real `ev_automation.cnf` outside the public repository.
- Review the sanitized flow text and all configuration files before publication.
- Use a test database when adapting or experimenting with the refresh procedure.

## Disclaimer

This is a portfolio project developed to demonstrate desktop automation, data validation, database operations, SQL analysis, and reporting. The included dataset and validation thresholds are specific to the development scenario.

## Author

Developed as a data analytics and automation portfolio project.
