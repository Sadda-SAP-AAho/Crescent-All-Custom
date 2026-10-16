@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Non BOM Standard VS Actual Consumption'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PP_STAN_VS_ACT_NONBOM_3
  as select from ZCDS_PP_STAN_VS_ACT_NONBOM as a
    inner join   I_MaterialDocumentItem_2   as b on  b.OrderID                  =  a.OrderID
                                                 and a.OrderID                  is not initial
                                                 and b.PostingDate              =  a.PostingDate
                                                 and b.GoodsMovementType        =  '261'
                                                 and b.GoodsMovementIsCancelled <> 'X'
                                                 and b.Plant                    = a.Plant
                                                 and a.GLAccount                = b.GLAccount
  inner join I_ProductDescription as c on c.Product = b.Material and c.Language = 'E'                                               
{
  a.PostingDate,
  a.Plant,
  a.CostCenter,
  a.GLAccount,
  a.conbase,
  b.Material,
  c.ProductDescription,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit2'
  sum( a.QuantityInBaseUnit ) as issqty,
  a.MaterialBaseUnit as MaterialBaseUnit2
}
group by
  a.PostingDate,
  a.Plant,
  a.CostCenter,
  a.GLAccount,
  a.conbase,
  b.Material,
  c.ProductDescription,
  a.MaterialBaseUnit
