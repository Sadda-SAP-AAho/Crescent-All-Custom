@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_OPR_UPD_ITM 
as projection on ZI_OPR_UPD_ITM 
{
    key Id,
    key Item,
    /* Associations */
    _head : redirected to parent ZC_OPR_UPD_HDR
}
