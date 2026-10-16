@EndUserText.label: 'SHIPMENT TYPE Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'ShipmentTypeAll'
  }
}
define root view entity ZI_ShipmentType_S1
  as select from I_Language
    left outer join ZDT_SHIPMENTTYPE on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _I_ABAPTransportRequestText on $projection.TransportRequestID = _I_ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_ShipmentType_01 as _ShipmentType
{
  @UI.facet: [ {
    id: 'ZI_ShipmentType_01', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'SHIPMENT TYPE', 
    position: 1 , 
    targetElement: '_ShipmentType'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _ShipmentType,
  @UI.hidden: true
  max( ZDT_SHIPMENTTYPE.LAST_CHANGED_AT ) as LastChangedAtMax,
  @ObjectModel.text.association: '_I_ABAPTransportRequestText'
  @UI.identification: [ {
    position: 2 , 
    type: #WITH_INTENT_BASED_NAVIGATION, 
    semanticObjectAction: 'manage'
  } ]
  @Consumption.semanticObject: 'CustomizingTransport'
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  _I_ABAPTransportRequestText
  
}
where I_Language.Language = $session.system_language
