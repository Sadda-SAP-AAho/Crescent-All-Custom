@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Go-Comet POD'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_GOCOMET_POL
as select distinct from zdt_mpod_tmg
{
   key podcodename,
//   key transitdays,
   key gotrackcode   
}
group by
podcodename,
//transitdays,
gotrackcode   
