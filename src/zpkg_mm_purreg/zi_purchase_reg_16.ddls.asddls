@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR Without PO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PURCHASE_REG_16 
as select from ZI_PURCHASE_REG_15
{
    key PurchaseRequisition,
    key PurchaseRequisitionItem,
    Plant,
    PurchaseReqnCreationDate,
    WrkflwTskCompletionUTCDateTime,
    RequestedQuantity
    
}
where PurchaseOrder is null
