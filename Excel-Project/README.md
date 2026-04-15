# Customer Retention & CLV Analysis (Excel Project)
## Overview
This project analyzes the UCI Online Retail Dataset (UK-based e-commerce transactions from Jan–Dec 2011) to understand customer purchasing behavior, retention patterns, churn drivers, and Customer Lifetime Value (CLV). The goal is to provide actionable recommendations to improve retention and maximize revenue.

## Dataset
- Source: UCI Online Retail Dataset  
- Region: UK-based e-commerce  
- Period: Jan–Dec 2011  
- Records: 9,999 transactions (cleaned)

## Business Problem
E-commerce businesses often struggle with high customer churn and difficulty identifying which customers are truly valuable. This project helps answer:
- Why do customers stop purchasing?
- Which customers contribute the most revenue?
- How can the business reduce churn and grow revenue efficiently?

## Key Questions Addressed
- What is the overall retention and churn rate?
- How does customer value vary across segments?
- What are the main drivers of churn and seasonal patterns?
- How can the business prioritize high-value customers?

## Data Cleaning & Preparation
- Cleaned 9,999 transaction records
- Removed invalid/negative transactions and missing CustomerIDs
- Created Revenue column (Quantity × Unit Price)
- Standardized date formats
- Derived Cohort Month for retention analysis

## Analysis Performed
- Customer-level KPIs (Total Revenue, Order Count, AOV, Purchase Frequency)
- Monthly Cohort Analysis for retention tracking
- Churn Analysis based on 90+ days inactivity
- CLV Calculation using AOV × Purchase Frequency × Lifespan (in months)
- RFM-style Segmentation into High, Mid, and Low-Value customers

## Key Insights
- Overall retention rate is 95.4%, yet 77.4% of customers eventually churn after 90+ days of inactivity.
- Only 5.6% of customers (22 High-Value) contribute 37% of total revenue (£93,084 out of £251,801).
- The United Kingdom accounts for 89.2% of the customer base (348 out of 390 customers).
- March had the lowest activity with only 59 transactions.
- Low-Value customers (84% of base) contribute only 54% of revenue, while High-Value customers deliver significantly higher lifetime value.

## Recommendations
- Launch personalized re-engagement campaigns (email/SMS) at the 60-day inactivity mark to reduce churn.
- Create a dedicated loyalty program for the High-Value segment to protect 37% of revenue.
- Expand marketing efforts in France and Germany to reduce UK dependency (89.2%).
- Run targeted promotions during slow months (especially March) to boost order volume.
- Shift marketing budget toward acquiring and retaining High & Mid-Value customers using CLV-based targeting.

## Tools & Techniques Used
- Microsoft Excel (Advanced formulas, PivotTables, Conditional Formatting)
- Cohort Analysis & Customer Segmentation
- CLV Modeling
- Dashboard creation with charts and slicers
