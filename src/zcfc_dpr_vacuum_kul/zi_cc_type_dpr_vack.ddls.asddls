@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR VACCUM KUL CC TYPE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CC_TYPE_DPR_VACK
  as select from zdt_cc_type
{
  key '1200'              as Plant,
  key ltrim( kostl, '0' ) as Kostl,
      cctype              as Cctype
}
union select from ZI_CC_TYPE_DPR_3
{
  key Plant,
  key Kostl,
      Cctype
}

where
  Kostl <> '120001'
group by
  Plant,
  Kostl,
  Cctype
