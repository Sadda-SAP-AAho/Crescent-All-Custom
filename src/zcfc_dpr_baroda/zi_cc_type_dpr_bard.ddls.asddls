@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR BARODA CC TYPE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CC_TYPE_DPR_BARD 
  as select from zdt_cc_type
{
  key '1400'              as Plant,
  key ltrim( kostl, '0' ) as Kostl,
      cctype              as Cctype
}
union select from ZI_CC_TYPE_DPR_5
{
  key Plant,
  key Kostl,
      Cctype
}

where
  Kostl <> '140001'
group by
  Plant,
  Kostl,
  Cctype
