use i0001425;
go

--Register Admin


drop procedure if exists LibraryManagementSystem.RegisterAdmin ;
go

 create procedure LibraryManagementSystem.RegisterAdmin
 (
 @name varchar(50),
 @emailid varchar(50),
 @password varchar(50)
 )
 as 
 begin 
 
 -- If The EmailId Already Exists In The Databse
 if  exists(select 1 from LibraryManagementSystem.UserInfo where LibraryManagementSystem.UserInfo.EmailId = @emailid)
 begin;
 declare @err_message varchar(100)
 set @err_message = @emailid + ' already exists'
raiserror(@err_message, 1,1);
return;
 end;
 
insert into LibraryManagementSystem.UserInfo([Name]  ,[EmailId] ,[Password] ,[PrivilageLevel])
values (@name , @emailid ,@password ,1);
end;
 
 go
 
--Register User

drop procedure if exists LibraryManagementSystem.RegisterUser ;
go

 create procedure LibraryManagementSystem.RegisterUser
 (
 @name varchar(50),
 @emailid varchar(50),
 @password varchar(50)
 )
 as 
 begin 
 
 -- If The EmailId Already Exists In The Databse
 if  exists(select 1 from LibraryManagementSystem.UserInfo where LibraryManagementSystem.UserInfo.EmailId = @emailid)
 begin;
 declare @err_message varchar(100)
 set @err_message = @emailid + ' already exists'
raiserror(@err_message, 1,1);
return;
 end;
 
 insert into LibraryManagementSystem.UserInfo([Name]  ,[EmailId] ,[Password])
 values
 (@name , @emailid ,@password);
 
 end;
 
 go
 
 
 --AddBook
 
 drop procedure if exists LibraryManagementSystem.AddBook ;
go

 create procedure LibraryManagementSystem.AddBook
 (
 @userid int ,
 @name varchar(60),
 @author varchar(60),
 @description varchar(100),
 @baseprice decimal(10,2),
 @priceperday decimal(10,2),
 @isbn bigint
 )
 as 
 begin 
 
 -- If The User Is Not An Admin
  if  not exists(select 1 from LibraryManagementSystem.UserInfo where LibraryManagementSystem.UserInfo.[UserId] = @userid and LibraryManagementSystem.UserInfo.[PrivilageLevel] = 1 )
 begin;
 declare @err_message1 varchar(100)
 set @err_message1 = ' you are not permited to add books '
raiserror(@err_message1, 1,1);
return;
 end;

--If The Book Already Exists In The Database 
 if  exists(select 1 from LibraryManagementSystem.BookInfo where LibraryManagementSystem.BookInfo.ISBN = @isbn and LibraryManagementSystem.BookInfo.IsDeleted = 0)
 begin;
 declare @err_message2 varchar(100)
 set @err_message2 = @name + ' already exists'
raiserror(@err_message2, 1,1);
return;
 end;
 
--If Book Was Earlier In The Database but was deleted 
if  exists(select 1 from LibraryManagementSystem.BookInfo where LibraryManagementSystem.BookInfo.ISBN = @isbn and LibraryManagementSystem.BookInfo.IsDeleted = 1)
 begin;
 
 update LibraryManagementSystem.BookInfo set 
 LibraryManagementSystem.BookInfo.IsDeleted = 0 where
 LibraryManagementSystem.BookInfo.ISBN = @isbn ;

return;
end;
-- If Book Is Not Present 

--Insert Into Book Info Table
insert into LibraryManagementSystem.BookInfo([Name]  ,[Author] ,[Description],[BasePrice],[PricePerDay],[ISBN])
 values
 (@name , @author , @description, @baseprice , @priceperday,@isbn);

--Insert Into BookAnalytics Table
declare @bookid  int ;
select @bookid= [BookId] from LibraryManagementSystem.BookInfo where LibraryManagementSystem.BookInfo.ISBN = @isbn ; 
insert into LibraryManagementSystem.BookAnalytics([BookId]) values (@bookid);
 
end; 
 go
 
 
 
 --UpdateBook Information 
drop procedure if exists LibraryManagementSystem.UpdateBook;
go

create procedure LibraryManagementSystem.UpdateBook
 (
 @userid int ,
 @bookid int ,
 @name varchar(60) = null,
 @author varchar(60) =null,
 @description varchar(100) = null,
 @baseprice decimal(10,2) =null,
 @priceperday decimal(10,2) =null,
 @isbn bigint =null
 )
 as 
 begin 

-- Check Whether The User Is A valid User  
if  not exists(select 1 from LibraryManagementSystem.UserInfo where LibraryManagementSystem.UserInfo.[UserId] = @userid and LibraryManagementSystem.UserInfo.[PrivilageLevel] = 1 )
 begin;
 declare @err_message1 varchar(100)
 set @err_message1 = ' you are not permited to update book info '
raiserror(@err_message1, 1,1);
return ;
 end;
 
--Book Does Not EXISTS In The DATABASE
if  not exists(select 1 from LibraryManagementSystem.BookInfo where LibraryManagementSystem.BookInfo.BookId = @bookid )
 begin;
 declare @err_message2 varchar(100)
 set @err_message2 = @name + ' book does not  exists'
raiserror(@err_message2, 1,1);
return 
end;

--Book Was Deleted Eralier From The Database
if   exists(select 1 from LibraryManagementSystem.BookInfo where LibraryManagementSystem.BookInfo.BookId = @bookid and LibraryManagementSystem.BookInfo.ISBN = @isbn)
 begin;
 declare @err_message3 varchar(100)
 set @err_message3 = @name + ' book was deleted from the database';
