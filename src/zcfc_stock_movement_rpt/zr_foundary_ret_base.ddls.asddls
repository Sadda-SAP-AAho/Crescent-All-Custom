@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Base CDS Entity for Foundary Return Qty'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_FOUNDARY_RET_BASE
  with parameters
    p_date_low  : zde_date,
    p_date_high : zde_date

  as select from I_GoodsMovementCube as mat_doc
    inner join   I_Product           as product on mat_doc.Material = product.Product
{

  product.Product,
  product.ProductGroup,
  mat_doc.Plant,
  mat_doc.PostingDate,
  mat_doc.GoodsMovementType,
  cast(
    cast(mat_doc.TotalGdsMvtQtyInBaseUnit as abap.dec(15,3)) *
    cast(product.NetWeight                as abap.dec(15,3))
    as abap.dec(16,3)
  ) as GdsMvtQty

}

where mat_doc.PostingDate between $parameters.p_date_low and $parameters.p_date_high
and product.ProductGroup = 'Z021' and product.ExternalProductGroup = 'FR'
and ( mat_doc.GoodsMovementType = '531' and mat_doc.GoodsMovementType = '532' )
