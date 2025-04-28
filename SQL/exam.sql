/*
SELECT CONCAT(E.FirstName, ' ', E.LastName) as FullNmae,
	D.DepartmentName
FROM [dbo].[Employees] AS E
JOIN [dbo].[Departments] D ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'IT';

1. IT bo‘limida ishlovchi xodimlarning ismi va familiyasini chiqaring.
*/
/*
SELECT E.FirstName,
	E.HireDate
FROM [dbo].[Employees] AS E
ORDER BY E.HireDate

2. Xodimlar ro‘yxatini ishga kirgan sanasi bo‘yicha eng eski xodimdan saralang.
*/
/*
SELECT D.DepartmentName,
	COUNT(*) AS NumberEmployee
FROM [dbo].[Employees] E
JOIN [dbo].[Departments] D ON E.DepartmentID = D.DepartmentID
GROUP BY  D.DepartmentName

3. Har bir bo‘limda nechta xodim ishlayotganini ko‘rsating.
*/
/*
select e.LastName,
	d.DepartmentName
from [dbo].[Employees] e
join [dbo].[Departments] d on e.DepartmentID = d.DepartmentID

4. Har bir xodimning familiyasi va bo‘lim nomini chiqaring.
*/
/*
SELECT *
FROM [dbo].[Employees] E
WHERE E.Salary BETWEEN 50000.00 AND 60000.00

5. Maoshi 50,000 dan 60,000 gacha bo‘lgan xodimlarni ko‘rsating.
*/
/*
SELECT D.DepartmentName,
	SUM(E.Salary) AS TotalSalaryOfDepartments
FROM [dbo].[Departments] D
JOIN [dbo].[Employees] E ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName

6. Har bir bo‘lim bo‘yicha jami maosh miqdorini chiqaring.
*/
/*
SELECT TOP 2 *
FROM [dbo].[Employees] E
ORDER BY E.Salary DESC

7. Eng ko‘p maosh oladigan 2 xodimni ko‘rsating.
*/
/*
SELECT distinct S.EmployeeID
FROM [dbo].[Sales] S																????????

8. Sotuvlar jadvalidagi yagona (distinct) xodim IDlarini ko‘rsating.
*/
/*
SELECT C.CategoryName,
	P.ProductName,
	P.Price
FROM [dbo].[Categories] C
JOIN [dbo].[Products] P ON C.CategoryID = P.CategoryID
WHERE C.CategoryName = 'Electronics'


9. ‘Electronics’ kategoriyasiga tegishli mahsulotlarni nomi va narxi bilan chiqaring.
*/
/*
SELECT *
FROM [dbo].[Products] P
ORDER BY P.Price DESC

10. Mahsulotlarni narxi bo‘yicha kamayish tartibida saralang.
*/
/*
WITH CountProducts as(
SELECT E.FirstName,
	s.ProductID,
	SUM(S.Quantity) AS CountProduct
FROM [dbo].[Employees] E
JOIN [dbo].[Sales] S ON E.EmployeeID = S.EmployeeID
group by E.FirstName,s.ProductID
)
select c.FirstName,
	(p.Price * c.CountProduct) as TotalSoldPrice
from CountProducts c
join [dbo].[Products] p on c.ProductID = p.ProductID

11. Har bir xodim qancha dona mahsulot sotganini va jami miqdorini chiqaring.
*/
/*
SELECT CONCAT(E.FirstName, ' ', E.LastName) AS FullName,
	s.Quantity
FROM [dbo].[Employees] E
JOIN [dbo].[Sales] S ON E.EmployeeID = S.EmployeeID
WHERE S.Quantity > 1

12. Faqat 1 tadan ko‘p mahsulot sotgan xodimlarni ko‘rsating.
*/
/*
SELECT *
FROM [dbo].[Sales] S
WHERE YEAR(S.SaleDate) = '2023'

13. 2023-yilda bo‘lgan sotuvlarni ko‘rsating.
*/
WITH AvgProductPrice AS(
SELECT P.ProductName,
	P.Price,
	SUM(Price) OVER() AS AvgPrice
FROM [dbo].[Products] P
)
SELECT A.ProductName,
	A.AvgPrice
FROM AvgProductPrice A
GROUP BY A.ProductName
HAVING (AvgPrice / COUNT(.ProductName)) > A.Price


14. O‘rtacha narxdan yuqori bo‘lgan mahsulotlarni chiqaring.

/*
SELECT P.ProductName,
	 E.LastName,
	 D.DepartmentName,
	 S.Quantity
FROM [dbo].[Employees] E
JOIN [dbo].[Sales] S ON E.EmployeeID = S.EmployeeID
JOIN [dbo].[Departments] D ON E.DepartmentID = D.DepartmentID
JOIN [dbo].[Products] P ON S.ProductID = P.ProductID
WHERE S.Quantity > 0

15. Sotilgan mahsulot nomi, sotgan xodim familiyasi va bo‘lim nomini chiqaruvchi query yozing.
*/
/*
SELECT E.FirstName,
	 MIN(E.Salary)  over() as LowSalary,
	 MAX(E.Salary)	OVER() AS HighSalary,
	 AVG(E.Salary) OVER() AS MediumSalary
FROM [dbo].[Employees] E 


16. Xodimlarning maoshiga qarab ‘Low’, ‘Medium’, ‘High’ sifatida toifalaydigan ustun yarating.
*/
/*
SELECT *,
	NTILE(3) OVER(ORDER BY Salary ) AS SalaryGroup,
	ROW_NUMBER() OVER(PARTITION BY DepartmentID ORDER BY Salary
	) AS RowNum
FROM [dbo].[Employees] E

17. Xodimlarni maoshiga ko‘ra 3 ta guruhga bo‘ling (NTILE(3)) va har biriga Guruh raqamini bering.
*/
/*
with InfoEmployee as(
SELECT D.DepartmentID,
	e.FirstName,
	e.Salary,
	ROW_NUMBER() OVER(PARTITION BY D.DepartmentID order by Salary 
	) AS RowNum
FROM [dbo].[Departments] D
JOIN [dbo].[Employees] E ON D.DepartmentID = E.DepartmentID
)
select e.DepartmentID,
	e.FirstName,
	max(Salary) over(PARTITION BY RowNum) as maxsalary
from InfoEmployee e

18. Har bir bo‘lim ichida eng ko‘p maosh olgan xodimlarni toping (RANK() yoki ROW_NUMBER() OVER (PARTITION BY) bilan).
*/

/*
19. O‘rtacha maoshdan yuqori oladigan va mahsulot sotgan xodimlar ro‘yxatini chiqaruvchi query yozing (JOIN + AGGREGATE + SUBQUERY).
*/
/*
with HighPrice as(
select *
from [dbo].[Products] p
where p.Price > 100
),
LowPrice as(
select p.Price as narxi,
	 p.ProductName as nameProd,
	 p.ProductID as id
from [dbo].[Products] p
where p.Price < 100
)
select h.ProductName,
	count(*) as numberHighPrice
from HighPrice as h
group by h.ProductName

20. CTE yordamida mahsulotlar narxi 100 dan yuqori bo‘lsa — ‘High Price’, past bo‘lsa — ‘Low Price’ deb ajrating. Har bir kategoriya bo‘yicha nechta ‘High Price’ borligini hisoblang.
