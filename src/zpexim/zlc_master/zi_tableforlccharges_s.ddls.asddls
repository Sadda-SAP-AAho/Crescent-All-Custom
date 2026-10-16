@EndUserText.label: 'Table for LC Charges Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZI_TableForLcCharges_S
  as select from I_Language
    left outer join ZDT_CHARGESF4 on 0 = 0
  composition [0..*] of ZI_TableForLcCharges as _TableForLcCharges
{
  key 1 as SingletonID,
  _TableForLcCharges,
  max( ZDT_CHARGESF4.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
