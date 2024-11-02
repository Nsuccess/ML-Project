#!/bin/bash

# Define the path to the CSV file and ensure it exists
csv_file="reports/baseline_model_results.csv"
if [[ ! -f "$csv_file" ]]; then
  echo "Error: $csv_file not found."
  exit 1
fi

# Find the best model by sorting the CSV by F1-score (assumed to be in the 5th column)
best_model=$(sort -t, -k5 -rg "$csv_file" | head -n 1)

# Extract individual fields from the best model
data_version=$(echo "$best_model" | awk -F, '{print $1}')
model_name=$(echo "$best_model" | awk -F, '{print $2}')
precision=$(echo "$best_model" | awk -F, '{print $3}')
recall=$(echo "$best_model" | awk -F, '{print $4}')
f1_score=$(echo "$best_model" | awk -F, '{print $5}')
roc_auc=$(echo "$best_model" | awk -F, '{print $6}')

# Define the confusion matrix image file path based on data_version and model_name
confusion_matrix="reports/${data_version}_${model_name}_confusion_matrix.png"

# Generate the Markdown report
cat <<EOF > reports/baseline_model_report.md
# Baseline Model Evaluation

## Model Information
* **Model Name**: $model_name
* **Data Version**: $data_version

## Performance Metrics
* **Precision**: $precision
* **Recall**: $recall
* **F1-Score**: $f1_score
* **ROC-AUC**: $roc_auc

## Confusion Matrix
![Confusion Matrix Image]($confusion_matrix)
EOF
