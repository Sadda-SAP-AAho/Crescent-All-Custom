@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR BARODA - Rejection Loss Value'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_BARD_20
  as select from    I_ManufacturingOrder     as a
    inner join      I_MaterialDocumentItem_2 as c on  c.OrderID = a.ManufacturingOrder
                                                  and c.Plant   = a.ProductionPlant
    inner join      I_ProductValuationBasic  as d on  d.Product       = c.Material
                                                  and d.ValuationArea = c.Plant
    inner join      I_Product                as e on e.Product = c.Material
    inner join      I_ProductPlantBasic      as g on  g.Product = c.Material
                                                  and g.Plant   = c.Plant
    left outer join ZI_DPR_BARD_22           as f on f.ManufacturingOrder = a.ManufacturingOrder

{
  a.ManufacturingOrder,
  c.PostingDate,
  sum( cast( case when c.GoodsMovementType = '261'
             then case when d.InventoryValuationProcedure = 'V'
                       then cast( ( c.QuantityInBaseUnit * cast( d.MovingAveragePrice as abap.dec( 23, 2 ) ) ) as abap.dec( 23, 2 ) )
                       when d.InventoryValuationProcedure = 'S'
                       then cast( ( c.QuantityInBaseUnit * cast( d.StandardPrice as abap.dec( 23, 2 ) ) ) as abap.dec( 23, 2 ) )
                       else 0 end
             else case when d.InventoryValuationProcedure = 'V'
                       then cast( ( c.QuantityInBaseUnit * cast( ( -1 * d.MovingAveragePrice ) as abap.dec( 23, 2 ) ) ) as abap.dec( 23, 2 ) )
                       when d.InventoryValuationProcedure = 'S'
                       then cast( ( c.QuantityInBaseUnit * cast( ( -1 * d.StandardPrice ) as abap.dec( 23, 2 ) ) ) as abap.dec( 23, 2 ) )
                       else 0 end
             end as abap.dec( 23, 2 ) ) )      as issuevalue,
  sum( cast( case when c.GoodsMovementType = '261'
                  then cast( ( c.QuantityInBaseUnit * e.NetWeight * f.Price ) as abap.dec( 23, 2 ) )
                  else cast( ( -1 * c.QuantityInBaseUnit * e.NetWeight * f.Price ) as abap.dec( 23, 2 ) )
                  end as abap.dec( 23, 2 ) ) ) as frrecval

}
where
       a.ManufacturingOrderType = 'ZRWK'
  and  a.ProductionPlant        = '1400'
  and(
       c.GoodsMovementType      = '261'
    or c.GoodsMovementType      = '262'
  )
  and(
       e.ProductGroup           = 'Z027'
    or e.ProductGroup           = 'Z026'
    or e.ProductGroup           = 'Z028'
    or e.ProductGroup           = 'Z003'
    or e.ProductGroup           = 'Z045'

  )
  and(
       g.ProfitCenter           = '0000001401'
    or g.ProfitCenter           = '0000001402'
  )
group by
  a.ManufacturingOrder,
  c.PostingDate
