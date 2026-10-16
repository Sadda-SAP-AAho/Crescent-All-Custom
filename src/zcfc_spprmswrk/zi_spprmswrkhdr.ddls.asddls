@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View for Spl Price for Misc Work Header'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_SPPRMSWRKHDR
  as select from zdt_spprmswrkhdr
  composition [0..*] of ZI_SPPRMSWRKITM as _Item
{
  key zdt_spprmswrkhdr.id        as Id,
      zdt_spprmswrkhdr.plantcode as Plantcode,
      zdt_spprmswrkhdr.plantname as Plantname,
      zdt_spprmswrkhdr.workcode  as Workcode,
      zdt_spprmswrkhdr.workname  as Workname,
      _Item
}
