@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for BOM Cost Report - Routing'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_BOMCOST_RPT_R_3
  as select from    ZR_BOMCOST_RPT_R     as a
    inner join      ZR_BOMCOST_RPT_R_1   as b on  b.BillOfOperationsGroup   = a.BillOfOperationsGroup
                                              and a.BillOfOperationsVariant = b.BillOfOperationsVariant
    left outer join zdt_bomdet           as c on  c.component   = a.Parent
                                              and c.plant       = a.Plant
                                              and c.hedmaterial = a.Hedmaterial
                                              and c.bomlevel    = a.Bomlevel_p
    inner join      I_Product            as d on a.Hedmaterial = d.Product
    left outer join I_ProductGroupText_2 as e on  e.ProductGroup = d.ProductGroup
                                              and e.Language     = 'E'

{
  key a.Plant,
  key a.Hedmaterial,
      e.ProductGroup                            as HeaderGrpCode,
      e.ProductGroupName                        as HeaderGrpName,
      a.HeadQty,
      a.Bomlevel,
      a.Parent,
      @Semantics.quantity.unitOfMeasure: 'ParentGrossWtUnit'
      a.ParentGrosswt,
      a.ParentGrossWtUnit,
      @Semantics.quantity.unitOfMeasure: 'ParentNetWtUnit'
      a.ParentNetwt,
      a.ParentNetWtUnit,
      a.Costitemcat,
      b.ProductionRouting                       as sequence,
      b.CostCtrActivityType,
      b.CostCtrActivityTypeName,
      'Activity'                                as ChildGrpCode,
      'Activity Item'                           as ChildGrpName,
      b.WorkCenterStandardWorkQty               as qty1,
      c.parentqty,
      c.childqty,
      case when c.parentqty is not initial then division( ( b.WorkCenterStandardWorkQty * c.childqty ),
                                                          ( case when coalesce(c.parentqty,0) = 0 then 1 else coalesce(c.parentqty,0) end )  ,
                                                          3 )
           else b.WorkCenterStandardWorkQty end as WorkCenterStandardWorkQty,
      b.StandardWorkQuantityUnit1,
      @Semantics.amount.currencyCode: 'Currency'
      b.costamt,
      cast( 'INR' as abap.cuky( 5 ) )           as currency,
      b.factor
      //      case when b.factor is not initial
      //           then cast( division( cast( ( b.WorkCenterStandardWorkQty * b.costamt ) as abap.dec( 23, 2 ) ),
      //                cast( b.factor as abap.dec( 23, 2 ) ), 2 ) as abap.dec( 23, 2 ) )
      //           else cast( 0 as abap.dec( 23, 3 )) end as totamt
}
