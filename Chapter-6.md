# 案例一：使用[hotel.sql](hotel.sql)定义的Hotel 关系数据库模式。
## 简单查询
1. 列出所有酒店的情况。  
   `SELECT * FROM Hotel;`
2. 列出伦敦所有酒店的情况。  
   `SELECT * FROM Hotel WHERE city='London';`
3. 列出住在伦敦的所有客人的姓名和地址，按字母表顺序排序。  
   `SELECT guest_name,guest_address FROM Guest WHERE guest_address LIKE %London% ORDER BY guest_name,guest_address;` 
4. 列出每晚房价在40英镑以下的所有双人间或套间，按价格升序排序。  
   `SELECT * FROM Room WHERE price <= 40 && (type == 'single room' OR type == 'suite') ORDER BY price;`
5. 列出没有指定dateTo的预订情况。  
   `SELECT * FROM Booking WHERE date_to IS NULL;`
## 聚集函数
6. 有多少酒店？  
   `SELECT COUNT(*) AS Hotels FROM Hotel;`
7. 房间的平均价格是多少？  
   `SELECT AVG(price) FROM Room;`
8. 所有双人间每晚的总收人是多少？  
   `SELECT SUM(price) FROM Room WHERE type == 'double';`
9.  八月份有多少不同的客人订房？  
    `SELECT COUNT(DINSTINCT guest_no) FROM Booking WHERE date_from >= '01-Aug-2021';`
## 子查询和连接操作
10. 列出格罗夫纳酒店所有房间的价格和类型。  
    `SELECT price,type FROM Room r WHERE hotel_no == (SELECT hotel_no FROM Hotel WHERE hotel_name == 'Grosvenor');`
11. 列出当前住在格罗夫纳酒店的所有客人的情况。  
    `SELECT * FROM Guest WHERE guest_no IN (SELECT DINSTINCT b.guest_no FROM Booking JOIN Hotel h USING hotel_no WHERE h.hotel_name == 'Grosvenor');`
12. 列出格罗夫纳酒店所有房间的情况，包括房间中住的客人的名字。
    `SELECT r.room_no,r.hotel_no,r.type,r.price,bg.guest_no,bg.guest_name,bg.date_from,bg.date_to FROM Room r LEFT JOIN (Booking JOIN Guest USING guest_no AS bg) ON r.hotel_no == bg.hotel_no AND r.room_no = bg.room_no WHERE r.hotel_no == (SELECT hotel_no FROM Hotel WHERE hotel_name == 'Grosvenor');`
13. 今天格罗夫纳酒店订房的总收入是多少？    
    `SELECT SUM(r.price * (b.date_to - b.date_from)) FROM Booking b JOIN Room r USING hotel_no,room_no WHERE b.hotel_no == (SELECT hotel_no FROM Hotel WHERE hotel_name == 'Grosvenor') AND b.date_from == (SELECT MAX(date_from) FROM Booking);`
14. 列出格罗夫纳酒店当前没被使用的房间。    
    `SELECT * FROM Room WHERE room_no NOT IN (SELECT room_no FROM Booking WHERE date_to >= (SELECT MAX(date_from) FROM Booking) AND hotel_no == (SELECT hotel_no FROM Hotel WHERE hotel_name == 'Grosvenor'));`
15. 格罗夫纳酒店空房损失是多少？  
    $空房损失=\sum每日空房损失 = \sum空闲房间*单价 = \sum每个房间空房损失,由于未知空闲房间历史单价及计算的时间起点，先假设计算今日空房损失$   
    `SELECT SUM(price) FROM Room WHERE Room_no NOT IN (SELECT room_no FROM Booking WHERE date_to >= (SELECT MAX(date_from) FROM Booking) AND hotel_no == (SELECT hotel_no FROM Hotel WHERE hotel_name == 'Grosvenor'));`  
    若假设房间单价从未发生变化，且从最小的date_from作为起点算起计算历史总空房损失，则总收入为  
    `SELECT SUM(b.price * (b.date_to - b.date_from)) FROM Booking b JOIN Room r USING hotel_no,room_no WHERE hotel_no == (SELECT hotel_no FROM Hotel WHERE hotel_name == 'Grosvenor');`  
    最大预期收入为
    `SELECT SUM(r.price) FROM Room r WHERE hotel_no == (SELECT hotel_no FROM Hotel WHERE hotel_name == 'Grosvenor')`  
    则空房损失为  
    `SELECT (is - ms) AS loss FROM (SELECT SUM(b.price * (b.date_to - b.date_from)) FROM Booking b JOIN Room r USING hotel_no,room_no WHERE hotel_no == (SELECT hotel_no FROM Hotel WHERE hotel_name == 'Grosvenor')) AS is,(SELECT SUM(r.price) FROM Room r WHERE hotel_no == (SELECT hotel_no FROM Hotel WHERE hotel_name == 'Grosvenor')) AS ms;`  
