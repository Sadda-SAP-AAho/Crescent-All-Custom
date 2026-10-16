@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Child Item Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_CHILDSTOCK
  as select from I_StockQuantityCurrentValue_2 ( P_DisplayCurrency : 'INR' )
{
  key Product,
  key Plant,
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum ( MatlWrhsStkQtyInMatlBaseUnit ) as MatlStock
}

where
      StorageLocation   not like '%RJ'
  and StorageLocation   is not initial
  and ValuationAreaType = '1'

group by
  Product,
  Plant,
  MaterialBaseUnit
