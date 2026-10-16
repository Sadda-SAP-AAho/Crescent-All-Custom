@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Long Text'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_PO_LT
  provider contract transactional_query
  as projection on I_PurchaseOrderItemNoteTP_2 as polt
{
  key PurchaseOrder,
  key PurchaseOrderItem,
  key TextObjectType,
  key Language,
      PlainLongText,
      PurchaseOrderItemUniqueID
}
