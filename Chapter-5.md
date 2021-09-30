# 案例一：使用[hotel.sql](hotel.sql)定义的Hotel 关系数据库模式。
1. 描述由下列关系代数运算生成的关系：
   - $\prod_{hotelNo}\sigma_{price > 50}(Room)$:price大于50的Room的hotelNo
   - $\sigma_{Hotel.holelNo} = _{Room.hotelNo}(Hotel \times  Room)$:所有Room与Hotel的对应信息
   - $\prod_{hotelName}(Hotel \Join_{Hotel.hotelNo = Room.hotelNo}(\sigma_{price > 50}(Room)))$:所有price大于50的Room对应的hotelName
   - $Guest ⟕ (\sigma_{dateTo} \ge _{1-Jan-2007}(Booking))$:所有顾客的信息及其dateTo在1-Jan-2007之后的Booking信息
   - $Hotel \rhd _{Hotel.hotelNo = Room.hotelNo}(\sigma_{price > 50}(Room))$
   - $\prod_{guestName,hotelNo} (Booking \Join _{Booking.guestNo = Guest.guestNo} Guest) \div \prod_{hotelNo}(\sigma_{city = London}(Hotel))$:所有在London的Hotel有过Booking记录的Guest的guestName和对应的hotelNo
2. 写出与习题1中的关系代数查询等价的元组关系演算和域关系演算。
   1. $\{S.hotelNo | Hotel(S) \land S.price > 50 \}$
   2. $\{S,P | Hotel(S) \land ((\exists P) Room(P) \land S.hotelNo = P.hotelNo) \}$
   3. $\{S.hotelName | Room(S) \land ((\exists P) Hotel(P) \land S.hotelNo = P.hotelNo \land S.price > 50)  \}$
   4. $\{S,P | Guest(S) \lor ((\exists P) Booking(P) \land P.dateTo > 1-Jan-2007) \}$
   5. $\{S | Hotel(S) \land ((\exists P) Room(P) \land S.hotelNo = P.hotelNo \land P.price > 50) \}$
   6. $\{S.guestName,P.hotelNo | Guest(S) \land ((\exists P) (\exists Q) Booking(P) \land Hotel(Q) \land S.guestNo = P.guestNo \land P.hotelNo = Q.hotelNo \land Q.city = London) \}$
3. 描述由下列元组关系演算表达式生成的关系：
   - $\{H.hotelName | Hotel(H) \land H.city ='London'\}$:London所有Hotel的hotelName
   - $\{H.hotelName | Hotel(H) \land (\exists R) (Room(R) \land H.hotelNo = R.hotelNo \land R.price > 50)\}$:所有price超过50的Room对应的Hotel的hotelName
   - $\{H.hotelName | Hotel(H)\land (\exists B) (\exists G) (Booking(B)\land Guest(G)\land H.hotelNo = B.hotelNo \land B.guestNo = G.guestNo \land G.guestName ='John\ Smith')\}$:John Smith所有Booking记录中的Hotel的hotelName
   - $\{H.hotelName, G.guestName, B1.dateFrom, B2.dateFrom | Hotel(H) \land Guest(G) \land Booking(B1)\land Booking(B2) \land H.hotelNo = B1.hotelNo \land G.guestNo = B1.guestNo \land B2.hotelNo = B1.hotelNo \land B2.guestNo = B1.guestNo \land B2.dateFrom \ne B1.dateFrom\}$:每位Guest在每家Hotel中dateFrom不同的所有Booking记录
