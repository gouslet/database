以下列表是存在某RDBMS中的数据库的一部分：  
    Hotel (<u>hotelNo</u>,hotelName,city)  
    Room(<u>roomNo</u>,<u>hotelNo</u>,type, price)  
    Booking (<u>hotelNo</u>,<u>guestNo</u>,<u>dateFrom</u>,dateTo, roomNo)  
    Guest (<u>guestNo</u>,guestName, guestAddress)

其中
- Hotel中包含酒店的详细资料，hotelNo是主关键字；
- Room 中包含每个旅馆的房间信息，(roomNo, hotelNo)组成主关键字；
- Booking 中包含各种预订资料，(hotelNo, guestNo, dateFrom) 组成主关键字；
- Guest中包含客人的详细资料，guestNo是主关键字。

问题  
1. 指出这个模式中所有的外部关键字。说明在这些关系中如何运用实体完整性规则和引用完整性规则。  
    - 外部关键字有：
      - Room:hotelNo
      - Booking:hotelNo,guestNo,roomNo  
    - 为满足实体完整性，则Hotel关系的hotelNo关键字、Room关系的roomNo关键字和hotelNo关键字、Booking关系的hotel关键字、guestNo关键字和dateFrom关键字和Guest关系的guestNo关键字不得为空
    - 为满足引用完整性，则Room关系的元组中hotelNo关键字的值应当与Hotel关系的某个元组中hotelNo关键字的值相同，Booking关系的元组中hotelNo关键字的值应当与Hotel关系的某个元组中hotelNo关键字的值相同，Guest关系的元组中guestNo关键字的值应当与Guest关系的某个元组中guestNo关键字的值相同
2. 为这些关系写出一些遵守关系完整性规则的实例表。为这个模式制定一些适当的一般性约束。
- Hotel关系  
  
    |hotelNo|hotelName|
    |---|---|
    |0|A|
    |1|B|
    |2|S|
    |3|E|
    可增加一般性约束：hotelNo值小于100等

- Room关系  
  
    |roomNo|hotelNo|type|price|
    |---|---|---|---|
    |301|0|标准房|500|
    |302|0|大床房|600|
    |303|2|标准房|700|
    |304|1|总统套房|10000|
    可增加一般性约束：roomNo值大于300等
- Guest关系  
  
    |guestNo|guestName|guestAddress|
    |---|---|---|
    |0|Jack|"asdsfgdhgfh"|
    |1|刘洪|"dsfdgfss"|
    |2|yamota|"sfdgfhhhhhhhh"|
    |3|S.Dois|"00000"|
    可增加一般性约束：guestAddress值非空等
- Booking关系  
  
    |hotelNo|guestNo|dateFrom|dateTo|roomNo|
    |---|---|---|---|---|
    |0|0|2021-06-15|2021-06-16|301|
    |1|3|2021-06-21|2021-06-25|302|
    |2|1|2021-07-02|2021-08-02|303|
    |3|2|2020-07-15|2021-07-15|304|

    可增加一般性约束：dateTo值大于dateFrom等
