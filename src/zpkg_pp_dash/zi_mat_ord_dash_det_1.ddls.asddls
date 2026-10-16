@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Used Quantity Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MAT_ORD_DASH_DET_1
 as select from ZI_CONF_ORD as a
 left outer join ZI_CONFPOST_ORD as b on b.Refid = a.Id and b.RefItem = a.Item and b.Reford = a.Ord
{  
    key a.Shpflrno,
    key a.Prodord,
    key a.Matnr,
    key a.Plant,
    @Semantics.quantity.unitOfMeasure: 'Meins'
    sum( a.Pendprqty ) as Qty,
    @Semantics.quantity.unitOfMeasure: 'Meins'
    sum( b.Alpostqty ) as Apqty,
    a.Meins
//    a.Status
}
//where Status = 'C'
group by a.Shpflrno, a.Prodord, a.Matnr, a.Plant, a.Meins, a.Status
