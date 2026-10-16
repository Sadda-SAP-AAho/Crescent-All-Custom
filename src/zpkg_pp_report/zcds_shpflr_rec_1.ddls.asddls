@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shorfloor Already Posted Quantity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SHPFLR_REC_1 
as select from ZCDS_SHPFLR_REC
{
    refid,
    refitem,
    shpflrno,
    matnr,
    meins,
    @Semantics.quantity.unitOfMeasure: 'Meins'
    sum( recqty ) as recqty,
    @Semantics.quantity.unitOfMeasure: 'Meins'
    sum( rejrecqty ) as rejrecqty
}
group by
refid,
refitem,
shpflrno,
matnr,
meins
