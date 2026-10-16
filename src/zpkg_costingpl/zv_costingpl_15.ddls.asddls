@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_15

  as select from ZCDS_SALES5       as a

    inner join   I_BillingDocument as b on b.BillingDocument = a.BillingDocument
{

  key a.BillingDocument,
  key a.BillingDocumentItem,
      cast( a.sum_a as abap.dec(15,2) )    as InvoiceAmount,
      cast( a.DISCinDc as abap.dec(15,2) ) as DiscAmount
}
