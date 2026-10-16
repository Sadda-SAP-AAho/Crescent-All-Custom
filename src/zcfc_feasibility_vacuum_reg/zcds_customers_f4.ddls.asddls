@AbapCatalog.sqlViewName: 'ZCUSTOMERSF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CUSTOMER-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_CUSTOMERS_F4
  as select distinct from I_Customer as a
{
  key a.Customer as CustCode,
      a.CustomerName as CustName
}
