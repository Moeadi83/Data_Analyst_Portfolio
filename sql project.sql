The Situation: I have joined Judah Inc., a company specializing in computer hardware sales to large businesses, as a sales analyst.
The Vice President of Sales is generally satisfied with her team's performance but seeks a clearer understanding of its strengths and weaknesses.
I have been tasked with analyzing last year's sales, including key statistics on the sales pipeline's health and sales agent performance.
I will also assess product popularity and customer profiles.





Objective 1 
Pipeline metrics
  
Calculate the number of sales opportunities created each month using "engage_date" and identify month with the most opportunities. 
  
SELECT * FROM sales_pipeline;

SELECT YEAR(engage_date),MONTH(engage_date), count(*)
FROM sales_pipeline
GROUP BY year(engage_date) ,MONTH(engage_date)
ORDER BY count(*) DESC

YEAR	MONTH	Count
2017	7	  796
2017	4	  753
2017	10	703
2017	6	  681
2017	9	  677
2017	3	  655
2017	5 	588
2017	8	  539
2017	2	  420
2017	1	  247
2017	11	244
2016	12	196
2017	12	103
2016	11	102
2016	10	7

FIND the average time deals stayed open ( from "engage_date" to "close date"), and compare closed delas versus won deals

SELECT AVG (DATEDIFF(close_date, engage_date)) FROM sales_pipeline;
AVG (DATEDIFF(close_date, engage_date))
47.9854
  


SELECT deal_stage, AVG (DATEDIFF(close_date, engage_date))
FROM sales_pipeline
GROUP BY deal_stage
ORDER BY 2 DESC;
deal stage	Days
Won       52
lost      41


Calculate the percentage of deals in each stage, and determine what share were lost


SELECT AVG(CASE WHEN deal_stage = 'lost' THEN 1 ELSE 0 END) * 100 as lost_rate FROM sales_pipeline;
lost_rate
36.8499

Compute the win rate for each product,and identify which one had the highest win rate 

SELECT product,AVG(CASE WHEN deal_stage = 'won' THEN 1 ELSE 0 END) *100 as win_rate
FROM sales_pipeline
GROUP BY Product
ORDER BY 2 DESC;

product	     win_rate
MG Special	 64.8406
GTX Plus Pro	64.2953
GTX Basic	    63.7187
GTXPro	      63.5571
GTX Plus Basic	62.1313
MG Advanced	    60.3321
GTK             500	60

Objerctive 2 
Sales agent performance

Calculate the win rate for each sales agent, and find the top performer
SELECT sales_agent,  AVG(CASE WHEN deal_stage = 'won' then 1 else 0 END) as win_rate
FROM sales_pipeline
GROUP BY sales_agent
ORDER BY 2 DESC

sales_agent	   win_rate
Hayden Neloms	  0.7039
Maureen Marcano	0.6995
Wilburn Farren	0.6962
Cecily Lampkin	0.6688
Versie Hillebrand	0.6667
Moses Frase	     0.6615
Boris Faz	      0.6601
James Ascencio	0.6553
Corliss Cosme	   0.655
Rosalina Dieter	0.6545
Reed Clapper	   0.654
Jonathan Berthelot	0.6477
Rosie Papadopoulos	0.6446
Kami Bicknell	     0.6397
Vicki Laflamme	  0.6369
Elease Gluck	    0.6349
Violet Mclelland	0.6321
Darcel Schlecht	  0.6311
Marty Freudenburg	0.6289
Cassey Cress	   0.6245
Kary Hendrixson	0.6239
Anna Snelling	  0.619
Zane Levy	      0.6169
Garret Kinder	  0.6098
Daniell Hammack	0.6096
Niesha Huffines	0.6
Gladys Colclough	0.5819
Donn Cantrell	0.5745
Markita Hansen	0.5727
Lajuana Vencill	0.5498


Calculate the total revenue by agent, and see who generated the most
  
