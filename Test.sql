use I0001425;
go

print 'Testing Start Now'
go

--LibraryManagementSystem.RegisterAdmin name , emailid , password

exec LibraryManagementSystem.RegisterAdmin 'Sumit Joshi' , 'sumit.joshi@airbus.com' ,'1234';
go

exec LibraryManagementSystem.RegisterAdmin 'Shrisho Dutt' , 'shrisho.dutt@airbus.com' ,'1234';
go

exec LibraryManagementSystem.RegisterAdmin 'Rohit Singh' , 'shrisho.dutt@airbus.com' ,'1234';
go


--LibraryManagementSystem.RegisterUser name , emailid , password

exec LibraryManagementSystem.RegisterUser 'Nomad Singh' , 'nomad.singh@airbus.com' ,'1234';
go

exec LibraryManagementSystem.RegisterUser 'Ka KK' , 'ka.kk@airbus.com' ,'1234';
go


exec LibraryManagementSystem.RegisterUser 'b b' , 'ka.kk@airbus.com' ,'1234';
go

select * from LibraryManagementSystem.UserInfo ;
go

--DoLogin userid , password
select LibraryManagementSystem.DoLogin(1 ,'1234');
go

select LibraryManagementSystem.DoLogin(1 ,'134');
go

--GetAllUserDeatils userid
select * from LibraryManagementSystem.GetAllUserDetails(1);
go

select * from LibraryManagementSystem.GetAllUserDetails(3);
go

--LibraryManagementSystem.AddBook 
-- @userid int ,
-- @name varchar(60),
-- @author varchar(60),
-- @description varchar(100),
-- @baseprice decimal(10,2),
-- @priceperday decimal(10,2),
-- @isbn bigint

exec LibraryManagementSystem.AddBook 1 , 'Harry Potter 1' ,'JK' ,'Fiction , Worthless' , 4.50 , 5.50 , 1234567898;
go

exec LibraryManagementSystem.AddBook 1 , 'Harry Potter 2' ,'JK' ,'Fiction , Worthless' , 4.50 , 5.50 , 1134567898;
go

exec LibraryManagementSystem.AddBook 1 , 'Harry Potter 3' ,'JK' ,'Fiction , Worthless' , 4.50 , 5.50 , 12124567898;
go

exec LibraryManagementSystem.AddBook 1 , 'Harry Potter 4' ,'JK' ,'Fiction , Worthless' , 4.50 , 5.50 , 12331567898;
go

exec LibraryManagementSystem.AddBook 1 , 'Harry Potter 5' ,'JK' ,'Fiction , Worthless' , 4.50 , 5.50 , 12343267898;
go

exec LibraryManagementSystem.AddBook 1 , 'Harry Potter 51' ,'JK' ,'Fiction , Worthless' , 4.50 , 5.50 , 12343267898;
go

exec LibraryManagementSystem.AddBook 3 , 'Harry Potter 5' ,'JK' ,'Fiction , Worthless' , 4.50 , 5.50 , 12243267898;
go

select * from LibraryManagementSystem.BookInfo ;
go

--LibraryManagementSystem.UpdateBook
 --@userid int ,
 --@bookid int ,
 --@name varchar(60),
 --@author varchar(60),
 --@description varchar(100),
 --@baseprice decimal(10,2),
 --@priceperday decimal(10,2),
 --@isbn bigint

exec LibraryManagementSystem.UpdateBook 1 , 1 ,'JK Rowling' ,'Fiction , Worthless' ;
go;

select * from LibraryManagementSystem.BookInfo ;
go

exec LibraryManagementSystem.UpdateBook 1 , 1 ,'Harry Potter 1' , 'JK Rowling' ;
go

select * from LibraryManagementSystem.BookInfo ;
go

exec LibraryManagementSystem.UpdateBook 3 , 1 ,'Harry Potter 1' , 'JK Rowling' ;
go

exec LibraryManagementSystem.UpdateBook 1 , 1 , , ,'Fiction , Worthless' ;
go

select * from LibraryManagementSystem.BookInfo ;
go

--LibraryManagementSystem.IssueBook
 --@userid int ,
 --@bookid int ,
 --@days int

exec  LibraryManagementSystem.IssueBook 3,1,5;
go

exec  LibraryManagementSystem.IssueBook 4,1,5;
go

exec  LibraryManagementSystem.IssueBook 3,2,8;
go

exec  LibraryManagementSystem.IssueBook 4,3,5;
go

exec  LibraryManagementSystem.IssueBook 3,4,5;
go

exec  LibraryManagementSystem.IssueBook 8,4,5;
go

exec  LibraryManagementSystem.IssueBook 3,14,5;
go

select * from LibraryManagementSystem.IssuedBooks;
go

select * from LibraryManagementSystem.BookAnalytics;
go

select * from LibraryManagementSystem.GetBookReadHistory(3);
go

select * from LibraryManagementSystem.GetBookReadHistory(4);
go

select * from LibraryManagementSystem.GetBookReadHistory(14);
go

select * from LibraryManagementSystem.DisplayMoneyCollection(1);
go

select * from LibraryManagementSystem.DisplayMoneyCollection(3);
go

--LibraryManagementSystem.RateBook
	--@userid int ,
	--@bookid int ,
	--@rating int 
	
exec LibraryManagementSystem.RateBook 3, 1 , 5 ;
go 
exec LibraryManagementSystem.RateBook 4, 1 , 4 ;
go

exec LibraryManagementSystem.RateBook 4, 4 , 4 ;
go 

exec LibraryManagementSystem.RateBook 4, 3 , 41 ;
go 

select * from LibraryManagementSystem.DisplayPopularBook(1);
go

