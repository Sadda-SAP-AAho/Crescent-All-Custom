@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Planning Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_4_1
  as select from    ZR_PLAN_RPT_5 as a
    left outer join ZR_PLAN_RPT_4 as b on  a.plant       = b.plant
                                       and a.hedmaterial = b.hedmaterial
                                       and a.matZ027     = b.component
    left outer join ZR_PLAN_RPT_4 as c on  a.plant       = c.plant
                                       and a.hedmaterial = c.hedmaterial
                                       and a.matZ026     = c.component
    left outer join ZR_PLAN_RPT_4 as d on  a.plant       = d.plant
                                       and a.hedmaterial = d.hedmaterial
                                       and a.matZ028     = d.component
    left outer join ZR_PLAN_RPT_4 as e on  a.plant       = e.plant
                                       and a.hedmaterial = e.hedmaterial
                                       and a.matZ045     = e.component
    left outer join ZR_PLAN_RPT_4 as f on  a.plant       = f.plant
                                       and a.hedmaterial = f.hedmaterial
                                       and a.matZ024     = f.component
    left outer join zdt_bomdet    as g on  a.plant        = g.plant
                                       and a.hedmaterial  = g.hedmaterial
                                       and a.component    = g.component
                                       and g.productgroup = 'Z025'
    left outer join zdt_bomdet    as h on  a.plant        = h.plant
                                       and a.hedmaterial  = h.hedmaterial
                                       and a.component    = h.parent
                                       and h.productgroup = 'Z024'


{
  key a.plant,
  key a.hedmaterial,
  key a.component,
      b.matstock  as matZ027,
      c.matstock  as matZ026,
      d.matstock  as matZ028,
      e.matstock  as matZ045,
      cast( division(g.childqty,h.childqty,3 )  as abap.dec( 5, 3 ) ) *
       f.matstock as matZ024
}
