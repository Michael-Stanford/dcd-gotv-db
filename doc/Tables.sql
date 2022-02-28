USE Votrack;

IF object_id('dbo.DistrictsCandidatesHelpers') is not null
  DROP TABLE  dbo.DistrictsCandidatesHelpers
IF object_id('dbo.DistrictsCandidates') is not null
  DROP TABLE  dbo.DistrictsCandidates
IF object_id('dbo.DistrictsCoordinators') is not null
  DROP TABLE  dbo.DistrictsCoordinators
IF object_id('dbo.DistrictsPrecincts') is not null
  DROP TABLE  dbo.DistrictsPrecincts
IF object_id('dbo.Districts') is not null
  DROP TABLE  dbo.Districts
IF object_id('dbo.OrganizationsPrecincts') is not null
  DROP TABLE  dbo.OrganizationsPrecincts
IF object_id('dbo.Organizations') is not null
  DROP TABLE  dbo.Organizations
IF object_id('dbo.PrecinctsChairs') is not null
  DROP TABLE  dbo.PrecinctsChairs
IF object_id('dbo.PrecinctsOrganizers') is not null
  DROP TABLE  dbo.PrecinctsOrganizers
IF object_id('dbo.PrecinctsLeaders') is not null
  DROP TABLE  dbo.PrecinctsLeaders
IF object_id('dbo.PeopleContacts') is not null
  DROP TABLE  dbo.PeopleContacts
IF object_id('dbo.PeoplePrecincts') is not null
  DROP TABLE  dbo.PeoplePrecincts
IF object_id('dbo.PeopleSecurity') is not null
  DROP TABLE  dbo.PeopleSecurity
IF object_id('dbo.PeopleTeams') is not null
  DROP TABLE  dbo.PeopleTeams
IF object_id('dbo.PeopleVolunteerTypes') is not null
  DROP TABLE  dbo.PeopleVolunteerTypes
IF object_id('dbo.People') is not null
  DROP TABLE  dbo.People
IF object_id('dbo.Precincts') is not null
  DROP TABLE  dbo.Precincts
IF object_id('dbo.Counties') is not null
  DROP TABLE  dbo.Counties
IF object_id('dbo.Log') IS not null
  DROP TABLE  dbo.Log
IF object_id('dbo.ListsItems') is not null
  DROP TABLE  dbo.ListsItems
IF object_id('dbo.Lists') is not null
  DROP TABLE  dbo.Lists


IF object_id('dbo.Configuration') is not null
  DROP TABLE  dbo.Configuration
CREATE TABLE  dbo.Configuration
(
     Id             int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,KeyString      nvarchar(254)   NOT null
    ,ValueString    nvarchar(max)   NOT null
    ,Description    nvarchar(max)   null

    CONSTRAINT [configuration keys must be unique] UNIQUE NONCLUSTERED
    (
         KeyString
        ,ArchivedDate
    )
)
GO

IF object_id('dbo.Lists') IS not null
  DROP TABLE  dbo.Lists
CREATE TABLE  dbo.Lists
(
     Id             int             NOT null    PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,ListName       nvarchar(254)   NOT null
    ,TableColumn    nvarchar(254)   null

    CONSTRAINT [list names must be unique] UNIQUE NONCLUSTERED
    (
         ListName
        ,ArchivedDate
    )
)

IF object_id('dbo.ListsItems') is not null
  DROP TABLE  dbo.ListsItems
CREATE TABLE  dbo.ListsItems
(
     Id             int             NOT null    DEFAULT 0 PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,ListId         int             NOT null    --REFERENCES Lists(Id)
    ,ListItem       int             NOT null
    ,ItemName       nvarchar(254)   NOT null
    ,ItemCode       nvarchar(100)   null
    ,ChildListId    int             null        --REFERENCES Lists(Id)

    CONSTRAINT [list item names must be unique (within each list)] UNIQUE NONCLUSTERED
    (
         ListId
        ,ItemName
        ,ArchivedDate
    )
)
GO
CREATE TRIGGER SetId_ListsItems ON dbo.ListsItems
FOR INSERT, UPDATE
AS

UPDATE  A
SET     A.Id = 1000 * INSERTED.ListId + INSERTED.ListItem
FROM    dbo.ListsItems AS A
JOIN    INSERTED ON INSERTED.ListId = A.ListId and INSERTED.ListItem = A.ListItem
GO

SET NOCOUNT ON

-- LogType is list #1.

IF not exists (SELECT * FROM dbo.Lists WHERE ListName = 'LogType')          INSERT dbo.Lists (Id, ListName, TableColumn) VALUES ( 1, 'LogType', 'Log.LogType')

IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 1001)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 1,  1, Rtrim('Error                                               '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 1002)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 1,  2, Rtrim('Automation Activity                                 '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 1003)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 1,  3, Rtrim('User Activity                                       '))


-- ErrorLogging is list #2.

IF not exists (SELECT * FROM dbo.Lists WHERE ListName = 'ErrorLogging')     INSERT dbo.Lists (Id, ListName, TableColumn) VALUES ( 2, 'ErrorLogging', 'BaseData.ErrorLogging')

IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 2001)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 2,  1, Rtrim('NoLogging                                           '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 2002)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 2,  2, Rtrim('LogOnly                                             '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 2003)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 2,  3, Rtrim('LogAndBubble                                        '))


-- GetLogging is list #3.

IF not exists (SELECT * FROM dbo.Lists WHERE ListName = 'GetLogging')       INSERT dbo.Lists (Id, ListName, TableColumn) VALUES ( 3, 'GetLogging', 'BaseData.GetLogging')

IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 3001)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 3,  1, Rtrim('NoLogging                                           '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 3002)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 3,  2, Rtrim('LogGetRowOnly                                       '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 3003)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 3,  3, Rtrim('LogGetRowOrList                                     '))


-- SetRowLogging is list #4.

IF not exists (SELECT * FROM dbo.Lists WHERE ListName = 'SetRowLogging')    INSERT dbo.Lists (Id, ListName, TableColumn) VALUES ( 4, 'SetRowLogging', 'BaseData.SetRowLogging')

IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 4001)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 4,  1, Rtrim('NoLogging                                           '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 4002)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 4,  2, Rtrim('LogSetOnly                                          '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 4003)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 4,  3, Rtrim('LogSetWithData                                      '))


-- ControlType is list #5.

IF not exists (SELECT * FROM dbo.Lists WHERE ListName = 'ControlType')      INSERT dbo.Lists (Id, ListName, TableColumn) VALUES ( 5, 'ControlType', 'SecuredPagesControls.ControlType')

IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5001)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5,  1, Rtrim('System.Object                                       '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5002)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5,  2, Rtrim('System.Web.UI.Page                                  '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5003)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5,  3, Rtrim('System.Web.UI.ScriptManager                         '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5004)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5,  4, Rtrim('System.Web.UI.UpdatePanel                           '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5005)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5,  5, Rtrim('System.Web.UI.UpdateProgress                        '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5006)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5,  6, Rtrim('System.Web.UI.WebControls.BoundField                '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5007)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5,  7, Rtrim('System.Web.UI.WebControls.Button                    '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5008)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5,  8, Rtrim('System.Web.UI.WebControls.ButtonField               '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5009)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5,  9, Rtrim('System.Web.UI.WebControls.CheckBox                  '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5010)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 10, Rtrim('System.Web.UI.WebControls.CheckBoxList              '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5011)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 11, Rtrim('System.Web.UI.WebControls.CommandField              '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5012)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 12, Rtrim('System.Web.UI.WebControls.CompareValidator          '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5013)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 13, Rtrim('System.Web.UI.WebControls.Content                   '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5014)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 14, Rtrim('System.Web.UI.WebControls.ContentPlaceHolder        '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5015)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 15, Rtrim('System.Web.UI.WebControls.CustomValidator           '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5016)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 16, Rtrim('System.Web.UI.WebControls.DropDownList              '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5017)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 17, Rtrim('System.Web.UI.WebControls.FileUpload                '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5018)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 18, Rtrim('System.Web.UI.WebControls.GridView                  '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5019)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 19, Rtrim('System.Web.UI.WebControls.HiddenField               '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5020)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 20, Rtrim('System.Web.UI.WebControls.HyperLink                 '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5021)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 21, Rtrim('System.Web.UI.WebControls.Image                     '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5022)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 22, Rtrim('System.Web.UI.WebControls.ImageButton               '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5023)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 23, Rtrim('System.Web.UI.WebControls.Label                     '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5024)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 24, Rtrim('System.Web.UI.WebControls.LinkButton                '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5025)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 25, Rtrim('System.Web.UI.WebControls.Literal                   '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5026)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 26, Rtrim('System.Web.UI.WebControls.MultiView                 '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5027)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 27, Rtrim('System.Web.UI.WebControls.ObjectDataSource          '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5028)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 28, Rtrim('System.Web.UI.WebControls.Panel                     '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5029)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 29, Rtrim('System.Web.UI.WebControls.Parameter                 '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5030)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 30, Rtrim('System.Web.UI.WebControls.RadioButton               '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5031)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 31, Rtrim('System.Web.UI.WebControls.RadioButtonList           '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5032)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 32, Rtrim('System.Web.UI.WebControls.RangeValidator            '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5033)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 33, Rtrim('System.Web.UI.WebControls.RegularExpressionValidator'))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5034)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 34, Rtrim('System.Web.UI.WebControls.Repeater                  '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5035)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 35, Rtrim('System.Web.UI.WebControls.RequiredFieldValidator    '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5036)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 36, Rtrim('System.Web.UI.WebControls.Table                     '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5037)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 37, Rtrim('System.Web.UI.WebControls.TableCell                 '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5038)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 38, Rtrim('System.Web.UI.WebControls.TableFooterRow            '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5039)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 39, Rtrim('System.Web.UI.WebControls.TableHeaderCell           '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5040)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 40, Rtrim('System.Web.UI.WebControls.TableHeaderRow            '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5041)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 41, Rtrim('System.Web.UI.WebControls.TableRow                  '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5042)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 42, Rtrim('System.Web.UI.WebControls.TextBox                   '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5043)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 43, Rtrim('System.Web.UI.WebControls.TreeView                  '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5044)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 44, Rtrim('System.Web.UI.WebControls.ValidationSummary         '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5045)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 45, Rtrim('System.Web.UI.WebControls.View                      '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5046)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 46, Rtrim('System.Web.UI.WebControls.Wizard                    '))
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 5047)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 5, 47, Rtrim('System.Web.UI.WebControls.WizardStep                '))


-- PropertyValue is list #6.

IF not exists (SELECT * FROM dbo.Lists WHERE ListName = 'PropertyValue')    INSERT dbo.Lists (Id, ListName, TableColumn) VALUES ( 6, 'PropertyValue', 'SecuredPagesControlsPropertiesRoles.PropertyValue')

IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 6001)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 6,  1, 'true')
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 6002)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 6,  2, 'false')


-- PropertyName is list #7.

IF not exists (SELECT * FROM dbo.Lists WHERE ListName = 'PropertyName')     INSERT dbo.Lists (Id, ListName, TableColumn) VALUES ( 7, 'PropertyName', 'SecuredPagesControlsProperties.PropertyName')

IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 7001)                INSERT dbo.ListsItems (ListId, ListItem, ItemName, ChildListId) VALUES ( 7,  1, 'Visible', 6)
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 7002)                INSERT dbo.ListsItems (ListId, ListItem, ItemName, ChildListId) VALUES ( 7,  2, 'Enabled', 6)


-- PropertyName is list #8.

IF not exists (SELECT * FROM dbo.Lists WHERE ListName = 'SecurityType')     INSERT dbo.Lists (Id, ListName, TableColumn) VALUES ( 8, 'SecurityType', 'PeopleSecurity.SecurityType')

IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 8001)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 8,  1, 'Default')
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 8002)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 8,  2, 'Admin')
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 8003)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 8,  3, 'LeadAdmin')
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 8004)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 8,  4, 'SuperAdmin')


-- DistrictType is list #9.

IF not exists (SELECT * FROM dbo.Lists WHERE ListName = 'DistrictType')     INSERT dbo.Lists (Id, ListName, TableColumn) VALUES ( 9, 'DistrictType', 'Districts.DistrictType')

IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 9001)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 9,  1, 'State House'        )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 9002)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 9,  2, 'State Senate'       )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 9003)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 9,  3, 'US Congressional'   )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 9004)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 9,  4, 'State School Board' )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 9005)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 9,  5, 'City Council'       )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 9006)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 9,  6, 'Local School Board' )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 9007)                INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES ( 9,  7, 'County Commission'  )


-- WhereFound is list #10.

IF not exists (SELECT * FROM dbo.Lists WHERE ListName = 'WhereFound')       INSERT dbo.Lists (Id, ListName, TableColumn) VALUES (10, 'WhereFound', 'People.WhereFound')

IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 10001)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (10,  1, 'Other - See Contact Note'   )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 10002)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (10,  2, 'Block Walk'                 )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 10003)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (10,  3, 'Phone Bank'                 )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 10004)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (10,  4, 'Facebook'                   )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 10005)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (10,  5, 'Monthly Meeting'            )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 10006)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (10,  6, 'Social Media'               )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 10007)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (10,  7, 'Precinct Meeting'           )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 10008)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (10,  8, 'Personal Connection'        )
                                                                                                                                               

-- VolunteerType is list #11.

IF not exists (SELECT * FROM dbo.Lists WHERE ListName = 'VolunteerType')    INSERT dbo.Lists (Id, ListName, TableColumn) VALUES (11, 'VolunteerType', 'PeopleVolunteerTypes.VolunteerType')

IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 11001)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (11,  1, 'Other - See Contact Note'   )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 11002)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (11,  2, 'Block Walk'                 )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 11003)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (11,  3, 'Social Media'               )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 11004)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (11,  4, 'Phone Bank'                 )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 11005)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (11,  5, 'Administration'             )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 11006)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (11,  6, 'Postcards'                  )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 11007)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (11,  7, 'Packet Making'              )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 11008)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (11,  8, 'Spanish Speaker'            )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 11009)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (11,  9, 'Project Leader'             )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 11010)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (11, 10, 'Community Relations'        )


-- ContactType is list #12.

IF not exists (SELECT * FROM dbo.Lists WHERE ListName = 'ContactType')      INSERT dbo.Lists (Id, ListName, TableColumn) VALUES (12, 'ContactType', 'PeopleContacts.ContactType')

IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 12001)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (12,  1, 'Other - See Note'   )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 12002)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (12,  2, 'Email'              )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 12003)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (12,  3, 'Phone Call'         )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 12004)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (12,  4, 'Text Message'       )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 12005)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (12,  5, 'Block Walk'         )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 12006)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (12,  6, 'Social Media'       )


-- DataType is list #13.

IF not exists (SELECT * FROM dbo.Lists WHERE ListName = 'DataType')         INSERT dbo.Lists (Id, ListName, TableColumn) VALUES (13, 'DataType', 'People.DataType')

IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 13001)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (13,  1, 'Default'                    )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 13002)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (13,  2, 'Other - See Contact Note'   )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 13003)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (13,  3, 'Imported'                   )


-- OrgType is list #14.

IF not exists (SELECT * FROM dbo.Lists WHERE ListName = 'OrgType')          INSERT dbo.Lists (Id, ListName, TableColumn) VALUES (14, 'OrgType', 'Organizations.OrgType')

IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 14001)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (14,  1, 'Local'      )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 14002)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (14,  2, 'Area'       )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 14003)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (14,  3, 'State'      )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 14004)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (14,  4, 'Regional'   )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 14005)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (14,  5, 'National'   )


-- TeamType is list #15.

IF not exists (SELECT * FROM dbo.Lists WHERE ListName = 'TeamType')         INSERT dbo.Lists (Id, ListName, TableColumn) VALUES (15, 'TeamType', 'PeopleTeams.TeamType')

IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 15001)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (15,  1, 'Other - See Contact Note'   )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 15002)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (15,  2, 'Mentoring'                  )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 15003)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (15,  3, 'Packet Making'              )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 15004)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (15,  4, 'Spanish Speaking'           )
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 15005)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (15,  5, 'VAN List Making'            )


-- MapSpecs is list #16. This list is based (so far) only on the Google Maps BitmapDescriptorFactory object.