4. 写出与习题3中的元组关系演算表达式等价的域关系演算和关系代数表达式。  
   
   1. 
   - 域关系演算：$\{hotelName | Hotel(hotelNo,hotelName,city) \land city = 'London'\}$  
   - 关系代数：$\prod_{hotelName}(\sigma_{city='London'}(Hotel))$
   
   2. 
   - 域关系演算：$\{hotelName | Hotel(hotelNo,hotelName,city) \land Room(room,hotelNo,type,price) \land price > 50 \}$  
   - 关系代数：$\prod_{hotelName}(\sigma_{price>50}(Room \Join_{Room.hotelNo=Hotel.hotelNo} Hotel))$
  
   3. 
   - 域关系演算：$\{hotelName | Hotel(hotelNo,hotelName,city) \land Booking(hotelNo,guestNo,dateFrom,dateTo,roomNo) \land Guest(guestNo,'John Smith',guestAddress) \}$  
   - 关系代数：$\prod_{hotelName}(Hotel \ Join \ (\sigma_{guestName = 'JohnSmith'}(Booking \ Join_{Booking.guestNo=Guest.guestNo} \ Guest)))$
   
   4. 
   - 域关系演算：$\{hotelName, guestName, dateFrom1, dateFrom2 | (\exists dateFrom1,dateFrom2,dateTo1,dateTo2) Hotel(hotelNo,hotelName,city) \land Guest(guestNo,guestName,guestAddress) \land Booking(hotelNo,guestNo,dateFrom1,dateTo1,roomNo) \land Booking(hotelNo,guestNo,dateFrom2,dateTo2,roomNo) \land dateFrom1 \ne dateFrom2\}$  
   - 关系代数：$\prod_{hotelName,guestName,Booking.dateFrom,Booking.dateFrom}(Hotel \ \Join_{hotelNo,roomNo} \ (Guest \ \Join_{guestNo} (\sigma_{Booking.dateFrom \ne Booking.dateFrom}(Booking \times Booking))))$
5. 给出下列查询所对应的关系代数、元组关系演算和域关系演算表达式：
   - 列出所有的酒店。
     - 关系代数： $\sigma_{predicate}(Hotel)$
     - 元组关系演算：$\{S|Hotel(S)\}$
     - 域关系演算表达式：$\{hotelNo,hotelName,city|Hotel(hotelNo,hotelName,city)\}$
   - 列出所有价格低于每晚20英镑的单人间。
     - 关系代数： $\sigma_{price < 20 \land type = 'single'}(Room)$
     - 元组关系演算：$\{S|(\exists S) \ Room(S) \land S.price < 20 \ \land S.type = 'single'\}$
     - 域关系演算表达式：$\{roomNo,hotelNo,type,price|(\exists price) (Room(roomNo,hotelNo,'single',price) \ \land price < 20)\}$
   - 列出所有客人的姓名和所属城市。
     - 关系代数：$\prod_{guestName,city}((Booking \Join_{hotelNo} Hotel) \Join_{guestNo} Guest)$
     - 元组关系演算：$\{S.guestName,B.city|Guest(S) \land ((\exists B)(\exists C)(Hotel(B) \land Booking(C) \land B.hotelNo = C.hotelNo \land S.guestNo = C.guestNo))\}$
     - 域关系演算表达式：$\{(gNm,ct)|Guest(gNo1,gNm,gA) \land Booking(hNo1,gNo2,dF,dT,rNo) \land Hotel(hNo2,hNm,ct) \land (gNo1 = gNo2) \land (hNo1 = hNo2)\}$
   - 列出格罗夫纳酒店中所有房间的价格和类型。    
     - 关系代数： $\prod_{price,type}(\sigma_{hotelName = 'Grolav'}(Room \Join_{hotelNo} Hotel))$
     - 元组关系演算：$\{S.price,S.type|Room(S) \land ((\exists B) (Hotel(B) \land B.hotelName = 'Grolav'))\}$
     - 域关系演算表达式：$\{(price,type)|Room(rNo,hNo1,type,price) \land Hotel(hNo2,hNm,city) \land hNm = 'Grolav' \land hNo1 = hNo2\}$
   - 列出当前住在格罗夫纳酒店里的所有客人。
     - 关系代数： $\prod_{guestNo} (\sigma_{hotelName = 'Grolav'}(Booking \Join_{hotelNo} Hotel))$
     - 元组关系演算：$\{S.guestNo|Booking(S) \land ((\exists B) (Hotel(B) \land B.hotelName = 'Grolav' \land S.hotelNo = B.hotelNo))\}$
     - 域关系演算表达式：$\{gstNo|Booking(hNo1,gstNo,dF,dT,rNo) \land Hotel(hNo2,'Grolav',city) \land hNo1 = hNo2\}$
   - 列出格罗夫纳酒店中所有房间的详细资料。如果房间已经被占用，还应该包括租用此房间的客人的姓名。
     - 关系代数： 
     - 元组关系演算：
     - 域关系演算表达式：
   - 列出住在格罗夫纳酒店的所有客人的详细资料(guestNo、guestName和guestAddress) 
     - 关系代数： 
     - 元组关系演算：
     - 域关系演算表达式：
