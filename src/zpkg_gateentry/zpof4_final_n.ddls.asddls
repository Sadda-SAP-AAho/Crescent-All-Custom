@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPOF4_FINAL_N
  as select from ZPOF4_FINAL as a
{
         @EndUserText.label: 'Purchase Order'
  key    a.PurchaseOrder,
         @EndUserText.label: 'Purchase Order Item'
  key    a.PurchaseOrderItem,
         @EndUserText.label: 'Delivery Document'
  key    a.deliverydocument,
         @EndUserText.label: 'Delivery Document Item'
  key    a.deliverydocumentitem,

         @UI.hidden: true
         @EndUserText.label: 'MP Number'
         a.DeliveryDocumentBySupplier,
         @UI.hidden: true
         @EndUserText.label: 'TP Number'
         a.BillOfLading,


         @EndUserText.label: 'Unit'
         a.Meins,
         @Semantics.amount.currencyCode: 'DocumentCurrency'
         @EndUserText.label: 'Net Price'
         a.NetAmount,
         @Semantics.amount.currencyCode: 'DocumentCurrency'
         @EndUserText.label: 'Rate'
         a.NetPriceAmount,
         @UI.hidden: true
         @EndUserText.label: 'Price Unit'
         a.DocumentCurrency,
         @EndUserText.label: 'Balance Qty.'
         @Semantics.quantity.unitOfMeasure : 'Meins'
         a.bal_qty,
         @EndUserText.label: 'Plant'
         a.Plant,
         @EndUserText.label: 'Purchase Order Text'
         a.PurchaseOrderItemText,
         @EndUserText.label: 'PO Item Text'
         a.PlainLongText,
         //       @EndUserText.label: 'Vehicle Number'
         //       Vehicleno,
         //       @EndUserText.label: 'Transporter NAme'
         //       Transname,
         @EndUserText.label: 'Purchase Order Quantity Unit'
         a.PurchaseOrderQuantityUnit,
         @EndUserText.label: 'Material'
         a.Material,
         @EndUserText.label: 'Order Qty.'
         @Semantics.quantity.unitOfMeasure : 'Meins'
         a.OrderQuantity,
         @EndUserText.label: 'Overall SD Process Status'
         a.OverallSDProcessStatus,
         @EndUserText.label: 'Actual Delivery Qty.'
         @Semantics.quantity.unitOfMeasure : 'Meins'
         a.ActualDeliveryQuantity,
         @EndUserText.label: 'Vendor Code'
         a.Vendorcode,
         @EndUserText.label: 'Unique key'
         case when a.deliverydocument is not null
         then
                concat( a.PurchaseOrder,concat(a.PurchaseOrderItem, concat(a.deliverydocument, a.deliverydocumentitem ))  )
                else concat( a.PurchaseOrder,a.PurchaseOrderItem ) end as PO,
         @EndUserText.label: 'Transporter Code'
         a.UnloadingPointName


}
where
  //  (
  //    (
  //         PurchaseOrderType =  'ZTMP'
  //      or PurchaseOrderType =  'ZTOC'
  //    )
  //    and  deliverydocument  <> '1000000000'
  //  )
  //  or
  (
        a.PurchaseOrderType <> 'ZTMP'
    and a.PurchaseOrderType <> 'ZTOC'
  )
  union all
select from ZI_FUNC_F4_Order as b
{
  key b.SchedulingAgreement        as PurchaseOrder,
  key cast( '' as abap.char(5))    as PurchaseOrderItem,
  key cast('' as abap.char(10))    as deliverydocument,
  key cast('' as abap.char(6))                           as deliverydocumentitem,

  cast( '' as abap.char(20) )      as DeliveryDocumentBySupplier,
  cast( '' as abap.char(20) )      as BillOfLading,
  cast( '' as abap.unit(3))         as Meins,
  cast( 0 as abap.curr(15,2) )     as NetAmount,
  cast( 0 as abap.curr(15,2) )     as NetPriceAmount,
  b.DocumentCurrency,
  cast( 0 as abap.quan(13,3) )     as bal_qty,
    cast('' as abap.char(4)) as Plant,
  cast( '' as abap.char(20)) as PurchaseOrderItemText,
  
  cast( '' as abap.char(30) )        as PlainLongText,
  cast('' as abap.unit(3))     as PurchaseOrderQuantityUnit,
  cast('' as abap.char(20))       as Material,
  cast('0' as abap.quan(13,3))    as OrderQuantity,
  
  cast( '' as abap.char(1) )       as OverallSDProcessStatus,
  cast( 0 as abap.quan(13,3) )     as ActualDeliveryQuantity,
  cast('' as abap.char(10))      as Vendorcode,
  b.SchedulingAgreement     as PO, 

  cast( '' as abap.char(20) )      as UnloadingPointName
}
  
