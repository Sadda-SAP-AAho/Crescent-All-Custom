@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mfg Order'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_mfgorder 
as select from I_MfgBOOOperationChangeState
{
    BillOfOperationsGroup,
    BillOfOperationsVariant,
    Plant,
    WorkCenterInternalID,
    WorkCenterTypeCode
}
group by
BillOfOperationsGroup,
BillOfOperationsVariant,
Plant,
WorkCenterInternalID,
WorkCenterTypeCode
