--72. Kaç farklı ülkeye ihracat yapıyorum? Bu ülkeler hangileri?

SELECT DISTINCT country FROM customers;

--73. En Pahalı 5 ürün?

SELECT unit_price FROM  products 
ORDER BY unit_price DESC LIMIT 5;

--74. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı.?

SELECT count(order_id) FROM  customers c
INNER JOIN orders o ON o.customer_id=c.customer_id
WHERE  c.customer_id='ALFKI';

--75. Ürünlerimin toplam maliyeti?

SELECT SUM (unit_price*units_in_stock) AS TOPLAM_MALİYET FROM  products;
 
--76. Şirketim, şimdiye kadar ne kadar ciro yapmış.?

SELECT SUM ((unit_price*quantity)*(1-discount)) AS CIRO FROM order_details;

--77. Ortalama Ürün Fiyatım?

SELECT AVG(unit_price) AS ORTALAMA FROM products;

--78. En Pahalı Ürünün Adı?

SELECT product_name,unit_price FROM products 
ORDER BY  unit_price DESC LIMIT 1;

--79. En az kazandıran sipariş?

SELECT order_id ,((unit_price*quantity)*(1-discount)) AS Enaz FROM order_details
ORDER BY ((unit_price*quantity)*(1-discount)) ASC LIMIT 1;

--2. yol
SELECT order_id, MIN((quantity * unit_price) - discount) AS kazanc FROM order_details
GROUP BY order_id
ORDER BY kazanc ASC
LIMIT 1;

--80. Müşterilerimin içinde en uzun isimli müşteri?

SELECT length(company_name),company_name FROM customers 
GROUP BY company_name LIMIT 1;

--81. Çalışanlarımın Ad, Soyad ve Yaşları?

SELECT first_name,last_name, EXTRACT(YEAR FROM AGE(current_date, birth_date)) AS age FROM employees;

--82. Hangi üründen toplam kaç adet alınmış.?

SELECT  p.product_name AS "Ürün Adı",  SUM(od.quantity) AS "Toplam Satış Adedi" FROM products p
INNER JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_name;

--83. Hangi siparişte toplam ne kadar kazanmışım.?

SELECT order_id ,((unit_price*quantity)*(1-discount)) AS TOPLAM_KAZANC FROM order_details
ORDER BY ((unit_price*quantity)*(1-discount)) ASC;

--84. Hangi kategoride toplam kaç adet ürün bulunuyor.?

SELECT  c.category_name AS "Kategori Adı", COUNT(p.product_id) AS "Toplam Ürün Adedi" FROM categories c
INNER JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name;

--85. 1000 Adetten fazla satılan ürünler?

SELECT p.product_name,SUM(od.quantity) FROM products p 
INNER JOIN  order_details od on od.product_id=p.product_id
GROUP BY p.product_name
HAVING SUM(od.quantity)>1000;

--86. Hangi Müşterilerim hiç sipariş vermemiş.?

SELECT company_name,o.order_id FROM customers c
LEFT JOIN orders o ON c.customer_id=o.customer_id 
WHERE o.order_id IS NULL;

--87. Hangi tedarikçi hangi ürünü sağlıyor ?

SELECT DISTINCT company_name,product_name FROM suppliers s 
INNER JOIN  products p ON p.supplier_id=s.supplier_id;


--88. Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş.?

 SELECT order_id,ship_name,shipped_date FROM orders;

--89. Hangi siparişi hangi müşteri verir.?

SELECT order_id,company_name FROM orders o
INNER JOIN customers c ON c.customer_id=o.customer_id;


--90. Hangi çalışan, toplam kaç sipariş almış.?

SELECT e.employee_id,count(order_id)FROM  orders o 
INNER JOIN employees e ON e.employee_id=o.employee_id
GROUP BY e.employee_id;

--91. En fazla siparişi kim almış.?

SELECT e.employee_id,count(order_id) FROM orders o 
INNER JOIN  employees e ON e.employee_id=o.employee_id
GROUP BY e.employee_id ORDER BY  count(order_id) DESC LIMIT 1;

--92. Hangi siparişi, hangi çalışan, hangi müşteri vermiştir.?

SELECT o.order_id,o.employee_id,c.company_name FROM orders o 
INNER JOIN customers c ON c.customer_id=o.customer_id;

--93. Hangi ürün, hangi kategoride bulunmaktadır.? Bu ürünü kim tedarik etmektedir.?

SELECT p.product_name,c.category_name,s.company_name FROM products p
INNER JOIN  categories c ON c.category_id=p.category_id
INNER JOIN suppliers s ON s.supplier_id=p.supplier_id;