IF not exists (SELECT * FROM dbo.Lists WHERE ListName = 'MapSpecs')         INSERT dbo.Lists (Id, ListName, TableColumn) VALUES (16, 'MapSpecs', 'People.MapSpecs')

IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 16001)               INSERT dbo.ListsItems (ListId, ListItem, ItemName, ItemCode) VALUES (16,  1, 'Default','240.0')
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 16002)               INSERT dbo.ListsItems (ListId, ListItem, ItemName, ItemCode) VALUES (16,  2, 'Azure',  '210.0')
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 16003)               INSERT dbo.ListsItems (ListId, ListItem, ItemName, ItemCode) VALUES (16,  3, 'Blue',   '240.0')
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 16004)               INSERT dbo.ListsItems (ListId, ListItem, ItemName, ItemCode) VALUES (16,  4, 'Cyan',   '180.0')
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 16005)               INSERT dbo.ListsItems (ListId, ListItem, ItemName, ItemCode) VALUES (16,  5, 'Green',  '120.0')
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 16006)               INSERT dbo.ListsItems (ListId, ListItem, ItemName, ItemCode) VALUES (16,  6, 'Magenta','300.0')
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 16007)               INSERT dbo.ListsItems (ListId, ListItem, ItemName, ItemCode) VALUES (16,  7, 'Orange', '030.0')
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 16008)               INSERT dbo.ListsItems (ListId, ListItem, ItemName, ItemCode) VALUES (16,  8, 'Red',    '000.0')
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 16009)               INSERT dbo.ListsItems (ListId, ListItem, ItemName, ItemCode) VALUES (16,  9, 'Rose',   '330.0')
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id =160010)               INSERT dbo.ListsItems (ListId, ListItem, ItemName, ItemCode) VALUES (16, 10, 'Violet', '270.0')
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id =160011)               INSERT dbo.ListsItems (ListId, ListItem, ItemName, ItemCode) VALUES (16, 11, 'Yellow', '060.0')


-- VotrackStates is list #17.

IF not exists (SELECT * FROM dbo.Lists WHERE ListName = 'VotrackStates')    INSERT dbo.Lists (Id, ListName, TableColumn) VALUES (17, 'VotrackStates', 'Precincts.ST')

IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 17001)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (17,  1, 'Unknown State')
IF not exists (SELECT * FROM dbo.ListsItems WHERE Id = 17002)               INSERT dbo.ListsItems (ListId, ListItem, ItemName) VALUES (17,  2, 'TX')



IF object_id('dbo.Log') is not null
  DROP TABLE  dbo.Log
CREATE TABLE  dbo.Log
(
     Id             int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,Name           nvarchar(100)   NOT null
    ,LogType        int             NOT null    REFERENCES ListsItems(Id)                   -- See ListsItems.ListId = 1.
    ,Text           nvarchar(max)   NOT null
    ,Data           nvarchar(max)   null
)

IF object_id('dbo.Counties') is not null
  DROP TABLE  dbo.Counties
CREATE TABLE  dbo.Counties
(
     Id             int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,ST             int             NOT null    DEFAULT 17002 REFERENCES ListsItems(Id)     -- See ListsItems.ListId = 17.
    ,CountyName     nvarchar(100)   NOT null

    CONSTRAINT [counties must be unique (within each state)] UNIQUE NONCLUSTERED
    (
         ST
        ,CountyName
        ,ArchivedDate
    )
)
        INSERT dbo.Counties (ST, CountyName) VALUES (17001,'Unknown County')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Anderson')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Andrews')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Angelina')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Aransas')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Archer')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Armstrong')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Atascosa')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Austin')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Bailey')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Bandera')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Bastrop')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Baylor')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Bee')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Bell')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Bexar')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Blanco')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Bosque')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Bowie')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Brazoria')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Brazos')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Brewster')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Briscoe')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Brooks')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Brown')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Burleson')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Burnet')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Caldwell')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Calhoun')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Callahan')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Cameron')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Camp')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Carson')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Cass')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Castro')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Chambers')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Cherokee')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Childress')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Clay')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Cochran')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Coke')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Coleman')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Collin')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Collingsworth')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Colorado')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Comal')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Comanche')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Concho')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Cooke')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Coryell')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Crane')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Crosby')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Dallam')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Dallas')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Dawson')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Deaf Smith')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Delta')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Denton')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'DeWitt')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Dickens')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Dimmit')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Donley')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Duval')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Eastland')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Ector')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'El Paso')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Ellis')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Erath')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Falls')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Fannin')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Fayette')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Fisher')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Floyd')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Foard')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Fort Bend')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Franklin')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Freestone')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Frio')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Gaines')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Galveston')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Garza')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Gillespie')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Goliad')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Gonzales')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Gray')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Grayson')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Gregg')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Grimes')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Guadalupe')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Hale')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Hall')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Hamilton')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Hansford')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Hardeman')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Hardin')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Harris')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Harrison')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Hartley')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Haskell')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Hays')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Hemphill')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Henderson')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Hidalgo')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Hill')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Hockley')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Hood')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Hopkins')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Houston')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Howard')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Hudspeth')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Hunt')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Hutchinson')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Irion')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Jack')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Jackson')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Jasper')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Jefferson')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Jim Wells')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Johnson')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Jones')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Karnes')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Kaufman')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Kendall')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Kent')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Kerr')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Kimble')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Kinney')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Kleberg')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Knox')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'La Salle')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Lamar')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Lamb')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Lampasas')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Lavaca')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Lee')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Leon')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Liberty')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Limestone')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Lipscomb')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Live Oak')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Llano')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Lubbock')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Lynn')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Madison')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Marion')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Martin')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Mason')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Matagorda')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Maverick')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'McCulloch')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'McLennan')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Medina')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Menard')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Midland')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Milam')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Mills')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Mitchell')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Montague')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Montgomery')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Moore')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Morris')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Nacogdoches')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Navarro')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Newton')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Nolan')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Nueces')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Ochiltree')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Oldham')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Orange')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Palo Pinto')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Panola')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Parker')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Parmer')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Patricio')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Pecos')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Polk')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Potter')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Presidio')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Rains')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Randall')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Reagan')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Real')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Red River')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Reeves')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Refugio')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Roberts')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Robertson')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Rockwall')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Runnels')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Rusk')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Sabine')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'San Augustine')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'San Jacinto')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'San Patricio')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'San Saba')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Schleicher')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Scurry')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Shackelford')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Shelby')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Sherman')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Smith')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Somervell')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Starr')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Stephens')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Sterling')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Sutton')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Swisher')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Tarrant')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Taylor')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Terry')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Titus')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Tom Green')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Travis')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Trinity')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Tyler')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Upshur')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Upton')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Uvalde')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Val Verde')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Van Zandt')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Victoria')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Walker')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Waller')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Ward')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Washington')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Webb')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Wharton')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Wheeler')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Wichita')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Wilbarger')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Willacy')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Williamson')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Wilson')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Winkler')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Wise')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Wood')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'WoodReal')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Young')
        INSERT dbo.Counties (ST, CountyName) VALUES (17002,'Zavala')

IF object_id('dbo.StatesCountiesCities') is not null
  DROP TABLE  dbo.StatesCountiesCities
