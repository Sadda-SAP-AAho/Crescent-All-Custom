@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Open Sales Stock_1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_1_1

  as select from    ZR_PLAN_RPT_1_4 as a

    left outer join ZR_PLAN_RPT_1_6 as b on  a.Plant   = b.Plant
                                         and a.Product = b.Product
                                         and b.DayQty  = '7'

    left outer join ZR_PLAN_RPT_1_6 as c on  a.Plant   = c.Plant
                                         and a.Product = c.Product
                                         and c.DayQty  = '8'

    left outer join ZR_PLAN_RPT_1_6 as d on  a.Plant   = d.Plant
                                         and a.Product = d.Product
                                         and d.DayQty  = '16'

    left outer join ZR_PLAN_RPT_1_6 as e on  a.Plant   = e.Plant
                                         and a.Product = e.Product
                                         and e.DayQty  = '23'

    left outer join ZR_PLAN_RPT_1_6 as f on  a.Plant   = f.Plant
                                         and a.Product = f.Product
                                         and f.DayQty  = '31'

    left outer join ZR_PLAN_RPT_1_6 as g on  a.Plant   = g.Plant
                                         and a.Product = g.Product
                                         and g.DayQty  = '39'

    left outer join ZR_PLAN_RPT_1_6 as h on  a.Plant   = h.Plant
                                         and a.Product = h.Product
                                         and h.DayQty  = '47'

    left outer join ZR_PLAN_RPT_1_6 as i on  a.Plant   = i.Plant
                                         and a.Product = i.Product
                                         and i.DayQty  = '55'

    left outer join ZR_PLAN_RPT_1_6 as j on  a.Plant   = j.Plant
                                         and a.Product = j.Product
                                         and j.DayQty  = '63'

    left outer join ZR_PLAN_RPT_1_6 as k on  a.Plant   = k.Plant
                                         and a.Product = k.Product
                                         and k.DayQty  = '71'

    left outer join ZR_PLAN_RPT_1_6 as l on  a.Plant   = l.Plant
                                         and a.Product = l.Product
                                         and l.DayQty  = '366'

    left outer join ZR_PLAN_RPT_1_6 as n on  a.Plant   = n.Plant
                                         and a.Product = n.Product
                                         and n.DayQty  = 'CN'
{
  key a.Plant,
  key a.Product,
      a.OpenSoQty,
      sum( b.OpenSoQty) as OpenSoQty7,
      sum( c.OpenSoQty) as OpenSoQty8,
      sum( d.OpenSoQty) as OpenSoQty16,
      sum( e.OpenSoQty) as OpenSoQty23,
      sum( f.OpenSoQty) as OpenSoQty31,
      sum( g.OpenSoQty) as OpenSoQty39,
      sum( h.OpenSoQty) as OpenSoQty47,
      sum( i.OpenSoQty) as OpenSoQty55,
      sum( j.OpenSoQty) as OpenSoQty63,
      sum( k.OpenSoQty) as OpenSoQty71,
      sum( l.OpenSoQty) as OpenSoQty366,
      sum( n.OpenSoQty) as OpenSoQtyCN
}
where
  a.OpenSoQty is not null
group by
  a.Plant,
  a.Product,
  a.OpenSoQty
