@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Delivery Qy Cal F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zdelqtypo
  as select from zdt_gitem as a
    inner join   zdt_ghead as b on b.id = a.id
{
  a.ebeln,
  a.ebelp,
  @Semantics.quantity.unitOfMeasure : 'Meins'
  sum( a.challanqty ) as challanqty,
  a.meins
}
where b.status <> 'Deleted'
group by
  a.ebeln,
  a.ebelp,
  a.meins
