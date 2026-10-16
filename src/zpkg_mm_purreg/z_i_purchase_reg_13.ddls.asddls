@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM ITEM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_PURCHASE_REG_13 
  provider contract transactional_query
  as projection on I_PurchaseOrderItemNoteTP_2 as poitmnote
{
    key PurchaseOrder,
    key PurchaseOrderItem,
    key TextObjectType,
    key Language,
    PlainLongText,
    PurchaseOrderItemUniqueID
}
