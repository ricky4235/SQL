SELECT d.`2nd Item Number` "Item Num" , d.`Customer Name`, d.Description,	#含空格欄位須用反引號  
	   d.`Foreign Extended Price`  ,  d.`Quantity Shipped`
       
FROM genius_data.genius_data_202002 as d
where `Department` = 'SF1' & 'SF3'
and `Year` = '2020'
and `Month` = '2'
and `LargeCat` = 'Mouse'
and `MediumCat` = 'Wireless Mouse'
and `Description` = 'OBM'
join 

;

/*
Order Number, Department,
Continent, Country,
Ship To Number, Ship_To AlphaName,
Customer Number, Customer Name, 
LargeCat, MediumCat, Sls CD1 Desc#, Sls CD2  Desc#, Sls CD3 Desc#, Sls CD4 Desc#, Sls CD9 Desc#, 
Product Desc#,2nd Item Number,
Year, Month, Exchange Rate, 
Foreign Unit Price, 
Foreign Extended Price,
Foreign Extended Cost,
Foreign Ext# Margin,
Quantity Shipped,
Description
*/