CREATE TABLE  dbo.StatesCountiesCities
(
     Id             int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,ST             nvarchar(100)   NOT null
    ,County         nvarchar(100)   NOT null
    ,City           nvarchar(100)   NOT null

    CONSTRAINT [cities and counties must be unique (within each state)] UNIQUE NONCLUSTERED
    (
         ST
        ,County
        ,City
        ,ArchivedDate
    )
)
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Anderson','Palestine')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Andrews','Andrews')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Angelina','Burke')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Angelina','Diboll')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Angelina','Hudson')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Angelina','Huntington')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Angelina','Lufkin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Angelina','Zavalla')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Aransas','Aransas Pass')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Aransas','Corpus Christi')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Aransas','Rockport')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Archer','Archer City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Archer','Holliday')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Archer','Scotland')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Armstrong','Claude')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Atascosa','Charlotte')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Atascosa','Jourdanton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Atascosa','Lytle')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Atascosa','Pleasanton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Atascosa','Poteet')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Austin','Bellville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Austin','Brazos Country')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Austin','Industry')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Austin','Sealy')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Austin','Wallis')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bailey','Muleshoe')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bandera','Bandera')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bastrop','Bastrop')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bastrop','Elgin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bastrop','Smithville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Baylor','Seymour')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bee','Beeville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bell','Bartlett')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bell','Belton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bell','Copperas Cover')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bell','Harker Heights')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bell','Killeen')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bell','Little River-Academy')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bell','Morgan''s Point Resort')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bell','Nolanville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bell','Temple')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bell','Troy')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Alamo Heights')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Balcones Heights')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Castle Hills')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Cibolo')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Converse')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Elmendorf')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Fair Oaks Ranch')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Grey Forest')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Helotes')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Hill Country Village')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Kirby')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Leon Valley')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Live Oak')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Lytle')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Olmos Park')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','San Antonio')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Sandy Oaks')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Schertz')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Selma')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Shavano Park')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Somerset')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Terrell Hills')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Universal City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Von Ormy')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bexar','Windcrest')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Blanco','Blanco')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Blanco','Johnson City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bosque','Clifton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bosque','Cranfills Gap')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bosque','Iredell')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bosque','Meridian')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bosque','Morgan')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bosque','Valley Mills')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bosque','Walnut Springs')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bowie','DeKalb')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bowie','Hooks')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bowie','Leary')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bowie','Maud')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bowie','Nash')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bowie','New Boston')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bowie','Red Lick')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bowie','Redwater')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bowie','Texarkana')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Bowie','Wake Village')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazoria','Alvin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazoria','Angleton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazoria','Brazoria')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazoria','Brookside Village')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazoria','Clute')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazoria','Danbury')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazoria','Freeport')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazoria','Friendswood')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazoria','Lake Jackson')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazoria','Liverpool')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazoria','Manvel')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazoria','Oyster Creek')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazoria','Pearland')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazoria','Richwood')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazoria','Sandy Point')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazoria','Surfside Beach')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazoria','Sweeny')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazoria','West Columbia')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazos','Bryan')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazos','College Station')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brazos','Wixon Valley')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brewster','Alpine')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Briscoe','Quitaque')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Briscoe','Silverton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brooks','Falfurrias')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brown','Bangs')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brown','Brownwood')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Brown','Early')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Burleson','Caldwell')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Burleson','Snook')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Burleson','Somerville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Burnet','Bertram')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Burnet','Burnet')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Burnet','Cottonwood Shores')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Burnet','Granite Shoals')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Burnet','Highland Haven')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Burnet','Horseshoe Bay')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Burnet','Marble Falls')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Burnet','Meadowlakes')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Caldwell','Lockhart')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Caldwell','Luling')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Caldwell','Martindale')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Caldwell','Mustang Ridge')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Caldwell','Niederwald')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Caldwell','San Marcos')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Caldwell','Uhland')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Calhoun','Point Comfort')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Calhoun','Port Lavaca')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Calhoun','Seadrift')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Callahan','Baird')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Callahan','Clyde')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cameron','Brownsville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cameron','Harlingen')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cameron','La Feria')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cameron','Los Fresnos')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cameron','Palm Valley')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cameron','Port Isabel')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cameron','Rio Hondo')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cameron','San Benito')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Camp','Pittsburg')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Carson','Fritch')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cass','Atlanta')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cass','Hughes Springs')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cass','Linden')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cass','Queen City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Castro','Dimmitt')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Castro','Hart')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Castro','Nazareth')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Chambers','Anahuac')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Chambers','Baytown')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Chambers','Beach City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Chambers','Cove')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Chambers','Mont Belvieu')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Chambers','Old River-Winfree')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Chambers','Seabrook')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Chambers','Shoreacres')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Chambers','Texas City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cherokee','Gallatin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cherokee','Jacksonville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cherokee','New Summerfield')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cherokee','Reklaw')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cherokee','Rusk')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cherokee','Troup')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Childress','Childress')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Clay','Bellevue')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Clay','Byers')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Clay','Dean')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Clay','Henrietta')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Clay','Jolly')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Clay','Petrolia')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cochran','Morton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Coke','Blackwell')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Coke','Robert Lee')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Coleman','Coleman')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Coleman','Novice')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Allen')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Anna')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Blue Ridge')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Carrollton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Celina')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Dallas')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Farmersville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Frisco')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Garland')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Josephine')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Lavon')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Lowry Crossing')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Lucas')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','McKinney')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Melissa')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Murphy')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Nevada')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Parker')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Plano')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Princeton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Richardson')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Royse City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Sachse')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Van Alstyne')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Weston')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collin','Wylie')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Collingsworth','Wellington')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Colorado','Columbus')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Colorado','Eagle Lake')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Colorado','Weimar')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Comal','Bulverde')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Comal','Fair Oaks Ranch')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Comal','Garden Ridge')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Comal','New Braunfels')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Comal','San Antonio')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Comal','Schertz')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Comal','Selma')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Comal','Spring Branch')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Comanche','Comanche')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Comanche','De Leon')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Concho','Eden')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cooke','Callisburg')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cooke','Gainesville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cooke','Lindsay')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cooke','Muenster')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Cooke','Valley View')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Coryell','Copperas Cove')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Coryell','Gatesville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Coryell','McGregor')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Coryell','Oglesby')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Crane','Crane')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Crosby','Crosbyton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Crosby','Lorenzo')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Crosby','Ralls')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallam','Dalhart')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Addison')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Balch Springs')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Carrollton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Cedar Hill')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Cockrell Hill')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Combine')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Coppell')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Dallas')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','DeSoto')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Duncanville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Farmers Branch')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Ferris')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Garland')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Glenn Heights')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Grand Prairie')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Grapevine')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Hutchins')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Irving')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Lancaster')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Mesquite')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Ovilla')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Richardson')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Rowlett')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Sachse')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Seagoville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','University Park')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Wilmer')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dallas','Wylie')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dawson','Ackerly')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dawson','Lamesa')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dawson','Los Ybanez')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dawson','O''Donnell')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Deaf Smith','Hereford')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Delta','Cooper')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Delta','Pecan Gap')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Argyle')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Aubrey')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Carrollton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Celina')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Coppell')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Corinth')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Dallas')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Denton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Fort Worth')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Frisco')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Grapevine')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Haslet')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Highland Village')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Justin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Krugerville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Krum')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Lake Dallas')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Lakewood Village')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Lewisville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Little Elm')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Oak Point')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Pilot Point')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Plano')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Roanoke')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Sanger')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','Southlake')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Denton','The Colony')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','DeWitt','Cuero')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','DeWitt','Nordheim')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','DeWitt','Yoakum')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','DeWitt','Yorktown')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dickens','Dickens')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dickens','Spur')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dimmit','Asherton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dimmit','Big Wells')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Dimmit','Carrizo Springs')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Donley','Clarendon')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Donley','Hedley')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Donley','Howardwick')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Duval','Benavides')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Duval','Freer')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Duval','San Diego')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Eastland','Cisco')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Eastland','Eastland')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Eastland','Gorman')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Eastland','Ranger')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Ector','Goldsmith')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Ector','Odessa')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','El Paso','El Paso')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','El Paso','Horizon City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','El Paso','San Elizario')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','El Paso','Socorro')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Ellis','Bardwell')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Ellis','Cedar Hill')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Ellis','Ennis')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Ellis','Ferris')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Ellis','Glenn Heights')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Ellis','Grand Praire')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Ellis','Mansfield')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Ellis','Maypearl')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Ellis','Midlothian')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Ellis','Oak Leaf')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Ellis','Ovilla')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Ellis','Pecan Hill')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Ellis','Red Oak')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Ellis','Waxahachie')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Erath','Dublin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Erath','Stephenville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Falls','Bruceville-Eddy')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Falls','Golinda')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Falls','Lott')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Falls','Marlin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Falls','Rosebud')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fannin','Bailey')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fannin','Bonham')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fannin','Ector')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fannin','Honey Grove')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fannin','Leonard')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fannin','Pecan Gap')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fannin','Ravenna')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fannin','Savoy')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fannin','Trenton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fannin','Whitewright')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fayette','Carmine')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fayette','Fayetteville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fayette','La Grange')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fayette','Schulenburg')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fisher','Hamlin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fisher','Roby')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fisher','Rotan')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Floyd','Floydada')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Foard','Crowell')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fort Bend','Arcola')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fort Bend','Beasley')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fort Bend','Fulshear')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fort Bend','Houston')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fort Bend','Katy')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fort Bend','Kendleton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fort Bend','Meadows Place')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fort Bend','Missouri City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fort Bend','Needville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fort Bend','Orchard')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fort Bend','Pearland')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fort Bend','Richmond')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fort Bend','Rosenberg')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fort Bend','Simonton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fort Bend','Stafford')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fort Bend','Sugar Land')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Fort Bend','Weston Lakes')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Franklin','Winnsboro')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Freestone','Fairfield')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Freestone','Teague')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Frio','Dilley')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Frio','Pearsall')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Gaines','Seagraves')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Gaines','Seminole')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Galveston','Bayou Vista')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Galveston','Clear Lake Shores')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Galveston','Dickinson')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Galveston','Friendswood')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Galveston','Galveston')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Galveston','Hitchcock')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Galveston','Jamaica Beach')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Galveston','Kemah')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Galveston','La Marque')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Galveston','League City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Galveston','Santa Fe')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Galveston','Texas City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Garza','Post')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Gillespie','Fredericksburg')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Goliad','Goliad')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Gonzales','Gonzales')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Gonzales','Nixon')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Gonzales','Smiley')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Gonzales','Waelder')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Gray','Pampa')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Grayson','Denison')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Grayson','Dorchester')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Grayson','Gunter')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Grayson','Knollwood')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Grayson','Sadler')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Grayson','Sherman')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Grayson','Southmayd')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Grayson','Tom Bean')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Grayson','Trenton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Grayson','Van Alstyne')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Grayson','Whitesboro')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Grayson','Whitewright')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Gregg','Clarksville City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Gregg','East Mountain')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Gregg','Easton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Gregg','Gladewater')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Gregg','Kilgore')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Gregg','Lakeport')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Gregg','Longview')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Gregg','Warren City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Gregg','White Oak')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Grimes','Anderson')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Grimes','Bedias')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Grimes','Iola')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Grimes','Navasota')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Grimes','Todd Mission')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Guadalupe','Cibolo')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Guadalupe','Kingsbury')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Guadalupe','Marion')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Guadalupe','New Berlin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Guadalupe','New Braunfels')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Guadalupe','San Marcos')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Guadalupe','Santa Clara')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Guadalupe','Schertz')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Guadalupe','Seguin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Guadalupe','Selma')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Guadalupe','Staples')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Guadalupe','Universal City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hale','Abernathy')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hale','Hale Center')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hale','Petersburg')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hale','Plainview')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hall','Memphis')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hall','Turkey')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hamilton','Hamilton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hamilton','Hico')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hansford','Gruver')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hansford','Spearman')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hardeman','Chillicothe')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hardeman','Quanah')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hardin','Kountze')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hardin','Lumberton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hardin','Rose Hill Acres')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hardin','Silsbee')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hardin','Sour Lake')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Baytown')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Bellaire')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Bunker Hill Village')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Deer Park')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','El Lago')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Friendswood')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Galena Park')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Hedwig Village')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Hilshire Village')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Houston')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Humble')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Hunters Creek Village')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Jacinto City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Jersey Village')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Katy')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','La Porte')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','League City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Missouri City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Morgan''s Point')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Nassau Bay')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Pasadena')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Pearland')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Piney Point Village')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Seabrook')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Shoreacres')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','South Houston')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Southside Place')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Spring Valley Village')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Stafford')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Taylor Lake Village')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Tomball')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Waller')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','Webster')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harris','West University Place')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harrison','Hallsville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harrison','Longview')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harrison','Marshall')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harrison','Scottsville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harrison','Uncertain')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Harrison','Waskom')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hartley','Channing')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hartley','Dalhart')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Haskell','Haskell')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Haskell','O''Brien')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Haskell','Stamford')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Haskell','Weinert')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hays','Austin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hays','Buda')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hays','Dripping Springs')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hays','Hays')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hays','Kyle')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hays','Mountain City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hays','Niederwald')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hays','San Marcos')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hays','Uhland')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hays','Wimberley')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hays','Woodcreek')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hemphill','Canadian')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Henderson','Athens')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Henderson','Brownsboro')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Henderson','Chandler')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Henderson','Eustace')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Henderson','Gun Barrel City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Henderson','Log Cabin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Henderson','Malakoff')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Henderson','Moore Station')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Henderson','Murchison')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Henderson','Poynor')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Henderson','Seven Points')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Henderson','Star Harbor')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Henderson','Tool')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Henderson','Trinidad')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','Alamo')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','Alton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','Donna')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','Edcouch')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','Edinburg')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','Elsa')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','Granjeno')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','Hidalgo')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','La Joya')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','La Villa')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','McAllen')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','Mercedes')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','Mission')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','Palmhurst')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','Palmview')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','Penitas')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','Pharr')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','Progreso')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','Progreso Lakes')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','San Juan')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','Sullivan City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hidalgo','Weslaco')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hill','Abbott')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hill','Aquilla')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hill','Covington')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hill','Hillsboro')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hill','Hubbard')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hill','Itasca')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hill','Mount Calm')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hockley','Anton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hockley','Levelland')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hockley','Ropesville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hockley','Sundown')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hood','Brazos Bend')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hood','Cresson')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hood','DeCordova')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hood','Granbury')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hood','Lipan')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hood','Tolar')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hopkins','Cumby')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hopkins','Sulphur Springs')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Houston','Crockett')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Houston','Grapeland')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Houston','Kennard')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Houston','Latexo')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Houston','Lovelady')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Howard','Big Spring')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Howard','Forsan')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hudspeth','Dell City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hunt','Caddo Mills')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hunt','Campbell')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hunt','Celeste')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hunt','Commerce')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hunt','Greenville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hunt','Hawk Cove')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hunt','Josephine')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hunt','Lone Oak')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hunt','Quinlan')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hunt','Royse City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hunt','Union Valley')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hunt','West Tawakoni')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hunt','Wolfe City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hutchinson','Borger')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hutchinson','Fritch')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Hutchinson','Stinnett')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Irion','Mertzon')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jack','Bryson')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jack','Jacksboro')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jackson','Edna')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jackson','Ganado')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jackson','La Ward')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jasper','Browndell')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jasper','Jasper')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jasper','Kirbyville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jefferson','Beaumont')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jefferson','Bevil Oaks')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jefferson','China')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jefferson','Groves')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jefferson','Nederland')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jefferson','Nome')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jefferson','Port Arthur')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jefferson','Port Neches')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jefferson','Taylor Landing')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jim Wells','Alice')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jim Wells','Orange Grove')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jim Wells','Premont')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jim Wells','San Diego')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Johnson','Alvarado')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Johnson','Briaroaks')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Johnson','Burleson')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Johnson','Cleburne')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Johnson','Coyote Flats')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Johnson','Cresson')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Johnson','Crowley')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Johnson','Godley')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Johnson','Grandview')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Johnson','Joshua')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Johnson','Keene')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Johnson','Mansfield')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Johnson','Rio Vista')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jones','Abilene')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jones','Anson')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jones','Hamlin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jones','Hawley')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jones','Lueders')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Jones','Stamford')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Karnes','Falls City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Karnes','Karnes City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Karnes','Kenedy')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kaufman','Combine')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kaufman','Cottonwood')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kaufman','Crandall')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kaufman','Dallas')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kaufman','Forney')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kaufman','Heath')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kaufman','Kaufman')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kaufman','Kemp')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kaufman','Mesquite')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kaufman','Seagovill')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kaufman','Seven Points')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kaufman','Terrell')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kendall','Boerne')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kendall','Fair Oaks Ranch')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kent','Jayton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kerr','Ingram')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kerr','Kerrville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kimble','Junction')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kinney','Brackettville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kinney','Spofford')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kleberg','Corpus Christi')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Kleberg','Kingsville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Knox','Benjamin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Knox','Goree')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Knox','Munday')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','La Salle','Cotulla')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','La Salle','Encinal')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lamar','Blossom')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lamar','Deport')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lamar','Paris')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lamar','Reno')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lamar','Roxton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lamar','Sun Valley')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lamar','Toco')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lamb','Amherst')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lamb','Earth')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lamb','Littlefield')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lamb','Olton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lamb','Sudan')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lampasas','Copperas Cove')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lampasas','Kempner')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lampasas','Lampasas')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lampasas','Lometa')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lavaca','Hallettsville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lavaca','Shiner')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lavaca','Yoakum')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lee','Giddings')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Leon','Buffalo')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Leon','Centerville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Leon','Jewett')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Leon','Leona')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Leon','Marquez')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Liberty','Ames')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Liberty','Cleveland')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Liberty','Daisetta')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Liberty','Dayton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Liberty','Dayton Lakes')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Liberty','Devers')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Liberty','Hardin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Liberty','Liberty')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Liberty','Mont Belvieu')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Liberty','Nome')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Liberty','North Cleveland')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Liberty','Old River-Winfree')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Liberty','Plum Grove')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Limestone','Groesbeck')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Limestone','Mart')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Limestone','Mexia')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lipscomb','Follett')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lipscomb','Higgins')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Live Oak','George West')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Live Oak','Three Rivers')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Llano','Horseshoe Bay')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Llano','Llano')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Llano','Sunrise Beach Village')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lubbock','Abernathy')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lubbock','Idalou')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lubbock','Lubbock')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lubbock','Shallowater')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lubbock','Slaton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lubbock','Wolfforth')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lynn','New Home')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lynn','O''Donnell')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lynn','Tahoka')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Lynn','Wilson')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Madison','Madisonville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Madison','Midway')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Marion','Jefferson')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Martin','Ackerly')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Martin','Midland')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Martin','Stanton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Mason','Mason')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Matagorda','Bay City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Matagorda','Blessing')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Matagorda','Palacios')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Maverick','Eagle Pass')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McCulloch','Brady')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McLennan','Bellmead')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McLennan','Beverly Hills')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McLennan','Bruceville-Eddy')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McLennan','Gholson')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McLennan','Golinda')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McLennan','Hallsburg')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McLennan','Hewitt')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McLennan','Lacy-Lakeview')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McLennan','Leroy')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McLennan','Lorena')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McLennan','Mart')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McLennan','McGregor')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McLennan','Moody')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McLennan','Riesel')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McLennan','Robinson')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McLennan','Ross')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McLennan','Valley Mills')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McLennan','Waco')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McLennan','West')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','McLennan','Woodway')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Medina','Castroville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Medina','Devine')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Medina','Hondo')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Medina','LaCoste')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Medina','Lytle')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Medina','Natalia')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Medina','San Antonio')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Menard','Menard')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Midland','Midland')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Midland','Odessa')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Milam','Cameron')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Milam','Milano')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Milam','Rockdale')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Milam','Thorndale')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Mills','Goldthwaite')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Mitchell','Colorado City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Mitchell','Westbrook')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Montague','Bowie')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Montague','Nocona')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Montague','Saint Jo')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Montgomery','Conroe')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Montgomery','Cut and Shoot')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Montgomery','Houston')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Montgomery','Magnolia')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Montgomery','Montgomery')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Montgomery','Oak Ridge North')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Montgomery','Panorama Village')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Montgomery','Patton Village')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Montgomery','Shenandoah')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Montgomery','Splendora')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Montgomery','Willis')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Montgomery','Woodbranch')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Moore','Cactus')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Moore','Dumas')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Moore','Sunray')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Morris','Daingerfield')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Morris','Hughes Springs')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Morris','Lone Star')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Morris','Naples')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Morris','Omaha')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Nacogdoches','Appleby')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Nacogdoches','Chireno')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Nacogdoches','Cushing')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Nacogdoches','Garrison')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Nacogdoches','Nacogdoches')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Navarro','Angus')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Navarro','Barry')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Navarro','Corsicana')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Navarro','Eureka')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Navarro','Frost')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Navarro','Goodlow')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Navarro','Kerens')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Navarro','Rice')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Newton','Newton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Nolan','Blackwell')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Nolan','Roscoe')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Nolan','Sweetwater')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Nueces','Agua Dulce')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Nueces','Aransas Pass')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Nueces','Bishop')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Nueces','Corpus Christi')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Nueces','Driscoll')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Nueces','Ingleside')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Nueces','Petronila')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Nueces','Port Aransas')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Nueces','Portland')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Nueces','Robstown')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Nueces','San Patricio')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Ochiltree','Perryton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Oldham','Adrian')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Oldham','Vega')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Orange','Bridge City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Orange','Orange')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Orange','Pine Forest')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Orange','Pinehurst')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Orange','Port Arthur')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Orange','Rose City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Orange','Vidor')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Orange','West Orange')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Palo Pinto','Gordon')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Palo Pinto','Graford')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Palo Pinto','Mineral Wells')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Palo Pinto','Mingus')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Palo Pinto','Strawn')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Panola','Beckville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Panola','Carthage')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Panola','Tatum')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Parker','Aledo')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Parker','Azle')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Parker','Cool')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Parker','Cresson')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Parker','Fort Worth')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Parker','Hudson Oaks')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Parker','Mineral Wells')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Parker','Reno')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Parker','Springtown')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Parker','Weatherford')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Parker','Willow Park')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Parmer','Bovina')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Parmer','Farwell')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Parmer','Friona')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Patricio','San')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Pecos','Fort Stockton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Pecos','Iraan')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Polk','Goodrich')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Polk','Onalaska')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Polk','Seven Oaks')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Potter','Amarillo')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Presidio','Marfa')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Presidio','Presidio')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rains','East Tawakoni')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rains','Emory')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rains','Point')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Randall','Amarillo')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Randall','Canyon')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Reagan','Big Lake')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Real','Leakey')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Red River','Avery')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Red River','Bogata')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Red River','Clarksville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Red River','Deport')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Reeves','Balmorhea')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Reeves','Pecos')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Refugio','Austwell')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Roberts','Miami')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Robertson','Bremond')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Robertson','Calvert')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Robertson','Franklin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Robertson','Hearne')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rockwall','Dallas')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rockwall','Fate')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rockwall','Garland')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rockwall','Heath')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rockwall','McLendon-Chisholm')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rockwall','Mobile City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rockwall','Rockwall')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rockwall','Rowlett')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rockwall','Royse City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rockwall','Wylie')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Runnels','Ballinger')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Runnels','Miles')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Runnels','Winters')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rusk','Easton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rusk','Henderson')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rusk','Kilgore')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rusk','Mount Enterprise')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rusk','New London')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rusk','Overton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rusk','Reklaw')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Rusk','Tatum')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Sabine','Hemphill')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Sabine','Pineland')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','San Augustine','San Augustine')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','San Jacinto','Coldspring')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','San Jacinto','Point Blank')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','San Jacinto','Shepherd')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','San Patricio','Aransas Pass')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','San Patricio','Corpus Christi')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','San Patricio','Gregory')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','San Patricio','Ingleside')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','San Patricio','Ingleside on the Bay')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','San Patricio','Mathis')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','San Patricio','Odem')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','San Patricio','San Patricio')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','San Patricio','Sinton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','San Patricio','Taft')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','San Saba','San Saba')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Schleicher','Eldorado')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Scurry','Snyder')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Shackelford','Albany')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Shackelford','Lueders')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Shackelford','Moran')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Shelby','Center')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Shelby','Huxley')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Shelby','Joaquin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Shelby','Timpson')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Sherman','Stratford')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Sherman','Texhoma')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Smith','Arp')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Smith','Hideaway')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Smith','Lindale')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Smith','New Chapel Hill')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Smith','Noonday')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Smith','Overton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Smith','Troup')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Smith','Tyler')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Smith','Whitehouse')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Somervell','Glen Rose')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Starr','Escobares')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Starr','La Grulla')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Starr','Rio Grande City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Starr','Roma')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Stephens','Breckenridge')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Sterling','Sterling City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Sutton','Sonora')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Swisher','Kress')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Swisher','Tulia')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Arlington')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Azle')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Bedford')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Benbrook')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Blue Mound')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Burleson')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Colleyville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Crowley')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Dalworthington Gardens')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Euless')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Everman')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Forest Hill')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Fort Worth')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Grand Prairie')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Grapevine')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Haltom City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Haslet')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Hurst')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Keller')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Kennedale')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Lake Worth')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Mansfield')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Newark')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','North Richland Hills')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Pelican Bay')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Reno')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Richland Hills')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','River Oaks')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Saginaw')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Sansom Park')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Southlake')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Watauga')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','Westworth Village')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tarrant','White Settlement')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Taylor','Abilene')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Taylor','Tuscola')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Taylor','Tye')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Terry','Brownfield')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Terry','Wellman')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Titus','Mount Pleasant')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Titus','Talco')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Titus','Winfield')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tom Green','San Angelo')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Travis','Austin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Travis','Bee Cave')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Travis','Cedar Park')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Travis','Creedmoor')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Travis','Elgin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Travis','Jonestown')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Travis','Lago Vista')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Travis','Lakeway')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Travis','Leander')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Travis','Manor')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Travis','Mustang Ridge')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Travis','Pflugerville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Travis','Rollingwood')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Travis','Sunset Valley')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Travis','West Lake Hills')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Trinity','Groveton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Trinity','Trinity')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tyler','Colmesneil')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Tyler','Ivanhoe')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Upshur','Clarksville City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Upshur','East Mountain')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Upshur','Gilmer')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Upshur','Gladewater')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Upshur','Ore City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Upshur','Union Grove')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Upshur','Warren City')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Upton','McCamey')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Upton','Rankin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Uvalde','Sabinal')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Uvalde','Uvalde')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Val Verde','Del Rio')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Van Zandt','Canton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Van Zandt','Edom')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Van Zandt','Fruitvale')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Van Zandt','Grand Saline')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Van Zandt','Van')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Van Zandt','Wills Point')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Victoria','Victoria')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Walker','Huntsville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Walker','New Waverly')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Walker','Riverside')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Waller','Brookshire')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Waller','Hempstead')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Waller','Katy')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Waller','Pattison')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Waller','Prairie View')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Waller','Waller')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Ward','Barstow')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Ward','Monahans')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Washington','Brenham')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Webb','El Cenizo')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Webb','Laredo')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Webb','Rio Bravo')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wharton','East Bernard')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wharton','El Campo')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wharton','Wharton')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wheeler','Mobeetie')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wheeler','Shamrock')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wheeler','Wheeler')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wichita','Burkburnett')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wichita','Cashion Community')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wichita','Electra')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wichita','Iowa Park')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wichita','Wichita Falls')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wilbarger','Vernon')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Willacy','Lyford')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Willacy','Raymondville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Willacy','San Perlita')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Williamson','Austin')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Williamson','Bartlett')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Williamson','Cedar Park')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Williamson','Coupland')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Williamson','Florence')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Williamson','Georgetown')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Williamson','Granger')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Williamson','Hutto')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Williamson','Jarrell')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Williamson','Leander')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Williamson','Liberty Hill')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Williamson','Pflugerville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Williamson','Round Rock')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Williamson','Taylor')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Williamson','Thordale')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Williamson','Thrall')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Williamson','Weir')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wilson','Floresville')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wilson','La Vernia')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wilson','Nixon')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wilson','Stockdale')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Winkler','Kermit')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Winkler','Monahans')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Winkler','Wink')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wise','Aurora')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wise','Bridgeport')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wise','Chico')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wise','Decatur')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wise','Fort Worth')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wise','Lake Bridgeport')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wise','New Fairview')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wise','Newark')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wise','Paradise')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wise','Rhome')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wise','Runaway Bay')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wood','Hawkins')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wood','Mineola')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wood','Quitman')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Wood','Winnsboro')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','WoodReal','Camp')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Young','Graham')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Young','Newcastle')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Young','Olney')
        INSERT dbo.StatesCountiesCities (ST, County, City) VALUES ('TX','Zavala','Crystal City')

