@EndUserText.label: 'TMG table for Packing Material Type Sing'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'TmgTableForPackiAll'
  }
}
define root view entity ZI_TmgTableForPackingM_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_TMGTABLEFORPACKINGM'
  association [0..*] to I_ABAPTransportRequestText as _I_ABAPTransportRequestText on $projection.TransportRequestID = _I_ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_TmgTableForPackingM as _TmgTableForPackingM
{
  @UI.facet: [ {
    id: 'ZI_TmgTableForPackingM', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'TMG table for Packing Material Type', 
    position: 1 , 
    targetElement: '_TmgTableForPackingM'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _TmgTableForPackingM,
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
