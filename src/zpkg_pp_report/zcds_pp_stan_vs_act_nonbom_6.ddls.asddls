@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Non BOM Standard VS Actual Consumption'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PP_STAN_VS_ACT_NONBOM_6
  as select from   ZCDS_PP_STAN_VS_ACT_NONBOM_5 as a
  left outer join  ZCDS_PP_STAN_VS_ACT_NONBOM_1 as b  on  b.PostingDate = a.PostingDate
                                                      and b.Plant       = a.Plant
                                                      and b.CostCenter  = a.CostCenter
                                                      and b.Material    = a.Material
                                                      and b.GLAccount   = a.GLAccount
                                                      and b.conbase     = a.conbase
  left outer join  ZCDS_PP_STAN_VS_ACT_NONBOM_3 as c  on  c.PostingDate = a.PostingDate
                                                      and c.Plant       = a.Plant
                                                      and c.CostCenter  = a.CostCenter
                                                      and c.Material    = a.Material
                                                      and c.GLAccount   = a.GLAccount
                                                      and c.conbase     = a.conbase
{
      $session.client as mandt_1,
      a.PostingDate,
      a.Plant,
      a.CostCenter,
      a.GLAccount,
      a.conbase,
      a.Material,
      a.ProductDescription,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
      b.conqty,
      b.MaterialBaseUnit1,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit2'
      c.issqty,
      c.MaterialBaseUnit2
}