IF object_id('dbo.Districts') is not null
  DROP TABLE  dbo.Districts
CREATE TABLE  dbo.Districts
(
     Id             int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,NumberName     nvarchar(100)   NOT null
    ,DistrictType   int             NOT null    REFERENCES ListsItems(Id)                   -- See ListsItems.ListId = 9.
    ,DistrictNotes  nvarchar(max)   null

    CONSTRAINT [district numbers must be unique (within each district type)] UNIQUE NONCLUSTERED
    (
         NumberName
        ,DistrictType
        ,ArchivedDate
    )
)

IF object_id('dbo.Organizations') is not null
  DROP TABLE  dbo.Organizations
CREATE TABLE  dbo.Organizations
(
     Id             int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,OrgName        nvarchar(100)   NOT null
    ,OrgType        int             NOT null    DEFAULT 14001 REFERENCES ListsItems(Id)     -- See ListsItems.ListId = 14.
    ,OrgNotes       nvarchar(max)   null

    CONSTRAINT [organization names must be unique] UNIQUE NONCLUSTERED
    (
         OrgName
        ,ArchivedDate
    )
)

IF object_id('dbo.Precincts') is not null
  DROP TABLE  dbo.Precincts
CREATE TABLE  dbo.Precincts
(
     Id             int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,ST             int             NOT null    DEFAULT 17002 REFERENCES ListsItems(Id)     -- See ListsItems.ListId = 17.
    ,County         int             NOT null    REFERENCES Counties(Id)
    ,NumberName     nvarchar(100)   NOT null
    ,DoorCount      int             NOT null
    ,PrecinctNotes  nvarchar(max)   null

    CONSTRAINT [precinct numbers must be unique (within each county in each state)] UNIQUE NONCLUSTERED
    (
         ST
        ,County
        ,NumberName
        ,ArchivedDate
    )
)
INSERT dbo.Precincts (ST, County, NumberName, DoorCount, PrecinctNotes) VALUES (17001, 1, 'Unknown Precinct', 0, 'Used only for unverified people')

