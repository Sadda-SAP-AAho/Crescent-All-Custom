@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shorfloor Already Posted Quantity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SHPFLR_REC
  as select from zdt_confpost_ord
{
  refid,
  refitem,
  shpflrno,
  matnr,
  meins,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  ( case when rej is initial then sum( alpostqty ) else cast( 0 as abap.quan( 13, 2 ) ) end ) as recqty,
  @Semantics.quantity.unitOfMeasure: 'meins'
  ( case when rej is not initial then sum( alpostqty ) else cast( 0 as abap.quan( 13, 2 ) ) end ) as rejrecqty

}
group by
  refid,
  refitem,
  shpflrno,
  matnr,
  meins,
  rej
