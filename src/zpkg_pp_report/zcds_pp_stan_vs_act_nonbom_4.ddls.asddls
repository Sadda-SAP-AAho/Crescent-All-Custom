@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Non BOM Standard VS Actual Consumption'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PP_STAN_VS_ACT_NONBOM_4
  as select from ZCDS_PP_STAN_VS_ACT_NONBOM_3
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
  
union
select from ZCDS_PP_STAN_VS_ACT_NONBOM_1
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
