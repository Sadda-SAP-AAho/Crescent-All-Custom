@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Planning FG stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_4_2
  as select distinct from ZR_PLAN_RPT_4_2_1 as a

{
  key a.Plant,
  key a.hedmaterial,
      cast( sum(a.matstock) as abap.dec(23,3) ) as matstock
}

group by
  a.Plant,
  a.hedmaterial
