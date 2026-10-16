@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'ZI_FEASVACUUM_F4'
@ObjectModel.representativeKey: 'matcd'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L

define root view entity ZI_FEASVACUUM_F4
  as select distinct from zdt_fesvacuum as a
    left outer join       zdt_estvac    as b on a.matcd = b.matcd
{

  key  a.matcd,
  key  a.rfqdate,
       a.line                                                                                                                                                                                                                                                                                                             as typofmld,
       a.boxsize1,
       a.boxsize2,
       a.annualqty,
       a.mouldspd,
       a.weight_2d                                                                                                                                                                                                                                                                                                        as reqweight,
       a.noofcav,
       a.yldprcnt                                                                                                                                                                                                                                                                                                         as yield,
       a.addcst                                                                                                                                                                                                                                                                                                           as addacccost,
       a.drlfacing                                                                                                                                                                                                                                                                                                        as drillperfacing,
       a.srfcarea,

       /// Tonnage ///
       cast( abs( division( cast(a.weight_2d * a.annualqty as abap.dec(12,3) ), 1000, 3 ) ) as abap.dec(12,3) )                                                                                                                                                                                                           as tonnagecal,

       /// Weight / box (kg.) ///
       cast(a.weight_2d as abap.dec(12,3))  * cast( a.noofcav as abap.dec(12,3))                                                                                                                                                                                                                                          as wgtprbxcal,

       ///Melting Cost/MT///
       cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))                                                                                                                                              as mltngcstmtcal,

       ///Total cost/MT///
       cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
       + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3))                                                                                                                                                                                                                                        as totlcstmtcal,

       ///Total cost/MT with tolerance///
       ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
         + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3) ) ) +
         ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
         + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3)) ) * cast( b.tolerance as abap.dec(9,3) ) )                                                                                                                                                                                           as totlcsttolcal,

       /// Metal Cost / Piece///
       cast( abs( division( ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
         + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3) ) ) +
         ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
         + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3)) ) * cast( b.tolerance as abap.dec(9,3) ) ) * cast( a.weight_2d as abap.dec(6,3) ) ), 1000, 3 ) ) as abap.dec(12,3) )                                                                                                                 as mtlcstprpccal,

       /// Labour for Moulding/Box///
       cast( abs( division( cast( b.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) )                                                                                                                                                  as labmldperbxcal,

       ///Maintenance/Pc///
       cast( abs( division( cast( b.mntcstperpc as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) )                                                                                                                                                  as mntprpccal,

       ///Fettling Cost/Pc///
       cast( abs( division( ( cast( b.fetcstperpc as abap.dec(12,3) ) * cast( a.weight_2d as abap.dec(6,3) ) ), 1000, 3 ) ) as abap.dec(12,3) )                                                                                                                                                                           as fetcstprpccal,

       ///Cost of Molding/MT///
       ( cast ( b.elccst as abap.dec(12,3) ) + cast( abs( division( cast( b.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) ) +
       cast ( b.mldcst as abap.dec(12,3) ) + cast( abs( division( cast( b.mntcstperpc as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) ) +
       cast( abs( division( ( cast( b.fetcstperpc as abap.dec(12,3) ) * cast( a.weight_2d as abap.dec(6,3) ) ), 1000, 3 ) ) as abap.dec(12,3) ) ) *
       cast( abs( division( cast(a.weight_2d as abap.dec(12,3) ), 1000, 3 ) ) as abap.dec(12,3) )                                                                                                                                                                                                                         as cstmldprmtcal,

       ///Paint (Labour + Material)-Primer Cost///
       cast ( b.paintprcst as abap.dec(12,3) ) * cast ( a.srfcarea as abap.dec(12,3) )                                                                                                                                                                                                                                    as pntprmrcstcal,

       ///Manufacturing Cost - w/o VA /MT///
       cast( abs( division( ( ( cast ( b.elccst as abap.dec(12,3) ) + cast( abs( division( cast( b.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) ) +
       cast ( b.mldcst as abap.dec(12,3) ) + cast( abs( division( cast( b.mntcstperpc as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) ) +
       cast( abs( division( ( cast( b.fetcstperpc as abap.dec(12,3) ) * cast( a.weight_2d as abap.dec(6,3) ) ), 1000, 3 ) ) as abap.dec(12,3) ) ) *
       cast( abs( division( cast(a.weight_2d as abap.dec(12,3) ), 1000, 3 ) ) as abap.dec(12,3) ) ) +
       ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
         + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3) ) ) +
         ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
         + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3)) ) * cast( b.tolerance as abap.dec(9,3) ) ) ), 1000, 3 ) ) as abap.dec(12,3) )                                                                                                                                                        as mnfcostcal,

       ///Cost of VA/Pc///
       cast( b.corecstcav as abap.dec(12,3) ) + cast( a.addcst as abap.dec(12,3) ) + cast( a.drlfacing as abap.dec(12,3) ) + cast( b.acccavity as abap.dec(12,3) ) +
       ( cast ( b.paintprcst as abap.dec(12,3) ) * cast ( a.srfcarea as abap.dec(12,3) ) )                                                                                                                                                                                                                                as cstvaprpccal,

       ///FC/Kg///
       cast( abs( division( cast(b.fxdcst_ue as abap.dec(12,3) ), ( case when (cast(a.weight_2d as abap.dec(12,3))  * cast( a.noofcav as abap.dec(12,3))) = cast( 0 as abap.dec(12,3)) then cast( 1 as abap.dec(12,3)) else (cast(a.weight_2d as abap.dec(12,3))  * cast( a.noofcav as abap.dec(12,3))) end), 3 ) ) as abap.dec(12,3) )                                                                                                                                                    as fcprkgcal,

       ///Selling Expense///
       cast( abs( division( cast(b.sellexpn as abap.dec(12,3) ), cast(a.weight_2d as abap.dec(12,3)), 3 ) ) as abap.dec(12,3) )                                                                                                                                                                                           as sellexpcal,

       ///SE/KG///
       cast(b.sellexpn as abap.dec(12,3) )                                                                                                                                                                                                                                                                                as seperkg,

       ///Total Cost/Pc///
       ( ( ( cast( abs( division( ( ( cast ( b.elccst as abap.dec(12,3) ) + cast( abs( division( cast( b.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) ) +
        cast ( b.mldcst as abap.dec(12,3) ) + cast( abs( division( cast( b.mntcstperpc as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) ) +
        cast( abs( division( ( cast( b.fetcstperpc as abap.dec(12,3) ) * cast( a.weight_2d as abap.dec(6,3)) ), 1000, 3 ) ) as abap.dec(12,3) ) ) *
        cast( abs( division( cast(a.weight_2d as abap.dec(12,3) ), 1000, 3 ) ) as abap.dec(12,3) ) ) +
        ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
        + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3) ) ) +
        ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
        + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3)) ) * cast( b.tolerance as abap.dec(9,3) ) ) ), 1000, 3 ) ) as abap.dec(12,3) ) ) +
        cast(b.sellexpn as abap.dec(12,3) ) +
        cast( abs( division( cast(b.fxdcst_ue as abap.dec(12,3) ), ( case when (cast(a.weight_2d as abap.dec(12,3))  * cast( a.noofcav as abap.dec(12,3))) = cast( 0 as abap.dec(12,3)) then cast( 1 as abap.dec(12,3)) else (cast(a.weight_2d as abap.dec(12,3))  * cast( a.noofcav as abap.dec(12,3))) end), 3 ) ) as abap.dec(12,3) ) ) *
        cast(a.weight_2d as abap.dec(12,3)) ) +
        ( cast( b.corecstcav as abap.dec(12,3) ) + cast( a.addcst as abap.dec(12,3) ) + cast( a.drlfacing as abap.dec(12,3) ) + cast( b.acccavity as abap.dec(12,3) ) +
        ( cast ( b.paintprcst as abap.dec(12,3) ) * cast ( a.srfcarea as abap.dec(12,3) ) ) )                                                                                                                                                                                                                             as totlcstprpccal,

       ///Total Cost/Kg///
       cast( abs( division( ( ( ( cast( abs( division( ( ( cast ( b.elccst as abap.dec(12,3) ) + cast( abs( division( cast( b.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) ) +
       cast ( b.mldcst as abap.dec(12,3) ) + cast( abs( division( cast( b.mntcstperpc as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) ) +
       cast( abs( division( ( cast( b.fetcstperpc as abap.dec(12,3) ) * cast( a.weight_2d as abap.dec(6,3) ) ), 1000, 3 ) ) as abap.dec(12,3) ) ) *
       cast( abs( division( cast(a.weight_2d as abap.dec(12,3) ), 1000, 3 ) ) as abap.dec(12,3) ) ) +
       ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
         + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3) ) ) +
         ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
         + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3)) ) * cast( b.tolerance as abap.dec(9,3) ) ) ), 1000, 3 ) ) as abap.dec(12,3) ) ) +
       cast(b.sellexpn as abap.dec(12,3) ) +
       cast( abs( division( cast(b.fxdcst_ue as abap.dec(12,3) ), ( case when (cast(a.weight_2d as abap.dec(12,3))  * cast( a.noofcav as abap.dec(12,3))) = cast( 0 as abap.dec(12,3)) then cast( 1 as abap.dec(12,3)) else (cast(a.weight_2d as abap.dec(12,3))  * cast( a.noofcav as abap.dec(12,3))) end), 3 ) ) as abap.dec(12,3) ) ) *
       cast(a.weight_2d as abap.dec(12,3)) ) +
       ( cast( b.corecstcav as abap.dec(12,3) ) + cast( a.addcst as abap.dec(12,3) ) + cast( a.drlfacing as abap.dec(12,3) ) + cast( b.acccavity as abap.dec(12,3) ) +
       ( cast ( b.paintprcst as abap.dec(12,3) ) * cast ( a.srfcarea as abap.dec(12,3) ) ) ), cast(a.weight_2d as abap.dec(12,3)), 3 ) ) as abap.dec(12,3) )                                                                                                                                                              as totlcstprkgcal,

       ///Cost-USD/MT///
       cast( abs( division( cast( abs( division( ( ( ( cast( abs( division( ( ( cast ( b.elccst as abap.dec(12,3) ) + cast( abs( division( cast( b.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) ) +
       cast ( b.mldcst as abap.dec(12,3) ) + cast( abs( division( cast( b.mntcstperpc as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) ) +
       cast( abs( division( ( cast( b.fetcstperpc as abap.dec(12,3) ) * cast( a.weight_2d as abap.dec(6,3) ) ), 1000, 3 ) ) as abap.dec(12,3) ) ) *
       cast( abs( division( cast(a.weight_2d as abap.dec(12,3) ), 1000, 3 ) ) as abap.dec(12,3) ) ) +
       ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
         + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3) ) ) +
         ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
         + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3)) ) * cast( b.tolerance as abap.dec(9,3) ) ) ), 1000, 3 ) ) as abap.dec(12,3) ) ) +
       cast(b.sellexpn as abap.dec(12,3) ) +
       cast( abs( division( cast(b.fxdcst_ue as abap.dec(12,3) ), ( case when (cast(a.weight_2d as abap.dec(12,3))  * cast( a.noofcav as abap.dec(12,3))) = cast( 0 as abap.dec(12,3)) then cast( 1 as abap.dec(12,3)) else (cast(a.weight_2d as abap.dec(12,3))  * cast( a.noofcav as abap.dec(12,3))) end), 3 ) ) as abap.dec(12,3) ) ) *
       cast(a.weight_2d as abap.dec(12,3)) ) +
       ( cast( b.corecstcav as abap.dec(12,3) ) + cast( a.addcst as abap.dec(12,3) ) + cast( a.drlfacing as abap.dec(12,3) ) + cast( b.acccavity as abap.dec(12,3) ) +
       ( cast ( b.paintprcst as abap.dec(12,3) ) * cast ( a.srfcarea as abap.dec(12,3) ) ) ), cast(a.weight_2d as abap.dec(12,3)), 3 ) ) as abap.dec(12,3) ), ( case when b.exchngrt is initial then cast( 1 as abap.dec(12,3) ) else cast( b.exchngrt as abap.dec(12,3) ) end ),  3 ) ) as abap.dec(12,3) )              as cstusdprmtcal,

       ///Packaging Cost/Pc///
       ( cast(b.packngcst as abap.dec(12,3) ) * cast( 60 as abap.dec(12,3) ) ) * cast( a.weight_2d as abap.dec(12,3) )                                                                                                                                                                                                    as pckngcstcal,

       ///Offers/Pc///
       ( ( ( cast( abs( division( ( ( ( cast( abs( division( ( ( cast ( b.elccst as abap.dec(12,3) ) + cast( abs( division( cast( b.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) ) +
       cast ( b.mldcst as abap.dec(12,3) ) + cast( abs( division( cast( b.mntcstperpc as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) ) +
       cast( abs( division( ( cast( b.fetcstperpc as abap.dec(12,3) ) * cast( a.weight_2d as abap.dec(6,3) ) ), 1000, 3 ) ) as abap.dec(12,3) ) ) *
       cast( abs( division( cast(a.weight_2d as abap.dec(12,3) ), 1000, 3 ) ) as abap.dec(12,3) ) ) +
       ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
         + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3) ) ) +
         ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
         + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3)) ) * cast( b.tolerance as abap.dec(9,3) ) ) ), 1000, 3 ) ) as abap.dec(12,3) ) ) +
       cast(b.sellexpn as abap.dec(12,3) ) +
       cast( abs( division( cast(b.fxdcst_ue as abap.dec(12,3) ), ( case when (cast(a.weight_2d as abap.dec(12,3))  * cast( a.noofcav as abap.dec(12,3))) = cast( 0 as abap.dec(12,3)) then cast( 1 as abap.dec(12,3)) else (cast(a.weight_2d as abap.dec(12,3))  * cast( a.noofcav as abap.dec(12,3))) end), 3 ) ) as abap.dec(12,3) ) ) *
       cast(a.weight_2d as abap.dec(12,3)) ) +
       ( cast( b.corecstcav as abap.dec(12,3) ) + cast( a.addcst as abap.dec(12,3) ) + cast( a.drlfacing as abap.dec(12,3) ) + cast( b.acccavity as abap.dec(12,3) ) +
       ( cast ( b.paintprcst as abap.dec(12,3) ) * cast ( a.srfcarea as abap.dec(12,3) ) ) ), cast(a.weight_2d as abap.dec(12,3)), 3 ) ) as abap.dec(12,3) ) ) +
       cast(b.margin as abap.dec(12,3) ) ) * cast(a.weight_2d as abap.dec(12,3)) ) +
       ( ( cast(b.packngcst as abap.dec(12,3) ) * cast( 60 as abap.dec(12,3) ) ) * cast( a.weight_2d as abap.dec(12,3) ) )                                                                                                                                                                                                as offprprccal,

       ///Offers/Kg///
       cast( abs( division( ( ( ( cast( abs( division( ( ( ( cast( abs( division( ( ( cast ( b.elccst as abap.dec(12,3) ) + cast( abs( division( cast( b.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) ) +
       cast ( b.mldcst as abap.dec(12,3) ) + cast( abs( division( cast( b.mntcstperpc as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) ) +
       cast( abs( division( ( cast( b.fetcstperpc as abap.dec(12,3) ) * cast( a.weight_2d as abap.dec(6,3) ) ), 1000, 3 ) ) as abap.dec(12,3) ) ) *
       cast( abs( division( cast(a.weight_2d as abap.dec(12,3) ), 1000, 3 ) ) as abap.dec(12,3) ) ) +
       ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
         + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3) ) ) +
         ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
         + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3)) ) * cast( b.tolerance as abap.dec(9,3) ) ) ), 1000, 3 ) ) as abap.dec(12,3) ) ) +
       cast(b.sellexpn as abap.dec(12,3) ) +
       cast( abs( division( cast(b.fxdcst_ue as abap.dec(12,3) ), ( case when (cast(a.weight_2d as abap.dec(12,3))  * cast( a.noofcav as abap.dec(12,3))) = cast( 0 as abap.dec(12,3)) then cast( 1 as abap.dec(12,3)) else (cast(a.weight_2d as abap.dec(12,3))  * cast( a.noofcav as abap.dec(12,3))) end), 3 ) ) as abap.dec(12,3) ) ) *
       cast(a.weight_2d as abap.dec(12,3)) ) +
       ( cast( b.corecstcav as abap.dec(12,3) ) + cast( a.addcst as abap.dec(12,3) ) + cast( a.drlfacing as abap.dec(12,3) ) + cast( b.acccavity as abap.dec(12,3) ) +
       ( cast ( b.paintprcst as abap.dec(12,3) ) * cast ( a.srfcarea as abap.dec(12,3) ) ) ), cast(a.weight_2d as abap.dec(12,3)), 3 ) ) as abap.dec(12,3) ) ) +
       cast(b.margin as abap.dec(12,3) ) ) * cast(a.weight_2d as abap.dec(12,3)) ) +
       ( ( cast(b.packngcst as abap.dec(12,3) ) * cast( 60 as abap.dec(12,3) ) ) * cast( a.weight_2d as abap.dec(12,3) ) ), cast( a.weight_2d as abap.dec(12,3) ), 3 ) ) as abap.dec(12,3) )                                                                                                                              as offprkgcal,

       ///USD/Pc///
       cast( abs( division( ( ( ( ( cast( abs( division( ( ( ( cast( abs( division( ( ( cast ( b.elccst as abap.dec(12,3) ) + cast( abs( division( cast( b.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) ) +
       cast ( b.mldcst as abap.dec(12,3) ) + cast( abs( division( cast( b.mntcstperpc as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) ) +
       cast( abs( division( ( cast( b.fetcstperpc as abap.dec(12,3) ) * cast( a.weight_2d as abap.dec(6,3) ) ), 1000, 3 ) ) as abap.dec(12,3) ) ) *
       cast( abs( division( cast(a.weight_2d as abap.dec(12,3) ), 1000, 3 ) ) as abap.dec(12,3) ) ) +
       ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
         + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3) ) ) +
         ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
         + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3)) ) * cast( b.tolerance as abap.dec(9,3) ) ) ), 1000, 3 ) ) as abap.dec(12,3) ) ) +
       cast(b.sellexpn as abap.dec(12,3) ) +
       cast( abs( division( cast(b.fxdcst_ue as abap.dec(12,3) ), ( case when (cast(a.weight_2d as abap.dec(12,3))  * cast( a.noofcav as abap.dec(12,3))) = cast( 0 as abap.dec(12,3)) then cast( 1 as abap.dec(12,3)) else (cast(a.weight_2d as abap.dec(12,3))  * cast( a.noofcav as abap.dec(12,3))) end), 3 ) ) as abap.dec(12,3) ) ) *
       cast(a.weight_2d as abap.dec(12,3)) ) +
       ( cast( b.corecstcav as abap.dec(12,3) ) + cast( a.addcst as abap.dec(12,3) ) + cast( a.drlfacing as abap.dec(12,3) ) + cast( b.acccavity as abap.dec(12,3) ) +
       ( cast ( b.paintprcst as abap.dec(12,3) ) * cast ( a.srfcarea as abap.dec(12,3) ) ) ), cast(a.weight_2d as abap.dec(12,3)), 3 ) ) as abap.dec(12,3) ) ) +
       cast(b.margin as abap.dec(12,3) ) ) * cast(a.weight_2d as abap.dec(12,3)) ) +
       ( ( cast(b.packngcst as abap.dec(12,3) ) * cast( 60 as abap.dec(12,3) ) ) * cast( a.weight_2d as abap.dec(12,3) ) ) ), cast( b.exchngrt as abap.dec(12,3) ), 3 ) ) as abap.dec(12,3) )                                                                                                                             as usdprpccal,

       ///USD/MT///
       cast( abs( division( cast( abs( division( ( ( ( cast( abs( division( ( ( ( cast( abs( division( ( ( cast ( b.elccst as abap.dec(12,3) ) + cast( abs( division( cast( b.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) ) +
       cast ( b.mldcst as abap.dec(12,3) ) + cast( abs( division( cast( b.mntcstperpc as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) ) +
       cast( abs( division( ( cast( b.fetcstperpc as abap.dec(12,3) ) * cast( a.weight_2d as abap.dec(6,3) ) ), 1000, 3 ) ) as abap.dec(12,3) ) ) *
       cast( abs( division( cast(a.weight_2d as abap.dec(12,3) ), 1000, 3 ) ) as abap.dec(12,3) ) ) +
       ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
         + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3) ) ) +
         ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
         + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3)) ) * cast( b.tolerance as abap.dec(9,3) ) ) ), 1000, 3 ) ) as abap.dec(12,3) ) ) +
       cast(b.sellexpn as abap.dec(12,3) ) +
       cast( abs( division( cast(b.fxdcst_ue as abap.dec(12,3) ), ( case when (cast(a.weight_2d as abap.dec(12,3))  * cast( a.noofcav as abap.dec(12,3))) = cast( 0 as abap.dec(12,3)) then cast( 1 as abap.dec(12,3)) else (cast(a.weight_2d as abap.dec(12,3))  * cast( a.noofcav as abap.dec(12,3))) end), 3 ) ) as abap.dec(12,3) ) ) *
       cast(a.weight_2d as abap.dec(12,3)) ) +
       ( cast( b.corecstcav as abap.dec(12,3) ) + cast( a.addcst as abap.dec(12,3) ) + cast( a.drlfacing as abap.dec(12,3) ) + cast( b.acccavity as abap.dec(12,3) ) +
       ( cast ( b.paintprcst as abap.dec(12,3) ) * cast ( a.srfcarea as abap.dec(12,3) ) ) ), cast(a.weight_2d as abap.dec(12,3)), 3 ) ) as abap.dec(12,3) ) ) +
       cast(b.margin as abap.dec(12,3) ) ) * cast(a.weight_2d as abap.dec(12,3)) ) +
       ( ( cast(b.packngcst as abap.dec(12,3) ) * cast( 60 as abap.dec(12,3) ) ) * cast( a.weight_2d as abap.dec(12,3) ) ), cast( a.weight_2d as abap.dec(12,3) ), 3 ) ) as abap.dec(12,3) ), cast( b.exchngrt as abap.dec(12,3) ), 3 ) ) as abap.dec(12,3) ) * cast( 1000 as abap.dec(12,3) )                            as usdprmtcal,

       ///Price/lb///
       cast( abs( division( ( cast( abs( division( cast( abs( division( ( ( ( ( cast( abs( division( ( ( ( cast( abs( division( ( ( cast ( b.elccst as abap.dec(12,3) ) + cast( abs( division( cast( b.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) ) +
       cast ( b.mldcst as abap.dec(12,3) ) + cast( abs( division( cast( b.mntcstperpc as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( b.rejection as abap.dec(12,3) ) ) , 3 ) ) as abap.dec(12,3) ) +
       cast( abs( division( ( cast( b.fetcstperpc as abap.dec(12,3) ) * cast( a.weight_2d as abap.dec(6,3) ) ), 1000, 3 ) ) as abap.dec(12,3) ) ) *
       cast( abs( division( cast(a.weight_2d as abap.dec(12,3) ), 1000, 3 ) ) as abap.dec(12,3) ) ) +
       ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
         + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3) ) ) +
         ( ( cast(b.metalcst as abap.dec(12,3) ) * (cast(a.yldprcnt - (case when b.rejection is initial then cast(0 as abap.dec(12,3) ) else b.rejection end ) as abap.dec(12,3)))
         + cast(b.chrgingcst as abap.dec(12,3)) + cast(b.metalcst as abap.dec(12,3)) ) * cast( b.tolerance as abap.dec(9,3) ) ) ), 1000, 3 ) ) as abap.dec(12,3) ) ) +
       cast(b.sellexpn as abap.dec(12,3) ) +
       cast( abs( division( cast(b.fxdcst_ue as abap.dec(12,3) ), ( case when (cast(a.weight_2d as abap.dec(12,3))  * cast( a.noofcav as abap.dec(12,3))) = cast( 0 as abap.dec(12,3)) then cast( 1 as abap.dec(12,3)) else (cast(a.weight_2d as abap.dec(12,3))  * cast( a.noofcav as abap.dec(12,3))) end), 3 ) ) as abap.dec(12,3) ) ) *
       cast(a.weight_2d as abap.dec(12,3)) ) +
       ( cast( b.corecstcav as abap.dec(12,3) ) + cast( a.addcst as abap.dec(12,3) ) + cast( a.drlfacing as abap.dec(12,3) ) + cast( b.acccavity as abap.dec(12,3) ) +
       ( cast ( b.paintprcst as abap.dec(12,3) ) * cast ( a.srfcarea as abap.dec(12,3) ) ) ), cast(a.weight_2d as abap.dec(12,3)), 3 ) ) as abap.dec(12,3) ) ) +
       cast(b.margin as abap.dec(12,3) ) ) * cast(a.weight_2d as abap.dec(12,3)) ) +
       ( ( cast(b.packngcst as abap.dec(12,3) ) * cast( 60 as abap.dec(12,3) ) ) * cast( a.weight_2d as abap.dec(12,3) ) ) ), cast( b.exchngrt as abap.dec(12,3) ), 3 ) ) as abap.dec(12,3) ), cast(a.weight_2d as abap.dec(12,3)), 3 ) ) as abap.dec(12,3) ) ), cast( 2.2 as abap.dec(12,3) ), 3 ) ) as abap.dec(12,3) ) as prcprlbcal


}
