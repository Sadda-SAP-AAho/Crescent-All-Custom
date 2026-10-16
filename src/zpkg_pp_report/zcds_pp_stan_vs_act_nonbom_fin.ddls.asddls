@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Non BOM Standard VS Actual Consumption'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PP_STAN_VS_ACT_NONBOM_FIN 
as select from ZCDS_PP_STAN_VS_ACT_NONBOM_F1
{
    key PostingDate,
    key Plant,
    key CostCenter, 
    key Material,
    key GLAccount,
    key conbase,
//    CostCenterDescription,
    ProductDescription,
    MaterialGroup,
    MaterialGroupName,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    lmqty,
    MaterialBaseUnit,
    GLAccountLongName,
    //@Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
    conqty,
    MaterialBaseUnit1,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit2'
    issqty,
    MaterialBaseUnit2,
    @Semantics.amount.currencyCode: 'Currency'
    actissval,
    currency,
    stdissue,
    lastpurprice,
    stdissueval,
    cast( ( coalesce( cast( actissval as abap.dec( 23, 2 ) ), 0 ) - coalesce( stdissueval, 0 ) ) as abap.dec( 23, 2) ) as valdiff
}
