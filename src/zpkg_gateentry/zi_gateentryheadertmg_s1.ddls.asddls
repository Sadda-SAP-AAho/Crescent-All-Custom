@EndUserText.label: 'GATE ENTRY HEADER TMG Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'GateEntryHeaderTAll'
  }
}
define root view entity ZI_GateEntryHeaderTmg_S1
  as select from I_Language
    left outer join ZDT_GATEHEADER on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _I_ABAPTransportRequestText on $projection.TransportRequestID = _I_ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_GateEntryHeaderTmg_01 as _GateEntryHeaderTmg
{
  @UI.facet: [ {
    id: 'ZI_GateEntryHeaderTmg_01', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'GATE ENTRY HEADER TMG', 
    position: 1 , 
    targetElement: '_GateEntryHeaderTmg'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _GateEntryHeaderTmg,
  @UI.hidden: true
  max( ZDT_GATEHEADER.LAST_CHANGED_AT ) as LastChangedAtMax,
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