IF object_id('dbo.DistrictsPrecincts') is not null
  DROP TABLE  dbo.DistrictsPrecincts
CREATE TABLE  dbo.DistrictsPrecincts
(
     Id             int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,DistrictId     int             NOT null    REFERENCES Districts(Id)
    ,PrecinctId     int             NOT null    REFERENCES Precincts(Id)

    CONSTRAINT [districts may have only one of each precinct] UNIQUE NONCLUSTERED
    (
         DistrictId
        ,PrecinctId
        ,ArchivedDate
    )
)

IF object_id('dbo.OrganizationsPrecincts') is not null
  DROP TABLE  dbo.OrganizationsPrecincts
CREATE TABLE  dbo.OrganizationsPrecincts
(
     Id             int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,OrganizationId int             NOT null    REFERENCES Organizations(Id)
    ,PrecinctId     int             NOT null    REFERENCES Precincts(Id)

    CONSTRAINT [organizations may have only one of each precinct] UNIQUE NONCLUSTERED
    (
         OrganizationId
        ,PrecinctId
        ,ArchivedDate
    )
)

IF object_id('dbo.People') is not null
  DROP TABLE  dbo.People
CREATE TABLE  dbo.People
(
     Id             int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,PrecinctId     int             NOT null    DEFAULT 1 REFERENCES Precincts(Id)
    ,FirstName      nvarchar(100)   NOT null
    ,MiddleName     nvarchar(100)   null
    ,LastName       nvarchar(100)   NOT null
    ,FullName       AS Left(RTrim(FirstName) + ' ' + RTrim(LTrim(IsNull(MiddleName, '') + ' ') + RTrim(LastName)), 200) PERSISTED
    ,Phone          nvarchar(100)   null
    ,Address        nvarchar(100)   null
    ,Address2       nvarchar(100)   null
    ,City           nvarchar(100)   null
    ,ST             nvarchar(100)   null
    ,Zip            nvarchar(100)   null
    ,EmailAddress   nvarchar(100)   null
    ,WhereFound     int             NOT null    REFERENCES ListsItems(Id)                   -- See ListsItems.ListId = 10.
    ,DataType       int             null        DEFAULT 13001 REFERENCES ListsItems(Id)     -- See ListsItems.ListId = 13.
    ,Verified       bit             null        DEFAULT 0
    ,MassComm       bit             null        DEFAULT 1
    ,MapSpecs       int             null        DEFAULT 16001 REFERENCES ListsItems(Id)     -- See ListsItems.ListId = 16.
    ,UserAccess     bit             null        DEFAULT 0
    ,Username       nvarchar(100)   null        DEFAULT NewID()
    ,PersonNotes    nvarchar(max)   null

    CONSTRAINT [full names must be unique] UNIQUE NONCLUSTERED
    (
         FullName
        ,ArchivedDate
    )
    ,CONSTRAINT [user names must be unique] UNIQUE NONCLUSTERED
    (
         Username
        ,ArchivedDate
    )
)
ALTER TABLE dbo.People ADD CONSTRAINT [address or phone or email address must be provided]
CHECK ((Address + City + ST + Zip) is not null or Phone is not null or EmailAddress is not null)

