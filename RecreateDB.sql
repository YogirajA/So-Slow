
IF OBJECT_ID(N'[dbo].[Badges]') is not null
	DROP TABLE [Badges]

IF OBJECT_ID(N'[dbo].[Comments]') is not null
	DROP TABLE [Comments]

IF OBJECT_ID(N'[dbo].[Posts]') is not null
	DROP TABLE [Posts]
	
IF OBJECT_ID(N'[dbo].[Users]') is not null
	DROP TABLE [Users]
	
IF OBJECT_ID(N'[dbo].[Votes]') is not null
	DROP TABLE [Votes]

IF OBJECT_ID(N'[dbo].[VoteTypes]') is not null
	DROP TABLE [VoteTypes]

IF OBJECT_ID(N'[dbo].[Tags]') is not null
	DROP TABLE [Tags]


IF OBJECT_ID(N'[dbo].[PostTags]') is not null
	DROP TABLE [PostTags]



CREATE TABLE [dbo].[Badges] (
  [Id]            [int]   IDENTITY ( 1 , 1 )   NOT NULL
  ,[UserId]       [int]   NULL
  ,[Name]         [nvarchar](50)   NULL
  ,[CreationDate] [datetime]   NULL,
  CONSTRAINT [PK_Badges] PRIMARY KEY CLUSTERED ( [Id] ASC ) WITH ( PAD_INDEX = OFF,STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF,ALLOW_ROW_LOCKS = ON,ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY])
ON [PRIMARY]

CREATE TABLE [dbo].[Comments] (
  [Id]            int   NOT NULL
  ,[PostId]       int   NULL
  ,[Score]		  int	null
  ,[Text]         nvarchar(max)   NULL
  ,[CreationDate] datetime   NULL
  ,[UserId]       int   NULL,
  CONSTRAINT [PK_Comments] PRIMARY KEY CLUSTERED ( [Id] ASC ) WITH ( PAD_INDEX = OFF,STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF,ALLOW_ROW_LOCKS = ON,ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY])
ON [PRIMARY]

                    
CREATE TABLE [dbo].[Posts](
	[Id] [int] NOT NULL IDENTITY(1,1),
	[PostTypeId] [int] NULL,
	[AcceptedAnswerId] [int] NULL,
	[CreationDate] [datetime] NULL,
	[Score] [int] NULL,
	[ViewCount] [int] NULL,
	[Body] [nvarchar](max) NULL,
	[OwnerUserId] [int] NULL,
	[OwnerDisplayName] [nvarchar](40) NULL,
	[LastEditorUserId] [int] NULL,
	[LastEditDate] [datetime] NULL,
	[LastActivityDate] [datetime] NULL,
	[Title] [nvarchar](250) NULL,
	[Tags] [nvarchar](150) NULL,
	[AnswerCount] [int] NULL,
	[CommentCount] [int] NULL,
	[FavoriteCount] [int] NULL,
	[ClosedDate] [datetime] NULL,
	[ParentId] [int] NULL,
	CommunityOwnedDate datetime null
CONSTRAINT [PK_Posts] PRIMARY KEY CLUSTERED 
(
[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[Users] (
  [Id]              [int]   NOT NULL
  ,[Reputation]     [int]   NULL
  ,[CreationDate]   [datetime]   NULL
  ,[DisplayName]    [nvarchar](40)   NULL
  ,[LastAccessDate] [datetime]   NULL
  ,[WebsiteUrl]     [nvarchar](200)   NULL
  ,[Location]       [nvarchar](100)   NULL
  ,[Age]            [int]   NULL
  ,[AboutMe]        [nvarchar](max)   NULL
  ,[Views]          [int]   NULL
  ,[UpVotes]        [int]   NULL
  ,[DownVotes]      [int]   NULL,
  CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ( [Id] ASC ) WITH ( PAD_INDEX = OFF,STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF,ALLOW_ROW_LOCKS = ON,ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY])
ON [PRIMARY]


CREATE TABLE [dbo].[Votes] (
[Id] [int] NOT NULL
,[PostId]       [int]   NULL
,[VoteTypeId]   [int]   NULL
,[CreationDate] [datetime]   NULL,
CONSTRAINT [PK_Votes] PRIMARY KEY CLUSTERED ( [Id] ASC ) WITH ( PAD_INDEX = OFF,STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF,ALLOW_ROW_LOCKS = ON,ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY])

ON [PRIMARY]


CREATE TABLE [dbo].[Tags] (
[Id] [int] identity primary key NOT NULL
,[TagName] varchar(255)  NULL
)
ON [PRIMARY]


CREATE TABLE [dbo].[PostTags] (
	PostId int, 
	TagId int
)
ON [PRIMARY]

create unique clustered index PostTagsIndex on PostTags (PostId,TagId)

create table VoteTypes ( Id int primary key, Name varchar(40))

insert VoteTypes 
select 
1, 'AcceptedByOriginator'
union all select
2, 'UpMod'
union all select
3, 'DownMod'
union all select
4, 'Offensive'
union all select
5, 'Favorite'
union all select
6, 'Close'
union all select
7, 'Reopen'
union all select
8, 'BountyStart'
union all select
9, 'BountyClose'
union all select
10, 'Deletion'
union all select
11, 'Undeletion'
union all select
12, 'Spam'
union all select
13, 'InformModerator'

--set identity_insert Posts ON

IF 0 = 0--INDEXES 
  BEGIN 
    SET ANSI_PADDING  OFF 

    IF NOT EXISTS (SELECT * 
                   FROM   dbo.sysindexes 
                   WHERE  id = OBJECT_ID(N'[dbo].[Posts]') 
                          AND name = N'IX_Posts_PostType') 
      CREATE NONCLUSTERED INDEX [IX_Posts_PostType] ON [dbo].[Posts] ( 
            [PostTypeId] ASC) 
      ON [PRIMARY]  
  END 

IF 0 = 0--FULLTEXT  If installed turn this on
  BEGIN 
    IF (OBJECTPROPERTY(OBJECT_ID(N'[dbo].[Posts]'),'TableFullTextCatalogId') = 0) 
      EXEC dbo.sp_fulltext_table 
        @tabname = N'[dbo].[Posts]' , 
        @action = N'create' , 
        @keyname = N'PK_Posts' , 
        @ftcat = N'PostFullText' 

    DECLARE  @lcid INT 

    SELECT @lcid = lcid 
    FROM   MASTER.dbo.syslanguages 
    WHERE  alias = N'English' 

    EXEC dbo.sp_fulltext_column 
      @tabname = N'[dbo].[Posts]' , 
      @colname = N'Body' , 
      @action = N'add' , 
      @language = @lcid 

   EXEC dbo.sp_fulltext_column 
      @tabname = N'[dbo].[Posts]' , 
      @colname = N'Tags' , 
      @action = N'add' , 
      @language = @lcid 

    SELECT @lcid = lcid 
    FROM   MASTER.dbo.syslanguages 
    WHERE  alias = N'English' 

    EXEC dbo.sp_fulltext_column 
      @tabname = N'[dbo].[Posts]' , 
      @colname = N'Title' , 
      @action = N'add' , 
      @language = @lcid 

    EXEC dbo.sp_fulltext_table 
      @tabname = N'[dbo].[Posts]' , 
      @action = N'start_change_tracking' 

    EXEC dbo.sp_fulltext_table 
      @tabname = N'[dbo].[Posts]' , 
      @action = N'start_background_updateindex' 
  END 
