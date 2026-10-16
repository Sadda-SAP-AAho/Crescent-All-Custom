@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED 
}
define view entity ZI_PURCHASE_REG 
as select from  I_PurchaseRequisitionItemAPI01 as a
left outer join ZI_PURCHASE_REG_1 as b on b.SAPBusinessObjectNodeKey1 = a.PurchaseRequisition
{
    key a.PurchaseRequisition,
    key a.PurchaseRequisitionItem,
    a.PurchaseReqnCreationDate,
    a.Plant,
    b.WrkflwTskCompletionUTCDateTime,
    cast( a.RequestedQuantity as abap.dec( 13, 3 ) ) as RequestedQuantity,
    a.YY1_MaterialLongText_PRI
//    a.PurchaseRequisitionItemText
}
where a.IsClosed is initial and a.IsDeleted is initial
