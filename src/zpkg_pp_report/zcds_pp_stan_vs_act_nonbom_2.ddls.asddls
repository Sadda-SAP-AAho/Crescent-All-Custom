@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Non BOM Standard VS Actual Consumption'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PP_STAN_VS_ACT_NONBOM_2
  as select from  ZCDS_PP_STAN_VS_ACT_NONBOM as a
{
  a.PostingDate,
  a.Plant,
  a.CostCenter,
  a.CostCenterDescription,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  sum( a.QuantityInBaseUnit ) as lmqty,
  a.MaterialBaseUnit,
  a.GLAccount,
  a.GLAccountLongName,
  a.conbase
}
group by
  a.PostingDate,
  a.Plant,
  a.CostCenter,
  a.CostCenterDescription,
  a.MaterialBaseUnit,
  a.GLAccount,
  a.GLAccountLongName,
  a.conbase
