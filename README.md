# layoffs-data-analysis

This project contains SQL scripts for analyzing layoffs data. The scripts perform various data cleaning, transformation, and analysis tasks to derive insights from the dataset.

## Project Overview

- **Data Cleaning**: Remove duplicate records, standardize data, and handle missing values.
- **Data Transformation**: Convert date fields, trim text fields, and standardize industries and countries.
- **Data Analysis**: Perform exploratory data analysis to identify trends and patterns in layoffs by company, industry, country, and time.

## Key Features

- **Duplicate Removal**: Identify and remove duplicate records using `ROW_NUMBER()`.
- **Data Standardization**: Standardize company names, industries, and country names.
- **Date Conversion**: Convert date strings to proper date format.
- **Industry Imputation**: Fill missing industry values based on matching company and location.
- **Trend Analysis**: Analyze layoffs trends over time and across different industries and countries.
- **Ranking**: Rank companies by layoffs per year.

