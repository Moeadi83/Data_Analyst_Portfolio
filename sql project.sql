using 'engage date', calculate the number of sales opportunitoes each months
which month had the hights ? 
  
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


