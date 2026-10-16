@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Ledger'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_VENDORLEDGER06

  as select from ZV_VENDORLEDGER05( mandt: $session.client )
{
  key accountingdocument,
  key companycode,
  key fiscalyear,
      poreference
}
