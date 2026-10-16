@EndUserText.label: 'Shipment Type New'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_ShipmentTypeNew
  as select from ZDT_SHIPMENTTYP
  association to parent ZI_ShipmentTypeNew_S as _ShipmentTypeNewAll on $projection.SingletonID = _ShipmentTypeNewAll.SingletonID
{
  key SHIPMENTTYPE as Shipmenttype,
  @Consumption.hidden: true
  1 as SingletonID,
  _ShipmentTypeNewAll
  
}
