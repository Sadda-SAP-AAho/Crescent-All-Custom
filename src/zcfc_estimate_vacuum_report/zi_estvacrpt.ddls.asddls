@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Estimate Vacuum Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_ESTVACRPT
  as select distinct from ZI_ESTVACREG as a

{
  key a.id,
      a.rfqno,
      a.rfqdate,
      a.matcd,
      cast( a.rejection as abap.dec(12,2) )                                                                                                         as rejection,
      cast( a.tolerance as abap.dec(12,2) )                                                                                                         as tolerance,
      cast( a.margin as abap.dec(12,3) )                                                                                                            as margin,

      cast(abs( division( ( (cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3))) * a.margin )

      , 100

      , 3 ) ) as abap.dec(12,3) )                                                                                                                   as amtmrgn,

      cast( ( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,0))                     as fxdcst_ue,
      a.line,
      cast( a.annualqty as abap.dec(12,0))                                                                                                          as annualqty,
      cast( a.mouldspd as abap.dec(12,0))                                                                                                           as mouldspd,
      cast( a.reqweight as abap.dec(12,0))                                                                                                          as reqweight,
      cast(a.reqweight as abap.dec(12,0))                                                                                                           as nominal,
      a.noofcav,
      cast( a.yield as abap.dec(12,3))                                                                                                              as yield,
      cast( a.addacccost as abap.dec(12,0))                                                                                                         as addacccost,
      cast( a.drillperfacing as abap.dec(12,0))                                                                                                     as drillperfacing,
      cast( a.srfcarea as abap.dec(12,2))                                                                                                           as srfcarea,
      cast( a.chrgingcst as abap.dec(12,0))                                                                                                         as chrgingcst,
      cast     (a.metalcst as abap.dec(12,0) )                                                                                                      as metalcstperton,
      cast( a.elccst as abap.dec(12,0))                                                                                                             as elccst,
      cast( a.mldcst as abap.dec(12,0))                                                                                                             as mldcst,
      cast( a.acccavity as abap.dec(12,0))                                                                                                          as acccavity,
      cast( a.packngcst as abap.dec(12,3))                                                                                                          as packngcst,
      cast( a.corecstcav as abap.dec(12,0))                                                                                                         as corecstcav,
      a.curr,

      /// Tonnage ///
      cast(abs(division( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)
                             * (case when coalesce(a.annualqty,0) = 0 then 1 else a.annualqty end) as abap.dec(12,3) )
                             , 1000
           , 3 )) as abap.dec(12,0))                                                                                                                as tonnagecal,

      /// Weight/Box(Kg) ///
      cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,0) )                     as wgtprbxcal,

      /// Melting Cost/MT(cal) ///
      cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,0))                                                                                                                as mltngcstmtcal,

      /// Total cost/MT ///
      cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,0) )                                                                                    as totlcstmtcal,

      /// Total cost/MT with tolerance ///
      cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,0) )        as totlcsttolcal,

      /// Metal Cost/Pcs ///
      cast(abs( division( ( cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )

      * (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) )

      , 1000

      , 3 ) ) as abap.dec(12,0) )                                                                                                                   as mtlcstprpccal,

      /// Labour for Moulding/Box ///
      cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,0) )                                                                                                              as labmldperbxcal,

      /// Maintenance/Pc ///
      cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,0) )                                                                                                              as mntprpccal,

      /// Fettling Cost/Pc ///
      cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,0) )                                                                                                              as fetcstprpccal,

      /// Cost of Molding/MT ///
      cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,0) )                                                                                                                   as cstmldprmtcal,

      /// Paint(Labour+Material)-Primer Cost(Calculation) ///
      cast( (cast ( a.paintprcst as abap.dec(12,3) ) * cast ( a.srfcarea as abap.dec(12,3) ) ) as abap.dec(12,0) )                                  as pntprmrcstcal,

      ///Manufacturing Cost - w/o VA /MT///
      cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,0))                                                                                                                as mnfcostcal,

      ///Cost of VA/Pc///
      cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + cast( a.srfcarea as abap.dec(12,3))
      + cast( cast( (cast ( a.paintprcst as abap.dec(12,3) ) * cast ( a.srfcarea as abap.dec(12,3) ) ) as abap.dec(12,0) ) as abap.dec(12,3) )

      - cast( a.srfcarea as abap.dec(12,3)) ) as abap.dec(12,0) )                                                                                   as cstvaprpccal,

      ///FC/Kg///
      cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,2))                                                                                                                as fcprkgcal,

      ///Selling Expense///
      cast( ( cast(a.sellexpn as abap.dec(12,3)) * cast(a.reqweight as abap.dec(12,3)) ) as abap.dec(12,0) )                                        as sellexpcal,

      ///SE/KG///
      cast(a.sellexpn as abap.dec(12,3) )                                                                                                           as seperkg,

      ///Total Cost/Pc///
      cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,0) )                  as totlcstprpccal,

      a.exchngrt,

      /// Total Cost/Kg ///

      cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3))                                                                                                                     as totlcstprkgcal,


      ///Cost-USD/MT///

      cast(abs(division( ( (cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3))) * 1000 )

      , (case when coalesce(a.exchngrt,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.exchngrt,0) end)

      , 3 )) as abap.dec(12,0))                                                                                                                     as cstusdprmtcal,


      ///Packaging Cost/Pc///

      cast( ( ( cast(a.packngcst as abap.dec(12,3) ) * cast( a.packrateperkg as abap.dec(12,3) ) ) * cast( a.reqweight as abap.dec(12,3) ) ) as abap.dec(12,0) ) as pckngcstcal,

      ///Offers/Pc///

      cast( ( ( ( ( cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3)) )
      + ( cast(abs( division( ( (cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3))) * a.margin )

      , 100

      , 3 ) ) as abap.dec(12,3) ) ) )

      * cast( a.reqweight as abap.dec(12,3)) )
      + ( ( cast(a.packngcst as abap.dec(12,3) ) * cast( a.packrateperkg as abap.dec(12,3) ) ) * cast( a.reqweight as abap.dec(12,3) ) ) ) as abap.dec(12,0) )   as offprprccal,

      /// Offers/Kg ///

      cast(abs(division( ( ( ( ( ( cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3)) )
      + ( cast(abs( division( ( (cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3))) * a.margin )

      , 100

      , 3 ) ) as abap.dec(12,3) ) ) )

      * cast( a.reqweight as abap.dec(12,3)) )
      + ( ( cast(a.packngcst as abap.dec(12,3) ) * cast( a.packrateperkg as abap.dec(12,3) ) ) * cast( a.reqweight as abap.dec(12,3) ) ) ) )

      , cast( a.reqweight as abap.dec(12,3))

      , 3 ) ) as abap.dec(12,3) )                                                                                                                   as offprkgcal,

      ///FX/Pc///

      cast(abs(division( ( ( ( ( ( cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3)) )
      + ( cast(abs( division( ( (cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3))) * a.margin )

      , 100

      , 3 ) ) as abap.dec(12,3) ) ) )

      * cast( a.reqweight as abap.dec(12,3)) )
      + ( ( cast(a.packngcst as abap.dec(12,3) ) * cast( a.packrateperkg as abap.dec(12,3) ) ) * cast( a.reqweight as abap.dec(12,3) ) ) ) )

       ,  (case when coalesce(a.exchngrt,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.exchngrt,0) end)

       , 3 )) as abap.dec(12,2))                                                                                                                    as usdprpccal,


      ///FX/MT///

      cast(abs(division( ( ( cast(abs(division( ( ( ( ( ( cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3)) )
      + ( cast(abs( division( ( (cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3))) * a.margin )

      , 100

      , 3 ) ) as abap.dec(12,3) ) ) )

      * cast( a.reqweight as abap.dec(12,3)) )
      + ( ( cast(a.packngcst as abap.dec(12,3) ) * cast( a.packrateperkg as abap.dec(12,3) ) ) * cast( a.reqweight as abap.dec(12,3) ) ) ) )

      , cast( a.reqweight as abap.dec(12,3))

      , 3 ) ) as abap.dec(12,3) ) ) * 1000 )

      ,  (case when coalesce(a.exchngrt,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.exchngrt,0) end)

       , 3 )) as abap.dec(12,2))                                                                                                                    as usdprmtcal,

      ///Price/lb///

      cast(abs(division(
      ( cast(abs(division( ( cast(abs(division( ( ( ( ( ( cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3)) )
      + ( cast(abs( division( ( (cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3))) * a.margin )

      , 100

      , 3 ) ) as abap.dec(12,3) ) ) )

      * cast( a.reqweight as abap.dec(12,3)) )
      + ( ( cast(a.packngcst as abap.dec(12,3) ) * cast( a.packrateperkg as abap.dec(12,3) ) ) * cast( a.reqweight as abap.dec(12,3) ) ) ) )

       ,  (case when coalesce(a.exchngrt,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.exchngrt,0) end)

       , 3 )) as abap.dec(12,0)) )

       , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

       , 3 )) as abap.dec(12,3)) )

       , cast(2.2046 as abap.dec(12,4))

       , 3 )) as abap.dec(12,3))                                                                                                                    as prcprlbcal,


      //Incoterm//

      a.agreedincoterm,
      
      // Freightcharge//
      a.freightchrg,

      //Freight/Kg in FX /

      (case when a.agreedincoterm is not initial
            then
                (cast(abs(division(cast(a.freightchrg as abap.dec(12,3))
                                 , (case when cast (coalesce(a.fclwgt,0) as abap.dec(12,3)) = 0 then cast( 1 as abap.dec(12,3))
                                         else cast (coalesce(a.fclwgt,0) as abap.dec(12,3)) end )
                                 , 3 ))
                 as abap.dec(12,3)) )
            else cast(0 as abap.dec(12,3))

      end )                                                                                                                                         as frghtkgFX,

      //Freight/Pc//

      (case when a.agreedincoterm is not initial
            then
                ( cast( cast(abs(division(cast(a.freightchrg as abap.dec(12,3))
                                        , (case when cast (coalesce(a.fclwgt,0) as abap.dec(12,3)) = 0 then cast( 1 as abap.dec(12,3))
                                                else cast (coalesce(a.fclwgt,0) as abap.dec(12,3)) end )
                                        , 3 ))
                  as abap.dec(12,3))

                * cast(a.reqweight as abap.dec(12,3))  as abap.dec(12,3)) )
            else cast(0 as abap.dec(12,3))

      end )                                                                                                                                         as frghtpc,

      //Part Price/PC(FX)//

      (case when a.agreedincoterm is not initial
            then
                cast( cast( cast(abs(division(cast(a.freightchrg as abap.dec(12,3))
                                            , (case when cast (coalesce(a.fclwgt,0) as abap.dec(12,3)) = 0 then cast( 1 as abap.dec(12,3))
                                                    else cast (coalesce(a.fclwgt,0) as abap.dec(12,3)) end )
                                            , 3 ))
                as abap.dec(12,3))

              * cast(a.reqweight as abap.dec(12,3))  as abap.dec(12,3))

      +

      cast(abs(division( ( ( ( ( ( cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3)) )
      + ( cast(abs( division( ( (cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3))) * a.margin )

      , 100

      , 3 ) ) as abap.dec(12,3) ) ) )

      * cast( a.reqweight as abap.dec(12,3)) )
      + ( ( cast(a.packngcst as abap.dec(12,3) ) * cast( a.packrateperkg as abap.dec(12,3) ) ) * cast( a.reqweight as abap.dec(12,3) ) ) ) )

       ,  (case when coalesce(a.exchngrt,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.exchngrt,0) end)

       , 3 )) as abap.dec(12,2))

      as abap.dec(12,3) )

      else cast(0 as abap.dec(12,3))

      end )                                                                                                                                         as partpcs,

      //INR/Kg//

      (case when a.agreedincoterm is not initial
            then
                cast(abs(division( ( ( cast( cast( cast(abs(division(cast(a.freightchrg as abap.dec(12,3))
                                                                   , (case when cast (coalesce(a.fclwgt,0) as abap.dec(12,3)) = 0 then cast( 1 as abap.dec(12,3))
                                                                           else cast (coalesce(a.fclwgt,0) as abap.dec(12,3)) end )
                                                                   , 3 ))
                                                   as abap.dec(12,3))

                                                 * cast(a.reqweight as abap.dec(12,3))  as abap.dec(12,3))

      +

      cast(abs(division( ( ( ( ( ( cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3)) )
      + ( cast(abs( division( ( (cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3))) * a.margin )

      , 100

      , 3 ) ) as abap.dec(12,3) ) ) )

      * cast( a.reqweight as abap.dec(12,3)) )
      + ( ( cast(a.packngcst as abap.dec(12,3) ) * cast( a.packrateperkg as abap.dec(12,3) ) ) * cast( a.reqweight as abap.dec(12,3) ) ) ) )

       ,  (case when coalesce(a.exchngrt,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.exchngrt,0) end)

       , 3 )) as abap.dec(12,2))

      as abap.dec(12,3) ) )

      * ( cast(abs(division( ( ( ( ( ( cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3)) )
      + ( cast(abs( division( ( (cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3))) * a.margin )

      , 100

      , 3 ) ) as abap.dec(12,3) ) ) )

      * cast( a.reqweight as abap.dec(12,3)) )
      + ( ( cast(a.packngcst as abap.dec(12,3) ) * cast( a.packrateperkg as abap.dec(12,3) ) ) * cast( a.reqweight as abap.dec(12,3) ) ) ) )

       ,  (case when coalesce(a.exchngrt,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.exchngrt,0) end)

       , 3 )) as abap.dec(12,2)) ) )

       , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

       , 3 )) as abap.dec(12,3))

       else cast(0 as abap.dec(12,3))

      end )                                                                                                                                         as inrkg,


      //FX/Kg//

      (case when a.agreedincoterm is not initial
            then
                ( cast(abs(division( ( (case when a.agreedincoterm is not initial
                                             then
                                                 cast( cast( cast(abs(division(cast(a.freightchrg as abap.dec(12,3))
                                                                             , cast (a.fclwgt as abap.dec(12,3))
                                                                      , 3 ))
                                                              as abap.dec(12,3))

              * cast(a.reqweight as abap.dec(12,3))  as abap.dec(12,3))

      +

      cast(abs(division( ( ( ( ( ( cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3)) )
      + ( cast(abs( division( ( (cast(abs(division( (cast( ( ( ( cast(abs(division( ( (cast(abs(division( cast ( ( ( cast( a.elccst as abap.dec(12,3))
      + cast(abs( division( cast( a.labmldperbx as abap.dec(12,3) ), ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast( a.mldcst as abap.dec(12,3))
      + cast(abs( division( cast( a.mntcstperpc as abap.dec(12,3)),
                          ( cast( 1 as abap.dec(12,3) ) - cast( a.rejection as abap.dec(12,3) ) )
           , 3 ) ) as abap.dec(12,3) )
      + cast(abs( division( ( cast( a.fetcstperpc as abap.dec(12,3) )
                          * ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                            * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) ) )
                           , 1000
           , 3 ) ) as abap.dec(12,3) ) ) * 1000 ) as abap.dec(12,3) )

           , ( cast( cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
      * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)) as abap.dec(12,3) ) )

      , 3 ) ) as abap.dec(12,3) ))

        + (cast ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) )

      + ( cast( ( cast(abs(division( cast((case when coalesce(a.meltingcst,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.meltingcst,0) end) as abap.dec(12,3))
                      , (cast(a.yield - (case when a.rejection is initial then cast(0 as abap.dec(12,3)) else a.rejection end ) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3))
      + cast(a.chrgingcst as abap.dec(12,3))
      + cast(a.metalcst as abap.dec(12,3)) ) as abap.dec(12,3) ) * cast( coalesce( a.tolerance ,0 ) as abap.dec(12,3)) ) as abap.dec(12,3) )) )

           , 1000
           , 3 )) as abap.dec(12,3)) )

           + cast(a.sellexpn as abap.dec(12,3) )

           + ( cast(abs(division( (cast(( case when coalesce( a.fxdcst_ue, 0) = 0 then a.fxdcst_cal else coalesce( a.fxdcst_ue, 0) end ) as abap.dec(12,3))),
                        (cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))
                        * cast((case when coalesce(a.noofcav,0) = 0 then 1 else coalesce(a.noofcav,0) end) as abap.dec(12,3)))
           , 3 )) as abap.dec(12,3)) ) )

           * cast( (case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end)as abap.dec(12,3) ) )

      + ( cast( ( cast( a.corecstcav as abap.dec(12,3))
      + cast( a.addacccost as abap.dec(12,3))
      + cast( a.drillperfacing as abap.dec(12,3))
      + cast( a.acccavity as abap.dec(12,3))
      + (cast( a.paintprcst as abap.dec(12,3) ) * cast( a.srfcarea as abap.dec(12,3))) ) as abap.dec(12,3) ) ) as abap.dec(12,3) ))

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,3))) * a.margin )

      , 100

      , 3 ) ) as abap.dec(12,3) ) ) )

      * cast( a.reqweight as abap.dec(12,3)) )
      + ( ( cast(a.packngcst as abap.dec(12,3) ) * cast( a.packrateperkg as abap.dec(12,3) ) ) * cast( a.reqweight as abap.dec(12,3) ) ) ) )

       ,  (case when coalesce(a.exchngrt,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.exchngrt,0) end)

       , 3 )) as abap.dec(12,2))

      as abap.dec(12,3) )

      else cast(0 as abap.dec(12,3))

      end ) )

      , cast((case when coalesce(a.reqweight,0) = cast(0 as abap.dec(12,3)) then cast(1 as abap.dec(12,3)) else coalesce(a.reqweight,0) end) as abap.dec(12,3))

      , 3 )) as abap.dec(12,2)) )

      else

      cast(0 as abap.dec(12,3))

      end )                                                                                                                                         as FXkg,
      
      a.freightrmrks
      





}
