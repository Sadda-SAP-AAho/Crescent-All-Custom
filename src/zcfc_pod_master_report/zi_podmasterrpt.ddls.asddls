@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'POD Master Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PODMASTERRPT
  as select from zdt_mpod_tmg

{
  key podcode     as Podcode,
  key contsize    as Contsize,
  key gotrackcode as Gotrackcode,
      podcodename as Podcodename,
      transitdays as Transitdays,
      grossweight as Grossweight,
      netweight   as Netweight

}
