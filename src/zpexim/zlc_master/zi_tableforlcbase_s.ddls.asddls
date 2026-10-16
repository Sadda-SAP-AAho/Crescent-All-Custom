@EndUserText.label: 'Table for LC Base Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZI_TableForLcBase_S
  as select from I_Language
    left outer join zdt_lcbasef4 on 0 = 0
  composition [0..*] of ZI_TableForLcBase as _TableForLcBase
{
  key 1 as SingletonID,
  _TableForLcBase,
  max( zdt_lcbasef4.last_changed_at ) as LastChangedAtMax,
  cast( '' as sxco_transport) as TransportRequestID,
  cast( 'X' as abap_boolean preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
