@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Item Text'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_POITMTXT
  provider contract transactional_query
  as projection on I_PurchaseOrderItemNoteTP_2 as itemtext
{
  key PurchaseOrder,
  key PurchaseOrderItem,
  key TextObjectType,
  key Language,
  PlainLongText
}
