@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Plan vs Actual-1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PLAN_ACTUAL_1
  as select distinct from ZI_PRODPLANDATA  as a

    left outer join       ZI_SHPFLOORDATA  as b on  a.Proddate  = b.Shpflrdt
                                                and a.Plantcode = b.Plant
                                                and a.Prodcode  = b.Matnr

    left outer join       ZI_RECPTPRODDATA as c on  a.Proddate  = c.RcptfrmPrdDt
                                                and a.Plantcode = c.Plant_Code
                                                and a.Prodcode  = c.Mat_Code

    left outer join       I_Product        as d on a.Prodcode = d.Product

    left outer join       I_ProductText    as e on  a.Prodcode = e.Product
                                                and e.Language = 'E'

    left outer join       zdt_pp_matinffld as f on a.Prodcode = f.product


{
  key '1'                                      as Type,
  key a.Proddate                               as plan_date,
  key a.Plantcode                              as plant_code,
  key a.Prodcode                               as mat_code,
      e.ProductName                            as mat_name,
      a.comb,
      'Y'                                      as Status,
      f.typeofmould                            as typeofmould,
      d.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      d.NetWeight                              as NetWeight,
      f.qtyperbox                              as QTB,
      a.Quantity                               as plan_qty,
      b.Meins,

      @Semantics.quantity.unitOfMeasure: 'Meins'
      b.Goodcastqty                            as far_qty,
      cast( abs( case when f.qtyperbox = 0 then 0
                     else division(
                              cast( b.Goodcastqty as abap.dec(12,3) ),
                              cast( f.qtyperbox  as abap.dec(12,3) ),
                              3
                              )
                end ) as abap.dec(12,3))       as far_qty_box,

      c.Goodcastqty                            as recpt_prod_qty,
      cast( abs( case when f.qtyperbox = 0 then 0
                     else division(
                              cast( c.Goodcastqty as abap.dec(12,3) ),
                              cast( f.qtyperbox  as abap.dec(12,3) ),
                              3
                              )
                end ) as abap.dec(12,3))       as recpt_prod_qty_box,
      f.moc                                    as MOC,

      cast(d.NetWeight as abap.dec(12,3) )
      * cast(f.qtyperbox as abap.dec(12,3) )
      * cast(a.Quantity as abap.dec(12,3) )    as ttl_plan_wt,

      cast(d.NetWeight as abap.dec(12,3) )
      * cast(b.Goodcastqty as abap.dec(12,3) ) as ttl_far_wt,

      cast(d.NetWeight as abap.dec(12,3) )
      * cast(c.Goodcastqty as abap.dec(12,3) ) as ttl_prod_wt

}


