@EndUserText.label: 'BG TYPE Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZI_BgType_S
  as select from I_Language
    left outer join zbg_type on 0 = 0
  composition [0..*] of ZI_BgType as _BgType
{
  key 1 as SingletonID,
  _BgType,
  max( zbg_type.last_changed_at ) as LastChangedAtMax,
  cast( '' as sxco_transport) as TransportRequestID,
  cast( 'X' as abap_boolean preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
