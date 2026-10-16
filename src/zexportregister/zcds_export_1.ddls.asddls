@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Calculation for Export Value'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_export_1
  as select from I_BillingDocumentItemPrcgElmnt as a
{
  key  a.BillingDocument,
       @Semantics.amount.currencyCode: 'TransactionCurrency'
       coalesce( cast( sum( a.ConditionAmount ) as abap.dec( 21, 2 ) ) , 0 ) as ConditionAmount,
       TransactionCurrency
}
where
  (
       a.ConditionType = 'ZPR0'
    or a.ConditionType = 'ZPR1'
    or a.ConditionType = 'ZSPC'
  )
group by
  a.BillingDocument,
  TransactionCurrency
