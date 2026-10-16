@EndUserText.label: 'Database table for Doc Type TMG Singleto'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'DatabaseTableForAll'
  }
}
define root view entity ZI_DatabaseTableForDoc_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_DATABASETABLEFORDOC'
  association [0..*] to I_ABAPTransportRequestText as _I_ABAPTransportRequestText on $projection.TransportRequestID = _I_ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_DatabaseTableForDoc as _DatabaseTableForDoc
{
  @UI.facet: [ {
    id: 'ZI_DatabaseTableForDoc', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Database table for Doc Type TMG', 
    position: 1 , 
    targetElement: '_DatabaseTableForDoc'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _DatabaseTableForDoc,
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