ALTER TABLE dbo.People ADD CONSTRAINT [full name must be for one person only]
CHECK (CharIndex(' and ', Fullname) = 0)

IF object_id('dbo.PeoplePrecincts') is not null
  DROP TABLE  dbo.PeoplePrecincts
CREATE TABLE  dbo.PeoplePrecincts
(
     Id             int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,PeopleId       int             NOT null    REFERENCES People(Id)
    ,PrecinctId     int             NOT null    REFERENCES Precincts(Id)

    CONSTRAINT [people may access only one of each precinct] UNIQUE NONCLUSTERED
    (
         PeopleId
        ,PrecinctId
        ,ArchivedDate
    )
)

IF object_id('dbo.PeopleSecurity') is not null
  DROP TABLE  dbo.PeopleSecurity
CREATE TABLE  dbo.PeopleSecurity
(
     Id             int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,PeopleId       int             NOT null    REFERENCES People(Id)
    ,SecurityType   int             NOT null    DEFAULT 8001 REFERENCES ListsItems(Id)      -- See ListsItems.ListId = 8.

    CONSTRAINT [people may have only one of each security type] UNIQUE NONCLUSTERED
    (
         PeopleId
        ,SecurityType
        ,ArchivedDate
    )
)

IF object_id('dbo.PeopleTeams') is not null
  DROP TABLE  dbo.PeopleTeams
