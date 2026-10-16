@EndUserText.label: 'Approval Matrix For Payments Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'ApprovalMatrixFoAll'
  }
}
define root view entity ZI_ApprovalMatrixForPa_S
  as select from I_Language
    left outer join ZTMG_APPR_MATRIX on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _I_ABAPTransportRequestText on $projection.TransportRequestID = _I_ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_ApprovalMatrixForPa as _ApprovalMatrixForPa
{
  @UI.facet: [ {
    id: 'ZI_ApprovalMatrixForPa', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Approval Matrix For Payments', 
    position: 1 , 
    targetElement: '_ApprovalMatrixForPa'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _ApprovalMatrixForPa,
  @UI.hidden: true
  max( ZTMG_APPR_MATRIX.LAST_CHANGED_AT ) as LastChangedAtMax,
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
