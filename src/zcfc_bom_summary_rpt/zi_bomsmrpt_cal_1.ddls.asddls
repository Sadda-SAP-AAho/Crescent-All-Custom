@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Summary Report-Calculation1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BOMSMRPT_CAL_1
  as select distinct from ZR_BOMCOST_RPT    as a
    left outer join       zdt_pp_matinffld  as b  on a.Hedmaterial = b.product
    left outer join       I_Product         as g  on a.Hedmaterial = g.Product
    left outer join       ZI_BOMSM_CAST     as h  on  a.Hedmaterial = h.Hedmaterial
                                                  and a.Plant       = h.Plant

    left outer join       ZI_BOMSM_CAST_1   as i  on  a.Hedmaterial = i.Hedmaterial
                                                  and a.Plant       = i.Plant

    left outer join       ZI_BOMSM_PAINT    as j  on  a.Hedmaterial = j.Hedmaterial
                                                  and a.Plant       = j.Plant

    left outer join       ZI_BOMSM_LM       as k  on  a.Hedmaterial = k.Hedmaterial
                                                  and a.Plant       = k.Plant

    left outer join       ZI_METALPRICE     as k1 on  a.Hedmaterial = k1.Hedmaterial
                                                  and a.Plant       = k1.Plant

    left outer join       ZI_DITRTCOST      as l  on  a.Hedmaterial = l.Hedmaterial
                                                  and a.Plant       = l.Plant

    left outer join       ZI_ELECCOST       as m  on  a.Hedmaterial = m.Hedmaterial
                                                  and a.Plant       = m.Plant

    left outer join       ZI_PACKMTLCOST    as n  on  a.Hedmaterial = n.Hedmaterial
                                                  and a.Plant       = n.Plant

    left outer join       ZI_ACCESSORYCOST  as o  on  a.Hedmaterial = o.Hedmaterial
                                                  and a.Plant       = o.Plant

    left outer join       ZI_GENSTRCOST     as p  on  a.Hedmaterial = p.Hedmaterial
                                                  and a.Plant       = p.Plant

    left outer join       ZI_PAINTMTLCOST   as q  on  a.Hedmaterial = q.Hedmaterial
                                                  and a.Plant       = q.Plant

    left outer join       ZI_CONVCOST       as r  on  a.Hedmaterial = r.Hedmaterial
                                                  and a.Plant       = r.Plant

    left outer join       ZI_LABOURCOST     as s  on  a.Hedmaterial = s.Hedmaterial
                                                  and a.Plant       = s.Plant

    left outer join       ZI_LABOURCOSTSP   as t  on  a.Hedmaterial = t.Hedmaterial
                                                  and a.Plant       = t.Plant

    left outer join       ZI_LABOURCOSTGR   as u  on  a.Hedmaterial = u.Hedmaterial
                                                  and a.Plant       = u.Plant

    left outer join       ZI_LABOURCOSTOTH  as v  on  a.Hedmaterial = v.Hedmaterial
                                                  and a.Plant       = v.Plant

    left outer join       ZI_LABOURCOSTSTR  as w  on  a.Hedmaterial = w.Hedmaterial
                                                  and a.Plant       = w.Plant

    left outer join       ZI_MELTLOSSCOST   as x  on  a.Hedmaterial = x.Hedmaterial
                                                  and a.Plant       = x.Plant

    left outer join       ZI_MACHNCOST      as y  on  a.Hedmaterial = y.Hedmaterial
                                                  and a.Plant       = y.Plant

    left outer join       ZI_CUSTTTLSELLEXP as aa on b.cuscode = aa.Custcode
{
  key a.Plant,
  key b.cuscode                                   as custcode,
  key a.Hedmaterial                               as matcode,

      g.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      g.NetWeight,
      h.mcloss,
      i.qtybox,
      i.typmold,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      h.bunchwt,
      j.sqmtr,

      // Yield_% //

      cast(abs( division( ( cast(coalesce(g.NetWeight,0) as abap.dec(12,3)) + cast(coalesce(h.mcloss,0) as abap.dec(12,3)) )
                      , ( case when cast(h.bunchwt as abap.dec(12,3)) = 0 then 1 else cast(h.bunchwt as abap.dec(12,3)) end )
                      , 3 ) ) as abap.dec(12,3) ) as yield,

      k.lmmatl,

      k1.metalprc,
      
      aa.ttlselexp,


      // DI Treatment Cost/Kg //

      ( case when l.ditrtcost <> 0
             then cast(abs( division( cast(l.ditrtcost as abap.dec(12,3))
               , ( case when cast(g.NetWeight as abap.dec(12,3)) = 0 then 1 else cast(g.NetWeight as abap.dec(12,3)) end )
               , 3 ) ) as abap.dec(12,3) )

             else
             cast( 0 as abap.dec(12,3))

        end )                                     as ditrtcost,

      // Electricity Cost/Kg //

      ( case when m.eleccost <> 0
             then cast(abs( division( cast(m.eleccost as abap.dec(12,3))
               , ( case when cast(g.NetWeight as abap.dec(12,3)) = 0 then 1 else cast(g.NetWeight as abap.dec(12,3)) end )
               , 3 ) ) as abap.dec(12,3) )

             else
             cast( 0 as abap.dec(12,3))

        end )                                     as eleccost,

      // Total Cost/Kg //

      cast(k1.metalprc as abap.dec(12,3)) +

      ( case when l.ditrtcost <> 0
             then cast(abs( division( cast(l.ditrtcost as abap.dec(12,3))
               , ( case when cast(g.NetWeight as abap.dec(12,3)) = 0 then 1 else cast(g.NetWeight as abap.dec(12,3)) end )
               , 3 ) ) as abap.dec(12,3) )

             else
             cast( 0 as abap.dec(12,3))

        end ) +

      ( case when m.eleccost <> 0
             then cast(abs( division( cast(m.eleccost as abap.dec(12,3))
               , ( case when cast(g.NetWeight as abap.dec(12,3)) = 0 then 1 else cast(g.NetWeight as abap.dec(12,3)) end )
               , 3 ) ) as abap.dec(12,3) )

             else
             cast( 0 as abap.dec(12,3))

        end )                                     as ttlcost,

      // Packing Material Cost/Kg //

      ( case when n.packmtlcost <> 0
             then cast(abs( division( cast(n.packmtlcost as abap.dec(12,3))
               , ( case when cast(g.NetWeight as abap.dec(12,3)) = 0 then 1 else cast(g.NetWeight as abap.dec(12,3)) end )
               , 3 ) ) as abap.dec(12,3) )

             else
             cast( 0 as abap.dec(12,3))

        end )                                     as packmtlcost,

      // Accessory Cost/Kg //

      ( case when o.accscost <> 0
             then cast(abs( division( cast(o.accscost as abap.dec(12,3))
               , ( case when cast(g.NetWeight as abap.dec(12,3)) = 0 then 1 else cast(g.NetWeight as abap.dec(12,3)) end )
               , 3 ) ) as abap.dec(12,3) )

             else
             cast( 0 as abap.dec(12,3))

        end )                                     as accscost,

      // General Store Cost/Kg //

      ( case when p.genstrcost <> 0
             then cast(abs( division( cast(p.genstrcost as abap.dec(12,3))
               , ( case when cast(g.NetWeight as abap.dec(12,3)) = 0 then 1 else cast(g.NetWeight as abap.dec(12,3)) end )
               , 3 ) ) as abap.dec(12,3) )

             else
             cast( 0 as abap.dec(12,3))

        end )                                     as genstrcost,

      // Painting Mtl Cost/Kg //

      ( case when q.pntmtlcost <> 0
             then cast(abs( division( cast(q.pntmtlcost as abap.dec(12,3))
               , ( case when cast(g.NetWeight as abap.dec(12,3)) = 0 then 1 else cast(g.NetWeight as abap.dec(12,3)) end )
               , 3 ) ) as abap.dec(12,3) )

             else
             cast( 0 as abap.dec(12,3))

        end )                                     as pntmtlcostkg,

      // Painting Mtl Cost/SqMtr //

      ( case when q.pntmtlcost <> 0
             then cast(abs( division( cast(q.pntmtlcost as abap.dec(12,3))
               , ( case when cast(j.sqmtr as abap.dec(12,3)) = 0 then 1 else cast(j.sqmtr as abap.dec(12,3)) end )
               , 3 ) ) as abap.dec(12,3) )

             else
             cast( 0 as abap.dec(12,3))

        end )                                     as pntmtlcostsqm,

      // Conversion Cost/Kg //

      ( case when r.convcost <> 0
             then cast(abs( division( cast(r.convcost as abap.dec(12,3))
               , ( case when cast(g.NetWeight as abap.dec(12,3)) = 0 then 1 else cast(g.NetWeight as abap.dec(12,3)) end )
               , 3 ) ) as abap.dec(12,3) )

             else
             cast( 0 as abap.dec(12,3))

        end )                                     as convcost,

      // Labour Cost/Kg //

      ( case when s.labrcost <> 0
             then cast(abs( division( cast(s.labrcost as abap.dec(12,3))
               , ( case when cast(g.NetWeight as abap.dec(12,3)) = 0 then 1 else cast(g.NetWeight as abap.dec(12,3)) end )
               , 3 ) ) as abap.dec(12,3) )

             else
             cast( 0 as abap.dec(12,3))

        end )                                     as labrcost,

      // Labour Cost(Spl. Painting)/Kg //

      ( case when t.labrcostsp <> 0
             then cast(abs( division( cast(t.labrcostsp as abap.dec(12,3))
               , ( case when cast(g.NetWeight as abap.dec(12,3)) = 0 then 1 else cast(g.NetWeight as abap.dec(12,3)) end )
               , 3 ) ) as abap.dec(12,3) )

             else
             cast( 0 as abap.dec(12,3))

        end )                                     as labrcostsp,

      // Rate Per Sq Mtr for Paint Only Labour //

      cast(abs( division( cast(t.labrcostsp as abap.dec(12,3))
               , ( case when cast(j.sqmtr as abap.dec(12,3)) = 0 then 1 else cast(j.sqmtr as abap.dec(12,3)) end )
               , 3 ) ) as abap.dec(12,3) )        as rateprsqm,

      // Labour Cost(Grinding)/Kg //

      ( case when u.labrcostgr <> 0
             then cast(abs( division( cast(u.labrcostgr as abap.dec(12,3))
               , ( case when cast(g.NetWeight as abap.dec(12,3)) = 0 then 1 else cast(g.NetWeight as abap.dec(12,3)) end )
               , 3 ) ) as abap.dec(12,3) )

             else
             cast( 0 as abap.dec(12,3))

        end )                                     as labrcostgr,

      // Labour Cost(Others)/Kg //

      ( case when v.labrcostoth <> 0
             then cast(abs( division( cast(v.labrcostoth as abap.dec(12,3))
               , ( case when cast(g.NetWeight as abap.dec(12,3)) = 0 then 1 else cast(g.NetWeight as abap.dec(12,3)) end )
               , 3 ) ) as abap.dec(12,3) )

             else
             cast( 0 as abap.dec(12,3))

        end )                                     as labrcostoth,

      // Labour Cost(Store)/Kg //

      ( case when w.labrcoststr <> 0
             then cast(abs( division( cast(w.labrcoststr as abap.dec(12,3))
               , ( case when cast(g.NetWeight as abap.dec(12,3)) = 0 then 1 else cast(g.NetWeight as abap.dec(12,3)) end )
               , 3 ) ) as abap.dec(12,3) )

             else
             cast( 0 as abap.dec(12,3))

        end )                                     as labrcoststr,

      // Melting Loss Cost/Kg //

      ( case when x.meltlosscst <> 0
             then cast(abs( division( cast(x.meltlosscst as abap.dec(12,3))
               , ( case when cast(g.NetWeight as abap.dec(12,3)) = 0 then 1 else cast(g.NetWeight as abap.dec(12,3)) end )
               , 3 ) ) as abap.dec(12,3) )

             else
             cast( 0 as abap.dec(12,3))

        end )                                     as meltlosscst,

      // Machine Cost/Kg //

      ( case when y.machncst <> 0
             then cast(abs( division( cast(y.machncst as abap.dec(12,3))
               , ( case when cast(g.NetWeight as abap.dec(12,3)) = 0 then 1 else cast(g.NetWeight as abap.dec(12,3)) end )
               , 3 ) ) as abap.dec(12,3) )

             else
             cast( 0 as abap.dec(12,3))

        end )                                     as machncst

}

where
  a.HeaderGrpCode = 'Z003'