## 分组
16. 列出每个酒店的房间数量。
    `SELECT COUNT(*) FROM Room GROUP BY hotel_name;`
17. 列出伦敦每个酒店的房间数量。
    `SELECT COUNT(*) FROM Room JOIN Hotel USING hotel_no WHERE city == 'London' GROUP BY hotel_name;`
18. 八月份每个酒店平均订房数是多少？
    `SELECT AVG(*) FROM Booking WHERE date_from BETWEEN 2021-08-01 AND 2021-08-31 GROUP BY hotel_no;`
19. 伦敦每个酒店最常订的房间类型是什么？
    最常订定义为非空房时间占总时间比例最大
    `SELECT MAX(m.t),m.tp,m.hotel_no FROM (SELECT SUM(br.date_to - br.date_from) AS t,br.type AS tp,hotel_no FROM (Booking JOIN Room USING hotel_no,room_no) AS br JOIN Hotel h USING hotel_no WHERE h.city == 'London' GROUP BY h.hotel_no,br.type) AS m GROUP BY hotel_no;`
20. 今天每个酒店空房损失是多少？
    `SELECT SUM(price) FROM Room WHERE Room_no NOT IN (SELECT room_no FROM Booking WHERE date_to >= (SELECT MAX(date_from) FROM Booking) GROUP BY hotel_no;`
## 修改表
21. 向每一个表中插入一行。
    Hotel:`INSERT INTO Hotel(hotel_name,city) VALUES ('lover','London');`
    Guest:`INSERT INTO Guest(guest_name,guest_address) VALUES ('Jack','780,15th St,London');`
    Room:`INSERT INTO Room(hotel_no,type,price) VALUES (1,'single',30);`
    Booking:`INSERT INTO Booking VALUES (1,1,'2021-08-01','2021-08-02',1);`
22. 所有房间的价格提高5%。
    `Update Room SET price = price*1.05;`
## 综合
22. 研究当前使用的各种DBMS中的SQL方言。查看系统是否符合ISO标准中的DML语句。研究DBMS的扩展功能。是否有SQL标准中不支持的功能？
23. 说明任何用HAVING子句的查询语句都存在一个等价的不用HAVING子句的查询语句。
24. 说明SQL是具有关系完整性的查询语言。
# 案例2：使用笫5章后面的习题定义的项目(Project)模式。
25. 按姓氏字典序列出所有雇员的姓名。
26. 列出所有女雇员的情况。
27. 列出所有担任经理的雇员的名字和地址。
28. 产生所有为IT部门工作的雇员的名字和地址表。
29. 产生今年内退休的所有经理的全部情况表，并按姓氏字典序排列。
30. 找出有多少雇员由James Adams管理。
31. 产生每位雇员工作总时数的报表，按部门编号排序，同一部门内按雇员的姓氏字典序排列。
32. 找出多千两位雇员参与工作的项目，列出项目编号、项目名称和参与该项目的雇员人数。
33. 列出雇员数多于10人的那些部门的雇员总数，为结果关系各列创建合适的列名。
# 案例3：使用第5章后面的习题定义的图书馆(Library) 模式。
34. 列出所有书目。
35. 列出所有读者的情况。
36. 列出所有2012年出版的书目。
37. 列出所有书目可外借的副本。
38. 列出《指环王》所有可外借的副本。
39. 列出目前正借阅《指环王》的读者的姓名。
40. 列出有逾期未还图书的读者的姓名。
41. ISBN 为'0-321-52306-7'的书有多少本？
42. ISBN 为'0-321-52306-7'的书还有多少本可外借？
43. ISBN 为'0-321-52306-7'的书目借出过多少次？
44. 产生由Peter Bloomfield借阅的图书的书目表。
45. 对馆藏多于三个副本的书目，列出借阅过它的读者的姓名。
46. 产生当前借有图书逾期未还的读者的情况报表。
47. 产生每个书目被借阅总次数的报表。