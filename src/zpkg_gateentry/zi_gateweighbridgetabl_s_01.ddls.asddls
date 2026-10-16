@EndUserText.label: 'gate weighbridge table Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'GateWeighbridgeTAll'
  }
}
define root view entity ZI_GateWeighbridgeTabl_S_01
  as select from I_Language
    left outer join ZDT_GATETABLE on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _I_ABAPTransportRequestText on $projection.TransportRequestID = _I_ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_GateWeighbridgeTabl_01 as _GateWeighbridgeTabl
{
  @UI.facet: [ {
    id: 'ZI_GateWeighbridgeTabl_01', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'gate weighbridge table', 
    position: 1 , 
    targetElement: '_GateWeighbridgeTabl'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _GateWeighbridgeTabl,
  @UI.hidden: true
  max( ZDT_GATETABLE.LAST_CHANGED_AT ) as LastChangedAtMax,
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
