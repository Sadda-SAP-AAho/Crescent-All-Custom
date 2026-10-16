@EndUserText.label: 'Cost & Profit Center TMG Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'CostProfitCenterAll'
  }
}
define root view entity ZI_CostProfitCenterTmg_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_COSTPROFITCENTERTMG'
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_CostProfitCenterTmg as _CostProfitCenterTmg
{
  @UI.facet: [ {
    id: 'ZI_CostProfitCenterTmg', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Cost & Profit Center TMG', 
    position: 1 , 
    targetElement: '_CostProfitCenterTmg'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _CostProfitCenterTmg,
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
