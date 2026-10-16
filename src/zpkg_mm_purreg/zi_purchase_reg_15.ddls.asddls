@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR Without PO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PURCHASE_REG_15 
as select from ZI_PURCHASE_REG as a
left outer join I_PurchaseOrderItemAPI01 as b on b.PurchaseRequisition     = a.PurchaseRequisition
                                             and b.PurchaseRequisitionItem = a.PurchaseRequisitionItem
{
    key a.PurchaseRequisition,
    key a.PurchaseRequisitionItem,
    a.Plant,
    a.PurchaseReqnCreationDate,
    a.WrkflwTskCompletionUTCDateTime,
    a.RequestedQuantity,
    b.PurchaseOrder
}
// where b.PurchaseOrder is initial
