@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR DI- Charging OPRN'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_DI_6
  as select from zdt_conf_hdr as b
{
  b.shpflrdt,
  b.dept,
  sum( case when b.arpacharg is not initial then cast( b.arpacharg as abap.dec( 13, 3 ) ) else cast( 0 as abap.dec( 13, 3) ) end ) as arpacharg,
  sum( case when b.rhinocharg is not initial then cast( b.rhinocharg as abap.dec( 13, 3 ) ) else cast( 0 as abap.dec( 13, 3) ) end ) as rhinocharg, //rhinocharg,
  sum( case when b.handmochrg is not initial then cast( b.handmochrg as abap.dec( 13, 3 ) ) else cast( 0 as abap.dec( 13, 3) ) end ) as handmochrg
  //  cast( b.arpacharg as abap.dec( 13, 3) ) as arpacharg,
  //  cast( b.rhinocharg as abap.dec( 13, 3) ) as rhinocharg,
  //  cast( b.handmochrg as abap.dec( 13, 3) ) as handmochrg
  ////  sum( coalesce( cast( b.arpacharg as abap.dec( 13, 3) ), 0 ) + coalesce( cast( b.rhinocharg as abap.dec( 13, 3) ), 0 )
  //                 + coalesce( cast( b.handmochrg as abap.dec( 13, 3) ), 0 ) ) as chargoprn
}
where
       b.opr      = '0010'
  and(
       arpacharg  is not initial
    or handmochrg is not initial
    or handmochrg is not initial
  )
group by
  b.shpflrdt,
  b.dept
