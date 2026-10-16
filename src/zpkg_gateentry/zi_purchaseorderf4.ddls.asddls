@AbapCatalog.sqlViewName: 'ZPOF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'f4'
define view zi_purchaseorderf4
  as select distinct from zi_purchaseorder2 as a
{
  key PurchaseOrder,
  key PurchaseOrderItem,
      Vendorcode,
      Material,
      cast( PurchaseOrderItemText as abap.char( 40 ) ) as PurchaseOrderItemText,
      OrderQuantity,
      PurchaseOrderQuantityUnit,
      deliverydocument,
      deliverydocumentitem,
      OverallSDProcessStatus,
      ActualDeliveryQuantity,
      bal_qty
}
