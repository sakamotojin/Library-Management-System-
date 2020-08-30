use i0001425;
go

--DoLoginFunction

 drop function if exists LibraryManagementSystem.DoLogin;
go

create function LibraryManagementSystem.DoLogin
(@userid int ,
 @password varchar(50))
 returns bit
 as begin
 if not exists(select 1 from LibraryManagementSystem.UserInfo where LibraryManagementSystem.UserInfo.UserId = @userid and LibraryManagementSystem.UserInfo.Password = @password)
 begin ;
 Return(0);
 end;
 Return(1)
 end
 
 go

 --GetAllUserDetails
drop function if exists LibraryManagementSystem.GetAllUserDetails;
go
 
 create function LibraryManagementSystem.GetAllUserDetails
 ( @userid int )
  returns @res table([UserId] int ,
[Name] varchar(50) ,
[EmailId] varchar(50) ,
[PrivilageLevel] bit )
 as begin
 if  exists(select 1 from LibraryManagementSystem.UserInfo where LibraryManagementSystem.UserInfo.UserId = @userid and LibraryManagementSystem.UserInfo.[PrivilageLevel] = 1)
begin ;
 insert into @res
  select [UserId],[Name],[EmailId],[PrivilageLevel]  from LibraryManagementSystem.UserInfo ;
end;
 return;
end

go

-- GetBookReadHistory

drop function if exists LibraryManagementSystem.GetBookReadHistory;
go
 
 
create function LibraryManagementSystem.GetBookReadHistory
 ( @userid int )
  returns @res table( [BookName] varchar(60),
[Author] varchar(60),
[Description] varchar(100),
[IssueDate] date 
 )
 as begin
 if  exists(select 1 from LibraryManagementSystem.UserInfo where LibraryManagementSystem.UserInfo.UserId = @userid)
begin ;
 insert into @res
   
  select LibraryManagementSystem.BookInfo.[Name],
  LibraryManagementSystem.BookInfo.[Author],
  LibraryManagementSystem.BookInfo.[Description],
  LibraryManagementSystem.BookReadHistory.[IssueDate]
  from LibraryManagementSystem.BookInfo join LibraryManagementSystem.BookReadHistory
  on LibraryManagementSystem.BookInfo.[BookId] = LibraryManagementSystem.BookReadHistory.[BookId] and 
  LibraryManagementSystem.BookReadHistory.[UserId] = @userid 
  ;
end;
 return;
end

go

--CalculateLeaseCharge

drop function if exists LibraryManagementSystem.CalculateLeaseCharge;
go
 
create function LibraryManagementSystem.CalculateLeaseCharge
( @bookid int ,
  @days int 
)
returns  decimal(10,2)
as begin 

declare @baseamt decimal(10,2);
declare @amtperday decimal(10,2);

select @baseamt = [BasePrice] ,
	@amtperday = [PricePerDay]
    from LibraryManagementSystem.BookInfo
	where LibraryManagementSystem.BookInfo.[BookId] = @bookid;

declare @finamt decimal(10,2);

set @finamt = @baseamt + @amtperday*@days ;
return @finamt;
end 
go

--DisplayMoneyCollection
drop function if exists LibraryManagementSystem.DisplayMoneyCollection;
go
create function LibraryManagementSystem.DisplayMoneyCollection
( @userid int 
)
returns @res table(
[srno] int identity(1,1),
[BookId] int ,
[BookName] varchar(60),
[Author] varchar(60),
[MoneyCollected] decimal(10,2)
)
as begin
 if  exists(select 1 from LibraryManagementSystem.UserInfo where LibraryManagementSystem.UserInfo.UserId = @userid and LibraryManagementSystem.UserInfo.PrivilageLevel = 1 )
begin ;
 insert into @res([BookId] ,[BookName],[Author],[MoneyCollected])
  select LibraryManagementSystem.BookInfo.[BookId],
  LibraryManagementSystem.BookInfo.[Name],
  LibraryManagementSystem.BookInfo.[Author],
  LibraryManagementSystem.BookAnalytics.[MoneyCollected]
  from LibraryManagementSystem.BookInfo join LibraryManagementSystem.BookAnalytics
  on LibraryManagementSystem.BookInfo.[BookId] = LibraryManagementSystem.BookAnalytics.[BookId] 
  order by LibraryManagementSystem.BookAnalytics.[MoneyCollected] desc;
end;
return;
end;
go

--Divide By Zero Error
drop function if exists LibraryManagementSystem.OnePlus;
go
create function LibraryManagementSystem.OnePlus
( @res int 
)
returns int 
as begin 
 if (@res != 0)
 begin
 return @res;
 end
return 1; 
end;
go

--DisplayPopularBook
drop function if exists LibraryManagementSystem.DisplayPopularBook;
go
create function LibraryManagementSystem.DisplayPopularBook
( @userid int 
)
returns @res table(
[srno] int identity(1,1),
[BookId] int ,
[BookName] varchar(60),
[Author] varchar(60),
[TotalIssues] int,
[Rating] decimal(10,2)
)
as begin
 if  exists(select 1 from LibraryManagementSystem.UserInfo where LibraryManagementSystem.UserInfo.UserId = @userid and LibraryManagementSystem.UserInfo.PrivilageLevel = 1)
begin ;
 insert into @res([BookId] ,[BookName] ,[Author] ,[TotalIssues] ,[Rating])
  select LibraryManagementSystem.BookInfo.[BookId],
  LibraryManagementSystem.BookInfo.[Name],
  LibraryManagementSystem.BookInfo.[Author],
  LibraryManagementSystem.BookAnalytics.[TotalIssues],
  LibraryManagementSystem.BookAnalytics.[Rating]/LibraryManagementSystem.OnePlus(LibraryManagementSystem.BookAnalytics.[TotalRated])
  from LibraryManagementSystem.BookInfo join LibraryManagementSystem.BookAnalytics
  on LibraryManagementSystem.BookInfo.[BookId] = LibraryManagementSystem.BookAnalytics.[BookId] 
  order by LibraryManagementSystem.BookAnalytics.[TotalIssues] desc , 
  LibraryManagementSystem.BookAnalytics.[Rating]/LibraryManagementSystem.OnePlus(LibraryManagementSystem.BookAnalytics.[TotalRated]) desc;
end;
return;
end;
go


--ValidateEmail
drop function if exists LibraryManagementSystem.ValidateEmail;
go
create function LibraryManagementSystem.ValidateEmail(
@email varchar(50)
)
returns bit
as 
begin;
declare @res bit ;
set @res =  ;
if (@email not like '%_@__%.__%')
set @res = 0 ;
return @res ;
end ;
go




