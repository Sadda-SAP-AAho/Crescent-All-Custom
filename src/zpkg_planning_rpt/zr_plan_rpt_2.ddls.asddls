@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Custing Material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_2
  as select distinct from zdt_bomdet           as a

    inner join            I_Product            as b on a.component = b.Product

    inner join            I_ProductDescription as c on  a.component = c.Product
                                                    and c.Language  = 'E'

    inner join            I_ProductPlantBasic  as d on  a.component = d.Product
                                                    and a.plant     = d.Plant

    left outer join       I_ProfitCenterText   as e on  d.ProfitCenter = e.ProfitCenter
                                                    and e.Language     = 'E'

    left outer join       zdt_pp_matinffld     as f on a.component = f.product

    left outer join       ZR_PLAN_RPT_3_1      as g on  a.hedmaterial = g.Product
                                                    and a.plant       = g.Plant

    left outer join       ZR_PLAN_RPT_1_1      as h on  a.plant       = h.Plant
                                                    and a.hedmaterial = h.Product

    left outer join       ZR_PLAN_RPT_4_1      as i on  a.plant       = i.plant
                                                    and a.hedmaterial = i.hedmaterial
                                                    and a.component   = i.component
  //                                                    and i.productgroup = 'Z028'
  //    left outer join       ZR_PLAN_RPT_4_1        as j on  a.plant        = j.plant
  //                                                    and a.hedmaterial  = j.hedmaterial
  //                                                        and a.component    = j.component
  //                                                    and j.productgroup = 'Z026'
  //    left outer join       ZR_PLAN_RPT_4_1        as k on  a.plant        = k.plant
  //                                                    and a.hedmaterial  = k.hedmaterial
  //                                                        and a.component    = k.component
  //                                                    and k.productgroup = 'Z027'
    left outer join       ZR_PLAN_RPT_4        as l on  a.plant        = l.plant
                                                    and a.hedmaterial  = l.hedmaterial
                                                    and a.component    = l.component
                                                    and l.productgroup = 'Z025'
  //    left outer join       ZR_PLAN_RPT_4        as m on  a.plant        = m.plant
  //                                                    and a.hedmaterial  = m.hedmaterial
  //                                                    and a.component    = m.component
  //                                                    and m.productgroup = 'Z024'
    left outer join       ZR_PLAN_RPT_4_2      as n on  a.plant       = n.plant
                                                    and a.hedmaterial = n.hedmaterial
    inner join            ZR_PLAN_RPT_5        as o on  a.plant       = o.plant
                                                    and a.hedmaterial = o.hedmaterial
                                                    and a.component   = o.component
    left outer join       ZCDS_PACK_CASTSTCK   as p on  a.component   = p.component
                                                    and a.plant       = p.plant

{
  key a.plant,
  key a.hedmaterial,
  key a.component,
      b.ProductGroup,
      c.ProductDescription,
      b.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      b.NetWeight,
      d.ProfitCenter,
      e.ProfitCenterLongName,
      f.cuscode,

//      --- new Logic ---
//      p.Cast_SubCode                                    as subcode,

      //      f.qtyperbox,

      --- old Logic ---
            case when  f.qtyperbox is not initial
                      then f.qtyperbox
                      else null end                           as qtyperbox,
      --- new Logic ---
//      case when  p.Cast_QtyPerBox is not initial
//                then p.Cast_QtyPerBox
//                else null end                           as qtyperbox,

      f.prodcapcday,
      f.pltpcdboxsize                                   as boxsize,
      //      case when  f.pltpcdboxsize is not initial
      //          then cast( cast( substring( f.pltpcdboxsize,1,3) as abap.char( 3) ) as abap.numc( 3 ) )
      //          else null end                               as boxsize,

      --- old Logic ---
            f.typeofmould                                     as typemould,
      --- new Logic ---
//      p.Cast_TypeMould                                  as typemould,

      //      g.OpenContQty,
      division( ( g.OpenContQty * a.childqty ), 100,3 ) as OpenContQty,
      //      h.OpenSoQty,
      division( ( h.OpenSoQty * a.childqty ), 100,3 )   as OpenSoQty,

      case when n.matstock is not null
           then division( ( cast( n.matstock as abap.dec(13,3) ) * a.childqty ), 100,3 )
           else null end                                as castonhand,

      //      case when l.matstock is not null
      //           then division( ( h.OpenSoQty * a.childqty ), 100,3 )
      //           else null end                                as FgLiveQty,

      case when division( ( h.OpenSoQty * a.childqty ), 100,3 ) <=
                division( ( cast( n.matstock as abap.dec(13,3) ) * a.childqty ), 100,3 )
           then division( ( h.OpenSoQty * a.childqty ), 100,3 )
           when division( ( h.OpenSoQty * a.childqty ), 100,3 ) >
                division( ( cast( n.matstock as abap.dec(13,3) ) * a.childqty ), 100,3 )
           then division( ( cast( n.matstock as abap.dec(13,3) ) * a.childqty ), 100,3 )
           else null end                                as FgLiveQty,

      i.matZ028                                         as stockZ028,
      i.matZ026                                         as stockZ026,
      i.matZ027                                         as stockZ027,
      i.matZ045                                         as stockZ045,
      i.matZ024                                         as stockZ024,
      l.matstock                                        as stockZ025,
      //      m.matstock                                        as stockZ024,

      o.matZ028                                         as matZ028,
      o.matZ026                                         as matZ026,
      o.matZ027                                         as matZ027,
      o.matZ045                                         as matZ045,
      o.matZ024                                         as matZ024,
      l.component                                       as matZ025,
      //      m.component                                       as matZ024,

      division( ( h.OpenSoQty7 * a.childqty ), 100,3 )  as OpenSoQty7,
      division( ( h.OpenSoQty8 * a.childqty ), 100,3 )  as OpenSoQty8,
      division( ( h.OpenSoQty16 * a.childqty ), 100,3 ) as OpenSoQty16,
      division( ( h.OpenSoQty23 * a.childqty ), 100,3 ) as OpenSoQty23,
      division( ( h.OpenSoQty31 * a.childqty ), 100,3 ) as OpenSoQty31,
      division( ( h.OpenSoQty39 * a.childqty ), 100,3 ) as OpenSoQty39,
      division( ( h.OpenSoQty47 * a.childqty ), 100,3 ) as OpenSoQty47,
      division( ( h.OpenSoQty55 * a.childqty ), 100,3 ) as OpenSoQty55,
      division( ( h.OpenSoQty63 * a.childqty ), 100,3 ) as OpenSoQty63,
      division( ( h.OpenSoQty71 * a.childqty ), 100,3 ) as OpenSoQty71,
      //      division( ( h.OpenSoQty366 * a.childqty ), 100,3 ) as OpenSoQty366,
      division(
               (
               ( coalesce( cast(h.OpenSoQty366 as abap.dec(13,3) ) ,0 ) +
                 coalesce( cast(h.OpenSoQtyCN as abap.dec(13,3) ) ,0 )
               ) * a.childqty ),100,3 )                 as OpenSoQty366
      //      h.OpenSoQty7,
      //      h.OpenSoQty8,
      //      h.OpenSoQty16,
      //      h.OpenSoQty23,
      //      h.OpenSoQty31,
      //      h.OpenSoQty39,
      //      h.OpenSoQty47,
      //      h.OpenSoQty55,
      //      h.OpenSoQty63,
      //      h.OpenSoQty71,
      //      h.OpenSoQty366

}
where
  (
       b.ProductGroup = 'Z024'
    or b.ProductGroup = 'Z025'
  )
//  and  h.OpenSoQty    is not initial
