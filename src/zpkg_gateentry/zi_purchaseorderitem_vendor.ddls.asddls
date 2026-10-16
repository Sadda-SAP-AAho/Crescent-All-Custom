@AbapCatalog.sqlViewName: 'ZIPORDERITEM3'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Poitem with vendor selection'
define view ZI_PurchaseOrderItem_vendor
  as select from    I_PurchaseOrderAPI01     as A
    left outer join I_PurchaseOrderItemAPI01 as B on B.PurchaseOrder = A.PurchaseOrder
{
  key A.PurchaseOrder,
  key B.PurchaseOrderItem,
      B.Material,
      B.PurchaseOrderItemText,
      B.OrderQuantity,
      B.PurchaseOrderQuantityUnit
}
where
      B.PurchasingDocumentDeletionCode = ''
  and B.IsCompletelyDelivered          = ''
