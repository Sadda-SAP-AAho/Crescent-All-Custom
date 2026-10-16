@EndUserText.label: 'Details For Company Code & Plant Singlet'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'DetailsForCompanAll'
  }
}
define root view entity ZI_DetailsForCompanyCo_S
  as select from I_Language
    left outer join zdt_mm_pc_tmg on 0 = 0
  composition [0..*] of ZI_DetailsForCompanyCo as _DetailsForCompanyCo
{
  key 1 as SingletonID,
  _DetailsForCompanyCo,
  max( zdt_mm_pc_tmg.last_changed_at ) as LastChangedAtMax,
  cast( '' as sxco_transport) as TransportRequestID,
  cast( 'X' as abap_boolean preserving type) as HideTransport

  
}
where I_Language.Language = $session.system_language
