# 使用[hotel.sql](hotel.sql)定义的Hotel 关系数据库模式。
1. 为习题6.7 ～习题6.11 中的每个查询创建一个存储过程。
2. 为下面每个场景创建一个触发器：
   - 所有双人间的价格必须大千100 镑。
   - 双人间的价格必须大于最贵的单人间。
   - 在指定日期已有预订的房间不能再有预订。
   - 客人不能在重叠的日期里重复预订。
   - 维护一个审计表，记录下预订了伦敦酒店的所有客人的姓名和地址（不重复存储客人信息） 。
3. 创建一个INSTEAD OF 触发器，以实现对下列视图的数据插入：
    ```sql
    CREATE VIEW LondonHotelRoom AS
    SELECT h.hotelNo, hotelName, city, roomNo, type, price
    FROM Hotel h, Room r
    WHERE h.hotelNo = r.hotelNo AND city ='London'
    ```
4. 分析你正在使用的RDBMS, 确定它对SQL编程结构、数据库触发器和递归查询提供的支持。写下每个系统与SQL标准的差别。