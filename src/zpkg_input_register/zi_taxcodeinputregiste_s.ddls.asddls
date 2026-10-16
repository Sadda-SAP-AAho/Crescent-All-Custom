@EndUserText.label: 'Taxcode Input Register Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'TaxcodeInputRegiAll'
  }
}
define root view entity ZI_TaxcodeInputRegiste_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_TAXCODEINPUTREGISTE'
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_TaxcodeInputRegiste as _TaxcodeInputRegiste
{
  @UI.facet: [ {
    id: 'ZI_TaxcodeInputRegiste', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Taxcode Input Register', 
    position: 1 , 
    targetElement: '_TaxcodeInputRegiste'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _TaxcodeInputRegiste,
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
