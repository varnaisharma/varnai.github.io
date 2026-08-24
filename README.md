# Cyclistic Bike-Share Analysis

## Project overview

This case study explores how Cyclistic, a bike-share company, can encourage casual riders to become annual members. I used Excel to clean the data, SQL to analyse rider behaviour, and Tableau to create an interactive dashboard that presents the findings clearly.

The analysis compares casual riders and annual members across ride volume, ride duration, day of week, quarter, and popular starting stations. The goal is to identify meaningful behavioural differences and translate them into practical membership-growth recommendations.

## Business question

**How can Cyclistic convert more casual riders into annual members?**

## Tools used

| Tool | How it was used |
| --- | --- |
| Excel | Cleaned and prepared the source data before analysis. |
| SQL (MySQL) | Loaded quarterly trip files, checked data quality, and analysed rider behaviour. |
| Tableau Public | Built an interactive dashboard to communicate trends and recommendations. |

## Process

### 1. Data preparation in Excel

- Reviewed and cleaned the raw trip data.
- Prepared consistent fields for analysis, including ride length and day of week.
- Organised the data into quarterly source files for loading into SQL.

### 2. Data analysis in SQL

I created a `cyclist_trips` table and loaded four quarterly data files. The SQL analysis included:

- Record-count checks by quarter and for the full dataset.
- Column and sample-record checks.
- Customer-type distribution and missing customer-type checks.
- Ride-duration analysis, including average ride length by customer type.
- Ride counts by day of week.
- Casual rider versus member comparisons by day and quarter.
- Average ride duration by day and customer type.
- Most popular starting stations and station preferences by customer type.

The complete query file is available in [Cyclist_Trips_SQL_Codes.sql](Cyclist_Trips_SQL_Codes.sql).

### 3. Dashboard development in Tableau

I created an interactive Tableau dashboard to make the comparison between casual riders and annual members easy to explore. The dashboard highlights ride patterns, duration, weekday behaviour, quarterly trends, and popular start stations.

## Key insights

1. **Casual riders take longer trips on average.** This indicates that casual riding is more leisure-oriented and provides an opportunity to position membership around enjoyable, frequent riding.
2. **Casual-rider activity is stronger on weekends.** Weekend promotions, local-event partnerships, and short-term offers can help reach riders when they are most engaged.
3. **Members ride more consistently.** This suggests that annual membership appeals to routine and practical travel needs, such as commuting and regular trips.
4. **Rider behaviour varies by time and location.** Day-of-week, quarterly, and station analysis can help Cyclistic tailor campaigns to the right audience, place, and moment.

## Recommendations

- Promote annual membership benefits to casual riders through weekend and seasonal campaigns.
- Emphasise convenience, cost savings, and routine-travel value for riders who may be ready to use the service more frequently.
- Use high-demand casual-rider stations for targeted in-app, email, or on-site membership messaging.
- Partner with local events and leisure destinations to offer conversion-focused promotions at points of high casual demand.

## Tableau dashboard

[View the interactive Tableau Public dashboard](https://public.tableau.com/views/CyclisticBike-ShareAnalysis_17873530559870/Dashboard2?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## Portfolio summary

For this project, I cleaned historical bike-share trip data in Excel, used SQL to identify differences between casual riders and annual members, and created a Tableau dashboard to present actionable insights. The analysis suggests that casual riders have longer, more leisure-oriented trips and stronger weekend activity, while members show more consistent travel patterns. Based on these findings, I recommend targeted weekend and seasonal campaigns that communicate the value, convenience, and savings of annual membership.
