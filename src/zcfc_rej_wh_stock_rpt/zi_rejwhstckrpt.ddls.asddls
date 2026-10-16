@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection WH Stock Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_REJWHSTCKRPT
  as select distinct from I_StockQuantityCurrentValue_2 ( P_DisplayCurrency : 'INR' ) as a
    left outer join       I_ProductText                                               as b on a.Product = b.Product
    left outer join       I_UnitOfMeasure                                             as c on a.MaterialBaseUnit = c.UnitOfMeasure
    left outer join       I_ProductPlantBasic                                         as d on  a.Product = d.Product
                                                                                           and a.Plant   = d.Plant
    left outer join       I_ProfitCenterText                                          as e on  d.ProfitCenter = e.ProfitCenter
                                                                                           and e.Language     = 'E'
    left outer join       I_Product                                                   as f on a.Product = f.Product
    left outer join       zdt_pp_matinffld                                            as g on a.Product = g.product
    left outer join       I_ProductGroupText_2                                        as k on  a.ProductGroup = k.ProductGroup
                                                                                           and k.Language     = 'E'
{
  key    a.Product,
  key    b.ProductName,
  key    a.ProductType,
  key    k.ProductGroupText,
  key    a.Plant,
  key    a.StorageLocation,
  key    d.ProfitCenter                                                                                         as PrftCntr,
  key    e.ProfitCenterName                                                                                     as ProfitCenter,
  key    g.moc                                                                                                  as MOC,
  key    ( case when a.InventoryStockType = '01' then 'Unrestricted-Use Stock'
             when a.InventoryStockType = '02' then 'Stock in Quality Inspection'
             when a.InventoryStockType = '03' then 'Returns'
             when a.InventoryStockType = '04' then 'Stock Transfer (Storage Location)'
             when a.InventoryStockType = '05' then 'Stock Transfer (Plant)'
             when a.InventoryStockType = '06' then 'Stock in Transit'
             when a.InventoryStockType = '07' then 'Blocked Stock'
             when a.InventoryStockType = '08' then 'Restricted-Use Stock'
             when a.InventoryStockType = '09' then 'Tied Empties'
             when a.InventoryStockType = '10' then 'Valuated Goods Receipt Blocked Stock' end )                 as StockType,
  key    a.Batch,
         a.MaterialBaseUnit,
         @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
         a.MatlWrhsStkQtyInMatlBaseUnit                                                                         as MatStock,
         c.UnitOfMeasure_E,
         f.WeightUnit,
         @Semantics.quantity.unitOfMeasure: 'WeightUnit'
         f.NetWeight,
         cast ( f.NetWeight as abap.dec( 13, 3 )) * cast ( a.MatlWrhsStkQtyInMatlBaseUnit as abap.dec( 13, 3 )) as TotalWt,
         a.Currency,
         cast ( a.StockValueInCCCrcy as abap.dec( 13, 3 ))                                                      as StockValue

}
where
       a.ValuationAreaType            = '1'
  and(
       a.StorageLocation              = 'SARJ'
    or a.StorageLocation              = 'KURJ'
    or a.StorageLocation              = 'BGRJ'
    or a.StorageLocation              = 'BARJ'
  )

  and  a.MatlWrhsStkQtyInMatlBaseUnit > 0
