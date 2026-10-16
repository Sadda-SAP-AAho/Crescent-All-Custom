@EndUserText.label: 'OTIF Report'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_SD_OTIF_REPORT_FIN
  as select distinct from ZI_SD_OTIF_REPORT_FIN
{
      @EndUserText.label: 'Our Commited Del Dt'
  key ConfirmedDeliveryDate,
      @EndUserText.label: 'Sales Order No'
  key SalesOrder,
      @EndUserText.label: 'Sales Order Item'
  key SalesOrderItem,
      //      @UI.hidden: true
      //      @EndUserText.label: 'Schedule line'
      //  key ScheduleLine,
      @UI.hidden: true
      @EndUserText.label: 'Delivery Document'
  key DeliveryDocument,
      @UI.hidden: true
  key DeliveryDocumentItem,
      @EndUserText.label: 'SO Date'
      CreationDate,
      @EndUserText.label: 'Doc Status'
      DocStatus,
      @EndUserText.label: 'Card Code'
      SoldToParty,
      @EndUserText.label: 'Item Code'
      Product,
      @EndUserText.label: 'Description'
      SalesOrderItemText,
      @EndUserText.label: 'Profit Center'
      ProfitCenterName,
      @EndUserText.label: 'Quantity'
      ScheduleLineOrderQuantity,
      @EndUserText.label: 'Delivered Qty'
      DeliveredQtyInOrderQtyUnit,
      @EndUserText.label: 'Open Qty'
      OpenConfdDelivQtyInOrdQtyUnit,
      @EndUserText.label: 'Order Wt'
      orderwt,
      @EndUserText.label: 'Open Wt'
      openwt,
      @EndUserText.label: 'Cust Ord No'
      PurchaseOrderByCustomer,
      @EndUserText.label: 'Cust Ord Date'
      CustomerPurchaseOrderDate,
      @EndUserText.label: 'Sales Emp'
      salesperson,
      @EndUserText.label: 'Cust Reqd Del Date'
      YY1_CustomerRequiredDe_SDI,
//      @EndUserText.label: 'Our Commited Del Dt'
//      ConfirmedDeliveryDate,
      @EndUserText.label: 'Act Days'
      actdays,
      @EndUserText.label: 'OTIF'
      otifamt,
      @EndUserText.label: 'OTIF Remarks'
      YY1_ItemPaintInformati_SDI,
      @EndUserText.label: 'Packing No'
      Packinglist,
      @EndUserText.label: 'Packing Date'
      Createdon,
      @EndUserText.label: 'Customer Nick Name'
      Salesnoteref,
      @EndUserText.label: 'Stock Qty'
      MatlWrhsStkQtyInMatlBaseUnit,
      @EndUserText.label: 'SO Hold Status'
      soholdstatus,
      @EndUserText.label: 'Final OTIF'
      finotifamt
}
