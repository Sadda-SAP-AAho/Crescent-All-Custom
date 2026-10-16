@EndUserText.label: 'Database table for region Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'DatabaseTableForAll'
  }
}
define root view entity ZI_DatabaseTableForReg_S
  as select from I_Language
    left outer join zdt_region_tmg on 0 = 0
  composition [0..*] of ZI_DatabaseTableForReg as _DatabaseTableForReg
{

  key 1 as SingletonID,
  _DatabaseTableForReg,
  max( zdt_region_tmg.last_changed_at ) as LastChangedAtMax,
  cast( '' as sxco_transport) as TransportRequestID,
  cast( 'X' as abap_boolean preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
