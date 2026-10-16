@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR CI CC Type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CC_TYPE_DPR_CI 
  as select from zdt_cc_type
{
    key '1100' as Plant,
    key ltrim( kostl, '0' ) as Kostl,
    cctype as Cctype
}
union select from ZI_CC_TYPE_DPR_2
{
    key Plant,
    key Kostl,
    Cctype
}
group by
Plant,
Kostl,
Cctype
