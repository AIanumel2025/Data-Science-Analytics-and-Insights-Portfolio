
# 🏥 Predicting Patient Survival: An extensive Exploratory Data Analysis of chronically ill patients.
Findings derived from an Exploratory Data Analysis of a dataset of 9105 patients between 1989 and 1994.

### ⚠️ PROBLEM STATEMENT ⚠️
The growing national concern over patients' loss of control near the end of life is an important problem. 
Despite this concern, which has been known since the 1980s, a noticeable absence of decision-making interventions to prolong patient death processes has been observed. 
To develop a prognostic model to estimate survival chances of these patients, the dataset gathered is rife with missing values. Some default values have been identified to handle missing values. However, an extensive IDA must be performed to improve the quality of the dataset. This is to improve the predictive ability of a progostic model that will rely on its quality. The predictions made will enable earlier decisions and planning to reduce the frequency of a mechanical, painful, and prolonged dying process.

### 📌 PROJECT OBJECTIVES 📌
1. Perform an extensive initial data analysis to preprocess dataset for model training.
2. Perform a thorough exploratory data analysis of the dataset by analyzing and visualizing to derive patterns and key findings. 
### ❓RESEARCH QUESTIONS❓
1. What is the distribution of PRG2M and PRG6M? What do their average values indicate about the short and long term survival rates of patients?
2. What does the age distribution of patients say about age related patterns in the dataset?
3. What findings are discoverd in exploring the distribution of patient hospital deaths?
4. How does patient sex impact survival rates?
5. What does the distribution of disease groups and classes patients fall under reveal?
6. What is the distribution of Comorbidities in the dataset?
7. Which age category(ies) are associated with higher hospital deaths?
8. What does the relationship between the number of patient comorbidities and its impact on the number of hospital mortality rates reveal?
9. How do the ages of the patients relate to their two and six month survival outcomes?
10. Which disease classes illustrate the short and long term chances of survival of patients(two and six months respectively)?
11. How does a patient's physiology score influence his/her chances of survival?
12. How does a patient's race impact physician’s 2 and 6 month survival estimates?
13. How do short and long term survival rates (by model or physician) impact gender?
14. Which physiological measure(s) correlates with survival at 2 and 6 months respectively?
15. What combination of physiological markers best impacts survival chances in two and six months?

## 🛠 Features & Capabilities
### 🔍 Data Cleaning

1. Standardization
2. Handling missing values
3. Data type correction
4. Duplicate removal

### 📊 Exploratory Analysis

1. Examined short- and long-term patient survival rates (2- and 6-month) and their relationship with age, sex, race, and disease class.
2. Explored hospital death patterns, identifying age groups and comorbidities associated with higher mortality.
3. Investigated the distribution of physiological scores and how individual and combined physiological markers influence survival chances.
4. Analyzed disease groups, classes, and comorbidities to understand their impact on patient outcomes.
5. Studied gender and physician predictions to see how demographic and clinical factors affect survival estimates.
6. Identified key predictors of patient survival, including age, comorbidities, disease type, and physiological measures.

### 🔥 Insights 🔥 

### 📈 Visualizations
1. Correlation Heatmaps: To examine relationships between multiple variables simultaneously.
2. Bar plots: To compare categorical variables and assess their impact on survival or mortality rates.
3. Scatter plots: To visualize several bivariate relationships and trends.
4. Staked bar plots: To show proportional differences in survival rates across categories.
5. Histograms/Distribution plots: To visualize the distribution of short and long term survival predictions.

## Conclusions
1. SPS and APS scores are the strongest prediction of patient survival over short and long terms. There is therefore the need to adopt an APS/SPS threshold to flag patients for early review, before their conditions get worse. This will drastically avoid last-minute interventions, prolonging patient lives.
2. Rely on model estimates and not physician estimates entirely. This helps to reduce bias and enhance the accuracy of estimates.
3. Set up advance care interventions when patients fall within at least two high risk categories (Age, SPS/APS and comorbidities).
4. Contextualize interventions within a low socio-economic patient group.
5. Avoid late decisions making to prevent added suffering and extra costs to patients.
   
## 🗒️🗒️ Original Dataset obtained from the UC Irvine Machine Learning Repository website: https://archive.ics.uci.edu/dataset/880/support2 .
Feedback, comments, analyses, all welcome!
