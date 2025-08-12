# 📉 Customer Churn Prediction

## 📝 Overview
Customer churn is a significant challenge for many businesses, especially in competitive industries like telecom, banking, and SaaS.  
This project focuses on predicting which customers are likely to leave (churn) using **machine learning classification techniques** in R.  
By accurately predicting churn, companies can take **proactive measures** to retain valuable customers.



## 📊 Dataset
- **Source:** [Kaggle Telecom Churn Dataset](https://www.kaggle.com/datasets)
- **Description:** Contains demographic, account, and service usage data for telecom customers.
- **Target Variable:** `Churn` (Yes/No)

### Key Columns:
- `gender`: Customer gender (Male/Female)
- `SeniorCitizen`: Whether the customer is a senior citizen
- `Partner`, `Dependents`: Family status
- `tenure`: Number of months the customer has stayed
- `PhoneService`, `InternetService`: Service types
- `Contract`: Type of contract (Month-to-month, One year, Two year)
- `MonthlyCharges`, `TotalCharges`: Billing information
- `Churn`: Target label



## 🛠️ Features
- **Data Preprocessing:**
  - Handling missing values
  - Encoding categorical variables
  - Converting target column to factors
- **Exploratory Data Analysis (EDA):**
  - Churn rate visualization
  - Distribution plots of tenure, charges
- **Modeling:**
  - Logistic Regression
  - Decision Tree
- **Evaluation:**
  - Accuracy
  - Confusion Matrix
  - ROC Curve & AUC Score



## 📈 Model Pipeline
1. **Data Loading** → Read dataset into R.
2. **Data Cleaning** → Handle missing/invalid data.
3. **Feature Engineering** → Encode categorical variables.
4. **Train-Test Split** → Split dataset into 80% training and 20% testing.
5. **Model Training** → Train Logistic Regression & Decision Tree models.
6. **Model Evaluation** → Evaluate using Accuracy, Precision, Recall, ROC & AUC.



## 🔧 Requirements
- **R >= 4.0**
- **Libraries:**
  - `tidyverse`
  - `caret`
  - `rpart`
  - `pROC`
  - `ggplot2`

Install dependencies:
```r
install.packages(c("tidyverse", "caret", "rpart", "pROC", "ggplot2"))
```



## 🚀 Running the Project
1. Download dataset from Kaggle and place it in your working directory.
2. Save the provided R script as `customer_churn_prediction.R`.
3. Run in R:
```r
source("customer_churn_prediction.R")
```



## 📊 Output Examples
- **Confusion Matrix**
- **Accuracy Score**
- **ROC Curve with AUC value**
- **Top contributing features plot**



## 📂 Project Structure
```bash
customer-churn-prediction/
│
├── customer_churn_prediction.R   # Main R script
├── README.md                     # Project documentation
└── telecom_churn.csv             # Dataset (download separately)
```



## 💡 Insights
- Month-to-month contracts and high monthly charges have strong correlation with churn.
- Customers with shorter tenure are more likely to churn.



## 📌 Business Use Case
- Identify high-risk customers early
- Launch targeted retention campaigns
- Reduce revenue loss from churn



## 🏆 Results
- **AUC:** ~0.85 with Logistic Regression
- **Most Important Factors:** Contract type, tenure, monthly charges


