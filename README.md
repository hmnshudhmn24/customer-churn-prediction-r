# 📉 Customer Churn Prediction (Fixed)

This ZIP includes a **robust** R script that trains and evaluates churn prediction models.
The script now checks for common dataset filenames and gives a clear, actionable message if the dataset is missing.

## Files in this ZIP
- `customer_churn_prediction.R` — Main R script (robust; checks for dataset files).
- `README.md` — This file with instructions.

## How to use
1. Download the Telco Customer Churn dataset (Kaggle: https://www.kaggle.com/blastchar/telco-customer-churn).
2. Place the CSV in the same folder as the R script. Acceptable filenames:
   - `Telco-Customer-Churn.csv`
   - `WA_Fn-UseC_-Telco-Customer-Churn.csv`
   - `telecom_churn.csv`
   - `Telco_Customer_Churn.csv`
   - `customer_churn.csv`
3. Open R or RStudio in this folder and run:
   ```r
   source("customer_churn_prediction.R")
   ```
4. Outputs created in the folder:
   - `glm_model.rds`
   - `rpart_model.rds`
   - `model_metrics_summary.csv`

## Requirements
R >= 4.0

Install required packages in R if needed:
```r
install.packages(c("tidyverse", "caret", "rpart", "rpart.plot", "pROC", "e1071", "readr"))
```

## Notes
- The script now prevents the ambiguous "file not found" error by checking multiple common filenames and printing a clear message.
- If you still see an error, check that the CSV is in the same working directory (use `getwd()` in R to confirm).

## Author
Himanshu