--94. Hangi siparişi hangi müşteri vermiş, hangi çalışan almış? Hangi tarihte,hangi kargo şirketi tarafından gönderilmiş hangi üründen kaç adet alınmış, hangi fiyattan alınmış? Ürün hangi kategorideymiş bu ürünü hangi tedarikçi sağlamış?

SELECT o.order_id,c.company_name,e.first_name,e.last_name,o.order_date,o.ship_name,p.product_id,od.quantity as" ADET",od.unit_price,ca.category_name,
su.company_name FROM orders o
INNER JOIN customers c ON c.customer_id=o.customer_id
INNER JOIN  employees e ON e.employee_id=o.employee_id
INNER JOIN order_details od ON od.order_id=o.order_id
INNER JOIN  products p ON od.product_id=p.product_id
INNER JOIN  categories ca ON ca.category_id=p.category_id
INNER JOIN suppliers su ON su.supplier_id=p.supplier_id;

--2. yol

SELECT o.order_id, o.customer_id, o.employee_id, order_date, ship_name, quantity, od.unit_price, category_id, supplier_id FROM order_details od
INNER JOIN  orders o ON od.order_id=o.order_id
INNER JOIN  products p ON od.product_id=p.product_id;


--95. Altında ürün bulunmayan kategoriler?

SELECT c.category_id, category_name, product_name FROM categories c
LEFT JOIN  products p ON c.category_id=p.category_id
WHERE p.product_id IS NULL 
ORDER BY c.category_id ASC ;

--96. Manager ünvanına sahip tüm müşterileri listeleyiniz.

SELECT contact_title FROM customers 
WHERE contact_title  LIKE '%Manager%';

--97. FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.

SELECT* FROM customers
WHERE customer_id LIKE 'FR___';
  
--98. (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.

SELECT company_name,phone FROM customers
WHERE phone LIKE '(171)%';

--99. Birimdeki Miktar alanında boxes geçen tüm ürünleri listeleyiniz.

SELECT quantity_per_unit FROM PRODUCTS 
WHERE quantity_per_unit ILIKE('%boxes%');

--100. Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)?

SELECT contact_name,country,phone FROM customers 
WHERE country IN('France' ,'Germany');

--101. En yüksek birim fiyata sahip 10 ürünü listeleyiniz.

SELECT product_id ,unit_price FROM Products 
ORDER BY unit_price DESC LIMIT 10;

--102. Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.

SELECT company_name, country,city FROM customers
ORDER BY country  ASC ,city ASC;

--103. Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.
SELECT first_name,last_name,EXTRACT(YEAR FROM AGE(current_date, birth_date)) AS age FROM employees; 

--104. 35 gün içinde sevk edilmeyen satışları listeleyiniz.

SELECT order_id FROM orders 
WHERE shipped_date-order_date>=35;

--105. Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)?

SELECT c.category_name,p.unit_price FROM products p 
INNER JOIN categories c ON c.category_id=p.category_id
WHERE unit_price = (SELECT MAX(unit_price) FROM products);

--106. Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)?

SELECT categories.category_id, category_name, product_name FROM (SELECT category_id,category_name FROM categories 
WHERE category_name LIKE '%on%') AS categories 
INNER JOIN products  ON categories.category_id = products.category_id;

--107. Konbu adlı üründen kaç adet satılmıştır?

SELECT SUM(quantity),p.product_id,p.product_name FROM products p 
INNER JOIN  order_details od ON od.product_id=p.product_id
WHERE product_name='Konbu' 
GROUP BY  p.product_id,p.product_name ;

--108. Japonyadan kaç farklı ürün tedarik edilmektedir?

SELECT  DISTINCT count(product_name),s.country FROM products p 
INNER JOIN  suppliers s ON s.supplier_id=p.supplier_id
WHERE s.country='Japan'
GROUP BY s.country;

--109. 1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücreti ne kadardır?

SELECT MAX(freight) AS "EN YÜKSEK ",MIN (freight)AS "EN DÜŞÜK",AVG(freight)AS "ORTALAMA" FROM orders 
WHERE EXTRACT(YEAR FROM order_date ) = 1997;

--110. Faks numarası olan tüm müşterileri listeleyiniz.

SELECT company_name,fax  FROM customers
WHERE fax IS NOT NULL;

--111. 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz.
 
SELECT order_id,shipped_date FROM orders 
WHERE shipped_date BETWEEN '1996-07-16' AND '1996-07-30';








