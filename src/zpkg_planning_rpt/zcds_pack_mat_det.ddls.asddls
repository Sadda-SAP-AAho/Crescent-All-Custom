@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for BOM Subsequent Material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PACK_MAT_DET
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
{
  key a.plant,
  key a.hedmaterial,
  key a.component,
      division( a.childqty, a.parentqty, 3 )       as qtyz025,
      a.bomitemqtyunit   as unitz025,
      
      b.component        as matZ027,
      case when b.parentqty is not initial then division(b.childqty, b.parentqty, 3 )
           else b.bomitemqty end       as qtyz027,
      b.bomitemqtyunit   as unitz027,
      
      case when c.component is not initial then c.component
           when g.component is not initial then g.component
           when f.component is not initial then f.component
       else null end     as matZ026,
      case when c.component is not initial then case when c.parentqty is not initial then division( c.childqty, c.parentqty, 3 ) else c.bomitemqty end
           when g.component is not initial then case when g.parentqty is not initial then division( g.childqty, g.parentqty, 3 ) else g.bomitemqty end
           when f.component is not initial then case when f.parentqty is not initial then division( f.childqty, f.parentqty, 3 ) else f.bomitemqty end
       else null end     as qtyZ026,        
      case when c.component is not initial then c.bomitemqtyunit
           when g.component is not initial then g.bomitemqtyunit
           when f.component is not initial then f.bomitemqtyunit
      else null end      as unitZ026,
      case when d.component is not initial then d.component
           when h.component is not initial then h.component
           else null end as matZ028,
      case when d.component is not initial then case when d.parentqty is not initial then division( d.childqty, d.parentqty, 3 ) else d.bomitemqty end
           when h.component is not initial then case when h.parentqty is not initial then division( h.childqty, h.parentqty, 3 ) else h.bomitemqty end
           else null end as qtyZ028,     
      case when d.component is not initial then d.bomitemqtyunit
           when h.component is not initial then h.bomitemqtyunit
           else null end as unitZ028,
      e.component        as matZ045,
      case when e.parentqty is not initial then division( e.childqty, e.parentqty, 3 ) 
           else e.bomitemqty end      as qtyz045,
      e.bomitemqtyunit   as unitZ045
}
where
  a.productgroup = 'Z025'
