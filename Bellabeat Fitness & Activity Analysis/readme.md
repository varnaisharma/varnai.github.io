# Bellabeat Smart Device Usage Analysis

## 📌 Project Overview

Bellabeat is a high-tech wellness company that develops smart products designed to help women monitor and improve their health and lifestyle habits.

This project analyses Fitbit smart device usage data to identify patterns in physical activity, sedentary behaviour, and sleep. The goal is to generate actionable insights that can help Bellabeat improve user engagement and encourage healthier lifestyle habits.

The analysis follows the data analytics process:

**Ask → Prepare → Process → Analyse → Share → Act**

---

## 🎯 Business Task

Analyse smart device usage data to understand user behaviour and identify opportunities for Bellabeat to improve customer engagement and encourage healthier habits.

### Key Questions

- How active are users on an average day?
- How much time do users spend being sedentary?
- What are the differences between activity levels?
- How does activity vary by day of the week?
- What patterns can be identified from sleep and activity data?
- How can Bellabeat use these insights to improve its products and user engagement?

---

# 🛠️ Tools Used

| Tool | Purpose |
|---|---|
| **Excel** | Data cleaning, initial data exploration and descriptive statistics |
| **SQL** | Data cleaning, transformation and exploratory data analysis |
| **Python** | Data analysis and visualisation |
| **Tableau Public** | Interactive dashboard and data storytelling |

---

# 📊 Dataset

The project uses Fitbit fitness tracker data containing information related to:

- Daily activity
- Steps
- Calories burned
- Active minutes
- Sedentary minutes
- Sleep patterns
- Heart rate
- Weight information
- Hourly activity data

The primary datasets used for analysis include:

- `daily_activity`
- `sleep_day`
- `hourlyCalories_merged`
- `hourlyIntensities_merged`
- `hourlySteps_merged`
- `minuteSleep_merged`
- `weightLogInfo_merged`

---

# 🧹 Data Cleaning and Preparation

The data was reviewed and prepared using Excel and SQL.

The following steps were performed:

- Checked for duplicate records
- Checked for missing values
- Reviewed data types
- Converted and standardised date formats
- Created additional fields such as day of the week
- Categorised days into weekday and weekend
- Created activity level categories
- Performed descriptive statistical analysis
- Validated data consistency before analysis

---

# 🔍 Data Analysis

The analysis focused on understanding user behaviour across several areas.

## 1. Physical Activity Analysis

Analysed:

- Average daily steps
- Total distance travelled
- Calories burned
- Very active minutes
- Fairly active minutes
- Lightly active minutes
- Sedentary minutes

### Key Finding

Users recorded an average of approximately:

- **6,547 daily steps**
- **2,189 calories burned**
- **995 sedentary minutes per day**

This indicates that users demonstrate moderate activity levels but spend a significant portion of their day sedentary.

---

## 2. Activity Level Analysis

Users were categorised into different activity levels to better understand movement patterns.

The analysis identified differences between:

- Low activity users
- Moderate activity users
- High activity users

This segmentation can help Bellabeat develop more personalised wellness recommendations.

---

## 3. Active vs Sedentary Behaviour

One of the strongest findings from the analysis was the significant amount of sedentary time compared with active time.

Average daily activity minutes showed:

- Very active minutes: approximately **17 minutes**
- Fairly active minutes: approximately **13 minutes**
- Lightly active minutes: approximately **170 minutes**
- Sedentary minutes: approximately **995 minutes**

This highlights a major opportunity for Bellabeat to encourage users to take more frequent movement breaks.

---

## 4. Day-Based Activity Analysis

User activity patterns were analysed across different days of the week.

The analysis compared:

- Average steps
- Calories burned
- Active minutes
- Sedentary minutes

This can help identify periods when users are more or less active and support the development of targeted notifications.

---

## 5. Sleep Analysis

Sleep data was analysed to understand user sleeping behaviour.

The analysis focused on:

- Total sleep duration
- Time spent in bed
- Sleep records
- Relationship between activity and sleep

Combining sleep and activity insights can help Bellabeat provide a more complete picture of user wellness.

---

# 📈 Key Insights

## 1. Users Are Moderately Active

Users averaged approximately **6,547 steps per day**.

This suggests that users are engaging in regular movement but may benefit from personalised activity goals that encourage gradual improvement.

---

## 2. Sedentary Behaviour Is High

Users spent approximately **995 minutes per day sedentary**.

This was one of the strongest insights from the analysis and highlights an opportunity for Bellabeat to introduce inactivity alerts and movement reminders.

---

## 3. Light Activity Dominates

Users spent significantly more time performing light activity compared with high-intensity exercise.

This suggests that encouraging small increases in daily movement may be more realistic and achievable than immediately promoting intense exercise.

---

## 4. Activity Patterns Vary Across Days

Daily activity patterns differ depending on the day of the week.

Bellabeat could use this information to provide personalised notifications and reminders during periods when users are typically less active.

---

## 5. Sleep and Activity Can Provide Holistic Wellness Insights

Combining sleep and physical activity data can provide users with a better understanding of their overall wellness habits.

Bellabeat has an opportunity to integrate these insights into personalised recommendations.

---

# 💡 Project Outcome

The analysis revealed that Fitbit users demonstrate moderate levels of daily activity but spend a significant portion of their day sedentary.

With an average of approximately **6,547 daily steps** and nearly **995 sedentary minutes per day**, there is a clear opportunity for Bellabeat to move beyond passive health tracking and provide more personalised behavioural guidance.

Based on the findings, Bellabeat could improve user engagement through:

### 🚶 Personalised Activity Goals

Instead of setting the same activity target for every user, Bellabeat could provide progressive goals based on individual activity levels.

For example:

```text
Current Activity → 6,500 steps
        ↓
Personalised Goal → 7,000 steps
        ↓
Progressive Goal → 8,000 steps
