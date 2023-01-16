
Select
  ProductKey,											
  OrderDate,
  City,
  [StateProvinceName] as [State],
  [CountryRegionName] as Country,
  sum(SalesAmount) as tcSalesValue,									
  sum(TotalProductCost) as tcProductCost,									
  sum(TaxAmt)	as tcSalesTax,										
  sum(Freight) as tcTransportCost,									
  count(distinct [SalesOrderNumber]) as tcOrderCount,									
  0 as ovOrderCount,									
  0 as ovRunningOrderCount,								
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								 
  0 as lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  0 as mvSalesValue,											 
  0 as mvAvgSales,
  0 as mvOrderCount,
  0 as mvAvgOrders,
  '' as xjSaleTypeName,									 
  '' as xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
 OnlineSales OL inner Join [dbo].[Customer] Cus on OL.[CustomerKey] = Cus.CustomerKey left join
[dbo].[GeoLocation]  Geo on Cus.[GeographyKey] = geo.GeographyKey

where	
 year(OrderDate) between 2017 and 2019 
group by
 ProductKey,
 OrderDate,
 City,
 StateProvinceName ,
 CountryRegionName

  UNION ALL
    
Select
  0 as ProductKey,											
  OrderDate,
  '' as City,
  '' as State,
  '' as Country,
  0 as tcSalesValue,									
  0 as tcProductCost,									
  0	as tcSalesTax,										
  0 as tcTransportCost,									
  0 as tcOrderCount,									
  ovOrderCount,									
  ovRunningOrderCount,								
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								 
  0 as lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  0 as mvSalesValue,											 
  0 as mvAvgSales,
  0 as mvOrderCount,
  0 as mvAvgOrders,
  '' as xjSaleTypeName,									 
  '' as xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
 (
 select
	OrderDate,
	count(distinct [SalesOrderNumber]) as ovOrderCount,
	sum(count(distinct SalesOrderNumber)) over (Order By OrderDate) as ovRunningOrderCount

	--,sum([SalesAmount] ) as ovSalesValue
	--,sum(sum([SalesAmount]) ) over (Order By OrderDate) as   ovRunningSalesTotal
 from
	OnlineSales 
 where
	year(OrderDate) between 2017 and 2019
 group by
	OrderDate
 ) dt


 UNION ALL

 Select
  0 as ProductKey,											
  OrderDate,
  '' as City,
  '' as State,
  '' as Country,
  0 as tcSalesValue,									
  0 as tcProductCost,									
  0	as tcSalesTax,										
  0 as tcTransportCost,									
  0 as tcOrderCount,									
  0 as ovOrderCount,									
  0 as ovRunningOrderCount,								
  ovSalesValue,									
  ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								 
  0 as lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  0 as mvSalesValue,											 
  0 as mvAvgSales,
  0 as mvOrderCount,
  0 as mvAvgOrders,
  '' as xjSaleTypeName,									 
  '' as xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
 (
 select
	OrderDate,
	--count(distinct [SalesOrderNumber]) as ovOrderCount,
	--sum(count(distinct SalesOrderNumber)) over (Order By OrderDate) as ovRunningOrderCount

	sum([SalesAmount] ) as ovSalesValue
	,sum(sum([SalesAmount]) ) over (Order By OrderDate) as   ovRunningSalesTotal
 from
	OnlineSales 
 where
	year(OrderDate) between 2017 and 2019
 group by
	OrderDate
 ) dt


 UNiON ALL
Select
  0 as ProductKey,											
  OrderDate,
  '' as City,
  '' as State,
  '' as Country,
  0 as tcSalesValue,									
  0 as tcProductCost,									
  0	as tcSalesTax,										
  0 as tcTransportCost,									
  0 as tcOrderCount,									
  0 as ovOrderCount,									
  0 as ovRunningOrderCount,								
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  lagSalesGrowthIn$,								 
  lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  0 as mvSalesValue,											 
  0 as mvAvgSales,
  0 as mvOrderCount,
  0 as mvAvgOrders,
  '' as xjSaleTypeName,									 
  '' as xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
(	
select								
    MonthStartDate as OrderDate,											-- Dimension on Chart as Year/Month only hence use Calendar table to achieve this
	sum(SalesAmount) as SalesValue,
	lag(sum(SalesAmount),1) Over (Order By MonthStartDate)  as PreviousYearMonthSales,
	sum(SalesAmount) - lag(sum(SalesAmount),1) Over (Order By MonthStartDate) as lagSalesGrowthIn$,
	100 * (
			(sum(SalesAmount) - lag(sum(SalesAmount),1) Over (Order By MonthStartDate)) /
			lag(sum(SalesAmount),1) Over (Order By MonthStartDate)
		   )
		  as lagSalesGrowthInPercent
from 
	OnlineSales os inner join
	Calendar cal on os.OrderDate = cal.DisplayDate
where
	year(OrderDate) between 2017 and 2019
group by 
    MonthStartDate
) dt

  


   UNiON ALL
