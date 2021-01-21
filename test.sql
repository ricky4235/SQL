SELECT  d.Department, d.Country, d.`Customer Name`
		, CEILING(sum(`Revenue`)) as Revenue
        , row_count()
        
FROM genius_data.`2020DA` as d

where `Year` = 2020
and	Month in(11, 12)
group by `Customer Name`

order by Revenue desc
