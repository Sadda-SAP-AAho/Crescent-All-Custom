@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR BARODA - Excess Weight'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_BARD_23
  as select from    zdt_conf_itm     as a
    inner join      zdt_conf_hdr     as b on b.id = a.id
    inner join      I_Product        as c on c.Product = a.matnr
    left outer join zdt_pp_matinffld as d on d.product = a.matnr
{
  b.shpflrdt,
  b.dept,
  b.plant,
  a.matnr,
  cast( a.totcast as abap.dec( 13, 3 ) )                                                                                                                                                                                                                                            as totcast,
  cast( a.actwt  as abap.dec( 13, 3 ) )                                                                                                                                                                                                                                             as actwt,
  cast( d.machloss  as abap.dec( 13, 3 ) )                                                                                                                                                                                                                                          as machloss,
  cast( c.NetWeight  as abap.dec( 13, 3 ) )                                                                                                                                                                                                                                         as netweight,
  cast( a.stdwt  as abap.dec( 13, 3 ) )                                                                                                                                                                                                                                             as stdwt,
  cast( ( cast( a.totcast as abap.dec( 13, 3 ) ) * cast( ( coalesce( cast( a.actwt  as abap.dec( 13, 3) ), 0 ) - ( coalesce( cast( d.machloss as abap.dec( 13, 3) ), 0 ) + coalesce( cast( a.stdwt  as abap.dec( 13, 3 ) ), 0 ) ) ) as abap.dec( 13, 3 ) ) ) as abap.dec( 23, 3 ) ) as excesswt

}
where
      b.opr          = '0040'
  and c.ProductGroup = 'Z025'
  
union select from    zdt_conf_itm     as a
    inner join      zdt_conf_hdr     as b on b.id = a.id
    inner join      I_Product        as c on c.Product = a.matnr
    left outer join zdt_pp_matinffld as d on d.product = a.matnr
{
  b.shpflrdt,
  b.dept,
  b.plant,
  a.matnr,
  cast( a.totcast as abap.dec( 13, 3 ) )                                                                                                                                                                                                                                            as totcast,
  cast( a.actwt  as abap.dec( 13, 3 ) )                                                                                                                                                                                                                                             as actwt,
  cast( d.machloss  as abap.dec( 13, 3 ) )                                                                                                                                                                                                                                          as machloss,
  cast( c.NetWeight  as abap.dec( 13, 3 ) )                                                                                                                                                                                                                                         as netweight,
  cast( a.stdwt  as abap.dec( 13, 3 ) )                                                                                                                                                                                                                                             as stdwt,
  cast( ( cast( a.totcast as abap.dec( 13, 3 ) ) * cast( ( coalesce( cast( a.actwt  as abap.dec( 13, 3) ), 0 ) - ( coalesce( cast( d.machloss as abap.dec( 13, 3) ), 0 ) + coalesce( cast( a.stdwt  as abap.dec( 13, 3 ) ), 0 ) ) ) as abap.dec( 13, 3 ) ) ) as abap.dec( 23, 3 ) ) as excesswt

}
where
      b.opr          = '0100'
  and c.ProductGroup = 'Z045'  
