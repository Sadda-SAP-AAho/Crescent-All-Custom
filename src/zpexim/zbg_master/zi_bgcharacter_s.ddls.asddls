@EndUserText.label: 'bg character Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZI_BgCharacter_S
  as select from I_Language
    left outer join zbg_character on 0 = 0
  composition [0..*] of ZI_BgCharacter as _BgCharacter
{
  key 1 as SingletonID,
  _BgCharacter,
  max( zbg_character.last_changed_at ) as LastChangedAtMax,
  cast( '' as sxco_transport) as TransportRequestID,
  cast( 'X' as abap_boolean preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
