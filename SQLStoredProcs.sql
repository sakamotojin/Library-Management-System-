use i0001425;
go

--Register User

--TODO emailid check , password check (optional req)

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
 
 if  exists(select 1 from LibraryManagementSystem.UserInfo where LibraryManagementSystem.UserInfo.EmailId = @emailid)
 begin;
 declare @err_message varchar(100)
 set @err_message = @emailid + ' already exists'
raiserror(@err_message, 1,1)
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
 @name varchar(50),
 @author varchar(50),
 @description varchar(50),
 @baseprice decimal(10,2),
 @priceperday decimal(10,2),
 @isbn bigint
 )
 as 
 begin 
 
  if  not exists(select 1 from LibraryManagementSystem.UserInfo where LibraryManagementSystem.UserInfo.[UserId] = @userid and LibraryManagementSystem.UserInfo.[PrivilageLevel] = 1 )
 begin;
 declare @err_message1 varchar(100)
 set @err_message1 = ' you are not permited to add books '
raiserror(@err_message1, 1,1)
 end;
 
 if  exists(select 1 from LibraryManagementSystem.BookInfo where LibraryManagementSystem.BookInfo.ISBN = @isbn)
 begin;
 declare @err_message2 varchar(100)
 set @err_message2 = @name + ' already exists'
raiserror(@err_message2, 1,1)
 end;
 
 insert into LibraryManagementSystem.BookInfo([Name]  ,[Author] ,[Description],[BasePrice],[PricePerDay],[ISBN])
 values
 (@name , @author , @description, @baseprice , @priceperday,@isbn);
 
  insert into LibraryManagementSystem.BookAnalytics([BookId])
 values
 (@bookid);
 
 
 end;
 
 go
 
 
 
 --UpdateBook Information
 
  drop procedure if exists LibraryManagementSystem.UpdateBook;
go

 create procedure LibraryManagementSystem.UpdateBook
 (
 @userid int ,
 @bookid int ,
 @name varchar(50),
 @author varchar(50),
 @description varchar(50),
 @baseprice decimal(10,2),
 @priceperday decimal(10,2),
 @isbn bigint
 )
 as 
 begin 
 
  if  not exists(select 1 from LibraryManagementSystem.UserInfo where LibraryManagementSystem.UserInfo.[UserId] = @userid and LibraryManagementSystem.UserInfo.[PrivilageLevel] = 1 )
 begin;
 declare @err_message1 varchar(100)
 set @err_message1 = ' you are not permited to update book info '
raiserror(@err_message1, 1,1)
 end;
 
 if  not exists(select 1 from LibraryManagementSystem.BookInfo where LibraryManagementSystem.BookInfo.BookId = @bookid)
 begin;
 declare @err_message2 varchar(100)
 set @err_message2 = @name + ' book does not  exists'
raiserror(@err_message2, 1,1)
 end;
 

 
 update LibraryManagementSystem.BookInfo set 
 [Name]        =  COALESCE(@name,Name) ,
 [Author]      = COALESCE(@author,Name),
 [Description] =  COALESCE(@description,Name),
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
 
  if  not exists(select 1 from LibraryManagementSystem.UserInfo where LibraryManagementSystem.UserInfo.[UserId] = @userid and LibraryManagementSystem.UserInfo.[PrivilageLevel] = 1 )
 begin;
 declare @err_message1 varchar(100)
 set @err_message1 = ' you are not permited to update book info '
raiserror(@err_message1, 1,1)
 end;
 
 if  not exists(select 1 from LibraryManagementSystem.BookInfo where LibraryManagementSystem.BookInfo.BookId = @bookid)
 begin;
 declare @err_message2 varchar(100)
 set @err_message2 =  ' book does not  exists'
raiserror(@err_message2, 1,1)
 end;
 
 update LibraryManagementSystem.BookInfo set 
 [IsDeleted]        =  1,
 [DateModified]= GETDATE()
 where [BookId] = @bookid;
 
 end;
 
 go
 
 --IssueBook
 --TODO rating , 
 
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
set @duedate = adddate(day , days , @issuedate);
set @lease_amt = LibraryManagementSystem.CalculateLeaseCharge(@bookid , @days);


insert into LibraryManagementSystem.IssuedBooks([UserId] ,[BookId] ,[IssueDate] ,[DueDate])
values
(@userid , @bookid , @issuedate ,@duedate);

insert into LibraryManagementSystem.BookReadHistory([UserId] ,[BookId] ,[IssueDate] )
values
(@userid , @bookid , @issuedate );

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
end catch
 
 end
 
 
 
 
 
 
 
 
 
 
 


