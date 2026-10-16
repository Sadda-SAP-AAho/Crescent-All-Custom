@EndUserText.label: 'BG INFOCATEGORY Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZI_BgInfocategory_S
  as select from I_Language
    left outer join zbg_infocategory on 0 = 0
  composition [0..*] of ZI_BgInfocategory as _BgInfocategory
{
  key 1 as SingletonID,
  _BgInfocategory,
  max( zbg_infocategory.last_changed_at ) as LastChangedAtMax,
  cast( '' as sxco_transport) as TransportRequestID,
  cast( 'X' as abap_boolean preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language