3. 分析你当前使用的RDBMS。确定系统提供了哪些对主关键字、候选关键字、外部关键字、关系完整性以及视图的支持。  
目前使用MySql，
    # 主关键字  
    ## 主键的分类
    ### 单一主键
    ```sql
    create table if not exists user(

    id int(11) auto_increment primary key,

    name char(64) not null default 'No Name'

    );
    ```
    id 就是单一的主键，需要注意，定义字段时声明主键是无法创建复合主键的。
    ### 复合主键
    ```sql
    create table if not exists user(

    id int(11) auto_increment,

    name char(64) not null default 'No Name',

    primary key(id,name)

    );
    ```
    允许创建单一主键也允许创建复合主键，推荐使用这种方法进行主键的创建。
    ### 联合主键
    当处理多对多的关系时，需要创建中间表来进行多对多的关联，此时中间表的主键成为联合主键，它能唯一的确定多对多的若干实体间的对应关系。联合主键也可以是复合主键即联合主键由第三表的多个列复合而成。
    ## 在使用主键的时候需要注意以下几个点：
    - 一个表只能定义一个主键；
    - 主键值必须唯一标识表中的每一行，并且不能出现null的情况，即表中不能存在有相同主键的两行或两行以上数据，严格遵守唯一性原则；
    - 一个字段名只能在联合主键字段表中出现一次；
    - 联合主键不能包含不必要的多余字段，以满足最小化原则。
    ## 增加主键
      - 在字段中定义主键
        - 语法格式：<字段名> <数据类型> PRIMARY KEY [默认值]
        - 示例
            ```sql
            create table if not exists user(

            id int(11) auto_increment primary key,

            name char(64) not null default 'No Name'

            );
            ```
      - 字段定义结束后定义主键
        - 语法格式：[CONSTRAINT <约束名>] PRIMARY KEY [字段名]
        - 示例
            ```sql
            create table if not exists user(

            id int(11) auto_increment,

            name char(64) not null default 'No Name',

            primary key(id,name)

            );
            ```
      - 或者在创建表结束后，通过`alter table tb_name add primary key(key_name)`来增加主键，其中
        - tb_name 表名
        - primary key() 括号里填写字段名,可以是一个，也可以是多个(复合主键)
    ## 删除主键
      - 如果主键字段中包含有自增 auto_increment，需要先删除自增属性，再删除主键
        - 删除自增类型。 ！！！注意 自增是类型，所以可以使用修改字段的类型
        - 修改字段的名，修改后需要重新指定类型
            `alter table tb_name change col_name col_name int`
        - 简单的直接修改类型
            `alter table tb_name modify col_name int`
        - 删除掉 auto_increment属性后可以删除主键
            `alter table tb_name drop primary key`
      - 如果没有自增直接删除主键即可
    ## 更新主键
    如果要更新主键，需要先将表中原来的主键drop掉，在重新添加主键约束。 

    # 候选关键字
    MySQL对候选关键字没有特殊支持，主要由创建者自主选择某个候选关键字作为主关键字
    # 外部关键字
    ## 定义外键时需要遵守以下规则：
    - 主表必须已经存在于数据库中，或者是当前正在创建的表。如果是后一种情况，则主表与从表是同一个表，这样的表称做自参照表，这种结构称做自参照完整性；
    - 必须为主表定义主键；
    - 主键不能包含空值，但允许在外键中出现空值；
    - 在主表的表名后面指定列名或列名的组合，这个列或列的组合必须是主表的主键或候选键；
    - 外键中列的数目必须和主表的主键中列的数目相同；
    - 外键中列的数据类型必须和主表主键中对应列的数据类型相同。
    ## 在创建表时设置外键约束
    在建表语句中，可以加入关键字FOREIGN KEY来指定外键，用REFERENCES来连接与主表的关系
    - 语法格式：
    CONSTRAINT <约束名>
    FOREIGN KEY <外键名>(字段名1，字段名2...)
    REFERENCES <主表名>(主键字段名)
    - 示例
    创建tb_1数据表，并在表上创建外键约束，使其中course_id作为外键关联到表st_info5的主键st_id：
        ```sql
        create table tb_1(
            course_id int(8) not null auto_increment,
            course_name varchar(25) not null,
            constraint course_Choosing
            foreign key fk_course(course_id)
            references st_info5(st_id)
        ) auto_increment=20015001;
        ```
        上面语句执行成功之后，在表tb_1中添加了course_Choosing的约束名称，以及外键名称为fk_course的course_id字段，依赖于表st_info5的主键st_id。
    ## 在修改表时添加外键约束
    同样的可以在创建表之后再修改，SQL语句如下：
    ```sql
    alter table tb_1 
    add 
    constraint course_Choosing
    foreign key fk_course(course_id)
    references st_info5(st_id);
    ```
    这里需要注意的是，从表的外键关联的必须是主表的主键，且主键和外键的数据类型必须一致。例如两者都是int型或者都是char型数据。
    ## 删除外键约束
    当一个表中不需要外键约束时，就需要从表中将其删除。外键一旦删除，就会解除主表和从表间的关联关系。
    删除的语法格式：
    ALTER TABLE <表名> 
    DROP 
    FOREIGN KEY <外键约束名>;
    - 示例
        ```sql
        alter table tb_1
        drop
        foreign key fk_course;
        ```
    # 关系完整性
    ## 实体完整形
    实体完整性是指在基本关系中，主关键宇的属性不能为空。
    MySQL中Not null和default可用来保证实体完整性
    - not null是非空的约束，也就是不能向表里插入空值，在主键中添加not null约束即可
    - default是在不给字段输入值时，默认返回的结果，将其用在主键上即可
    ## 引用完整性
    引用完整性是指，如果在关系中存在某个外部关键字，则它的值或与主关系中某个元组的候选关键字取值相等，或者全为空。
    - MySQL中添加外键时，从表的外键关联的必须是主表的主键，从表的主键不能包含空值，但允许在外键中出现空值，这保证了从表外键的值或与主表中某个元组的候选关键字取值相等，或者为空，即保证了引用完整性
    ## 一般性约束
    - 一般性约束是由数据库用户或数据库管理员所指定的附加规则
    - MySQL中check约束用来保证某一列的数值满足某种特定的条件，它的用途主要有以下几种：
      - 检查最大最小值，比如订单数量不能为0
      - 指定范围：比如发货日期必须大于等于今天的日期并且不超过明年的这个时候
      - 只允许特定的值，比如性别列中只允许填写"M" or "F"
    ### 创建check约束：
    - 第一种方法
        ```sql
        create table OrderItem(
        order_num int not null,
        order_item int not null,
        quantity int not null check (quantity > 0)
        );
        ```
    - 第二种方法
        ```sql 
        add constraint check (gender in ['M','F']);
        ```
    # 视图
    ## 创建视图
    - 语法格式：
    CREATE VIEW <视图名> AS <SELECT语句>
    - 说明
      - <视图名>：指定视图的名称。该名称在数据库中必须是唯一的，不能与其他表或视图同名。
      - <SELECT语句>：指定创建视图的 SELECT 语句，可用于查询多个基础表或源视图。
    - 对于创建视图中的 SELECT 语句的指定存在以下限制：
      - 用户除了拥有 CREATE VIEW 权限外，还具有操作中涉及的基础表和其他视图的相关权限。
      - SELECT 语句不能引用系统或用户变量。
      - SELECT 语句不能包含 FROM 子句中的子查询。
      - SELECT 语句不能引用预处理语句参数。
    - 注意
    - 视图定义中引用的表或视图必须存在。但是，创建完视图后，可以删除定义引用的表或视图。可使用 CHECK TABLE 语句检查视图定义是否存在这类问题。
    - 视图定义中允许使用 ORDER BY 语句，但是若从特定视图进行选择，而该视图使用了自己的 ORDER BY 语句，则视图定义中的 ORDER BY 将被忽略。
    - 视图定义中不能引用 TEMPORARY 表（临时表），不能创建 TEMPORARY 视图。
    - WITH CHECK OPTION 的意思是，修改视图时，检查插入的数据是否符合 WHERE 设置的条件。
    ## 查看视图
    ### 查看视图的字段信息
    - 查看视图的字段信息与查看数据表的字段信息一样，都是使用 DESCRIBE 关键字来查看的。具体语法如下：  
    DESCRIBE 视图名；
    - 视图用于查询主要应用在以下几个方面：
      - 使用视图重新格式化检索出的数据。
      - 使用视图简化复杂的表连接。
      - 使用视图过滤数据。
    - DESCRIBE 一般情况下可以简写成 DESC，输入这个命令的执行结果和输入 DESCRIBE 是一样的。
    ### 查看视图的详细信息
    - 在 MySQL 中，SHOW CREATE VIEW 语句可以查看视图的详细定义。其语法如下所示：  
    SHOW CREATE VIEW 视图名;
      - 该语句需要以\G结尾，这样能使显示结果格式化。如果不使用\G，显示的结果会比较混乱，
    - 所有视图的定义都是存储在 information_schema 数据库下的 views 表中，也可以在这个表中查看所有视图的详细信息，SQL 语句如下：  
    SELECT * FROM information_schema.views; 
    ## 修改视图
    - 修改视图是指修改 MySQL 数据库中存在的视图，当基本表的某些字段发生变化时，可以通过修改视图来保持与基本表的一致性。
    - 可以使用 ALTER VIEW 语句来对已有的视图进行修改。
      - 语法格式如下：  
        ALTER VIEW <视图名> AS <SELECT语句>
      - 语法说明如下：  
        - <视图名>：指定视图的名称。该名称在数据库中必须是唯一的，不能与其他表或视图同名。
        - <SELECT 语句>：指定创建视图的 SELECT 语句，可用于查询多个基础表或源视图。
        - 需要注意的是，对于 ALTER VIEW 语句的使用，需要用户具有针对视图的 CREATE VIEW 和 DROP 权限，以及由 SELECT 语句选择的每一列上的某些权限。
    - 修改视图的定义，除了可以通过 ALTER VIEW 外，也可以使用 DROP VIEW 语句先删除视图，再使用 CREATE VIEW 语句来实现。
    ### 修改视图内容
    - 视图是一个虚拟表，实际的数据来自于基本表，所以通过插入、修改和删除操作更新视图中的数据，实质上是在更新视图所引用的基本表的数据。
    - 注意：对视图的修改就是对基本表的修改，因此在修改时，要满足基本表的数据定义。
    - 某些视图是可更新的。也就是说，可以使用 UPDATE、DELETE 或 INSERT 等语句更新基本表的内容。对于可更新的视图，视图中的行和基本表的行之间必须具有一对一的关系。
    - 还有一些特定的其他结构，这些结构会使得视图不可更新。更具体地讲，如果视图包含以下结构中的任何一种，它就是不可更新的：
      - 聚合函数 SUM()、MIN()、MAX()、COUNT() 等
      - DISTINCT 关键字。
      - GROUP BY 子句。
      - HAVING 子句。
      - UNION 或 UNION ALL 运算符。
      - 位于选择列表中的子查询。
      - FROM 子句中的不可更新视图或包含多个表。
      - WHERE 子句中的子查询，引用 FROM 子句中的表。
      - ALGORITHM 选项为 TEMPTABLE（使用临时表总会使视图成为不可更新的）的时候。
    ### 修改视图名称
    修改视图的名称可以先将视图删除，然后按照相同的定义语句进行视图的创建，并命名为新的视图名称。
    ## 删除视图
    - 删除视图是指删除 MySQL 数据库中已存在的视图。删除视图时，只能删除视图的定义，不会删除数据。    
    - 可以使用 DROP VIEW 语句来删除视图。语法格式如下：
    DROP VIEW <视图名1> [ , <视图名2>...]
    - 其中：<视图名>指定要删除的视图名。DROP VIEW 语句可以一次删除多个视图，但是必须在每个视图上拥有 DROP 权限。

4. 在你当前使用的RDBMS中实现上面给出的模式。如果可能，实现主关键字、候选关键字、外部关键字以及适当的关系完整性约束。
解：见[hotel.sql](hotel.sql)