Select
  0 as ProductKey,											
  OrderDate,
  '' as City,
  '' as State,
  '' as Country,
  0 as tcSalesValue,									
  0 as tcProductCost,									
  0	as tcSalesTax,										
  0 as tcTransportCost,									
  0 as tcOrderCount,									
  0 as ovOrderCount,									
  0 as ovRunningOrderCount,								
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								 
  0 as lagSalesGrowthInPercent,							
  lagFreightGrowthIn$,								
  lagFreightGrowthInPercent,						
  0 as mvSalesValue,											 
  0 as mvAvgSales,
  0 as mvOrderCount,
  0 as mvAvgOrders,
  '' as xjSaleTypeName,									 
  '' as xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
(	

  
select								
    [WeekStartDate] as OrderDate,
	 sum(Freight) as tcTransportCost,				
	lag(sum(Freight),1) Over (Order By weekstartDate)  as PreviousYearweekTcost,
	sum(Freight) - lag(sum(Freight),1) Over (Order By weekstartDate) as lagFreightGrowthIn$,
	100 * (
			(sum(Freight) - lag(sum(Freight),1) Over (Order By weekstartDate)) /
			lag(sum(Freight),1) Over (Order By weekstartDate)
		   )
		  as lagFreightGrowthInPercent
from 
	OnlineSales os inner join
	Calendar cal on os.OrderDate = cal.DisplayDate
where
	year(OrderDate) between 2017 and 2019
group by 
    [WeekStartDate]

) dt


Union All


Select
  0 as ProductKey,											
  OrderDate,
  '' as City,
  '' as State,
  '' as Country,
  0 as tcSalesValue,									
  0 as tcProductCost,									
  0	as tcSalesTax,										
  0 as tcTransportCost,									
  0 as tcOrderCount,									
  0 as ovOrderCount,									
  0 as ovRunningOrderCount,								
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								 
  0 as lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  mvSalesValue,											 
  mvAvgSales,
  0 as mvOrderCount,
  0 as mvAvgOrders,
  '' as xjSaleTypeName,									 
  '' as xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from

(
select
	OrderDate,
	sum(SalesAmount) as mvSalesValue,
	avg(sum(SalesAmount)) over (Order By OrderDate rows between 30 preceding and current row ) as mvAvgSales

from
	OnlineSales  
where
	year(OrderDate) between 2017 and 2019
group by 
	OrderDate
) dtMvAvgSales


Union All


Select
  0 as ProductKey,											
  OrderDate,
  '' as City,
  '' as State,
  '' as Country,
  0 as tcSalesValue,									
  0 as tcProductCost,									
  0	as tcSalesTax,										
  0 as tcTransportCost,									
  0 as tcOrderCount,									
  0 as ovOrderCount,									
  0 as ovRunningOrderCount,								
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								 
  0 as lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  0 as mvSalesValue,											 
  0 as mvAvgSales,
  mvOrderCount,
  mvAvgOrders,
  '' as xjSaleTypeName,									 
  '' as xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from

(
select
	OrderDate,
	count(distinct [SalesOrderNumber]) as mvOrderCount,
	avg(count(distinct [SalesOrderNumber])) over (Order By OrderDate rows between 30 preceding and current row ) as mvAvgOrders

from
	OnlineSales  
where
	year(OrderDate) between 2017 and 2019
group by 
	OrderDate
) dtMvAvgSales

UNION ALL

Select
  ProductKey,											
  OrderDate,
  '' as City,
  '' as State,
  '' as Country,
  0 as tcSalesValue,									
  0 as tcProductCost,									
  0	as tcSalesTax,										
  0 as tcTransportCost,									
  0 as tcOrderCount,									
  0 as ovOrderCount,									
  0 as ovRunningOrderCount,								
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								 
  0 as lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  0 as mvSalesValue,											 
  0 as mvAvgSales,
  0 as mvOrderCount,
  0 as mvAvgOrders,
  xjSaleTypeName,									 
  xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
(
   select
    prod.ProductKey,
	st.SaleTypeName as xjSaleTypeName,
	case
  	  when SalesValue > 0 then 'Had Sale(s)'
	  when SalesValue is null then 'No Sale'
	 end as xjSaleStatus,
	'2019-12-31' as OrderDate
   from
	SaleType st cross join
	Product prod left join
    (
	select
		SaleTypeKey,
		ProductKey,
		sum(SalesAmount) as SalesValue
	from
		OnlineSales
	where
		year(OrderDate) between 2017 and 2019 
	group by
		SaleTypeKey,
		ProductKey
    ) as SaleTypeSales on SaleTypeSales.SaleTypeKey = st.SaleTypeKey and
						  SaleTypeSales.ProductKey = prod.ProductKey

   Where
    prod.ProductKey>0
) dt

Union all


