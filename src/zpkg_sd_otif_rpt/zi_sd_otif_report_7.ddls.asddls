@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OTIF Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_OTIF_REPORT_7
  as select from ZI_PACKLIST_HDR as a 
{
  a.Delivery,
  max( a.Createdon ) as Createdon
}
where
  Canind <> 'X'
group by
  Delivery
