@EndUserText.label: 'OTIF Report - INSIA'
@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_OTIF_INSIA
  provider contract transactional_query
  as projection on ZI_OTIF_INSIA
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
      @EndUserText.label: 'Cust Ord No'
      CustomerPONo,
      @EndUserText.label: 'Cust Ord Date'
      CustomerPODate,
      @EndUserText.label: 'Our Commited Del Dt'
      OurCommDate,
      @EndUserText.label: 'OTIF'
      OTIF
}
