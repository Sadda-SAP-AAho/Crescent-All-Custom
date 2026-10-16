@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Amount Calculation'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_export_2 
 as select from I_BillingDocumentItemPrcgElmnt as a
{
  key  a.BillingDocument,
       @Semantics.amount.currencyCode: 'TransactionCurrency'
       coalesce( cast( sum( a.ConditionAmount ) as abap.dec( 21, 2 ) ) , 0 ) as ConditionAmount,
       TransactionCurrency
}
where
  (
       a.ConditionType = 'ZSPC'
    //or a.ConditionType = 'ZOIG'
  )
group by
  a.BillingDocument,
  TransactionCurrency
