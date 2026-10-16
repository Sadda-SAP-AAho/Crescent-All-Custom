@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Base CDS Entity for Opening Stock Calc'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_OPENING_STOCK_BASE
  with parameters
    p_date_low  : zde_date,
    p_date_high : zde_date

  as select from I_GoodsMovementCube  as mat_doc
    inner join   I_Product            as product   on mat_doc.Material = product.Product
    inner join   I_MaterialStockTimeSeries (     P_StartDate  : $parameters.p_date_low , P_EndDate : $parameters.p_date_high,
                 P_PeriodType : 'M' ) as mat_stock on mat_doc.Material = mat_stock.Material

{

  product.Product,
  product.ProductGroup,
  mat_doc.Plant,
  mat_doc.PostingDate,
  cast(
    cast(mat_stock.MatlWrhsStkQtyInMatlBaseUnit as abap.dec(15,3)) *
    cast(product.NetWeight                as abap.dec(15,3))
    as abap.dec(16,3)
  ) as OpenStkQty

}

where
  mat_doc.PostingDate between $parameters.p_date_low and $parameters.p_date_high
  and mat_stock.InventoryStockType = '01' and mat_stock.InventorySpecialStockType is initial
