# 案例一：使用[hotel.sql](hotel.sql)定义的Hotel 关系数据库模式。
1. 使用SQL的完整性增强特性创建表Hotel。
2. 使用SQL的完整性增强特性和下面的约束条件创建表Room、Booking和Guest。
   - 类型必须为Single 、Double 和Family 中的一类。
   - 价格必须在10英镑到100英镑之间。
   - roomNo必须在1到100之间。
   - dateFrom和dateTo必须大于今天的日期。
   - 相同房间不能预订两次。
   - 相同客人不能重复预订。
3. 创建另一个和表Booking具有相同结构的表，用千保存归档记录。用INSERT语句将表Booking中2013年1月1日之前登记的记录复制到归档记录表中。从表Booking中将2013年1月1日之前所有登记删除。
4. 创建一个视图，包括酒店名字和居住在酒店中的客人名字。
5. 创建一个视图，包括格罗夫纳酒店的每个客人的账户。
6. 给用户Manager和Director访问视图的所有权限，并允许他们继续把这些权限传递给其他用户。
7. 给用户Accounts访问视图的SELECT权限，然后取消该用户的这个权限。
8. 思考下列基于Hotel 模式的视图：
    ````sql
    CREATE VIEW HotelBookingCount (hotelNo, bookingCount)
    AS SELECT h.hotelNo, COUNT(*)
    FROM Hotel h, Room r, Booking b
    WHERE h.hotelNo = r.hotelNo AND r.roomNo = b.roomNo
    GROUP BY h.hotelNo:
    ````
    对于下面每一个查询，陈述该查询是否有效，且对于有效查询说明该查询如何映射为对基表的查询。
    1. SELECT * FROM HotelBookingCount;
    2. SELECT hotelNo FROM HotelBookingCount WHERE hotel No ='H001';
    3. SELECT MIN(bookingCount) FROM HotelBookingCount;
    4. SELECT COUNT(*) FROM HotelBookingCount;
    5. SELECT hotel No FROM HotelBookingCount WHERE bookingCount > 1000;
    6. SELECT hotel No FROM HotelBookingCount ORDER BY bookingCount;
9. 假设还有一个供应商表
    ```sql
        Supplier (supplierNo. partNo. price)
    ```
    以及视图SupplierParts, 该视图包括至少一个供应商提供的各种零件号：
    ```sql
    CREATE VIEW SupplierParts (partNo)
    AS SELECT DISTINCT partNo
    FROM Supplier s, Part p
    WHERE s.partNo = p.partNo;
    ```
    讨论如何将其维护为物化视图，且在何种条件下不用访问基表Part 和Supplier 就可完成视图维护。
10. 调查你现在正在使用的DBMS 中的SQL 实现。讨论该系统的DDL 语句与ISO 标准是否兼容。调查该DBMS 扩展的任一功能。是否有不被支持的功能？
11. 创建4 . 2.6 节定义的DreamHome 数据库模式，将图4 . 3 中的元组插人其中。
12. 使用上面创建的模式，运行第6 章诸例子中给出的SQL 查询。
13. 为第4 章习题给出的Hotel 模型创建模式，插人一些样本元组。然后运行习题6 . 7 ～习题6.28产生的SQL 查询。
# 案例2：使用笫5 章后面的习题定义的项目（ Project) 模式。
14. 使用SQL 的完整性增强特性和下面的约束条件创建Project 模式
    - 性别必须是单个字母“ M" 或“F” 。
    - 职位必须是“经理”、“团队负责人”、“分析师”和“软件开发人员”之一。
    - 工时必须是0 到40 之间的一个整数。
15. 创建一个视图，由Employee 和Department 构成，但不包括address 、DOB 和sex 属性。
16. 创建一个由属性empNo 、tName 、IName 、projName 和hoursWorked 构成的视图。
17. 思考下列基于Project 模式的视图：
    ```sql
    CREATE VIEW EmpProject(empNo, projNo, totalHours)
    AS SELECT w.empNo, w.projNo, SUM(hoursWorked)
    FROM Employee e, Project p, Wo 欢sOnw
    WHERE e.empNo = w.empNo AND p.projNo = w.projNo
    GROUP BY w.empNo, w.projNo;
    ```
    对于下面每一个查询，陈述该查询是否有效，且对于有效查询说明该查询如何映射为对基表的查询。
    - SELECT * FROM EmpProject;
    - SELECT projNo FROM EmpProject WHERE projNo ='SCCS';
    - SELECT COUNT(pro」No) FROM EmpProject WHERE empNo = 'E1'
    - SELECT empNo, totalHours FROM EmpProject GROUP BY empNo;
# 综合
18. 考虑下表：
    ```sql
    Part (QfillliQ, ~. partCost)
    ```
    它代表着同一零件在每个合同下的协议价格（一个零件在不同的合同下可能有不同的价格） 。现在考虑下列视图ExpensiveParts, 它包括价格超过1000 英镑的零件数目：
    ```sql
    CREATE VIEW Expensive Parts (partNo) AS SELECT DISTINCT partNo 
    FROM Part 
    WHERE partCost > 1000;
    ```
    讨论如何将其维护为物化视图，且在何种条件下不用访问基表Part 即可完成视图的维护。