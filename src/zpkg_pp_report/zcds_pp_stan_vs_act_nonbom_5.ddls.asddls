@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Non BOM Standard VS Actual Consumption'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PP_STAN_VS_ACT_NONBOM_5
  as select distinct from ZCDS_PP_STAN_VS_ACT_NONBOM_4
{
  PostingDate,
  Plant,
  CostCenter,
  GLAccount,
  conbase,
  Material,
  ProductDescription
}
group by
  PostingDate,
  Plant,
  CostCenter,
  GLAccount,
  conbase,
  Material,
  ProductDescription
