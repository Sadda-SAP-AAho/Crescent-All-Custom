@EndUserText.label: 'Maintain UserID for Edit & Delete Single'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'MaintainUseridFoAll'
  }
}
define root view entity ZI_MaintainUseridForEd_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_MAINTAINUSERIDFORED'
  association [0..*] to I_ABAPTransportRequestText as _I_ABAPTransportRequestText on $projection.TransportRequestID = _I_ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_MaintainUseridForEd as _MaintainUseridForEd
{
  @UI.facet: [ {
    id: 'ZI_MaintainUseridForEd', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Maintain UserID for Edit & Delete', 
    position: 1 , 
    targetElement: '_MaintainUseridForEd'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _MaintainUseridForEd,
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
