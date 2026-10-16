@AbapCatalog.sqlViewName: 'Z_CUSTOMERF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CUSTOMER-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_CUSTOMER_F4
  as select from I_Customer as a
{
  key a.Customer     as CustCode,
      a.CustomerName as CustName
}
