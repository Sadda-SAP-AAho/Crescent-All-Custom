@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR BARODA - Rej Loss Value Foundry ret'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_BARD_21
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
  and  a.ProductionPlant        = '1400'
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
    or e.ProductGroup           = 'Z045'
  )
  and(
       g.ProfitCenter           = '0000001401'
    or g.ProfitCenter           = '0000001402'
  )
group by
  a.ManufacturingOrder,
  c.Material,
  c.Plant
