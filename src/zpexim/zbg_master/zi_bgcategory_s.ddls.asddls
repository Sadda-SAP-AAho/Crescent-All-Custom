@EndUserText.label: 'bg category Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZI_BgCategory_S
  as select from I_Language
    left outer join zbg_category on 0 = 0
  composition [0..*] of ZI_BgCategory as _BgCategory
{
  key 1 as SingletonID,
  _BgCategory,
  max( zbg_category.last_changed_at ) as LastChangedAtMax,
  cast( '' as sxco_transport) as TransportRequestID,
  cast( 'X' as abap_boolean preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language

