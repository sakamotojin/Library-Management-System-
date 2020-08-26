--author sumit.joshi@airbus.com

use I0001425;
go

--Schema

if not exists ( select  *
                from  sys.schemas
                where   name = N'LibraryManagementSystem' )
    EXEC('CREATE SCHEMA [LibraryManagementSystem]');
go

--BookInfoTable 

if not exists ( Select * FROM I0001425.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = N'LibraryManagementSystem'  AND TABLE_NAME = N'BookInfo')
begin ;
create table LibraryManagementSystem.BookInfo
(
[BookId] int not null identity(1,1), 
[Name] varchar(30) not null,
[Author] varchar(50) not null,
[Description] varchar(50) not null,
[ISBN] bigint not null unique ,
[BasePrice] decimal(10,2) not null,
[PricePerDay] decimal(10,2) not null,
[IsDeleted] bit default 0,
[DateCreated] date default GETDATE(),
[DateModified] date default GETDATE(),
constraint PkBookInfo primary key ([BookId])
);
end;

go

--UserInfoTable 

if not exists ( Select * FROM I0001425.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = N'LibraryManagementSystem'  AND TABLE_NAME = N'UserInfo')
begin ;
create table  LibraryManagementSystem.UserInfo
(
[UserId] int  not null identity(1,1) ,
[Password] varchar(50) not null,
[Name] varchar(50) not null,
[EmailId] varchar(50) not null,
[PrivilageLevel] bit default 0,
[DateCreated] date default GETDATE(),
[DateModified] date default GETDATE(),
constraint PkUserInfo primary key ([UserId])
);
end;

go

--IssuedBookTable

if not exists ( Select * FROM I0001425.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = N'LibraryManagementSystem'  AND TABLE_NAME = N'IssuedBooks')
begin ;
create table LibraryManagementSystem.IssuedBooks
(
[UserId] int not null ,
[BookId] int not null,
[IssueDate] date default GETDATE(),
[DueDate] date not null,
constraint PkIssuedBooks primary key ([UserId] ,[BookId]),
constraint FkIssuedBooks_uid foreign key (UserId) references LibraryManagementSystem.UserInfo ([UserId]),
constraint FkIssuedBooks_bid foreign key (BookId) references LibraryManagementSystem.BookInfo ([BookId])
);
end;

go

--BookAnalyticsTable

--TODO Non Clustered Index on TotalIssues and  Rating and Money 
--TODO constriants matching with book readhistory__ rating 

if not exists ( Select * FROM I0001425.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = N'LibraryManagementSystem'  AND TABLE_NAME = N'BookAnalytics')
begin ;
create table LibraryManagementSystem.BookAnalytics
(
[BookId] int not null,
[MoneyCollected] decimal(10,2) default 0.0,
[Rating] decimal(10,2) default 0.0,
[TotalIssues] int default 0,
[TotalRated] int default 0,
constraint PkBookAnalytics primary key ([BookId]),
constraint FkBookAnalytics foreign key (BookId) references LibraryManagementSystem.BookInfo ([BookId])
);
end;

go

--BookReadHistoryTable

if not exists ( Select * FROM I0001425.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = N'LibraryManagementSystem'  AND TABLE_NAME = N'BookReadHistory')
begin ;
create table LibraryManagementSystem.BookReadHistory
(
[UserId] int not null,
[BookId] int not null, 
[IssueDate] date not null,
[Rating] int default 3,
constraint PkBookReadHistory primary key ([UserId], [BookId]),
constraint FkBookReadHistory_uid foreign key (UserId) references LibraryManagementSystem.UserInfo ([UserId]),
constraint FkBookReadHistory_bid foreign key (BookId) references LibraryManagementSystem.BookInfo ([BookId])
);
end;

go

-- TABLE COMPLETION FINISHED