raiserror(@err_message3, 1,1);
return 
end;
 
 
update LibraryManagementSystem.BookInfo set 
 [Name]        =  COALESCE(@name,Name) ,
 [Author]      = COALESCE(@author,Author),
 [Description] =  COALESCE(@description,Description),
 [BasePrice]   =  COALESCE(@baseprice,BasePrice),
 [PricePerDay] =  COALESCE(@priceperday,PricePerDay),
 [ISBN]        = COALESCE(@isbn,ISBN),
 [DateModified]= GETDATE()
 where [BookId] = @bookid;
 
 end; 
 go
 

 -- DeleteBook From Collection
 
   drop procedure if exists LibraryManagementSystem.DeleteBook;
go

 create procedure LibraryManagementSystem.DeleteBook
 (
 @userid int ,
 @bookid int 
 )
 as 
 begin 

--Check Whether The User Is Valid To Delete The Book 
if  not exists(select 1 from LibraryManagementSystem.UserInfo where LibraryManagementSystem.UserInfo.[UserId] = @userid and LibraryManagementSystem.UserInfo.[PrivilageLevel] = 1 )
 begin;
 declare @err_message1 varchar(100)
 set @err_message1 = ' you are not permited to update book info '
raiserror(@err_message1, 1,1);
return ;
 end;

--Check Whether The Book Exists In The Databse 
if  not exists(select 1 from LibraryManagementSystem.BookInfo where LibraryManagementSystem.BookInfo.BookId = @bookid)
 begin;
 declare @err_message2 varchar(100);
 set @err_message2 =  ' book does not  exists'
raiserror(@err_message2, 1,1);
return ;
 end;
 
 update LibraryManagementSystem.BookInfo set 
 [IsDeleted]        =  1,
 [DateModified]= GETDATE()
 where [BookId] = @bookid;
 
 end;
 go
 
 
--IssueBook 
--If User Issues A Book Already Issued Update Action On Book ReadHistory
 
drop procedure if exists LibraryManagementSystem.IssueBook;
go
 create procedure LibraryManagementSystem.IssueBook
 (
 @userid int ,
 @bookid int ,
@days int  
 )
 as 
 begin 
 
begin try

declare @lease_amt decimal(10,2);
declare @duedate date;
declare @issuedate date;

set @issuedate = getdate();
set @duedate = dateadd(day , @days , @issuedate);
set @lease_amt = LibraryManagementSystem.CalculateLeaseCharge(@bookid , @days);


--Insert Into Issued Books Table
insert into LibraryManagementSystem.IssuedBooks([UserId] ,[BookId] ,[IssueDate] ,[DueDate])
values
(@userid , @bookid , @issuedate ,@duedate);

--Insert Into BookReadHistory Table
insert into LibraryManagementSystem.BookReadHistory([UserId] ,[BookId] ,[IssueDate] )
values
(@userid , @bookid , @issuedate );

--Update The BookAnalytics Table
update LibraryManagementSystem.BookAnalytics set 
LibraryManagementSystem.BookAnalytics.[MoneyCollected] = LibraryManagementSystem.BookAnalytics.[MoneyCollected] + @lease_amt,
LibraryManagementSystem.BookAnalytics.[TotalIssues] = LibraryManagementSystem.BookAnalytics.[TotalIssues] + 1
where LibraryManagementSystem.BookAnalytics.[BookId] = @bookid;

end try
begin catch
declare @ErrorMessage varchar(4000);  
    declare @ErrorSeverity int;  
    declare  @ErrorState int;  
  
    select  
        @ErrorMessage = ERROR_MESSAGE(),  
        @ErrorSeverity = ERROR_SEVERITY(),  
        @ErrorState = ERROR_STATE();

	raiserror(@ErrorMessage, -- Message text.  
               @ErrorSeverity, -- Severity.  
               @ErrorState -- State.  
               );
return;			   
end catch; 
end;
go
 
--RateBook
--TODO Rating Updation Issue
drop procedure if exists LibraryManagementSystem.RateBook;
go
create procedure LibraryManagementSystem.RateBook(
@userid int ,
@bookid int ,
@rating int 
)
as begin

--Rating Should Be Valid
if @rating < 0 or @rating > 5 
begin;
declare @err_message1 varchar(100)
set @err_message1 = ' please rate from 0 to 5  '
raiserror(@err_message1, 1,1);
return; 
end;

--User Should Have Read The Book
if  not exists(select 1 from LibraryManagementSystem.BookReadHistory where LibraryManagementSystem.BookReadHistory.BookId = @bookid and LibraryManagementSystem.BookReadHistory.UserId = @userid)
begin;
 declare @err_message2 varchar(100);
 set @err_message2 =  ' you have not read this book you cannot rate it '
raiserror(@err_message2, 1,1);
return ;
end;
 
update LibraryManagementSystem.BookReadHistory set 
 LibraryManagementSystem.BookReadHistory.Rating = @rating where
 LibraryManagementSystem.BookReadHistory.UserId = @userid and
 LibraryManagementSystem.BookReadHistory.BookId = @bookid ;

update LibraryManagementSystem.BookAnalytics set 
 LibraryManagementSystem.BookAnalytics.Rating =  LibraryManagementSystem.BookAnalytics.Rating + @rating,
 LibraryManagementSystem.BookAnalytics.TotalRated =  LibraryManagementSystem.BookAnalytics.TotalRated + 1 where
 LibraryManagementSystem.BookAnalytics.BookId = @bookid ;

 end;
go 

 
 
 
 
 
 
 
 
 
 


