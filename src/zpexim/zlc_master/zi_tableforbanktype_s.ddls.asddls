@EndUserText.label: 'Table for Bank Type Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZI_TableForBankType_S
  as select from I_Language
    left outer join zdt_banktypef4 on 0 = 0
  composition [0..*] of ZI_TableForBankType as _TableForBankType
{
  key 1 as SingletonID,
  _TableForBankType,
  max( zdt_banktypef4.last_changed_at ) as LastChangedAtMax,
  cast( '' as sxco_transport) as TransportRequestID,
  cast( 'X' as abap_boolean preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
