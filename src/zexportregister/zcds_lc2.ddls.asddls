@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LC Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_lc2
  as select from    ZI_LCEXPHEAD as a
    left outer join ZI_LCEXPITM  as b on b.Id = a.Id
{
  b.Delivery,
  b.Id,
  a.Lc_Appl,
  a.Lc_Req_Date,
  a.Lc_Open_Dt
}
