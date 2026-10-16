@EndUserText.label: 'TMG table for Labour Category Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'TmgTableForLabCatAll'
  }
}
define root view entity ZI_TmgTableForLabCat_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_TMGTABLEFORLABCAT'
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_TmgTableForLabCat as _TmgTableForLabCat
{
  @UI.facet: [ {
    id: 'ZI_TmgTableForLabCat', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'TMG table for Labour Category', 
    position: 1 , 
    targetElement: '_TmgTableForLabCat'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _TmgTableForLabCat,
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
