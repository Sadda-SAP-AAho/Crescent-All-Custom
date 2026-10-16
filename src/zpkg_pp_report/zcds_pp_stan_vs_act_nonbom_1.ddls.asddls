@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Non BOM Standard VS Actual Consumption'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PP_STAN_VS_ACT_NONBOM_1 
as select from ZCDS_PP_STAN_VS_ACT_NONBOM as a
inner join I_MaterialDocumentItem_2 as c on c.PostingDate   = a.PostingDate
                                        and c.Plant         = a.Plant
                                        and c.GLAccount     = a.GLAccount
inner join I_ProductDescription as b on b.Product = c.Material and b.Language = 'E'
{
    a.PostingDate,
    a.Plant,
    a.CostCenter,
    a.GLAccount,
    a.conbase,
    c.Material,
    b.ProductDescription,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
    sum( c.QuantityInBaseUnit ) as conqty,
    c.MaterialBaseUnit as MaterialBaseUnit1
}
where
    c.GoodsMovementType        =  '201'
and c.GoodsMovementIsCancelled <> 'X'
and c.CostCenter is not initial
group by
a.PostingDate,
a.Plant,
a.CostCenter,
a.GLAccount,
a.conbase,
c.Material,
b.ProductDescription,
c.MaterialBaseUnit
