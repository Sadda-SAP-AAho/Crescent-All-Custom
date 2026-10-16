@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR DI'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CC_TYPE_DPR_1 
as select from zdt_cc_type
{
    key '1100' as Plant,
    key 'ALL DEPT' as Kostl,
    cctype as Cctype
}
where cctype = 'DI'
