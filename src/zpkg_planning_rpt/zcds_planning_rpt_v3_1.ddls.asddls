@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shortage Report Stock FG'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PLANNING_RPT_V3_1
  as select from    I_StockQuantityCurrentValue_2( P_DisplayCurrency : 'INR' ) as a
    left outer join I_ProductPlantBasic                                        as b on  b.Product = a.Product
                                                                                    and b.Plant   = a.Plant
{
  a.Product,
  //  a.Plant,
  (case when b.SpecialProcurementType = '40' then '1100'
                    else a.Plant end)   as Plant,
  a.StorageLocation,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  sum( a.MatlWrhsStkQtyInMatlBaseUnit ) as qty,
  a.MaterialBaseUnit

}
where
  (
          a.InventoryStockType = '01'
    or    a.InventoryStockType = '02'
  )
  and(
    (
          a.Plant              = '1100'
      and a.StorageLocation    = 'SAFG'
    )
    or(
          a.Plant              = '1200'
      and a.StorageLocation    = 'KUFG'
    )
    or(
          a.Plant              = '1300'
      and a.StorageLocation    = 'BGFG'
    )
    or(
          a.Plant              = '1400'
      and a.StorageLocation    = 'BAFG'
    )
  )
  and     a.ValuationAreaType  = '1'
group by
  a.Product,
  a.Plant,
  b.SpecialProcurementType,
  a.StorageLocation,
  a.MaterialBaseUnit
