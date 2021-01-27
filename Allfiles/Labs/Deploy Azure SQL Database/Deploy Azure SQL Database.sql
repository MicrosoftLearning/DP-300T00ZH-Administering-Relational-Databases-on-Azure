select top 10 cust.[CustomerID], cust.[CompanyName], sum(sohead.[SubTotal]) as OverallOrderSubTotal
	from [SalesLT].[Customer] cust
		inner join [SalesLT].[SalesOrderHeader] sohead
			on sohead.[CustomerID] = cust.[CustomerID]
	group by cust.[CustomerID], cust.[CompanyName]
	order by [OverallOrderSubTotal] desc



select top 10 cat.[Name] as ProductCategory, sum(detail.[OrderQty]) as OrderedQuantity
	from salesLT.[ProductCategory] cat
		inner join saleslt.[Product] prod
			on prod.[ProductCategoryID] = cat.[ProductCategoryID]
		inner join salesLT.[SalesOrderDetail] detail
			on detail.[ProductID] = prod.[ProductID]
	group by cat.[name]
	order by [OrderedQuantity] desc