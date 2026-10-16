@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Shipping Instruction'
define root view entity ZC_SHIPINS_HDR
  provider contract transactional_query
  as projection on ZI_SHIPINS_HDR
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Booking No'
      @Search.defaultSearchElement: true
      Bookingno,
      @EndUserText.label: 'Shipment Type'
      Shipmenttype,
      @EndUserText.label: 'Shipping Type'
      Shippingtype,
      @EndUserText.label: 'Consignee Address Line 1'
      Constreet1,
      @EndUserText.label: 'Consignee Address Line 2'
      Consadd1,
      @EndUserText.label: 'Notify Party 1 Name'
      Notifyp1name,
      @EndUserText.label: 'Notify Party 1 Address Line1'
      Notifyp1add1,
      @EndUserText.label: 'Notify Party 1 Address Line2'
      Notifyp1add2,
      @EndUserText.label: 'Notify Party 2 Name'
      Notifyp2name,
      @EndUserText.label: 'Notify Party 2 Address Line1'
      Notifyp2add1,
      @EndUserText.label: 'Notify Party 2 Address Line2'
      Notifyp2add2,
      @EndUserText.label: 'Notify Party 3 Name'
      Notifyp3name,
      @EndUserText.label: 'Notify Party 3 Address Line1'
      Notifyp3add1,
      @EndUserText.label: 'Notify Party 3 Address Line2'
      Notifyp3add2,
      @EndUserText.label: 'Exporting Carrier Voyage'
      Expcarrvoyage,
      @EndUserText.label: 'Loading Pier/Terminal'
      Loadingpier,
      @EndUserText.label: 'Delivery Address Line 1'
      Deliveradd,
      @EndUserText.label: 'Delivery Address Line 2'
      Deliveradd1,
      @EndUserText.label: 'Delivery Address Line 3'
      Deliveradd2,
      Creationdate,
      @EndUserText.label: 'Shipping Instruction Print'
      Tprint

}
