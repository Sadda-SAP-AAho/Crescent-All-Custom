@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Wise Business Role'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_USERBUSINESSROLE
  as select from    I_BusinessUserBasic            as a
    left outer join I_IAMBusinessUserLogonDetails  as b on a.UserID = b.UserID
    left outer join ZI_USERCATEGORY                as c on a.UserID = c.User_Id
    left outer join I_IAMBusinessUserBusinessRole  as d on a.UserID = d.UserID
    left outer join I_IAMBusinessRoleText          as e on d.BusinessRole = e.BusinessRole
    left outer join I_IAMBusinessRolePriceCategory as f on d.BusinessRole = f.BusinessRole
    left outer join I_WorkplaceAddress             as g on a.BusinessPartner = g.BusinessPartner
{
  key a.UserID                                                    as User_Id,
  key upper ( a.PersonFullName )                                  as Full_Name,
  key ( case
          when c.Category_Priority = 3 then 'ADVANCED'
          when c.Category_Priority = 2 then 'CORE'
          when c.Category_Priority = 1 then 'SELFSERVICE'
          else '' end )                                           as User_Price_Catg,
  key ( case when b.UserIsLocked = 'X' then 'Yes' else 'No' end ) as User_Locked,
  key ( case when b.UserLastLogonDate = '00000000' then 'Not Log On'
             else concat(
            concat(
                substring(b.UserLastLogonDate, 7, 2),   -- DD
                concat('/', substring(b.UserLastLogonDate, 5, 2))  -- /MM
            ),
            concat('/', substring(b.UserLastLogonDate, 1, 4))      -- /YYYY
        ) end)                                                    as Last_Logon_Date,
  key ( case when b.UserLastLogonDate = '00000000' then 'Not Log On'
       else concat(
           concat(
             substring(b.UserLastLogonTime, 1, 2),   -- HH
             concat(':', substring(b.UserLastLogonTime, 3, 2))  -- :MM
           ),
           concat(':', substring(b.UserLastLogonTime, 5, 2))    -- :SS
         ) end )                                                  as Last_Logon_Time,
  key d.BusinessRole                                              as Business_Role_Id,
      e.Name                                                      as Business_Role,
      f.BusinessRolePriceCategory                                 as Business_Role_Price_Catg,
      g.DefaultEmailAddress                                       as Email_ID

}
