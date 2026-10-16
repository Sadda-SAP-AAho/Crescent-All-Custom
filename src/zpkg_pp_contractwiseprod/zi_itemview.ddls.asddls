@AbapCatalog.sqlViewName: 'ZIITEMVIEW'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item View'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_ITEMVIEW as 
select distinct from ZCDS_ITEMVIEW as a
left outer join ZCDS_PERDAYVIEW as b on  b.shpflrdt = a.shpflrdt
//                                and b.shpflrno = a.shpflrno
                                and b.cont = a.cont
                                and b.opr = a.opr
                                and b.plant = a.plant
                                and b.dept = a.dept
                                and b.matnr = a.matnr
left outer join ZCDS_PERDAYVIEW as c on  c.shpflrdt = dats_add_days( a.shpflrdt , 1, 'INITIAL' )
//                                and c.shpflrno = a.shpflrno
                                and c.cont = a.cont
                                and c.opr = a.opr
                                and c.plant = a.plant
                                and c.dept = a.dept
                                and c.matnr = a.matnr
left outer join ZCDS_PERDAYVIEW as d on  d.shpflrdt = dats_add_days( a.shpflrdt , 2, 'INITIAL' )
//                                and d.shpflrno = a.shpflrno
                                and d.cont = a.cont
                                and d.opr = a.opr
                                and d.plant = a.plant
                                and d.dept = a.dept
                                and d.matnr = a.matnr
left outer join ZCDS_PERDAYVIEW as e on  e.shpflrdt = dats_add_days( a.shpflrdt , 3, 'INITIAL' )
//                                and e.shpflrno = a.shpflrno
                                and e.cont = a.cont
                                and e.opr = a.opr
                                and e.plant = a.plant
                                and e.dept = a.dept
                                and e.matnr = a.matnr
left outer join ZCDS_PERDAYVIEW as f on  f.shpflrdt = dats_add_days( a.shpflrdt , 4, 'INITIAL' )
//                                and f.shpflrno = a.shpflrno
                                and f.cont = a.cont
                                and f.opr = a.opr
                                and f.plant = a.plant
                                and f.dept = a.dept
                                and f.matnr = a.matnr
left outer join ZCDS_PERDAYVIEW as g on  g.shpflrdt = dats_add_days( a.shpflrdt , 5, 'INITIAL' )
//                                and g.shpflrno = a.shpflrno
                                and g.cont = a.cont
                                and g.opr = a.opr
                                and g.plant = a.plant
                                and g.dept = a.dept
                                and g.matnr = a.matnr
left outer join ZCDS_PERDAYVIEW as h on  h.shpflrdt = dats_add_days( a.shpflrdt , 6, 'INITIAL' )
//                                and h.shpflrno = a.shpflrno
                                and h.cont = a.cont
                                and h.opr = a.opr
                                and h.plant = a.plant
                                and h.dept = a.dept
                                and h.matnr = a.matnr
{
//    key a.shpflrno,
    key a.shpflrdt,
    key a.cont,
    key a.opr,
    key a.plant,
    key a.dept,
    key a.matnr,
    a.WeightUnit,
    @Semantics.quantity.unitOfMeasure: 'WeightUnit'
    a.NetWeight,
    a.ProductDescription,
    a.contname,
//    b.prodord,
    b.MaterialBaseUnit,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    b.ReqQty as Day1qty,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    c.ReqQty as Day2qty,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    d.ReqQty as Day3qty,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    e.ReqQty as Day4qty,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    f.ReqQty as Day5qty,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    g.ReqQty as Day6qty,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    h.ReqQty as Day7qty,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    ( coalesce(b.ReqQty,0) + coalesce(c.ReqQty,0) + coalesce(e.ReqQty,0) 
    + coalesce(f.ReqQty,0) + coalesce(g.ReqQty,0) + coalesce(h.ReqQty,0) 
    + coalesce(d.ReqQty,0) ) as TotalPerDayQty,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    ( ( coalesce(b.ReqQty,0) + coalesce(c.ReqQty,0) + coalesce(e.ReqQty,0)
     + coalesce(f.ReqQty,0) + coalesce(g.ReqQty,0) + coalesce(h.ReqQty,0) 
     + coalesce(d.ReqQty,0) ) * a.NetWeight ) as Qtyinkg
    

}
