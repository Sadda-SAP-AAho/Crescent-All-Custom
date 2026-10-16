@AbapCatalog.sqlViewName: 'ZPOHELP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO help'
define view ZPO_F4HELP
  as select from ZPOF4_FINAL as a
{
  key PurchaseOrder,
  key PurchaseOrderItem,
      Vendorcode,
      Material,
      PurchaseOrderQuantityUnit,
      Meins,
      OrderQuantity,
      deliverydocument,
      deliverydocumentitem,
      OverallSDProcessStatus,
      ActualDeliveryQuantity,
      bal_qty,
      PurchaseOrderType,
      DeliveryDocumentBySupplier,
      Plant,
      BillOfLading,
      NetAmount,
      DocumentCurrency,
      UnloadingPointName
}
