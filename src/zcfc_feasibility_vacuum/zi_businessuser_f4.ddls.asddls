@AbapCatalog.sqlViewName: 'Z_BUSS_USER_F4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BUSINESS USER - F4'
@Metadata.ignorePropagatedAnnotations: true

define view ZI_BUSINESSUSER_F4
  as select from I_BusinessUserBasic as a
{
  key  a.UserID as User_Id,
       a.PersonFullName as User_Name
}
