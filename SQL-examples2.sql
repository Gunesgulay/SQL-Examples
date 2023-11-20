--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (ProductID, ProductName, CompanyName, Phone) almak için bir sorgu yazın.

SELECT p.product_id,p.product_name,s.company_name,s.phone FROM products p
INNER JOIN  suppliers s ON p.supplier_id = s.supplier_id
WHERE p.units_in_stock = 0;


--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı?

SELECT o.order_id,o.ship_address,concat(e.first_name,e.last_name) as "çalışanın adı soyadı",o.order_date FROM orders o
INNER JOIN employees e ON o.employee_id = e.employee_id
WHERE EXTRACT(YEAR FROM o.order_date ) = 1998
AND EXTRACT(MONTH FROM o.order_date) = 3;


--28. 1997 yılı şubat ayında kaç siparişim var?

SELECT count(order_id) FROM orders
WHERE EXTRACT(YEAR FROM order_date ) = 1997
AND EXTRACT(MONTH FROM order_date) = 2;


--29. London şehrinden 1998 yılında kaç siparişim var?

SELECT count(order_id) FROM orders
WHERE EXTRACT(YEAR FROM order_date ) = 1998
AND ship_city = 'London';


--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası?

SELECT distinct c.customer_id, c.contact_name,c.phone FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE EXTRACT(YEAR FROM order_date ) = 1997;

--30.1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası?

SELECT c.contact_name,c.phone FROM customers c
 INNER JOIN orders o ON c.customer_id=o.customer_id
WHERE order_date<='1997-12-31' AND order_date>='1997-01-01' 

--31.Taşıma ücreti 40 üzeri olan siparişlerim?

SELECT * FROM orders  
 WHERE freight>40

--32.Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı?

SELECT o.ship_city,c.contact_name,o.freight FROM orders o 
INNER JOIN customers c ON c.customer_id=o.customer_id
WHERE freight>=40

--33.1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf)?

SELECT o. order_date,o.ship_city, upper(concat (first_name,' ',last_name)) as fullname FROM orders o 
INNER JOIN employees e ON  o.employee_id= e.employee_id 
WHERE  order_date<='1997-12-31' AND order_date>='1997-01-01' 

--34.1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )?

SELECT distinct c.contact_name, regexp_replace(c.phone, '[^0-9]', '', 'g') FROM customers c
INNER JOIN orders o ON c.customer_id=o.customer_id 
WHERE order_date<='1997-12-31' AND order_date>='1997-01-01'

--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad?

SELECT o.order_date,c.contact_name,e.first_name,e.last_name FROM orders o 
INNER JOIN customers c ON c.customer_id=o.customer_id 
INNER JOIN employees e ON e.employee_id=o.employee_id

--36. Geciken siparişlerim?

--istenen tarih=required_date
--sevk tarihi=shipped_date
SELECT order_id,required_date ,shipped_date FROM  orders 
WHERE shipped_date>required_date

--37. Geciken siparişlerimin tarihi, müşterisinin adı?

SELECT order_date,c.contact_name,required_date ,shipped_date FROM orders o
INNER JOIN customers c ON c.customer_id=o.customer_id  
WHERE shipped_date>required_date

--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi?

SELECT od.order_id,p. product_name,c.category_name,od.quantity FROM order_details od
INNER JOIN products p ON od.product_id=p.product_id 
INNER JOIN categories c ON c.category_id=p.category_id
WHERE order_id=10248

--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı?

SELECT p.product_name,s.company_name FROM products p 
INNER JOIN  suppliers s ON s.supplier_id=p.supplier_id 
INNER JOIN order_details od ON od.product_id= p.product_id
WHERE order_id=10248

--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti?

SELECT p.product_name, od.quantity FROM orders o 
INNER JOIN order_details od ON o.order_id =od.order_id
INNER JOIN products p ON od.product_id =p.product_id
WHERE employee_id=3 AND order_date<='1997-12-31' AND order_date>='1997-01-01'

--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad?

SELECT o.order_id, e.employee_id, e.first_name, e.last_name, SUM(od.quantity*od.unit_price) Toplam FROM  orders o
INNER JOIN  order_details od ON o.order_id=od.order_id
INNER JOIN employees e ON e.employee_id=o.employee_id
WHERE order_date<='1997-12-31'and order_date>='1997-01-01' 
GROUP BY o.order_id, e.employee_id, e.first_name, e.last_name 
ORDER BY Toplam DESC limit1

--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ?

SELECT e.employee_id, e.first_name, e.last_name, SUM(od.quantity*od.unit_price) Toplam FROM orders o
INNER JOIN order_details od ON o.order_id=od.order_id
INNER JOIN  employees e ON e.employee_id=o.employee_id
WHERE order_date<='1997-12-31'and order_date>='1997-01-01' 
GROUP BY  e.employee_id, e.first_name, e.last_name 
ORDER BY  Toplam DESC  limit 1

--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?

SELECT p.product_name, p.unit_price, c.category_name FROM  products p
INNER JOIN categories c ON p.category_id=c.category_id
ORDER BY p.unit_price DESC limit 1

--44. Sıralama sipariş tarihine göre; Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID?

SELECT o.order_date,e.first_name, e.last_name, o.order_id FROM  orders o 
INNER JOIN employees e ON e.employee_id=o.employee_id
ORDER BY o.order_date DESC

--45. SON 5 siparişimin ortalama fiyatı ve order_id nedir?

SELECT o.order_id, (SELECT avg(od.quantity*od.unit_price) ortalama_fiyat FROM  order_details od
WHERE o.order_id=od.order_id GROUP BY  od.order_id) as ortalama FROM orders o
ORDER BY o.order_date DESC limit 5

