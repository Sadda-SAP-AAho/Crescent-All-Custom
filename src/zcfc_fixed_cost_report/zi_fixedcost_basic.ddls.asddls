@AbapCatalog.sqlViewName: 'ZFIXEDCOSTBASIC'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Fixed Cost Basic'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_FIXEDCOST_BASIC
  as select distinct from ZR_BOMCOST_RPT         as a
    inner join            I_Product              as b on  b.Product       = a.Hedmaterial
                                                      and a.HeaderGrpCode = 'Z003'
                                                      and a.ChildGrpCode  = 'Z025'
    left outer join       I_ProductText          as c on  c.Product  = a.Hedmaterial
                                                      and c.Language = 'E'
    left outer join       zdt_pp_matinffld       as d on d.product = a.Hedmaterial
    left outer join       ZI_TmgTableForMaterial as e on e.Matkl = a.ChildGrpCode
    left outer join       I_ProductText          as f on  f.Product  = a.Component
                                                      and f.Language = 'E'
    left outer join       ZI_MATINFO             as g on g.product = a.Component
    left outer join       ZI_CAPTYPMSTR          as h on h.capcode = g.typeofmould
    left outer join       ZI_TmgTableForOperatio as i on i.Zopn = e.Zopn

{
      /* ================= KEYS ================= */
  key a.Hedmaterial,
  key c.ProductName                            as Head_MatName,
  key a.Plant,
  key d.moc,
  key d.cuscode,
  key a.Bomlevel,
  key a.Component,

      /* ================= BASIC DATA ================= */
      f.ProductName                            as Child_MatName,
      e.Zopn                                   as Child_Oprn_Code,
      i.Zopd                                   as Child_Oprn,
      a.HeadQty                                as ParentQty,
      'Pcs'                                    as Unit,

      cast( b.NetWeight as abap.dec(16,3) )    as ParentNetwt,
      b.WeightUnit                             as ParentNetWtUnit,

      a.Childqty,
      a.Bomitemqtyunit,
      cast( a.ChildNetwt as abap.dec(16,3) )   as ChildNetwt,
      a.ChildWtUnit,

      cast( a.Childqty as abap.dec(16,3) )
      * cast( a.ChildNetwt as abap.dec(16,3) ) as Total_Wt,

      g.typeofmould,
      g.qtyperbox,
      g.mldlinspd                              as Mouldlinespd,
      h.noofpatt                               as Rate,

      /* ================= FIXED COST ================= */
      (case when h.noofpatt = 0
            then cast( 0 as abap.dec(16,3) )

            when h.noofpatt <> 0
            then
                (case
                 when a.Plant = '1400'
                 and g.typeofmould = 'LOST FOAM'
                 and g.qtyperbox <> 0
                 then cast( div( h.noofpatt, g.qtyperbox ) as abap.dec(16,3) )

                 when a.Plant = '1400'
                 and g.typeofmould = 'LOST FOAM'
                 and g.qtyperbox = 0
                 then cast( div( h.noofpatt, 1 ) as abap.dec(16,3) )

                 when a.Plant = '1400'
                 and g.typeofmould = 'SINTO'
                 and g.mldlinspd <> 0
                 then cast( div( h.noofpatt, g.mldlinspd ) as abap.dec(16,3) )

                 when a.Plant = '1400'
                 and g.typeofmould = 'SINTO'
                 and g.mldlinspd = 0
                 then cast( div( h.noofpatt, 1 ) as abap.dec(16,3) )

                 when a.Plant <> '1400'
                 then
                     ( case
                       when h.capcatg = 'Weight'
                       then ( cast( h.noofpatt * a.Childqty as abap.dec(16,3) ) * cast( a.ChildNetwt as abap.dec(16,3) ) )

                       when ( h.capcatg = 'Box' and g.qtyperbox <> 0 )
                       then cast ( ( ( cast( div ( h.noofpatt, g.qtyperbox ) as abap.dec( 16, 3 ) ) ) * a.Childqty ) as abap.dec( 16, 3 ) )

                       when ( h.capcatg = 'Box' and g.qtyperbox = 0 )
                       then cast ( ( ( cast( div ( h.noofpatt, 1 ) as abap.dec( 16, 3 ) ) ) * a.Childqty ) as abap.dec( 16, 3 ) )

                       else cast( 0 as abap.dec(16,3) )
                       end )

                 else cast( 0 as abap.dec(16,3) )
                 end )

         else cast( 0 as abap.dec(16,3) )
         end )                                 as FixedCost,

      /* ================= FIXED COST 2 ================= */
      h.ratefc2,

      (case when h.ratefc2 = 0
            then cast( 0 as abap.dec(16,3) )

            when h.ratefc2 <> 0
            then
                (case
                 when a.Plant = '1400'
                 and g.typeofmould = 'LOST FOAM'
                 and g.qtyperbox <> 0
                 then cast( div( h.ratefc2, g.qtyperbox ) as abap.dec(16,3) )

                 when a.Plant = '1400'
                 and g.typeofmould = 'LOST FOAM'
                 and g.qtyperbox = 0
                 then cast( div( h.ratefc2, 1 ) as abap.dec(16,3) )

                 when a.Plant = '1400'
                 and g.typeofmould = 'SINTO'
                 then cast( 0 as abap.dec(16,3) )

                 when a.Plant <> '1400'
                 then
                     ( case
                       when h.capcatg = 'Weight'
                       then ( cast( h.ratefc2 * a.Childqty as abap.dec(16,3) ) * cast( a.ChildNetwt as abap.dec(16,3) ) )

                       when ( h.capcatg = 'Box' and g.qtyperbox <> 0 )
                       then cast ( ( ( cast( div ( h.ratefc2, g.qtyperbox ) as abap.dec( 16, 3 ) ) ) * a.Childqty ) as abap.dec( 16, 3 ) )

                       when ( h.capcatg = 'Box' and g.qtyperbox = 0 )
                       then cast ( ( ( cast( div ( h.ratefc2, 1 ) as abap.dec( 16, 3 ) ) ) * a.Childqty ) as abap.dec( 16, 3 ) )

                       else cast( 0 as abap.dec(16,3) )
                       end )

                 else cast( 0 as abap.dec(16,3) )
                 end )

        else cast( 0 as abap.dec(16,3) )
        end )                                  as FixedCost2

}
