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
  returns @res table( [BookName] varchar(30),
[Author] varchar(50),
[Description] varchar(50),
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




