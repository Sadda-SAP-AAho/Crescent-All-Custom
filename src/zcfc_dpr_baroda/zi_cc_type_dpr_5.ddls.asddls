@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR BARODA'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CC_TYPE_DPR_5 
  as select from zdt_cc_type
{
    key '1400' as Plant,
    key 'ALL DEPT' as Kostl,
    cctype as Cctype
}
where cctype = 'BARD'
