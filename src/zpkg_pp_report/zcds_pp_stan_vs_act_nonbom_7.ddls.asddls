@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Non BOM Standard VS Actual Consumption'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PP_STAN_VS_ACT_NONBOM_7
  as select from    ZCDS_PP_STAN_VS_ACT_NONBOM_6 as a
    left outer join ZTBL_FCTN_NONBOM_RPT         as b on  b.postingdate = a.PostingDate
                                                      and b.plant       = a.Plant
                                                      and b.costcenter  = a.CostCenter
                                                      and b.material    = a.Material
                                                      and b.GLAccount   = a.GLAccount
                                                      and b.Conbase     = a.conbase

{
  a.PostingDate,
  a.Plant,
  a.CostCenter,
  a.GLAccount,
  a.conbase,
  a.Material,
  a.ProductDescription,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
  a.conqty,
  a.MaterialBaseUnit1,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit2'
  a.issqty,
  a.MaterialBaseUnit2,
  @Semantics.amount.currencyCode: 'Currency'
  b.actissval,
  b.currency
}
