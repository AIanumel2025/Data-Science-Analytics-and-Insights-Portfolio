# 🫁 Predictive Analytics for Asthma Deterioration  
**Environmental + Clinical Factors | SQL | MATLAB**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![MATLAB](https://img.shields.io/badge/MATLAB-R2024b-orange.svg)](https://mathworks.com)
[![Oracle SQL](https://img.shields.io/badge/SQL-Oracle-FF6600.svg)](https://oracle.com)

**Best model: Random Forest** – **Sensitivity 57.9%** (prioritised over accuracy to minimise life-threatening false negatives).

---

### 📊 Business Problem
Asthma affects **8 million** people in the UK, costs the NHS **£1.3 billion** directly, and causes  about **4 deaths per day**.  
This project predicts **asthma worsening** using:
- Demographic (age, gender)
- Genetic (family history)
- Environmental (motorway proximity ≤ 0.5 km = high pollution proxy)
- Clinical (smoking status, BP metrics)

### 🔄 The Project Workflow 
1. **Business Understanding** → NHS at-risk registers & national-level analytics
2. **Data Understanding** → 10,000 synthetic patients (SQL exploration)
3. **Data Preparation** → Oracle Apex SQL cleaning + feature engineering + CTE modelling view
4. **Modelling** → MATLAB (Decision Tree, Logistic Regression, **Random Forest**)
5. **Evaluation** → Sensitivity prioritised (medical context)
6. **Deployment** → Cloud + Kappa/Lambda architecture recommendations

### 🏆 Model Results (from report)
| Metric       | Decision Tree | Logistic Regression | **Random Forest** |
|--------------|---------------|---------------------|-------------------|
| Accuracy     | 86.23%        | 86.23%              | 61.8%             |
| Precision    | 50%           | 0%                  | 19.6%             |
| **Sensitivity** | 0.48%      | 0%                  | **57.9%**         |
| AUC          | 0.595         | 0.686               | 0.657             |

### 📊 Key Visuals from the Project

**Exploratory Data Analysis**
![Age Distribution](./figures/age-distribution.png)
![Motorway Proximity](./figures/motorway-proximity.png)
![Target Distribution](./figures/target-distribution.png)

**Asthma Deterioration by Age & Motorway Proximity**
![Age vs Worsened](./figures/age-vs-asthma.png)
![Motorway Proximity vs Worsened](./figures/motorway-vs-asthma.png)

**Model Visualisations**
![Decision Tree](./figures/decision-tree.png)
![Confusion Matrix - Decision Tree](./figures/confusion-decision-tree.png)
![Confusion Matrix - Logistic Regression](./figures/confusion-logistic.png)
![Confusion Matrix - Random Forest](./figures/confusion-random-forest.png)

*All figures generated directly from the MATLAB script*

**Why Random Forest wins:** Highest detection of true worsening cases → timely interventions.

### 🛠️ How to Reproduce (2 minutes)

#### SQL (Data Prep)
```sql
-- Run once
sqlplus user/pass@db
@sql/asthma-cleaning-and-modelling-view.sql