Select
  ProductKey,											
  OrderDate,
  '' as City,
  '' as State,
  Country,
  0 as tcSalesValue,									
  0 as tcProductCost,									
  0	as tcSalesTax,										
  0 as tcTransportCost,									
  0 as tcOrderCount,									
  0 as ovOrderCount,									
  0 as ovRunningOrderCount,								
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								 
  0 as lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  0 as mvSalesValue,											 
  0 as mvAvgSales,
  0 as mvOrderCount,
  0 as mvAvgOrders,
  '' as xjSaleTypeName,									 
  '' as xjSaleStatus,
  xjGeoSaleStatus,
  count(xjGeoSaleStatus) as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
   (
  	select
	  distinct(prod.ProductKey),
	  geo.CountryRegionName as Country,
	case
  	  when SalesValue > 0 then 'Had Sale(s)'
	  when SalesValue is null then 'No Sale'
	 end as xjGeoSaleStatus,
	 '2019-12-31' as OrderDate
	from
	  GeoLocation geo cross join					-- >> Card: 616
	  Product prod 	left join						-- >> Card: 606				: 616 X 606 = Cartesian Product 373,296 rows	
	(
	   select
			 cus.GeographyKey
			,ProductKey
			,sum(SalesAmount) as SalesValue	
		from
			OnlineSales os inner join
			Customer cus on os.CustomerKey = cus.CustomerKey
		where 
			year(OrderDate) between 2017 and 2019 
		group by
			 GeographyKey
			,ProductKey	
	) as geoSaleTypedSales ON geoSaleTypedSales.GeographyKey = geo.GeographyKey and
						      geoSaleTypedSales.ProductKey = prod.ProductKey
	where 
	  prod.ProductKey > 0
    ) dt
group by
	ProductKey,
	Country,
	xjGeoSaleStatus,
	OrderDate

	go

	with Sales_CTE (OrderDate,CustomerKey,SalesValue)
	AS
	(
	select
		cast(year(OrderDate) as char(4)) + '-01-01' as OrderDate,
		CustomerKey,
		sum(SalesAmount) as SalesValue
	from
		OnlineSales
	where
		year(OrderDate) between 2017 and 2019
	group by
		Year(OrderDate),
		CustomerKey
	)
	Select
	  0 as ProductKey,											
	  OrderDate,
	  '' as City,
	  '' as State,
	  '' as Country,
	  0 as tcSalesValue,									
	  0 as tcProductCost,									
	  0	as tcSalesTax,										
	  0 as tcTransportCost,									
	  0 as tcOrderCount,									
	  0 as ovOrderCount,									
	  0 as ovRunningOrderCount,								
	  0 as ovSalesValue,									
	  0 as ovRunningSalesTotal,								
	  0 as lagSalesGrowthIn$,								 
	  0 as lagSalesGrowthInPercent,							
	  0 as lagFreightGrowthIn$,								
	  0 as lagFreightGrowthInPercent,						
	  0 as mvSalesValue,											 
	  0 as mvAvgSales,
	  0 as mvOrderCount,
	  0 as mvAvgOrders,
	  '' as xjSaleTypeName,									 
	  '' as xjSaleStatus,
	  '' as xjGeoSaleStatus,
	  0 as xjGeoSaleStatusCount,
  	 avg(SalesValue) as cteAverageCustSales$,
	 0 as cteAvgOrderProductQty
	from
		Sales_CTE
	group by
		OrderDate
	order by
		OrderDate;

GO;

	with Sales_CTE (OrderDate,ProductKey,orderProductQty)
	AS
	(
	select
		cast(year(OrderDate) as char(4)) + '-01-01' as OrderDate,
		CustomerKey,
		count(ProductKey) as orderProductQty
	from
		OnlineSales
	where
		year(OrderDate) between 2017 and 2019
	group by
		Year(OrderDate),
		CustomerKey,
		SalesOrderNumber
	)
	Select
	  0 as ProductKey,											
	  OrderDate,
	  '' as City,
	  '' as State,
	  '' as Country,
	  0 as tcSalesValue,									
	  0 as tcProductCost,									
	  0	as tcSalesTax,										
	  0 as tcTransportCost,									
	  0 as tcOrderCount,									
	  0 as ovOrderCount,									
	  0 as ovRunningOrderCount,								
	  0 as ovSalesValue,									
	  0 as ovRunningSalesTotal,								
	  0 as lagSalesGrowthIn$,								 
	  0 as lagSalesGrowthInPercent,							
	  0 as lagFreightGrowthIn$,								
	  0 as lagFreightGrowthInPercent,						
	  0 as mvSalesValue,											 
	  0 as mvAvgSales,
	  0 as mvOrderCount,
	  0 as mvAvgOrders,
	  '' as xjSaleTypeName,									 
	  '' as xjSaleStatus,
	  '' as xjGeoSaleStatus,
	  0 as xjGeoSaleStatusCount,
  	0 cteAverageCustSales$,
	 avg(orderProductQty) as  cteAvgOrderProductQty
	from
		Sales_CTE
	group by
		OrderDate
	order by
		OrderDate;

GO;
