@AbapCatalog.sqlViewName: 'ZIBILLINGDPRIC3'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Doc'
define view ZI_BillingDPricing_3

  as select from ZI_BillingDPricing_1

{
  key BillingDocument,
  key BillingDocumentItem,
      max( ZROD_R ) as ZROD_R,
      max( ZDTB_R ) as ZDTB_R,
      max( ZROD_V ) as ZROD_V,
      max( ZDTB_V ) as ZDTB_V
}

group by
  BillingDocument,
  BillingDocumentItem
