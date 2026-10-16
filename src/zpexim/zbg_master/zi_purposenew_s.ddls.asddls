@EndUserText.label: 'purpose new Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZI_PurposeNew_S
  as select from I_Language
    left outer join zbg_pnew on 0 = 0
  composition [0..*] of ZI_PurposeNew as _PurposeNew
{
  key 1 as SingletonID,
  _PurposeNew,
  max( zbg_pnew.last_changed_at ) as LastChangedAtMax,
  cast( '' as sxco_transport) as TransportRequestID,
  cast( 'X' as abap_boolean preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
