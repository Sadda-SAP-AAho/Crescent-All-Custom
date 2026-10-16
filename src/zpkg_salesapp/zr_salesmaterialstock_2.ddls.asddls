@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_SALESMATERIALSTOCK_2

  as select from ZR_SALESMATERIALSTOCK_1

{

  key Material,
  key Plant,
      ProductName,
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      Stock,
      cast( 0.000 as abap.dec( 15, 3 ) ) as Quantity,
      cast( 0.00 as abap.dec( 23, 2 ) )  as VAT,
      cast( 0.00 as abap.dec( 23, 2 ) )  as UnitPrice

}

where
  Stock > 0
