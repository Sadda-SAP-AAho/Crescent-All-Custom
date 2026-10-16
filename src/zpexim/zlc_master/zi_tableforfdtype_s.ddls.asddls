@EndUserText.label: 'Table for FD Type Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZI_TableForFdType_S
  as select from I_Language
    left outer join ZDT_FD_TYPE on 0 = 0
  composition [0..*] of ZI_TableForFdType as _TableForFdType
{
  key 1 as SingletonID,
  _TableForFdType,
  max( ZDT_FD_TYPE.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
