@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Used Quantity Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MAT_ORD_DASH_DET_2 
as select from ZI_MAT_ORD_DASH_DET_1 as a
{
    key a.Shpflrno,
    key a.Prodord,
    key a.Matnr,
    key a.Plant,
    @Semantics.quantity.unitOfMeasure: 'Meins'
    case when a.Apqty is not initial
    then ( cast( a.Qty as abap.quan( 13, 3 ) ) - cast( a.Apqty as abap.quan( 13, 3 ) ) )
    else cast( a.Qty as abap.quan( 13, 3 ) ) end as Qty, 
    a.Meins
}
