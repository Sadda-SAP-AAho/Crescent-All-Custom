@AbapCatalog.sqlViewName: 'ZCDS_INV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For doc type invoice'
define view ZI_INV
  as select from I_BillingDocumentItem


{

  BillingDocument,
  BillingDocumentDate,
  NetAmount

  // Make association public
}
