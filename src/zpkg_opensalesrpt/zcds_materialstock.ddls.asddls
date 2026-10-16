@AbapCatalog.sqlViewName: 'ZV_STOCK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for material stock qty'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_MATERIALSTOCK
  as select from I_MaterialStock_2
{
  key Material,
  key Plant,
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(MatlWrhsStkQtyInMatlBaseUnit) as stockqty
}
where
  InventoryStockType = '01'
group by
  Material,
  Plant,
  MaterialBaseUnit
