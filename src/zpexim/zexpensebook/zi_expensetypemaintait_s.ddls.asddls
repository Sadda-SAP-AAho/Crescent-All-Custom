@EndUserText.label: 'ExpenseTypeMaintainTable Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'ExpensetypemaintAll'
  }
}
define root view entity ZI_Expensetypemaintait_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_EXPENSETYPEMAINTAINT'
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_Expensetypemaintaint as _Expensetypemaintain
{
  @UI.facet: [ {
    id: 'ZI_Expensetypemaintaint', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'ExpenseTypeMaintainTable', 
    position: 1 , 
    targetElement: '_Expensetypemaintain'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _Expensetypemaintain,
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
