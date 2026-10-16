@EndUserText.label: 'Organization Mail id base of Vendor Grp'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'OrganizationMailAll'
  }
}
define root view entity ZI_OrganizationMailIdB_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_ORGANIZATIONMAILIDB'
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_OrganizationMailIdB as _OrganizationMailIdB
{
  @UI.facet: [ {
    id: 'ZI_OrganizationMailIdB', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Organization Mail id base of Vendor Grp', 
    position: 1 , 
    targetElement: '_OrganizationMailIdB'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _OrganizationMailIdB,
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
