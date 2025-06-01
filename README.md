# Superstore-Sales-Power-BI-Dashboard

🛒 Superstore Sales Analytics Project

📌 Overview
This project provides a comprehensive analysis of sales data from a fictional Superstore. It uses a relational database model (SQL Server), Python for preprocessing, and Power BI for creating insightful dashboards and KPIs.

You’ll find everything from ETL pipelines to Power BI visualizations and SQL analysis queries.

🗃️ Dataset
The base dataset (Sample - Superstore.csv) contains transactional retail data including:

Orders

Products

Customers

Shipments

Regions

🗂️ Cleaned version: superstore_dataset_clean.csv

🏗️ Database Model (SQL Server)

The database is structured as a star schema:

Fact Table:

OrderDetails: contains sales, profit, quantity, discount, product_uid, order_id

Dimension Tables:

Orders: with customer, date, and shipment info

Products: category, sub-category, and product info

Customers: customer segmentation

Regions: state, city, postal code

ShipModes: shipping methods

All relationships are defined with primary and foreign keys.

See SQLQuery_TablesCreation_SSMS_And_Ingestion.sql for full DDL and insert scripts.

⚙️ Technologies Used
SQL Server Management Studio (SSMS)

Python (Jupyter Notebook) – for cleaning and splitting data

Power BI – interactive dashboards and reports

GitHub – version control & project portfolio

📊 Power BI Dashboard
The Power BI file: Superstore_Sales_Report.pbix

Main visuals include:

📈 KPIs: Total Sales, Profit, Orders, Profit Margin

📍 Sales by Region & State (map)

🧾 Profit by Month (Waterfall)

🏆 Top 10 Customers by Sales

🗃️ Profit by Sub-category

📊 Sales by Category (Pie chart)

🔁 Time slicer with drill-downs (via time dimension table)

📂 Files Included
File	Description
Sample - Superstore.csv	Original dataset
superstore_dataset_clean.csv	Cleaned dataset for ingestion
Superstore_Sales_Report.pbix	Final Power BI report
Superstore_Sales_Report Snapshot.png	Report preview
SQLQuery_TablesCreation_SSMS_And_Ingestion.sql	SQL schema creation & data load
SQLQuery_Analysis_Queries.sql	Advanced SQL queries (KPIs, insights)
Superstores Sales - Script Python.ipynb	Python cleaning & pre-ingestion


📬 Contact
Nordine Bouchelia
Data Analyst & BI Enthusiast
GitHub Profile
LinkedIn Profile
