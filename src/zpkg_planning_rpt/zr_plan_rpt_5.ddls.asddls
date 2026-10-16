@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for BOM Subsequent Material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_5
  as select from    zdt_bomdet as a
    left outer join zdt_bomdet as b on  a.plant        = b.plant
                                    and a.hedmaterial  = b.hedmaterial
                                    and a.parent       = b.component
                                    and b.productgroup = 'Z027'
    left outer join zdt_bomdet as c on  a.plant        = c.plant
                                    and a.hedmaterial  = c.hedmaterial
                                    and b.parent       = c.component
                                    and c.productgroup = 'Z026'
    left outer join zdt_bomdet as d on  a.plant        = d.plant
                                    and a.hedmaterial  = d.hedmaterial
                                    and c.parent       = d.component
                                    and d.productgroup = 'Z028'
    left outer join zdt_bomdet as e on  a.plant        = e.plant
                                    and a.hedmaterial  = e.hedmaterial
                                    and b.parent       = e.component
                                    and e.productgroup = 'Z045'
    left outer join zdt_bomdet as f on  a.plant        = f.plant
                                    and a.hedmaterial  = f.hedmaterial
                                    and e.parent       = f.component
                                    and f.productgroup = 'Z026'
    left outer join zdt_bomdet as g on  a.plant        = g.plant
                                    and a.hedmaterial  = g.hedmaterial
                                    and a.parent       = g.component
                                    and g.productgroup = 'Z026'
    left outer join zdt_bomdet as h on  a.plant        = h.plant
                                    and a.hedmaterial  = h.hedmaterial
                                    and g.parent       = h.component
                                    and h.productgroup = 'Z028'
    left outer join zdt_bomdet as i on  a.plant        = i.plant
                                    and a.hedmaterial  = i.hedmaterial
                                    and b.parent       = i.component
                                    and i.productgroup = 'Z028'
    left outer join zdt_bomdet as j on  a.plant        = j.plant
                                    and a.hedmaterial  = j.hedmaterial
                                    and a.component    = j.parent
                                    and j.productgroup = 'Z024'
    left outer join zdt_bomdet as k on  a.plant        = k.plant
                                    and a.hedmaterial  = k.hedmaterial
                                    and e.parent       = k.component
                                    and k.productgroup = 'Z028'                                    

{
  key a.plant,
  key a.hedmaterial,
  key a.component,
      b.component        as matZ027,
      case when c.component is not initial then c.component
           when g.component is not initial then g.component
           when f.component is not initial then f.component
       else null end     as matZ026,

      case when d.component is not initial then d.component
           when h.component is not initial then h.component
           when i.component is not initial then i.component
           when k.component is not initial then k.component
           else null end as matZ028,
      //      d.component    as matZ028,
      e.component        as matZ045,
      j.component        as matZ024


}
where
  a.productgroup = 'Z025'