--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?

SELECT p.product_name, c.category_name, sum(od.quantity*od.unit_price) as toplam FROM products p 
INNER JOIN order_details od ON od.product_id=p.product_id
INNER JOIN  categories c ON c.category_id=p.category_id
INNER JOIN orders o ON o.order_id=od.order_id
WHERE EXTRACT(month FROM o.order_date ) = 1 
GROUP BY  p.product_name, c.category_name

--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?

SELECT od.order_id, od.quantity FROM  order_details od 
WHERE  quantity > (SELECT avg(quantity) FROM order_details)
ORDER BY  od.quantity DESC

--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı?

SELECT p.product_name, c.category_name, s.company_name,od.quantity as adet FROM  products p 
INNER JOIN  order_details od ON od.product_id=p.product_id
INNER JOIN suppliers s ON s.supplier_id=p.supplier_id
INNER JOIN categories c ON c.category_id=p.category_id
GROUP BY  p.product_name, c.category_name, s.company_name, od.quantity
ORDER BY od.quantity DESC limit 1

--49. Kaç ülkeden müşterim var?

SELECT  count(distinct country) FROM  customers

--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?

SELECT SUM(od.quantity*p.unit_price) as sonuc FROM  orders o 
INNER JOIN order_details od ON od.order_id=o.order_id
INNER JOIN  products p ON p.product_id=od.product_id
INNER JOIN  employees e ON  e.employee_id=o.employee_id
WHERE o.order_date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '11 months' AND e.employee_id=3

--2.yol
 SELECT   SUM (order_details.quantity) as adet , 
 employees.first_name as adi, employees.last_name as soyadi , employees.employee_id as calisanid FROM orders
 INNER JOIN employees  ON employees.employee_id = orders.employee_id
 INNER JOIN order_details ON orders.order_id = order_details.order_id
 WHERE employees.employee_id = 3 AND  order_date >= '1998-01-01' AND order_date <= current_date --şimdiki zaman
 GROUP BY  employees.first_name , employees.last_name, employees.employee_id  


--51. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?

SEELCT od.product_id, SUM(unit_price*quantity) ciro,EXTRACT(month from order_date) ay,order_date FROM  orders o 
INNER JOIN  order_details od ON o.order_id=od.order_id
WHERE product_id = 10
GROUP BY  od.product_id,EXTRACT(month from order_date)
ORDER BY ay desc limit 3;
  

SELECT SUM(total_amount) AS ciro
FROM orders
WHERE customer_id = 10
 AND order_date >= (SELECT MAX(order_date) - INTERVAL '3 months' FROM orders WHERE order_date >= '1999-01-01');

--52. Hangi çalışan şimdiye kadar toplam kaç sipariş almış.?

SELECT  employee_id,count(order_id) FROM orders
GROUP BY  employee_id;

--53. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun?

SELECT  c.company_name,o.order_id FROM  customers c 
LEFT JOIN  orders o ON c.customer_id=o.customer_id
WHERE order_id is NULL ;

--54. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri?

SELECT company_name,contact_name,address,city,country FROM  customers
WHERE  country='Brazil';

--55. Brezilya’da olmayan müşteriler?

SELECT company_name,contact_name,address,city,country FROM  customers
WHERE country<>'Brazil';

--56. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler?

SELECT company_name,contact_name,address,city,country FROM  customers
WHERE country IN ('Spain','France','Germany');


--57. Faks numarasını bilmediğim müşteriler?

SELECT company_name,contact_name,address,city,country,fax FROM  customers
WHERE fax IS NULL;


--58. Londra’da ya da Paris’de bulunan müşterilerim?

SELECT company_name,contact_name,address,city FROM  customers
WHERE city IN ('London','Paris');

--59. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler?

SEELCT company_name,contact_name,contact_title FROM customers
WHERE city= 'México D.F.' AND contact_title='Owner';


--60. C ile başlayan ürünlerimin isimleri ve fiyatları?

SELECT product_name,unit_price FROM products
WHERE product_name ILIKE 'c%';

--61. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri?

SELECT first_name,last_name,birth_date FROM employees
WHERE first_name ILIKE 'a%';

--62. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları?

SELECT company_name FROM  customers
WHERE company_name ILIKE '%restaurant%';

--63. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları?

SELECT product_name, unit_price FROM products
WHERE unit_price BETWEEN 50 AND 100;

--64. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders),SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri?

SELECT order_id, order_date FROM orders 
WHERE order_date BETWEEN '01-07-1996' AND '31-12-1996';

--65. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler?

SELECT company_name,contact_name,address,city,country FROM customers
WHERE country IN ('Spain','France','Germany');

--66. Faks numarasını bilmediğim müşteriler?

SELECT company_name,contact_name,address,city,country,fax FROM  customers
WHERE fax IS NULL;

--67Müşterilerimi ülkeye göre sıralıyorum.

SELECT company_name, country FROM customers
ORDER BY country;

--68. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz?

SELECT product_name, unit_price FROM products
ORDER BY unit_price DESC;

--69. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz.

SELECT product_name, unit_price, units_in_stock FROM products
ORDER BY units_in_stock ASC, unit_price DESC;

--70. 1 Numaralı kategoride kaç ürün vardır.?

SELECT COUNT(product_id), category_id FROM products
WHERE category_id=1 GROUP BY category_id ;

--71. Kaç farklı ülkeye ihracat yapıyorum.?

SELECT COUNT(DISTINCT country) FROM customers;


















