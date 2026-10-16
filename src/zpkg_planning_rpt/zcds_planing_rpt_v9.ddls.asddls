@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Planning Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PLANING_RPT_V9 
as select from zdt_packlist_hdr  as f                                      
{
    f.delivery,
    f.packinglist,
    f.createdon
}
where f.canind   <> 'X'
group by
f.delivery,
f.packinglist,
f.createdon
