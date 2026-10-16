@AbapCatalog.sqlViewName: 'ZVIEW1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item View'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_ITEMVIEW as select from ZCDS_POSTINGDATE as z
left outer join zdt_confpost_hdr as a on a.shpflrno = z.shpflrno
left outer join zdt_confpost_itm as b on b.id = a.id
left outer join I_ProductDescription as c on c.Product = b.matnr and c.Language = 'E'
left outer join I_Product as d on d.Product = b.matnr
{ 
    key z.PostingDate as shpflrdt ,
    key a.opr,
    key a.plant,
    key a.dept,
    key a.cont,
    key b.matnr,
//    a.shpflrno,
    a.contname,   
    c.ProductDescription,
    d.WeightUnit,
    @Semantics.quantity.unitOfMeasure: 'WeightUnit'
    d.NetWeight
}
group by 
    z.PostingDate,
//    a.shpflrno,
    a.opr,
    a.plant,
    a.dept,
    a.cont,
    a.contname,
    b.matnr,
    c.ProductDescription,
    d.WeightUnit,
    d.NetWeight