SELECT sales_agent, SUM(close_value) as revenue
FROM sales_pipeline
GROUP BY sales_agent
ORDER BY 2 DESC
sales_agent	       revenue
Darcel Schlecht	   1153214
Vicki Laflamme	  478396
Kary Hendrixson  	454298
Cassey Cress	   450489
Donn Cantrell	   445860
Reed Clapper	   438336
Zane Levy	       430068
Corliss Cosme	   421036
James Ascencio	  413533
Daniell Hammack	 364229
Maureen Marcano	  350395
Gladys Colclough	345674
Markita Hansen	  328792
Kami Bicknell	    316456
Marty Freudenburg	291195
Elease Gluck	    289195
Jonathan Berthelot	284886
Anna Snelling	     275056
Hayden Neloms	    272111
Boris Faz	        261631
Rosalina Dieter	    235403
Rosie Papadopoulos	230169
Cecily Lampkin	   229800
Moses Frase	      207182
Garret Kinder	    197773
Lajuana Vencill	  194632
Versie Hillebrand	187693
Niesha Huffines	  176961
Wilburn Farren	  157640
Violet Mclelland	123431

Which Manager had the highest win rate ( Revenue)
  
SELECT st.manager,SUM(close_value) as revenue
FROM sales_teams st 
LEFT JOIN sales_pipeline sp on st.sales_agent =  sp.sales_agent
GROUP BY st.manager
ORDER BY 2 DESC; 
manager	        revenue
Melvin Marxen	   2251930
Summer Sewald	   1964750
Rocco Neubert	   1960545
Celia Rouche	    1603897
Cara Losch	      1130049
Dustin Brinkmann	1094363







  
Which Regional office sold the most units of GTX plus Pro?

SELECT  st.regional_office, count(*) as units_sold
FROM sales_teams st
LEFT JOIN sales_pipeline sp on st. sales_agent = sp. sales_agent
WHERE deal_stage = 'won' and sp.product = 'GTX PLUS Pro'
GROUP BY st. regional_office
ORDER BY 2 DESC; 
regional_office	units_sold
Central	        170
West	          160
East	          149

Objective 3
Product analysis

For March deals,identify the top product by revenue and compare it to the top by uinits sold

SELECT product, SUM(close_value) as revenue, count(*) as units_sold
FROM sales_pipeline
WHERE MONTH (close_date) = 3 and deal_stage = 'won'
GROUP BY product
ORDER BY 2 DESC;


product   	  revenue	      units_sold
GTXPro	       376966	            80
MG Advanced	    290207	         84
GTX Plus Pro	  278081	        51
GTX Plus Basic	88512	          82
GTX Basic	      69204	          126
GTK 500 	      25897	           1
MG Special	    5805	            107


  


  
 Calculate the average difference between 'sales_price' and 'close_value' for each product, and note if
the results suggest a data issue

SELECT sp.product, AVG(p.sales_price - sp.close_value) as difference, AVG( sp.close_value / p.sales_price) as discount
FROM sales_pipeline sp
LEFT JOIN products p on sp. product=p.product
WHERE sp.deal_stage = 'won'
GROUP BY product
ORDER BY difference DESC; 
product	      difference	              discount
GTK 500	        60.5333	                0.99773333
GTX PlusBasic	 15.9464       	          0.98544992
GTX Basic	     4.3574	                 0.99207639
MG Advanced	   4.0291	                 0.99881162
MG Special	  -0.1929	                 1.00350618
GTX Plus Pro	-7.8768       	        1.0014357
*GTXPro	       NULL	                        NULL
 
GTXPRO return to Null because in Sales_pipeline table GTXPRO is written with no space
however in products GTX PRO is written with space. Data Engineer will need to fix this. 








  
Calculate total_revenue by product series and compare their performance  
  
SELECT p.series, sum(sp.close_value) as revenue
FROM products p
LEFT JOIN sales_pipeline sp on p.product = sp.product
WHERE sp.deal_stage = 'won'
GROUP BY p.series
ORDER BY 2 DESC;
  
series	revenue
GTX	   3834189
MG	   2260155
GTK	   400612

  

  

  
  

