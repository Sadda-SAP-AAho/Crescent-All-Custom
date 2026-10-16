@EndUserText.label: 'TMG for material deletion in mat info up'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'TmgForMaterialDeAll'
  }
}
define root view entity ZI_TmgForMaterialDelet_S
  as select from I_Language
    left outer join ZDT_MAT_DEL on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_TmgForMaterialDelet as _TmgForMaterialDelet
{
  @UI.facet: [ {
    id: 'ZI_TmgForMaterialDelet', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'TMG for material deletion in mat info up', 
    position: 1 , 
    targetElement: '_TmgForMaterialDelet'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _TmgForMaterialDelet,
  @UI.hidden: true
  max( ZDT_MAT_DEL.LAST_CHANGED_AT ) as LastChangedAtMax,
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
