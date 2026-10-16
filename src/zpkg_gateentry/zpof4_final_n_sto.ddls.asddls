@AbapCatalog.sqlViewName: 'ZGHDF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO F4 Final'
@Metadata.ignorePropagatedAnnotations: true
define view ZPOF4_FINAL_N_STO
  as select distinct from ZPOF4_FINAL
{
       @EndUserText.label: 'Purchase Order'
  key  PurchaseOrder,
       @EndUserText.label: 'Purchase Order Item'
  key  PurchaseOrderItem,
       @EndUserText.label: 'Delivery Document'
  key  deliverydocument,
       @EndUserText.label: 'Delivery Document Item'
  key  deliverydocumentitem,

       @UI.hidden: true
       @EndUserText.label: 'MP Number'
       DeliveryDocumentBySupplier,
       @EndUserText.label: 'TP Number'
       @UI.hidden: true
       BillOfLading,


       @EndUserText.label: 'Unit'
       Meins,
       @Semantics.amount.currencyCode: 'DocumentCurrency'
       @EndUserText.label: 'Net Price'
       NetAmount,
       @Semantics.amount.currencyCode: 'DocumentCurrency'
       @EndUserText.label: 'Rate'
       NetPriceAmount,
       @UI.hidden: true
       @EndUserText.label: 'Price Unit'
       DocumentCurrency,





       @EndUserText.label: 'Balance Qty.'
       @Semantics.quantity.unitOfMeasure : 'Meins'
       bal_qty,
       @EndUserText.label: 'Plant'
       Plant,
       @EndUserText.label: 'Purchase Order Text'
       PurchaseOrderItemText,
       @EndUserText.label: 'PO Item Text'
       PlainLongText,
       //       @EndUserText.label: 'Vehicle Number'
       //       Vehicleno,
       //       @EndUserText.label: 'Transporter NAme'
       //       Transname,
       @EndUserText.label: 'Purchase Order Quantity Unit'
       PurchaseOrderQuantityUnit,
       @EndUserText.label: 'Material'
       Material,
       @EndUserText.label: 'Order Qty.'
       @Semantics.quantity.unitOfMeasure : 'Meins'
       OrderQuantity,
       @EndUserText.label: 'Overall SD Process Status'
       OverallSDProcessStatus,
       @EndUserText.label: 'Actual Delivery Qty.'
       @Semantics.quantity.unitOfMeasure : 'Meins'
       ActualDeliveryQuantity,
       @EndUserText.label: 'Vendor Code'
       Vendorcode,
       @EndUserText.label: 'Unique key'
       case when deliverydocument is not null
       then
              concat( PurchaseOrder,concat(PurchaseOrderItem, concat(deliverydocument, deliverydocumentitem ))  )
              else concat( PurchaseOrder,PurchaseOrderItem ) end as PO,
       @EndUserText.label: 'Transporter Code'
       UnloadingPointName
}
where
  (
    (
         PurchaseOrderType =  'ZTMP'
      or PurchaseOrderType =  'ZTOC'
    )
    and  deliverydocument  <> '1000000000'
  )
