@EndUserText.label: 'bg status Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZI_BgStatus_S
  as select from I_Language
    left outer join zbg_status on 0 = 0
  composition [0..*] of ZI_BgStatus as _BgStatus
{
  key 1 as SingletonID,
  _BgStatus,
  max( zbg_status.last_changed_at ) as LastChangedAtMax,
  cast( '' as sxco_transport) as TransportRequestID,
  cast( 'X' as abap_boolean preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
