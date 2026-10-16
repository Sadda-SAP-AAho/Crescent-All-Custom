@EndUserText.label: 'Table for LC Type Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZI_TableForLcType_S
  as select from I_Language
    left outer join ZDT_LCTYPEF4 on 0 = 0
  composition [0..*] of ZI_TableForLcType as _TableForLcType
{
  key 1 as SingletonID,
  _TableForLcType,
  max( ZDT_LCTYPEF4.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
