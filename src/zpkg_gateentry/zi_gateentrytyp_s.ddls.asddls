@EndUserText.label: 'GateEntry Type Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'GateentryTypeAll'
  }
}
define root view entity ZI_GateentryTyp_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_GATEENTRYTYP'
  association [0..*] to I_ABAPTransportRequestText as _I_ABAPTransportRequestText on $projection.TransportRequestID = _I_ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_GateentryTyp as _GateentryTyp
{
  @UI.facet: [ {
    id: 'Transport', 
    purpose: #STANDARD, 
    type: #IDENTIFICATION_REFERENCE, 
    label: 'Transport', 
    position: 1 , 
    hidden: #(HideTransport)
  }, {
    id: 'ZI_GateentryTyp', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'GateEntry Typ', 
    position: 2 , 
    targetElement: '_GateentryTyp'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _GateentryTyp,
  @UI.hidden: true
  I_CstmBizConfignLastChgd.LastChangedDateTime as LastChangedAtMax,
  @ObjectModel.text.association: '_I_ABAPTransportRequestText'
  @UI.identification: [ {
    position: 2 , 
    type: #WITH_INTENT_BASED_NAVIGATION, 
    semanticObjectAction: 'manage'
  }, {
    type: #FOR_ACTION, 
    dataAction: 'SelectCustomizingTransptReq', 
    label: 'Select Transport'
  } ]
  @Consumption.semanticObject: 'CustomizingTransport'
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  _I_ABAPTransportRequestText,
  @UI.hidden: true
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
