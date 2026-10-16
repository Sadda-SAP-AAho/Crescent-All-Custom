@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Wise Business Role'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_USERBUSINESSROLE
  provider contract transactional_query
  as projection on ZI_USERBUSINESSROLE
{
      @EndUserText.label: 'User ID'
  key User_Id,
      @EndUserText.label: 'User Name'
  key Full_Name,
      @EndUserText.label: 'Price Category'
  key User_Price_Catg,
      @EndUserText.label: 'User Locked'
  key User_Locked,
      @EndUserText.label: 'Last Logon Date'
  key Last_Logon_Date,
      @EndUserText.label: 'Last Logon Time'
  key Last_Logon_Time,
      @EndUserText.label: 'Business Role ID'
  key Business_Role_Id,
      @EndUserText.label: 'Business Role'
      Business_Role,
      @EndUserText.label: 'Business Role Price Category'
      Business_Role_Price_Catg,
      @EndUserText.label: 'Email ID'
      Email_ID
}
