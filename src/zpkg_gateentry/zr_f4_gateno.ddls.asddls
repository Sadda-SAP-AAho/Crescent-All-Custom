@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZR_F4_GATETYPE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_F4_Gateno as select from zdt_gatetable
{
    @EndUserText.label: 'Gate no'
    key gateno as GateNo,
    @EndUserText.label: 'Weighbridge no'
    key weighbridge as Weighbridge,
    @EndUserText.label: 'Numberrange object'
    object as Object
}
