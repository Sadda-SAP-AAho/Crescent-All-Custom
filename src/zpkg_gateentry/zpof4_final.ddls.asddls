@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FINAL PO F4 CDS'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPOF4_FINAL
  as select distinct from zi_purchaseorder2
{
  key PurchaseOrder,
  key PurchaseOrderItem,
      Vendorcode,
      Material,
      cast( PurchaseOrderItemText as abap.char( 40 ) ) as PurchaseOrderItemText,
      PlainLongText,
      PurchaseOrderQuantityUnit,
      Meins,
      @Semantics.quantity.unitOfMeasure : 'Meins'
      OrderQuantity,
      case when ( PurchaseOrderType = 'ZTMP' or PurchaseOrderType = 'ZTOC' ) and deliverydocument is null
           then '1000000000'
           else
      deliverydocument end                             as deliverydocument,
      //      '1000000000'                                     as deliverydocument,
      deliverydocumentitem,
      OverallSDProcessStatus,
      @Semantics.quantity.unitOfMeasure : 'Meins'
      ActualDeliveryQuantity,
      @Semantics.quantity.unitOfMeasure : 'Meins'
      bal_qty,
      PurchaseOrderType,
      DeliveryDocumentBySupplier,
      Plant,
      BillOfLading,
      //      Vehicleno,
      //      Transname,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      NetAmount,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      NetPriceAmount,
      DocumentCurrency,
      UnloadingPointName,
      ReleaseIsNotCompleted


}
where
  bal_qty > 0
