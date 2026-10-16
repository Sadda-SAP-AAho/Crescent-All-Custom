@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shop Floor Vs actual Production Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PP_SHPFLR_VS_PROD_1 
as select from zdt_cont_ord as a
{
    a.id,
    a.item,
    sum( case when a.rej = 'X' then cast( a.pendprqty as abap.dec( 13, 3 ) ) else cast( 0 as abap.dec( 13, 3 ) ) end ) as Rejqty,
    sum( case when a.rej is initial then cast( a.pendprqty as abap.dec( 13, 3 ) ) else cast( 0 as abap.dec( 13, 3 ) ) end ) as appqty
}
group by
a.id,
a.item
