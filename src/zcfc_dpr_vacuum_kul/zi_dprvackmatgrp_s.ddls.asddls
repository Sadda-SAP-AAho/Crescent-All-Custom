@EndUserText.label: 'DPR VAC KUL MAT GRP Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'DprVACKMatGrpAll'
  }
}
define root view entity ZI_DprVACKMatGrp_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_DPRVACKMATGRP'
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_DprVACKMatGrp as _DprVACKMatGrp
{
  @UI.facet: [ {
    id: 'ZI_DprVACKMatGrp', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'DPR VAC KUL MAT GRP', 
    position: 1 , 
    targetElement: '_DprVACKMatGrp'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _DprVACKMatGrp,
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
