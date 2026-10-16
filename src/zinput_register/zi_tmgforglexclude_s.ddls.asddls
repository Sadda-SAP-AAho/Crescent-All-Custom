@EndUserText.label: 'TMG FOR GL EXCLUDE Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'TmgForGlExcludeAll'
  }
}
define root view entity ZI_TmgForGlExclude_S
  as select from I_Language
    left outer join ZDT_GLTMG on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_TmgForGlExclude as _TmgForGlExclude
{
  @UI.facet: [ {
    id: 'ZI_TmgForGlExclude', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'TMG FOR GL EXCLUDE', 
    position: 1 , 
    targetElement: '_TmgForGlExclude'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _TmgForGlExclude,
  @UI.hidden: true
  max( ZDT_GLTMG.LAST_CHANGED_AT ) as LastChangedAtMax,
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
