@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'CDS for Planning Rpt 2_3'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZR_PLAN_RPT_2_3
  as select distinct from ZR_PLAN_RPT_2_2 as a

    inner join            zdt_plan_stock  as b on  a.plant     = b.plant
    //                                      and a.hedmaterial = b.hedmaterial
                                               and a.component = b.component

{
  key a.plant,
      //  key a.hedmaterial,
  key a.component,

      a.OpenSoQty,
      a.castonhand,
      a.SfgOnHand,
      a.SfgLiveQty,
      cast((cast(a.SfgLiveQty as abap.dec(15,3))   *
      cast(a.NetWeight as abap.dec(10,3))) as abap.dec(23,3)) as SfgLiveWt,
      a.SfgdeadQty,
      cast((cast(a.SfgdeadQty as abap.dec(15,3))   *
      cast(a.NetWeight as abap.dec(10,3))) as abap.dec(23,3)) as SfgdeadWt,
      a.Totalstockqty,
      cast((cast(a.Totalstockqty as abap.dec(15,3))   *
      cast(a.NetWeight as abap.dec(10,3))) as abap.dec(23,3)) as TotalstockWt,
      a.OpenSoQty7,
      a.OpenSoQty8,
      a.OpenSoQty16,
      a.OpenSoQty23,
      a.OpenSoQty31,
      a.OpenSoQty39,
      a.OpenSoQty47,
      a.OpenSoQty55,
      a.OpenSoQty63,
      a.OpenSoQty71,
      a.OpenSoQty366,

      cast((cast(b.opensoqtysnl7 as abap.dec(15,3))   *
      cast(a.NetWeight as abap.dec(10,3))) as abap.dec(23,3)) as OpenSoQtySwt7,

      b.opensoqtysnl7,
      ' '                                                     as OpenSoQtySrd7,

      cast((cast(b.opensoqtysnl8 as abap.dec(15,3))   *
      cast(a.NetWeight as abap.dec(10,3))) as abap.dec(23,3)) as OpenSoQtySwt8,

      b.opensoqtysnl8,
      ' '                                                     as OpenSoQtySrd8,

      cast((cast(b.opensoqtysnl16 as abap.dec(15,3))   *
      cast(a.NetWeight as abap.dec(10,3))) as abap.dec(23,3)) as OpenSoQtySwt16,

      b.opensoqtysnl16,
      ' '                                                     as OpenSoQtySrd16,

      cast((cast(b.opensoqtysnl23 as abap.dec(15,3))   *
      cast(a.NetWeight as abap.dec(10,3))) as abap.dec(23,3)) as OpenSoQtySwt23,

      b.opensoqtysnl23,
      ' '                                                     as OpenSoQtySrd23,

      cast((cast(b.opensoqtysnl31 as abap.dec(15,3))   *
      cast(a.NetWeight as abap.dec(10,3))) as abap.dec(23,3)) as OpenSoQtySwt31,

      b.opensoqtysnl31,
      ' '                                                     as OpenSoQtySrd31,

      cast((cast(b.opensoqtysnl39 as abap.dec(15,3))   *
      cast(a.NetWeight as abap.dec(10,3))) as abap.dec(23,3)) as OpenSoQtySwt39,

      b.opensoqtysnl39,
      ' '                                                     as OpenSoQtySrd39,

      cast((cast(b.opensoqtysnl47 as abap.dec(15,3))   *
      cast(a.NetWeight as abap.dec(10,3))) as abap.dec(23,3)) as OpenSoQtySwt47,

      b.opensoqtysnl47,
      ' '                                                     as OpenSoQtySrd47,

      cast((cast(b.opensoqtysnl55 as abap.dec(15,3))   *
      cast(a.NetWeight as abap.dec(10,3))) as abap.dec(23,3)) as OpenSoQtySwt55,

      b.opensoqtysnl55,
      ' '                                                     as OpenSoQtySrd55,

      cast((cast(b.opensoqtysnl63 as abap.dec(15,3))   *
      cast(a.NetWeight as abap.dec(10,3))) as abap.dec(23,3)) as OpenSoQtySwt63,

      b.opensoqtysnl63,
      ' '                                                     as OpenSoQtySrd63,

      cast((cast(b.opensoqtysnl71 as abap.dec(15,3))   *
      cast(a.NetWeight as abap.dec(10,3))) as abap.dec(23,3)) as OpenSoQtySwt71,

      b.opensoqtysnl71,
      ' '                                                     as OpenSoQtySrd71,

      cast((cast(b.opensoqtysnl366 as abap.dec(15,3))   *
      cast(a.NetWeight as abap.dec(10,3))) as abap.dec(23,3)) as OpenSoQtySwt366,

      b.opensoqtysnl366,
      ' '                                                     as OpenSoQtySrd366
      //      case when coalesce( OpenSoQty7,0 ) - coalesce( Totalstockqty,0)  > 0
      //           then cast( ( ( cast( coalesce( OpenSoQty7,0) as abap.dec( 10, 3 ) ) -
      //                          cast(coalesce(Totalstockqty,0) as abap.dec( 10, 3) )  ) *
      //                          cast( NetWeight as abap.dec( 10, 3) ) ) as abap.dec( 13, 3) )
      //          else null end                                                                                                                  as OpenSoQtySwt7,
      //      case when qtyperbox is not initial then
      //                division( ( coalesce( OpenSoQty7,0 ) - coalesce(Totalstockqty,0) ),cast( qtyperbox as abap.dec(3,0)) ,3 )  else null end as OpenSoQtySnl7,
      //      ' '                                       as OpenSoQtySrd7
      //      cast( ( ( cast( coalesce(Totalstockqty,0) as abap.dec( 10, 3) ) -
      //                cast( coalesce(OpenSoQty8,0) as abap.dec( 10, 3 ) ) ) *
      //                cast( NetWeight as abap.dec( 10, 3) ) ) as abap.dec( 13, 3) )                                                            as OpenSoQtySwt8,
      //      case when qtyperbox is not initial then
      //                division( ( coalesce(Totalstockqty,0) - coalesce(OpenSoQty8,0) ),cast( qtyperbox as abap.dec( 3,0) ),3 ) else null end   as OpenSoQtySnl8,
      //      ' '                                                                                                                                as OpenSoQtySrd8,
      //
      //      cast( ( ( cast( coalesce(Totalstockqty,0) as abap.dec( 10, 3) ) -
      //                cast( coalesce(OpenSoQty16,0) as abap.dec( 10, 3 ) ) ) *
      //                cast( NetWeight as abap.dec( 10, 3) ) ) as abap.dec( 13, 3) )                                                            as OpenSoQtySwt16,
      //      case when qtyperbox is not initial then
      //                division( ( coalesce(Totalstockqty,0) - coalesce(OpenSoQty16,0) ),cast( qtyperbox as abap.dec( 3,0) ),3 ) else null end  as OpenSoQtySnl16,
      //      ' '                                                                                                                                as OpenSoQtySrd16,
      //      cast( ( ( cast( coalesce(Totalstockqty,0) as abap.dec( 10, 3) ) -
      //                cast( coalesce(OpenSoQty23,0) as abap.dec( 10, 3 ) ) ) *
      //                cast( NetWeight as abap.dec( 10, 3) ) ) as abap.dec( 13, 3) )                                                            as OpenSoQtySwt23,
      //      case when qtyperbox is not initial then
      //                division( ( coalesce(Totalstockqty,0) - coalesce(OpenSoQty23,0) ),cast( qtyperbox as abap.dec( 3,0) ),3 ) else null end  as OpenSoQtySnl23,
      //      ' '                                                                                                                                as OpenSoQtySrd23,
      //      cast( ( ( cast( coalesce(Totalstockqty,0) as abap.dec( 10, 3) ) -
      //                cast( coalesce(OpenSoQty31,0) as abap.dec( 10, 3 ) ) ) *
      //                cast( NetWeight as abap.dec( 10, 3) ) ) as abap.dec( 13, 3) )                                                            as OpenSoQtySwt31,
      //      case when qtyperbox is not initial then
      //                division( ( coalesce(Totalstockqty,0) - coalesce(OpenSoQty31,0) ),cast( qtyperbox as abap.dec( 3,0) ),3 ) else null end  as OpenSoQtySnl31,
      //      ' '                                                                                                                                as OpenSoQtySrd31,
      //      cast( ( ( cast( coalesce(Totalstockqty,0) as abap.dec( 10, 3) ) -
      //                cast( coalesce(OpenSoQty39,0) as abap.dec( 10, 3 ) ) ) *
      //                cast( NetWeight as abap.dec( 10, 3) ) ) as abap.dec( 13, 3) )                                                            as OpenSoQtySwt39,
      //      case when qtyperbox is not initial then
      //                division( ( coalesce(Totalstockqty,0) - coalesce(OpenSoQty39,0) ),cast( qtyperbox as abap.dec( 3,0) ),3 ) else null end  as OpenSoQtySnl39,
      //      ' '                                                                                                                                as OpenSoQtySrd39,
      //      cast( ( ( cast( coalesce(Totalstockqty,0) as abap.dec( 10, 3) ) -
      //               cast( coalesce(OpenSoQty47,0) as abap.dec( 10, 3 ) ) ) *
      //               cast( NetWeight as abap.dec( 10, 3) ) ) as abap.dec( 13, 3) )                                                             as OpenSoQtySwt47,
      //      case when qtyperbox is not initial then
      //                division( ( coalesce(Totalstockqty,0) - coalesce(OpenSoQty47,0) ),cast( qtyperbox as abap.dec( 3,0) ),3 ) else null end  as OpenSoQtySnl47,
      //      ' '                                                                                                                                as OpenSoQtySrd47,
      //      cast( ( ( cast( coalesce(Totalstockqty,0) as abap.dec( 10, 3) ) -
      //               cast( coalesce(OpenSoQty55,0) as abap.dec( 10, 3 ) ) ) *
      //               cast( NetWeight as abap.dec( 10, 3) ) ) as abap.dec( 13, 3) )                                                             as OpenSoQtySwt55,
      //      case when qtyperbox is not initial then
      //                division( ( coalesce(Totalstockqty,0) - coalesce(OpenSoQty55,0) ),cast( qtyperbox as abap.dec( 3,0) ),3 ) else null end  as OpenSoQtySnl55,
      //      ' '                                                                                                                                as OpenSoQtySrd55,
      //      cast( ( ( cast( coalesce(Totalstockqty,0) as abap.dec( 10, 3) ) -
      //               cast( coalesce(OpenSoQty63,0) as abap.dec( 10, 3 ) ) ) *
      //               cast( NetWeight as abap.dec( 10, 3) ) ) as abap.dec( 13, 3) )                                                             as OpenSoQtySwt63,
      //      case when qtyperbox is not initial then
      //                division( ( coalesce(Totalstockqty,0) - coalesce(OpenSoQty63,0) ),cast( qtyperbox as abap.dec( 3,0) ),3 ) else null end  as OpenSoQtySnl63,
      //      ' '                                                                                                                                as OpenSoQtySrd63,
      //      cast( ( ( cast( coalesce(Totalstockqty,0) as abap.dec( 10, 3) ) -
      //                cast( coalesce(OpenSoQty71,0) as abap.dec( 10, 3 ) ) ) *
      //                cast( NetWeight as abap.dec( 10, 3) ) ) as abap.dec( 13, 3) )                                                            as OpenSoQtySwt71,
      //      case when qtyperbox is not initial then
      //                division( ( coalesce(Totalstockqty,0) - coalesce(OpenSoQty71,0) ),cast( qtyperbox as abap.dec( 3,0) ),3 ) else null end  as OpenSoQtySnl71,
      //      ' '                                                                                                                                as OpenSoQtySrd71,
      //      cast( ( ( cast( coalesce(Totalstockqty,0) as abap.dec( 10, 3) ) -
      //                cast( coalesce(OpenSoQty366,0) as abap.dec( 10, 3 ) ) ) *
      //                cast( NetWeight as abap.dec( 10, 3) ) ) as abap.dec( 13, 3) )                                                            as OpenSoQtySwt366,
      //      case when qtyperbox is not initial then
      //                division( ( coalesce(Totalstockqty,0) - coalesce(OpenSoQty366,0) ),cast( qtyperbox as abap.dec( 3,0) ),3 ) else null end as OpenSoQtySnl366,
      //      ' '                                                                                                                                as OpenSoQtySrd366
}
