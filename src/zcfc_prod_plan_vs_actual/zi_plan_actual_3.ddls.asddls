@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Plan vs Actual-3'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PLAN_ACTUAL_3
  as select distinct from ZI_RECPTPRODDATA as c

    left outer join       I_Product        as d on c.Mat_Code = d.Product

    left outer join       I_ProductText    as e on  c.Mat_Code = e.Product
                                                and e.Language = 'E'

    left outer join       zdt_pp_matinffld as f on c.Mat_Code = f.product

    left outer join       ZI_PLAN_ACTUAL_1 as a on a.comb = c.comb
    
    left outer join       ZI_PLAN_ACTUAL_2 as b on b.comb = c.comb


{
  key '3'                                                   as Type,
  key c.RcptfrmPrdDt                                        as plan_date,

  key c.Plant_Code                                          as plant_code,

  key c.Mat_Code                                            as mat_code,

      e.ProductName                                         as mat_name,
      
      ( case when ( a.comb is not null or b.comb is not null ) then 'N' else 'Y' end ) as Status,
      
      f.typeofmould                                         as typeofmould,
      d.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      d.NetWeight                                           as NetWeight,
      f.qtyperbox                                           as QTB,
      cast ( 0 as abap.dec(12,3) )                          as plan_qty,
      a.Meins,

      cast ( 0 as abap.dec(12,3) )                          as far_qty,
      cast ( 0 as abap.dec(12,3) )                          as far_qty_box,

      c.Goodcastqty                                         as recpt_prod_qty,
      cast( abs( case when f.qtyperbox = 0 then 0
                     else division(
                              cast( c.Goodcastqty as abap.dec(12,3) ),
                              cast( f.qtyperbox  as abap.dec(12,3) ),
                              3
                              )
                end ) as abap.dec(12,3))                    as recpt_prod_qty_box,
      f.moc                                                 as MOC,

      cast(d.NetWeight as abap.dec(12,3) )
      * cast(f.qtyperbox as abap.dec(12,3) )
      * cast ( 0 as abap.dec(12,3) )                        as ttl_plan_wt,

      cast(d.NetWeight as abap.dec(12,3) )
      * cast ( 0 as abap.dec(12,3) )                        as ttl_far_wt,

      cast(d.NetWeight as abap.dec(12,3) )
      * cast(c.Goodcastqty as abap.dec(12,3) )              as ttl_prod_wt

}
