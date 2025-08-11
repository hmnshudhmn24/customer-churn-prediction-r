# customer_churn_prediction.R
# Robust Customer Churn Prediction script (Logistic Regression + Decision Tree)
# This script checks for common dataset filenames and gives a clear message if the file is missing.

# -------------------------
# 0. Packages & helpers
# -------------------------
packages <- c("tidyverse", "caret", "rpart", "rpart.plot", "pROC", "e1071", "readr")
install_if_missing <- function(pkgs) {
  for (p in pkgs) {
    if (!require(p, character.only = TRUE)) {
      install.packages(p, dependencies = TRUE)
      library(p, character.only = TRUE)
    }
  }
}
install_if_missing(packages)

library(tidyverse)
library(caret)
library(rpart)
library(rpart.plot)
library(pROC)
library(e1071)
library(readr)

# -------------------------
# 1. Locate dataset
# -------------------------
possible_names <- c(
  "Telco-Customer-Churn.csv",
  "WA_Fn-UseC_-Telco-Customer-Churn.csv",
  "telecom_churn.csv",
  "Telco_Customer_Churn.csv",
  "customer_churn.csv",
  "Telco-Customer-Churn.csv"
)

data_path <- NULL
for (fn in possible_names) {
  if (file.exists(fn)) {
    data_path <- fn
    break
  }
}

if (is.null(data_path)) {
  stop(paste0(
    "Dataset not found. Please download the Telco Customer Churn CSV from Kaggle/IBM ",
    "and place it in this folder. Expected filenames (any one):\n  - ",
    paste(possible_names, collapse = "\n  - "),
    "\n\nDownload link (example): https://www.kaggle.com/blastchar/telco-customer-churn"
  ))
}

cat("Using dataset file:", data_path, "\n")

# -------------------------
# 2. Load data
# -------------------------
df <- read_csv(data_path, show_col_types = FALSE)

cat("Dataset rows:", nrow(df), "columns:", ncol(df), "\n")
glimpse(df)

# -------------------------
# 3. Preprocessing
# -------------------------
# Remove customerID if present
if ("customerID" %in% names(df)) df <- df %>% select(-customerID)

# Handle TotalCharges if present (some files have blanks)
if ("TotalCharges" %in% names(df)) {
  df <- df %>%
    mutate(TotalCharges = ifelse(trimws(as.character(TotalCharges)) == "", NA, TotalCharges),
           TotalCharges = as.numeric(TotalCharges))
  if (any(is.na(df$TotalCharges))) {
    cat("Imputing", sum(is.na(df$TotalCharges)), "missing TotalCharges with median\n")
    df$TotalCharges[is.na(df$TotalCharges)] <- median(df$TotalCharges, na.rm = TRUE)
  }
}

# Convert character columns to factors
char_cols <- df %>% select(where(is.character)) %>% names()
if (length(char_cols) > 0) {
  df <- df %>% mutate(across(all_of(char_cols), as.factor))
}

# Ensure target column 'Churn' exists and is factor with levels No/Yes
if (!"Churn" %in% names(df)) stop("Target column 'Churn' not found in dataset.")
df$Churn <- as.factor(df$Churn)
if (!all(levels(df$Churn) %in% c("No", "Yes"))) {
  df$Churn <- recode_factor(df$Churn,
                            "Yes" = "Yes", "No" = "No",
                            "TRUE" = "Yes", "FALSE" = "No",
                            "Y" = "Yes", "N" = "No")
  df$Churn <- factor(df$Churn, levels = c("No", "Yes"))
}

# -------------------------
# 4. Train-test split
# -------------------------
set.seed(123)
train_idx <- createDataPartition(df$Churn, p = 0.75, list = FALSE)
train <- df[train_idx, ]
test  <- df[-train_idx, ]

cat("Train rows:", nrow(train), "Test rows:", nrow(test), "\n")

# -------------------------
# 5. Modeling with caret
# -------------------------
ctrl <- trainControl(method = "cv",
                     number = 5,
                     classProbs = TRUE,
                     summaryFunction = twoClassSummary,
                     savePredictions = "final")

# 5A: Logistic Regression
set.seed(42)
glm_model <- train(Churn ~ ., data = train,
                   method = "glm",
                   family = "binomial",
                   metric = "ROC",
                   trControl = ctrl)

cat("Logistic regression trained.\n")

# 5B: Decision Tree
set.seed(42)
rpart_grid <- expand.grid(cp = seq(0.001, 0.05, length.out = 8))
rpart_model <- train(Churn ~ ., data = train,
                     method = "rpart",
                     tuneGrid = rpart_grid,
                     metric = "ROC",
                     trControl = ctrl)

cat("Decision tree trained.\n")

# -------------------------
# 6. Evaluation function
# -------------------------
eval_model <- function(model, test_df, model_name = "model") {
  probs <- predict(model, newdata = test_df, type = "prob")[, "Yes"]
  preds_class <- predict(model, newdata = test_df)

  cm <- confusionMatrix(preds_class, test_df$Churn, positive = "Yes")
  roc_obj <- roc(response = test_df$Churn, predictor = probs, levels = c("No","Yes"))
  auc_val <- auc(roc_obj)

  precision <- cm$byClass["Pos Pred Value"]
  recall    <- cm$byClass["Sensitivity"]
  f1        <- ifelse((precision + recall) == 0, 0, 2 * (precision * recall) / (precision + recall))
  accuracy  <- cm$overall["Accuracy"]

  list(model_name = model_name, confusion_matrix = cm, auc = as.numeric(auc_val),
       precision = as.numeric(precision), recall = as.numeric(recall),
       f1 = as.numeric(f1), accuracy = as.numeric(accuracy), roc_obj = roc_obj)
}

glm_eval <- eval_model(glm_model, test, "Logistic Regression")
rpart_eval <- eval_model(rpart_model, test, "Decision Tree")

# Print metrics
print_metrics <- function(res) {
  cat("\n---", res$model_name, "---\n")
  cat("Accuracy :", round(res$accuracy, 4), "\n")
  cat("AUC      :", round(res$auc, 4), "\n")
  cat("Precision:", round(res$precision, 4), "\n")
  cat("Recall   :", round(res$recall, 4), "\n")
  cat("F1-score :", round(res$f1, 4), "\n")
  print(res$confusion_matrix$table)
}

print_metrics(glm_eval)
print_metrics(rpart_eval)

# -------------------------
# 7. Save artifacts
# -------------------------
saveRDS(glm_model, file = "glm_model.rds")
saveRDS(rpart_model, file = "rpart_model.rds")

metrics <- tibble(
  model = c(glm_eval$model_name, rpart_eval$model_name),
  accuracy = c(glm_eval$accuracy, rpart_eval$accuracy),
  auc = c(glm_eval$auc, rpart_eval$auc),
  precision = c(glm_eval$precision, rpart_eval$precision),
  recall = c(glm_eval$recall, rpart_eval$recall),
  f1 = c(glm_eval$f1, rpart_eval$f1)
)

write_csv(metrics, "model_metrics_summary.csv")
cat("\nSaved models and metrics to disk (glm_model.rds, rpart_model.rds, model_metrics_summary.csv)\n")
cat("Done.\n")