CREATE TABLE  dbo.PeopleTeams
(
     Id             int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,PeopleId       int             NOT null    REFERENCES People(Id)
    ,TeamType       int             NOT null    REFERENCES ListsItems(Id)                   -- See ListsItems.ListId = 15.
    ,Rank           int             NOT null    DEFAULT 0
    ,TeamNotes      nvarchar(max)   null

    CONSTRAINT [people may have only one of each team type] UNIQUE NONCLUSTERED
    (
         PeopleId
        ,TeamType
        ,ArchivedDate
    )
)

IF object_id('dbo.PeopleVolunteerTypes') is not null
  DROP TABLE  dbo.PeopleVolunteerTypes
CREATE TABLE  dbo.PeopleVolunteerTypes
(
     Id             int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,PeopleId       int             NOT null    REFERENCES People(Id)
    ,VolunteerType  int             NOT null    REFERENCES ListsItems(Id)                   -- See ListsItems.ListId = 11.
    ,VolunteerNotes nvarchar(max)   null

    CONSTRAINT [people may have only one of each volunteer type] UNIQUE NONCLUSTERED
    (
         PeopleId
        ,VolunteerType
        ,ArchivedDate
    )
)

IF object_id('dbo.PeopleContacts') is not null
  DROP TABLE  dbo.PeopleContacts
CREATE TABLE  dbo.PeopleContacts
(
     Id             int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,PeopleId       int             NOT null    REFERENCES People(Id)
    ,ContactType    int             NOT null    REFERENCES ListsItems(Id)                   -- See ListsItems.ListId = 12.
    ,ContactDate    datetime        NOT null    DEFAULT GetDate()
    ,ContactNote    nvarchar(max)   NOT null
)

IF object_id('dbo.DistrictsCandidates') is not null
  DROP TABLE  dbo.DistrictsCandidates
CREATE TABLE  dbo.DistrictsCandidates
(
     Id             int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,DistrictId     int             NOT null    REFERENCES Districts(Id)
    ,CandidateId    int             NOT null    REFERENCES People(Id)
    ,CandidateNotes nvarchar(max)   null

    CONSTRAINT [districts may have only one of each candidate] UNIQUE NONCLUSTERED
    (
         DistrictId
        ,CandidateId
        ,ArchivedDate
    )
)

IF object_id('dbo.DistrictsCandidatesHelpers') is not null
  DROP TABLE  dbo.DistrictsCandidatesHelpers
CREATE TABLE  dbo.DistrictsCandidatesHelpers
(
     Id             int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,DistrictId     int             NOT null    REFERENCES Districts(Id)
    ,CandidateId    int             NOT null    REFERENCES People(Id)
    ,HelperId       int             NOT null    REFERENCES People(Id)
    ,HelperNotes    nvarchar(max)   null

    CONSTRAINT [district candidates may have only one of each helper] UNIQUE NONCLUSTERED
    (
         DistrictId
        ,CandidateId
        ,HelperId
        ,ArchivedDate
    )
)

IF object_id('dbo.DistrictsCoordinators') is not null
  DROP TABLE  dbo.DistrictsCoordinators
CREATE TABLE  dbo.DistrictsCoordinators
(
     Id                 int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived           bit             NOT null    DEFAULT 0
    ,ArchivedDate       datetime        null
    ,ArchivedBy         nvarchar(100)   null
    ,LastSetDate        datetime        null        DEFAULT GetDate()
    ,LastSetBy          nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,DistrictId         int             NOT null    REFERENCES Districts(Id)
    ,CoordinatorId      int             NOT null    REFERENCES People(Id)
    ,Rank               int             NOT null    DEFAULT 0
    ,CoordinatorNotes   nvarchar(max)   null

    CONSTRAINT [districts may have only one of each coordinator] UNIQUE NONCLUSTERED
    (
         DistrictId
        ,CoordinatorId
        ,ArchivedDate
    )
)

IF object_id('dbo.PrecinctsChairs') is not null
  DROP TABLE  dbo.PrecinctsChairs
CREATE TABLE  dbo.PrecinctsChairs
(
     Id             int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,PrecinctId     int             NOT null    REFERENCES Precincts(Id)
    ,ChairId        int             NOT null    REFERENCES People(Id)
    ,Rank           int             NOT null    DEFAULT 0
    ,ChairNotes     nvarchar(max)   null

    CONSTRAINT [precincts may have only one of each chair] UNIQUE NONCLUSTERED
    (
         PrecinctId
        ,ChairId
        ,ArchivedDate
    )
)

IF object_id('dbo.PrecinctsLeaders') is not null
  DROP TABLE  dbo.PrecinctsLeaders
CREATE TABLE  dbo.PrecinctsLeaders
(
     Id             int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,PrecinctId     int             NOT null    REFERENCES Precincts(Id)
    ,LeaderId       int             NOT null    REFERENCES People(Id)
    ,Rank           int             NOT null    DEFAULT 0
    ,LeaderNotes    nvarchar(max)   null

    CONSTRAINT [precincts may have only one of each leader] UNIQUE NONCLUSTERED
    (
         PrecinctId
        ,LeaderId
        ,ArchivedDate
    )
)

IF object_id('dbo.PrecinctsOrganizers') is not null
  DROP TABLE  dbo.PrecinctsOrganizers
CREATE TABLE  dbo.PrecinctsOrganizers
(
     Id             int             NOT null    IDENTITY (1, 1) PRIMARY KEY CLUSTERED
    ,Archived       bit             NOT null    DEFAULT 0
    ,ArchivedDate   datetime        null
    ,ArchivedBy     nvarchar(100)   null
    ,LastSetDate    datetime        null        DEFAULT GetDate()
    ,LastSetBy      nvarchar(100)   null        DEFAULT SYSTEM_USER

    ,PrecinctId     int             NOT null    REFERENCES Precincts(Id)
    ,OrganizerId    int             NOT null    REFERENCES People(Id)
    ,Rank           int             NOT null    DEFAULT 0
    ,OrganizerNotes nvarchar(max)   null

    CONSTRAINT [precincts may have only one of each organizer] UNIQUE NONCLUSTERED
    (
         PrecinctId
        ,OrganizerId
        ,ArchivedDate
    )
)
GO
