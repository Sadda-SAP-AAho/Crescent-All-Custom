@EndUserText.label: 'TMG DPR DI Cost Center Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'TmgDprDiCostCentAll'
  }
}
define root view entity ZI_TmgDprDiCostCenter_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_TMGDPRDICOSTCENTER'
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_TmgDprDiCostCenter as _TmgDprDiCostCenter
{
  @UI.facet: [ {
    id: 'ZI_TmgDprDiCostCenter', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'TMG DPR DI Cost Center', 
    position: 1 , 
    targetElement: '_TmgDprDiCostCenter'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _TmgDprDiCostCenter,
  @UI.hidden: true
  I_CstmBizConfignLastChgd.LastChangedDateTime as LastChangedAtMax,
  @ObjectModel.text.association: '_ABAPTransportRequestText'
  @UI.identification: [ {
    position: 2 , 
    type: #WITH_INTENT_BASED_NAVIGATION, 
    semanticObjectAction: 'manage'
  } ]
  @Consumption.semanticObject: 'CustomizingTransport'
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  _ABAPTransportRequestText
  
}
where I_Language.Language = $session.system_language
