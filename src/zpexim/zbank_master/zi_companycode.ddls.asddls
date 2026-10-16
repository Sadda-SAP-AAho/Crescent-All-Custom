@AbapCatalog.sqlViewName: 'ZBUKRS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 Help for Company Code'
define view ZI_COMPANYCODE
  as select from I_CompanyCode as A
{
  A.CompanyCode,
  A.CompanyCodeName
}
