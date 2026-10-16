@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Amount Calculation'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_export_3
  as select from I_BillingDocumentItemPrcgElmnt as a
{
  key  a.BillingDocument,
       @Semantics.amount.currencyCode: 'TransactionCurrency'
       coalesce( cast( sum( a.ConditionAmount ) as abap.dec( 21, 2 ) ) , 0 ) as ConditionAmount,
       TransactionCurrency
}
where
  (
       a.ConditionType = 'ZXIV'
    or a.ConditionType = 'ZXIP'
    or a.ConditionType = 'ZFIV'
    or a.ConditionType = 'ZFIP'
    or a.ConditionType = 'ZPIP'
    or a.ConditionType = 'ZPIV'
  )
group by
  a.BillingDocument,
  TransactionCurrency
