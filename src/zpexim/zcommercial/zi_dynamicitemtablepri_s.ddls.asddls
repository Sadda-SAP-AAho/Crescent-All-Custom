@EndUserText.label: 'Dynamic Item Table Print Fields Singleto'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'DynamicItemTableAll'
  }
}
define root view entity ZI_DynamicItemTablePri_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_DYNAMICITEMTABLEPRI'
  association [0..*] to I_ABAPTransportRequestText as _I_ABAPTransportRequestText on $projection.TransportRequestID = _I_ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_DynamicItemTablePri as _DynamicItemTablePri
{
  @UI.facet: [ {
    id: 'ZI_DynamicItemTablePri', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Dynamic Item Table Print Fields', 
    position: 1 , 
    targetElement: '_DynamicItemTablePri'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _DynamicItemTablePri,
  @UI.hidden: true
  I_CstmBizConfignLastChgd.LastChangedDateTime as LastChangedAtMax,
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
