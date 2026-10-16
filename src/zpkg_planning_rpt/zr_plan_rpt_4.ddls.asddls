@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Planning Report 4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZR_PLAN_RPT_4
  as select distinct from ZR_PLAN_RPT_4_4


{
  key plant,
  key hedmaterial,
  key component,
      productgroup,
      sum(matstock) as matstock
}

group by
  plant,
  hedmaterial,
  component,
  productgroup
