@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Weight Calculation'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_weight1
  as select from    zdt_packlist_hdr as a
    left outer join zdt_packlist_itm as b on  b.packinglist = a.packinglist
                                          and b.id          = a.id
{
  a.packinglist,
  a.delivery,
  a.revision,
  cast( sum(b.netwt) as abap.dec( 21, 2 ) ) as netwt,
  cast( sum(b.growt) as abap.dec( 21, 2 ) ) as growt
}
where
  a.canind <> 'X'


group by
  a.packinglist,
  a.delivery,
  a.revision
