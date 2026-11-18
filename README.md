#	E-commerce Performance & Customer Experience Analytics
End to end analysis of Olist Brazilian E-commerce dataset (about 99,000 orders, 2016-2018). Amounts are in Brazilian reais (R$), and there is no cost data, so profit isn’t calculated.
Tools used - Python, MySQL, and Power BI.
##	Business questions
-	What is the sales trend? 
-	How did product categories, and sellers perform? 
-	What influence does customer location have? 
-	What’s the late delivery rate, and does it affect the review stars? 
-	What payment methods do customers use? 
-	Do customers come back?

##  Brazilian Olist E-commerce dataset (https://github.com/profadept/olist-brazilian-ecommerce/blob/main/SOURCE.md?utm_source=chatgpt.com)

##	Key findings
-	Product value is R$13.59M with 98,666 orders with items and average order value of R$137.75 and R$160.58 with freight value.
-	Orders peaked in November 2017 (with 1,147 orders on November 24th alone), and plateaued in 2018 consistent with Black Friday 
-	Top 10 product categories hold about 62% of product value while top 10 sellers hold about 13%.
-	Late delivery rate is 8.11%. On time delivery has an average of 4.29 stars review, late delivery has average review score of 2.57 stars.
-	SP, RJ, and MG states have about 63% of product value.
-	Repeat customer rate is 3.12%.
##	Dashboard
![Overview](images/overview.png) 
![Drilldown](images/drilldown.png) 
##	Repository 
-	sql/: import scripts, nine analysis queries, and the views used by Power BI 
-	notebooks/: Python data profiling 
-	powerbi/: dashboard file 
-	findings.txt: full written findings, data-quality issues and decisions 
##	How to reproduce
1.	Download the dataset from Kaggle (Olist Brazilian E-Commerce) and import it into MySQL (database olist_analytics). 
2.	Run data_import.sql, then fix order dates 
3.	Run views.sql. 
4.	Open powerbi/e_commerce.pbix and point it to your MySQL server.
##	Data quality notes 
-	For order reviews to be fully imported it needs utf8mb4 and escaping changes.
-	Date columns were imported as text and converted.
-	Two category translations were manually added. These details are in findings.md.
##	Data limitations
-	The dataset has no cost data; therefore, profit isn’t calculated. 
-	The trend is limited to 2017–Aug 2018 because 2016 data is incomplete and 2018 stops around August.
-	Late-delivery and review results show association, not causation.
