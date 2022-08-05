/*
--Q1
Select a.FullName, a.FaxNumber, a.PhoneNumber, p.FaxNumber Company_Fax, p.PhoneNumber Company_Phone
from Application.people a
LEFT JOIN Purchasing.Suppliers p
ON a.PersonID = p.PrimaryContactPersonID
WHERE a.FaxNumber IS NOT NULL

--Q2
select s.CustomerName
From Sales.Customers s
JOIN Application.People a
ON s.PrimaryContactPersonID = a.PersonID
WHERE s.PhoneNumber = a.PhoneNumber


--Q3
Select c.CustomerID, c.CustomerName
FROM Sales.Customers c
JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderDate < '2016-01-01'


--Q4
select w.StockItemID, w.StockItemName, p.OrderDate, SUM(w.QuantityPerOuter) Total_Quantity
from Warehouse.StockItems w
JOIN Purchasing.PurchaseOrders p
ON w.SupplierID = p.SupplierID
WHERE LEFT(p.OrderDate,4) = '2013'
GROUP BY w.StockItemID, w.StockItemName, p.OrderDate;


--Q5
select StockItemID, StockItemName, Len(MarketingComments) as length_cha
from Warehouse.StockItems 
where Len(MarketingComments) > 10;


--Q6 xxxxx





select w.StockItemID, w.StockItemName, i.InvoiceDate, c.DeliveryCityID
from sales.Invoices i
JOIN sales.Customers c
ON i.CustomerID = c.CustomerID
JOIN Application.Cities a
ON a.CityID = c.DeliveryCityID
JOIN Warehouse.StockItemTransactions s
ON i.InvoiceID = s.InvoiceID
JOIN Warehouse.StockItems w
ON w.StockItemID = s.StockItemID
where datepart(year,i.InvoiceDate) = '2014'


-- Q7
select o.OrderDate order_date, LEFT(i.ConfirmedDeliveryTime,10) confirmed_delivery, s.StateProvinceName, DATEDIFF(day,o.OrderDate,i.ConfirmedDeliveryTime) dates_for_processing
from sales.Invoices i
JOIN Sales.Orders o
ON i.OrderID = o.OrderID
JOIN Sales.Customers c
On i.CustomerID = c.CustomerID
JOIN Application.Cities a
ON a.CityID = c.DeliveryCityID
JOIN Application.StateProvinces s
ON s.StateProvinceID = a.StateProvinceID


-- Q8
select o.OrderDate order_date, LEFT(i.ConfirmedDeliveryTime,10) confirmed_delivery, s.StateProvinceName, DATEDIFF(month,o.OrderDate,i.ConfirmedDeliveryTime) dates_for_processing
from sales.Invoices i
JOIN Sales.Orders o
ON i.OrderID = o.OrderID
JOIN Sales.Customers c
On i.CustomerID = c.CustomerID
JOIN Application.Cities a
ON a.CityID = c.DeliveryCityID
JOIN Application.StateProvinces s
ON s.StateProvinceID = a.StateProvinceID



-- Q9
select a.StateProvinceName, p.SupplierID, p.TransactionDate
from Purchasing.SupplierTransactions p
join Purchasing.Suppliers s
ON p.SupplierID = s.SupplierID
join Application.Cities c
ON s.PostalCityID = c.CityID
join Application.StateProvinces a
ON a.StateProvinceID = c.StateProvinceID
GROUP BY a.StateProvinceName, p.SupplierID, p.PurchaseOrderID, p.TransactionDate
Having SUM(p.TransactionAmount) < 0 and DATEPART(year,p.TransactionDate) = '2015'



-- Q10
select c.CustomerID, c.CustomerName, c.PhoneNumber, p.FullName Primary_Contact,s.StockItemID, t.Quantity, s.StockItemName
from Warehouse.StockItemTransactions t
join Warehouse.StockItems s
on t.StockItemID = s.StockItemID
join Sales.Customers c
on c.CustomerID = t.CustomerID
join Application.People p
on p.PersonID = c.PrimaryContactPersonID
where datepart(year,TransactionOccurredWhen) = '2016' and abs(t.Quantity) < 10 and s.StockItemName like '%mug%'


-- Q11
??????



-- Q12
select o.OrderDate,StockItemName, i.DeliveryInstructions, p.StateProvinceName, c.CityName, r.CountryName, b.CustomerName, x.FullName, b.PhoneNumber, s.Quantity
from Sales.Orders o
join Sales.Invoices i
on o.OrderID = i.OrderID
join Warehouse.StockItemTransactions s
on s.InvoiceID = i.InvoiceID
join Warehouse.StockItems w
on w.StockItemID = s.StockItemID
join Sales.Customers b
on b.CustomerID = o.CustomerID
join Application.Cities c
on c.CityID = b.DeliveryCityID
join Application.StateProvinces p
on p.StateProvinceID = c.StateProvinceID
join Application.Countries r
on r.CountryID = p.CountryID
join Application.People x
on x.PersonID = b.PrimaryContactPersonID
Where o.OrderDate = '2014-07-01'



-- Q13
select StockGroupName, StockItemID, SUM(qty_purchased) total_purchased, SUM(qty_sold) total_sold, (SUM(qty_purchased) - SUM(qty_sold)) as remaining_qty
from
(select w.StockGroupName, s.StockItemID, case when s.Quantity > 0 then SUM(s.Quantity) else 0 end as qty_sold, case when s.Quantity < 0 then SUM(abs(s.Quantity)) else 0 end as qty_purchased
from Warehouse.StockItemTransactions s
join Warehouse.StockItemStockGroups g
on g.StockItemID = s.StockItemID
join Warehouse.StockGroups w
on w.StockGroupID = g.StockGroupID
group by w.StockGroupName, s.StockItemID, s.Quantity) as transactions
group by StockItemID, StockGroupName
order by StockItemID



-- Q14
select a.CityName, x.StockItemName, case when count(i.invoiceID) > 0 then count(i.invoiceID) else 'No Sales' end as deliveries
from Sales.Customers c
join Application.Cities a
on c.DeliveryCityID = a.CityID
join Sales.Invoices i
on i.CustomerID = c.CustomerID
join Warehouse.StockItemTransactions s
on s.InvoiceID = i.InvoiceID
join Warehouse.StockItems x
on s.StockItemID = x.StockItemID
where datepart(year, i.ConfirmedDeliveryTime) = 2016
group by a.CityName, x.StockItemName
order by count(i.invoiceID) desc



-- Q15
????



-- Q16
select StockItemID, StockItemName, CustomFields
from Warehouse.StockItems
where CustomFields like '%China%'



-- Q17
select SUBSTRING(s.CustomFields, 28, 5) CountryOfManufacturing, count(s.StockItemID) TotalQuantity
from Warehouse.StockItems s
join Warehouse.StockItemTransactions t
on s.StockItemID = t.StockItemID
where DATEPART(year, t.TransactionOccurredWhen) = '2015'
group by SUBSTRING(s.CustomFields, 28, 5)



-- Q18
create view TotalQuantitySoldinGroup
as
select g.StockGroupName, datepart(year, t.TransactionOccurredWhen) Transaction_Year, SUM(t.Quantity) TotalQuantity
from Warehouse.StockItemTransactions t
join Warehouse.StockItemStockGroups s
on t.StockItemID = s.StockItemID
join Warehouse.StockGroups g
on g.StockGroupID = s.StockGroupID
where Quantity > 0
group by g.StockGroupName, datepart(year, t.TransactionOccurredWhen)


*/

-- Q19
select datepart(year, t.TransactionOccurredWhen) Transaction_Year, g.StockGroupName, SUM(t.Quantity) TotalQuantity
from Warehouse.StockItemTransactions t
join Warehouse.StockItemStockGroups s
on t.StockItemID = s.StockItemID
join Warehouse.StockGroups g
on g.StockGroupID = s.StockGroupID
where Quantity > 0
group by g.StockGroupName, datepart(year, t.TransactionOccurredWhen)