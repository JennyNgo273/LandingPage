# Maven Fuzzy Factory Marketing Insights 2014 - 2015 - Project Overview
## The goal of this project is to investigate the performance of marketing campaigns at Maven Fuzzy Factory in order to surface recommendations on marketing budget allocation across future campaign categories. 

**Founded in 2012, Maven Fuzzy Factory is a e-commerce company that sells popular toys especially types of bear via its website and mobile app**. **In 2014 - 2015 , they launched a fourth product targeting the birthday gift market - The Hudson River Mini Bear and giving customers the option to add 2nd product while on the /cart page** to implement the **cross selling** analysis. 

Now that they’ve hired a new data team and are strategizing their marketing budget for the year, the company would like to build more understanding of the effectiveness of these campaign categories and how they relate to launching new product and cross selling option. 
The budget is allocated to drive two primary objectives:
1) to increase the number of customer purchase
2) to raise the overall revenue for the following year.

## Dataset Structure
The dataset consisted of five tables, including information about website traffic data, website page view, orders, products, as well as specific order item.

![Data Structure](https://github.com/JennyNgo273/LandingPage/blob/master/Data-structure.PNG)


## Insights Summary
#### In order to evaluate campaign performance, we focused on the following key metrics:
- **Conversion Rate**: The percent of website visitor who complete making a purchase. 
- **Product per Order**: The average number of products a customer buys in each product.
- **Seasonal Trends**: Recurring, predictable fluctuations in key metrics sessions, orders over different periods within the year.

#### Conversion Rate
- Across campaign categories, the Brand campaign had the best performing conversion rate at (8.13%), but it ranked third in total orders (2,433 out of 5 campaigns).
- Interestingly, the Non-Brand campaign specifically from Google-search source generated the highest number of orders (12407) and sessions (164296) but had a lower conversion rate of 7.55%.
- The lower conversion rate for Non-Brand campaigns suggests that while it drives substantial traffic, visitors may be less targeted or require further engagement to convert.

#### Product per Order
- Across products, The Hudson River Mini Bear, The Birthday Sugar Panda, and The Forever Love Bear all performed nearly 4-5x better than the average PPO at 1.34. 
- The Original Mr. Fuzzy is a bestseller and drives the highest total revenue, but its PPO is the lowest (1.93), which is typically bought as a single unit per order.
- The Forever Love Bear has the highest AOV ($12.04) and PPO (6.67), indicating strong suggests potential pricing optimization opportunities

#### Seasonal Trends
- Sessions and orders showed steady growth throughout the year, with peak activity in Q4 (October-December). December recorded the highest sessions (29,722) and orders (2,314).
- In 2014, orders grew at a faster rate than sessions, orders grew 135% (983 → 2,314) while sessions increased 100% (14,825 → 29,722).

## Recommendations
- **Non-Brand Campaign (Google Search Source)**: Conduct A/B testing to optimize landing pages, deep dive into segment and optimize by devide (mobile, desktop) to identify disparities in conversion behavior and streamline user experience to get higher order rates in return.
- **The Original Mr. Fuzzy**: Introduce bundle deals, upsell personalized add-ons, and implement a cross-selling strategy, like with The Forever Love Bear products to increase PPO and repeat purchases.
- **The Forever Love Bear**: Implement tiered pricing discounts, explore bulk corporate partnerships, and introduce seasonal editions to boost AOV while maintaining high PPO.
- **2015 Forecast & Trend Strategy**: Prepare early for Q4 peak demand, leverage seasonal marketing campaigns year-round, and use predictive data to optimize ad spend and inventory planning.

## Dashboard
The dashboard can be found in Tableau Public [here](https://public.tableau.com/app/profile/christine3803/viz/RowHealthDashboard/Dashboard). This dashboard enables users to filter by plan, campaign type, and state, and focuses on trends and values in marketing metrics, signup metrics, and claim metrics.

<img width="812" alt="image" src="https://github.com/christinejiang11/rowhealth/assets/56368090/86756aa4-a0d8-44eb-a0d5-c128816f42ac">

