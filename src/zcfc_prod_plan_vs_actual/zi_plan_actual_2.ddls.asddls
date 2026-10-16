@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Plan vs Actual-2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PLAN_ACTUAL_2
  as select distinct from ZI_SHPFLOORDATA  as b

  left outer join    ZI_PRODPLANDATA  as a on a.comb = b.comb

  left outer join    ZI_RECPTPRODDATA as c on  b.Shpflrdt = c.RcptfrmPrdDt
                                           and b.Plant    = c.Plant_Code
                                           and b.Matnr    = c.Mat_Code

  left outer join    I_Product        as d on b.Matnr = d.Product

  left outer join    I_ProductText    as e on  b.Matnr    = e.Product
                                           and e.Language = 'E'

  left outer join    zdt_pp_matinffld as f on b.Matnr = f.product




{
  key '2'                                                    as Type,
  key b.Shpflrdt                                             as plan_date,

  key b.Plant                                                as plant_code,

  key b.Matnr                                                as mat_code,

      e.ProductName                                          as mat_name,
      b.comb,
      ( case when a.comb is not null then 'N' else 'Y' end ) as Status,
      f.typeofmould                                          as typeofmould,
      d.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      d.NetWeight                                            as NetWeight,
      f.qtyperbox                                            as QTB,
      cast ( 0 as abap.dec(12,3) )                           as plan_qty,
      b.Meins,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      b.Goodcastqty                                          as far_qty,
      cast( abs( case when f.qtyperbox = 0 then 0
                     else division(
                              cast( b.Goodcastqty as abap.dec(12,3) ),
                              cast( f.qtyperbox  as abap.dec(12,3) ),
                              3
                              )
                end ) as abap.dec(12,3))                     as far_qty_box,

      c.Goodcastqty                                          as recpt_prod_qty,
      cast( abs( case when f.qtyperbox = 0 then 0
                     else division(
                              cast( c.Goodcastqty as abap.dec(12,3) ),
                              cast( f.qtyperbox  as abap.dec(12,3) ),
                              3
                              )
                end ) as abap.dec(12,3))                     as recpt_prod_qty_box,
      f.moc                                                  as MOC,

      cast(d.NetWeight as abap.dec(12,3) )
      * cast(f.qtyperbox as abap.dec(12,3) )
      * cast ( 0 as abap.dec(12,3) )                         as ttl_plan_wt,

      cast(d.NetWeight as abap.dec(12,3) )
      * cast(b.Goodcastqty as abap.dec(12,3) )               as ttl_far_wt,

      cast(d.NetWeight as abap.dec(12,3) )
      * cast(c.Goodcastqty as abap.dec(12,3) )               as ttl_prod_wt

}

where ( b.Goodcastqty > 0
or c.Goodcastqty > 0 )
