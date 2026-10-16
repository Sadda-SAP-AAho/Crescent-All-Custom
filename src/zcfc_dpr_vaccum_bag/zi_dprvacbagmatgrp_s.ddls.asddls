@EndUserText.label: 'DPR VAC BAG MAT GRP Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'DprVacBagMatGrpAll'
  }
}
define root view entity ZI_DprVacBagMatGrp_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_DPRVACBAGMATGRP'
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_DprVacBagMatGrp as _DprVacBagMatGrp
{
  @UI.facet: [ {
    id: 'ZI_DprVacBagMatGrp', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'DPR VAC BAG MAT GRP', 
    position: 1 , 
    targetElement: '_DprVacBagMatGrp'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _DprVacBagMatGrp,
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
