SELECT  d.Department, d.Country, d.`Customer Name`  
		, CEILING(sum(`Revenue`)) as Revenue 
        , row_count()
        
FROM genius_data.`2010-2020` as d
where `Year` = 2020
and	Month = 12
group by `Customer Name`
order by Revenue desc

