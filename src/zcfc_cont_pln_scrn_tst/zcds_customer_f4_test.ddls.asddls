@AbapCatalog.sqlViewName: 'Z_CUSTOMERTEST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CUSTOMER-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_CUSTOMER_F4_TEST
 as select from I_Customer as a
{
    key a.Customer as Customer
}
