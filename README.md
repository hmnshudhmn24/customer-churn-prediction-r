Name: Customer Churn Prediction
Description: |
  📉 **Customer Churn Prediction** aims to predict which customers are likely to leave a company using historical data. 
  This project uses the **Telecom Churn dataset** from Kaggle, applying **Logistic Regression** and **Decision Tree** models 
  to classify customers as "Churn" or "No Churn".
  
  The pipeline includes:
  - Data Preprocessing and Cleaning
  - Feature Engineering
  - Model Training and Tuning
  - Evaluation with **AUC**, **Precision**, and **Recall**
  
  This project is built in **R** using packages such as:
  - Tidyverse
  - Caret
  - Rpart
  - pROC
  
Dataset:
  Source: Kaggle Telecom Churn Dataset
  Link: https://www.kaggle.com/blastchar/telco-customer-churn
  File: telecom_churn.csv

Features:
  - Gender: Customer gender (Male/Female)
  - SeniorCitizen: Whether the customer is a senior citizen (1 or 0)
  - Partner: Whether the customer has a partner
  - Dependents: Whether the customer has dependents
  - Tenure: Number of months the customer has stayed
  - PhoneService: Whether the customer has phone service
  - MultipleLines: Whether the customer has multiple lines
  - InternetService: Type of internet service
  - OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport: Optional internet features
  - StreamingTV, StreamingMovies: Streaming services usage
  - Contract: Contract type
  - PaperlessBilling: Whether the customer has paperless billing
  - PaymentMethod: Payment method
  - MonthlyCharges: Monthly charges
  - TotalCharges: Total charges
  - Churn: Target variable (Yes/No)

Model_Pipeline:
  Preprocessing:
    - Convert categorical variables to factors
    - Handle missing values
    - Scale numeric features
  Training:
    - Logistic Regression (Caret)
    - Decision Tree (Rpart)
  Evaluation:
    - Confusion Matrix
    - AUC-ROC Curve
    - Precision & Recall

Requirements:
  R: ">=4.0"
  Packages:
    - tidyverse
    - caret
    - rpart
    - pROC
    - ggplot2

Run_Instructions: |
  1. Download the dataset from Kaggle and save it as `telecom_churn.csv` in your working directory.
  2. Install the required R packages:
     ```r
     install.packages(c("tidyverse", "caret", "rpart", "pROC", "ggplot2"))
     ```
  3. Run the R script:
     ```r
     source("customer_churn_prediction.R")
     ```

Project_Structure: |
  customer-churn-prediction/
  ├── customer_churn_prediction.R   # Main R script
  ├── telecom_churn.csv             # Dataset (download manually)
  └── README.md                     # Project documentation
