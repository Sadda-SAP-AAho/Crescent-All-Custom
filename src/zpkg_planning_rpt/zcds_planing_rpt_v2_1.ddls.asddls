@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mat, Plant and Storage loc wise stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PLANING_RPT_V2_1
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
      and a.StorageLocation    = 'SASG'
    )
    or(
          a.Plant              = '1200'
      and a.StorageLocation    = 'KUSG'
    )
    or(
          a.Plant              = '1300'
      and a.StorageLocation    = 'BGSG'
    )
    or(
          a.Plant              = '1400'
      and a.StorageLocation    = 'BASG'
    )
  )
  and     a.ValuationAreaType  = '1'
  
group by
  a.Product,
  a.Plant,
  b.SpecialProcurementType,
  a.StorageLocation,
  a.MaterialBaseUnit
