@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for total amount in finalcomm'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_AMTCOMM as 
select distinct from ZVFINALCOMDATA
{
  key BillingDocument,
      TransactionCurrency,
      OrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      sum(amount) as sumamount,
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      ( sum(freightamt) * -1 ) as freightsum,
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      sum(packingamt) as packingsum,
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      sum(discamt) as discsum

}
group by BillingDocument,
         TransactionCurrency,
         OrderQuantityUnit