6. 使用关系代数创建一个包含格罗夫纳酒店中所有房间的视图，并隐藏价格信息。说明这个视图的优点。
   
# 案例二：下表是存在某RDBMS中的数据库的一部分

   Employee(<u>empNo</u>,fName,lName,address,DOB,sex,position,deptNo)  
   Department(<u>deptNo</u>,deptName,mgrEmpNo)  
   Project(<u>projNo</u>,projName,deptName)  
   WorksOn(<u>empNo</u>,<u>projNo</u>,<u>dateWorked</u>,hoursWorked)

   其中，Employee包含雇员的详情，empNo是主关键字。
   Department包含部门的详情， deptNo 是主关键字。
   mgrEmpNo 指出担任该部门经理的雇员。每个部门仅一位经理。
   Project 包含每个部门项目的详情，proNo 是主关键字（不会有两个部门运作同一个项目）。  
   WorkOn 包含在每个项目中雇员参与工作的时长情况， empNo/projNo/dateWorked 组合为主关键字。

## 用关系代数、元组关系演算和域关系演算表达式表达下列查询。
7. 列出所有雇员。
8. 列出所有女雇员的情况。
9. 列出所有担任经理的雇员的名字和地址。
10. 产生所有为IT 部门工作的雇员的名字和地址表。
11. 产生参与SCCS 项目的所有雇员的名表。
12. 产生今年内退休的所有经理的全部情况表，并按姓氏字典序排列。

## 用关系代数表达式表达下列查询。
12. 找出有多少雇员由James Adam 管理。
13. 产生每位雇员工作总时数的报表。
14. 找出多于两位雇员参与工作的项目，列出项目编号、项目名称和参与该项目的雇员人数。
15. 列出雇员数多于10 人的那些部门的雇员总数，为结果关系各列赋予合适的列名。

# 案例三：下表是某RDBMS 管理的图书馆数据库的一部分：
   Book (<u>ISBN</u>,title,edition,year)  
   BookCopy (<u>copyNo</u>,ISBN,available)  
   Borrower (<u>borrowerNo</u>,borrowerName,borrowerAddress)  
   Bookloan (<u>copyNo</u>,<u>dateOut</u>,dateDue,borrowerNo)  

   其中，Book包含图书馆馆藏书目的情况，ISBN是主关键字。
   BookCopy包含图书馆馆藏书本的情况，copyNo是主关键字，ISBN 是外部关键字，指向这本书对应的书目。
   Borrower包含能在图书馆借书的读者，borrowerNo是主关键字。
   BookLoan包含每本书被读者借阅的情况，copyNo/dateOut组合成主
   关键字，borrowerNo是外部关键字，指向这本书的借阅者。

## 用关系代数、元组关系演算和域关系演算表达式表达下列查询。
16. 列出所有书目。
17. 列出所有读者的情况。
18. 列出所有2012 年出版的书目。
19. 列出所有书目可外借的副本。
20. 列出《指环王》所有可外借的副本。
21. 列出目前正借阅《指环王》的读者的姓名。
22. 列出有预期未还图书的读者的姓名。

## 用关系代数表达式表达下列查询。
23. ISBN 为"0-321-52306-7"的书有多少本？
24. ISBN 为"0-321-52306-7"的书还有多少本可外借？
25. ISBN 为"0-321-52306-7"的书目借出过多少次？
26. 产生由Peter Bloomfield借阅的图书的书目表。
27. 对馆藏多于三个副本的书目，列出借阅过它的读者的姓名。
28. 产生当前借有图书逾期未还的读者的情况报表。
29. 产生每个书目被借阅总次数的报表。

30. 分析当前你所使用的RDBMS 。系统提供了哪几种关系语言？对于所提供的每种语言，找出与八个关系代数运算等价的运算。