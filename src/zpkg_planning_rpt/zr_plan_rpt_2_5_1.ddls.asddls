@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Club Custing'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_2_5_1
  as select from    ZR_PLAN_RPT_2_5    as a

    left outer join ZR_PLAN_RPT_2_6_1  as b on  a.plant     = b.plant
                                            and a.component = b.component

    left outer join ZR_PLAN_RPT_2_7_1  as c on  a.plant     = c.plant
                                            and a.component = c.component

    left outer join ZR_PLAN_RPT_2_8_1  as d on  a.plant     = d.plant
                                            and a.component = d.component


    left outer join ZR_PLAN_RPT_2_9_1  as e on  a.plant     = e.plant
                                            and a.component = e.component

    left outer join ZR_PLAN_RPT_2_10_1 as f on  a.plant     = f.plant
                                            and a.component = f.component

    left outer join ZR_PLAN_RPT_2_11_1 as g on  a.plant     = g.plant
                                            and a.component = g.component

{
  key a.plant,
  key a.component,
      a.ProductGroup,
      a.ProductDescription,
      a.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      a.NetWeight,
      a.ProfitCenter,
      a.ProfitCenterLongName,
      a.cuscode,
      a.qtyperbox,
      a.prodcapcday,
      a.boxsize,
      a.typemould,
      a.OpenContQty,
      a.OpenSoQty,
      cast(coalesce(a.castonhand,0) as abap.dec(15,3) ) as castonhand,

      case when coalesce(a.OpenSoQty,0) <= a.castonhand then a.OpenSoQty
           when coalesce(a.OpenSoQty,0) > a.castonhand then a.castonhand
           else null end                                as FgLiveQty,

      case when coalesce(a.OpenSoQty,0) > coalesce(a.castonhand,0)
             then coalesce(a.OpenSoQty,0) -  coalesce(a.castonhand,0)
           else null end                                as OpenSoQtyRem,
      //      ( coalesce(a.OpenSoQty,0) - coalesce(a.castonhand,0) ) as OpenSoQtyRem,
      //      ( a.OpenSoQty - a.castonhand ) as OpenSoQtyRem,
      b.stockZ028,
      c.stockZ027,
      d.stockZ026,
      e.stockZ025,
      f.stockZ024,
      g.stockZ045,

      a.OpenSoQty7,
      a.OpenSoQty8,
      a.OpenSoQty16,
      a.OpenSoQty23,
      a.OpenSoQty31,
      a.OpenSoQty39,
      a.OpenSoQty47,
      a.OpenSoQty55,
      a.OpenSoQty63,
      a.OpenSoQty71,
      a.OpenSoQty366



}
