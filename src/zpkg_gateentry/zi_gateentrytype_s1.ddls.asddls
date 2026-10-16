@EndUserText.label: 'gateentrytype Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'GateentrytypeAll'
  }
}
define root view entity ZI_Gateentrytype_S1
  as select from I_Language
    left outer join ZDT_ENTRYTYPE on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _I_ABAPTransportRequestText on $projection.TransportRequestID = _I_ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_Gateentrytype_01 as _Gateentrytype
{
  @UI.facet: [ {
    id: 'ZI_Gateentrytype_01', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'gateentrytype', 
    position: 1 , 
    targetElement: '_Gateentrytype'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _Gateentrytype,
  @UI.hidden: true
  max( ZDT_ENTRYTYPE.LAST_CHANGED_AT ) as LastChangedAtMax,
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
