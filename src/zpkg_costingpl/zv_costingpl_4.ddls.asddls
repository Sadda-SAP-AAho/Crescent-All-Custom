@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_4

  as select from I_BillingDocument     as a

    inner join   I_BillingDocumentItem as b on a.BillingDocument = b.BillingDocument

{
  key a.BillingDocument,
      b.ItemWeightUnit,
      sum( cast( b.ItemNetWeight as abap.dec( 15, 3 ) ) ) as TotalNetWeight
}

group by
  a.BillingDocument,
  b.ItemWeightUnit
