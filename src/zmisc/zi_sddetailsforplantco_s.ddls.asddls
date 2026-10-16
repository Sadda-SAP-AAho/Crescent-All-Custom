@EndUserText.label: 'SD details For Plant & Company Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'SdDetailsForPlanAll'
  }
}
define root view entity ZI_SdDetailsForPlantCo_S
  as select from I_Language
    left outer join zdt_sd_pc_tmg on 0 = 0
  composition [0..*] of ZI_SdDetailsForPlantCo as _SdDetailsForPlantCo
{

  key 1 as SingletonID,
  _SdDetailsForPlantCo,
  max( zdt_sd_pc_tmg.last_changed_at ) as LastChangedAtMax,
  cast( '' as sxco_transport) as TransportRequestID,
  cast( 'X' as abap_boolean preserving type) as HideTransport

  
}
where I_Language.Language = $session.system_language
