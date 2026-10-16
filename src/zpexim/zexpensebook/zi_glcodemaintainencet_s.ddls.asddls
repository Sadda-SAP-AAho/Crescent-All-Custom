@EndUserText.label: 'GL Code Maintainence TMG Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'GlCodeMaintainenAll'
  }
}
define root view entity ZI_GlCodeMaintainenceT_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_GLCODEMAINTAINENCET'
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_GlCodeMaintainenceT as _GlCodeMaintainenceT
{
  @UI.facet: [ {
    id: 'ZI_GlCodeMaintainenceT', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'GL Code Maintainence TMG', 
    position: 1 , 
    targetElement: '_GlCodeMaintainenceT'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _GlCodeMaintainenceT,
  @UI.hidden: true
  I_CstmBizConfignLastChgd.LastChangedDateTime as LastChangedAtMax,
  @ObjectModel.text.association: '_ABAPTransportRequestText'
  @UI.identification: [ {
    position: 1 , 
    type: #WITH_INTENT_BASED_NAVIGATION, 
    semanticObjectAction: 'manage'
  } ]
  @Consumption.semanticObject: 'CustomizingTransport'
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  _ABAPTransportRequestText
}
where I_Language.Language = $session.system_language
