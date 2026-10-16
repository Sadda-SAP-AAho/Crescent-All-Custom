@EndUserText.label: 'Table for PSA Indicator Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZI_TableForPsaIndicato_S
  as select from I_Language
    left outer join ZDT_PSA_INDC on 0 = 0
  composition [0..*] of ZI_TableForPsaIndicato as _TableForPsaIndicato
{
  key 1 as SingletonID,
  _TableForPsaIndicato,
  max( ZDT_PSA_INDC.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
