@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View of OTIF INSIA Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE

define root view entity ZC_OTIFINSIARPT
  provider contract transactional_query
  as projection on ZI_OTIFINSIARPT
{

      @EndUserText.label: 'Sales Order No'
      @Search.defaultSearchElement: true
  key SONo,
      @EndUserText.label: 'Sales Order Item'
  key SOLineNo,
      @UI.hidden: true
  key DelvNo,
      @UI.hidden: true
  key DelvLineNo,
      @EndUserText.label: 'SO Date'
      SODate,
      @EndUserText.label: 'SO Create Date'
      SOCreationDate,
      @EndUserText.label: 'SO Update Date'
      SOUpdateDate,
      @EndUserText.label: 'Customer'
      Customer,
      @EndUserText.label: 'Material No'
      MatNo,
      @EndUserText.label: 'Description'
      Description,
      @EndUserText.label: 'Customer Material Desc.'
      CustomerMatlDesc,
      @EndUserText.label: 'Quantity'
      Quantity,
      @EndUserText.label: 'Delivered Qty'
      DeliveredQty,
      @EndUserText.label: 'Open Qty'
      OpenQty,
      @EndUserText.label: 'Cust PO No'
      CustomerPONo,
      @EndUserText.label: 'Cust PO Line No'
      CustomerPOLineNo,
      @EndUserText.label: 'Cust PO Date'
      CustomerPODate,
      @EndUserText.label: 'Our Commited Del Dt'
      OurCommDate,
      @EndUserText.label: 'OTIF'
      OTIF,
      @EndUserText.label: 'Open Wt'
      openwt
}
