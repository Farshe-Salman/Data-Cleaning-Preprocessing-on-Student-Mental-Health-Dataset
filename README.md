# Data-Cleaning-Preprocessing-on-Student-Mental-Health-Dataset
This project was completed as part of the **Introduction to Data Science** course.  
It focuses on cleaning, preprocessing, visualizing, and preparing a student mental health dataset for further analysis or modeling.

The tasks include handling missing values, detecting outliers, fixing invalid data, encoding categorical variables, normalization, duplicate removal, data filtering, balancing (oversampling), and splitting the dataset into training and testing sets.


## Objectives of the Project
The main goals of the project were:

- Identify and handle missing values  
- Visualize missing values  
- Detect and treat outliers using multiple approaches  
- Identify invalid entries and correct them  
- Convert categorical variables into numeric codes  
- Normalize continuous variables  
- Remove duplicate rows  
- Apply filtering methods  
- Fix class imbalance using oversampling  
- Split the dataset into Training & Testing sets  
- Perform descriptive statistical analysis  
- Analyze sleep duration & study satisfaction patterns  


## Repository Structure
project-folder/
│
├── README.md
├── report.pdf
│
├── code/
│ └── midterm_project.R # Main R script
│
├── data/
│ ├── original_dataset.csv # Raw dataset
│ └── cleaned_dataset.csv # Cleaned dataset



## Technologies Used

- **R Programming Language**
- Packages:
  - `dplyr`
  - `caret`
  - `ggplot2`
  - `utf8`

---

## Key Steps Performed

### ✔ 1. Handling Missing Values
- Checked missing values using `colSums(is.na())`
- Removed NA rows (`na.omit`)
- Replaced numeric NA with mean
- Replaced categorical NA with mode

### ✔ 2. Visualizing Missing Values
- Created barplot showing missing values per column

### ✔ 3. Outlier Detection & Treatment
- Created custom IQR-based outlier detection function  
- Approaches used:
  - Removing outlier rows  
  - Replacing with mean  
  - Replacing with median  

### ✔ 4. Invalid Data Detection & Correction
- Defined valid ranges for each categorical attribute  
- Detected invalid entries  
- Fixed spelling errors (e.g., “Feemale” → “Female”)

### ✔ 5. Encoding Categorical Variables
Converted categories into numeric form for modeling:
- Gender → 1/0  
- Depression → 1/0  
- Sleep Duration → numeric scale  
- Diet habits → encoded values  

### ✔ 6. Normalization
Applied Min-Max Normalization to all numeric columns.

### ✔ 7. Duplicate Removal
Used `duplicated()` to find and remove duplicate rows.

### ✔ 8. Filtering Data
Filtered based on:
- Gender  
- Depression  
- Study hours  
- Age  
- Dietary habits  

### ✔ 9. Balancing Dataset (Oversampling)
Balanced the Depression column using oversampling.

### ✔ 10. Train-Test Split
Used `createDataPartition()` to split into:
- 80% Training  
- 20% Testing  

### ✔ 11. Statistical Analysis
Generated descriptive statistics for:
- Study Hours  
- Age  

### ✔ 12. Sleep Duration Comparison
Compared patterns between depressed vs. non-depressed students.

### ✔ 13. Study Satisfaction Analysis
Used grouped summary + histograms to analyze variation in study hours.

---

## 📊 Example Output (Optional)
Place your generated plots inside the `plots/` folder.

---

## 📜 How to Run the R Script

1. Clone this repository:
git clone https://github.com/your-username/your-repo-name.git

2. Open the project in RStudio.

3. Install required packages:
install.packages(c("dplyr", "caret", "ggplot2", "utf8"))

4. Run the script:
source("code/midterm_project.R")

