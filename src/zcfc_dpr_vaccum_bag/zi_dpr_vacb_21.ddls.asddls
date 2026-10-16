@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR VACUUM BAG - Rej Loss Value Foundry ret'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_VACB_21
  as select distinct from I_ManufacturingOrder     as a
    inner join            I_MaterialDocumentItem_2 as c on  c.OrderID = a.ManufacturingOrder
                                                        and c.Plant   = a.ProductionPlant
    inner join            I_Product                as e on e.Product = c.Material
    inner join            I_ProductPlantBasic      as g on  g.Product = c.Material
                                                        and g.Plant   = c.Plant
{
  a.ManufacturingOrder,
  c.Material,
  c.Plant
}
where
       a.ManufacturingOrderType = 'ZRWK'
  and  a.ProductionPlant        = '1300'
  and(
       c.GoodsMovementType      = '531'
    or c.GoodsMovementType      = '532'
  )
  and(
       e.ProductGroup           = 'Z027'
    or e.ProductGroup           = 'Z026'
    or e.ProductGroup           = 'Z028'
    or e.ProductGroup           = 'Z003'
    or e.ProductGroup           = 'Z021'
  )
  and(
       g.ProfitCenter           = '0000001301'
    or g.ProfitCenter           = '0000001302'
  )
group by
  a.ManufacturingOrder,
  c.Material,
  c.Plant
