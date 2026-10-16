@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Indent'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_MATMAX
  as select distinct from ZI_MATWHSTOCK           as a
    left outer join       ZI_PRDPRQTY             as b on  a.Product = b.Material
                                                       and a.Plant   = b.Plant
    left outer join       ZI_PRDPOQTY             as c on  a.Product = c.Material
                                                       and a.Plant   = c.Plant
    left outer join       I_ProductSupplyPlanning as d on  a.Product = d.Product
                                                       and a.Plant   = d.Plant
{
  key a.Product,
  key a.Plant                        as PlantCode,
  key a.ProductGroup,
  key a.ProductType,
  key a.StorageLocation,
      a.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      d.MaximumStockQuantity         as MaxStock,
      @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'
      a.MatlWrhsStkQtyInMatlBaseUnit as CurrentStock,
      //      sum( cast( b.RequestedQuantity as abap.dec(12,3) ) ) as pr_qty,
      b.pr_qty                       as pr_qty,
      //      sum( cast( c.OrderQuantity as abap.dec(12,3) ) )     as po_qty
      c.po_qty
}
