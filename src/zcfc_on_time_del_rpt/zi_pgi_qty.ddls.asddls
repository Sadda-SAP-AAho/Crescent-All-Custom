@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PGI Qty'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_PGI_QTY
  as select distinct from ZI_PGI_DATA
{
  key SalesOrder,
  key SalesOrderItem,
  key Material,
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum( TotalPGIQty ) as TotalPGIQty

}

group by
  SalesOrder,
  SalesOrderItem,
  Material,
  MaterialBaseUnit
