@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Base CDS for Material Net Qty Calc'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_NET_QTY_CALC_BASE
  with parameters
    p_date_low  : zde_date,
    p_date_high : zde_date
  as select from I_GoodsMovementCube as mat_doc
    inner join   I_Product           as product on mat_doc.Material = product.Product
{
  product.Product,
  product.ProductGroup,
  mat_doc.Plant,
  mat_doc.MaterialDocument,
  mat_doc.PurchaseOrder,
  mat_doc.ManufacturingOrder,
  mat_doc.SalesOrder,
  mat_doc.PostingDate,
  mat_doc.GoodsMovementType,
  mat_doc.IsConsumptionMovement,

  cast(
      cast(mat_doc.TotalGdsMvtQtyInBaseUnit as abap.dec(15,3)) *
      cast(product.NetWeight                as abap.dec(15,3))
      as abap.dec(16,3)
  ) as GdsMvtQty
}

where mat_doc.PostingDate between $parameters.p_date_low and $parameters.p_date_high
