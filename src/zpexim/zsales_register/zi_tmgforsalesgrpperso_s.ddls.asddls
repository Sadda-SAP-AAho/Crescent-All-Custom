@EndUserText.label: 'TMG for Sales grp & Person Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'TmgForSalesGrpPeAll'
  }
}
define root view entity ZI_TmgForSalesGrpPerso_S
  as select from I_Language
    left outer join ZTMG_SALESGRP on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_TmgForSalesGrpPerso as _TmgForSalesGrpPerso
{
  @UI.facet: [ {
    id: 'ZI_TmgForSalesGrpPerso', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'TMG for Sales grp & Person', 
    position: 1 , 
    targetElement: '_TmgForSalesGrpPerso'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _TmgForSalesGrpPerso,
  @UI.hidden: true
  max( ZTMG_SALESGRP.LAST_CHANGED_AT ) as LastChangedAtMax,
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
