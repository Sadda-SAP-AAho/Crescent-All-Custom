@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Daily Production Casting Report-Rej Qty(Baroda)-2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_PP_CAST_REJ_BARODA_2
  as select distinct from ZI_CONF_ORD                   as a
    
    inner join            I_ManufacturingOrderOperation as b on b.ManufacturingOrder = a.Prodord
    
    inner join            ZI_CONF_HDR                   as c on  c.Id       = a.Id
                                                             and c.Shpflrno = a.Shpflrno
    
    inner join            ZI_CONF_ITM                   as d on  d.Id       = a.Id
                                                             and d.Item     = a.Item
                                                             and d.Shpflrno = a.Shpflrno
    inner join            I_MaterialDocumentHeader_2    as l on l.MaterialDocumentHeaderText = a.Shpflrno
    
    inner join            I_MaterialDocumentItem_2      as j on  j.MaterialDocument    = l.MaterialDocument
                                                             and j.Material            = d.Matnr
                                                             and (
                                                                j.GoodsMovementType    = '101'
                                                                or j.GoodsMovementType = '102'
                                                                or j.GoodsMovementType = '321'
                                                              )
                                                             and (
                                                                j.StorageLocation      = 'BARJ'
                                                              )
                                                             and j.OrderID             = b.ManufacturingOrder

    inner join            I_Product                     as e on e.Product = a.Matnr

    left outer join       zcds_pp_component_dlts_main   as f on  f.Shpflrno                      = a.Shpflrno
                                                             and f.ManufacturingOrder            = b.ManufacturingOrder
                                                             and f.ManufacturingOrderOperation_2 = b.ManufacturingOrderOperation_2
    
    inner join            I_CostCenterActivityTypeText  as g on g.CostCtrActivityType = f.CostCtrActivityType


    inner join            I_FiscalCalendarDate          as i on  i.CalendarDate      = j.PostingDate
                                                             and i.FiscalYearVariant = 'V3'
    
    left outer join       zcds_get_rate                 as h on  h.ActivityType =       f.CostCtrActivityType
                                                             and (
                                                                j.PostingDate   between h.Validitystartdate and h.Validityenddate
                                                              )
                                                             and h.costcenter   =       c.Dept
{
  key a.Shpflrno,
  key b.ManufacturingOrder,
  key b.ManufacturingOrderOperation_2,
  key l.MaterialDocument,
  key j.MaterialDocumentItem,
      j.PostingDate                                             as Shpflrdt,
      c.Dept,
      c.Deptname,
      c.Plant,
      c.Cont,
      c.Contname,
      j.GoodsMovementType,
      a.Meins,
      a.Matnr,
      d.Maktx,
      @Semantics.quantity.unitOfMeasure: 'MEINS'

      ( case when j.GoodsMovementType = '102'
             then ( j.QuantityInBaseUnit * (-1) )
             else j.QuantityInBaseUnit end )                    as Rejcast,
      d.Wtunit,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      e.NetWeight,
      f.CostCtrActivityType,
      i.FiscalPeriod,
      f.WorkCenterStandardWorkQtyUnit1,
      @Semantics.quantity.unitOfMeasure: 'WorkCenterStandardWorkQtyUnit1'

      // Old Logic //
      //cast( k.WorkCenterStandardWorkQty as abap.quan( 13, 3 ) )                         as WorkCenterStandardWorkQty,

      // New Logic //
      cast( f.WorkCenterStandardWorkQty as abap.quan( 13, 3 ) ) as WorkCenterStandardWorkQty,

      g.CostCtrActivityTypeDesc,
      cast( ' ' as abap.cuky )                                  as currency,
      cast( h.CostRateFixedAmount / 100 as abap.dec( 15, 3 ) )  as CostRateFixedAmount,
      h.costcenter                                              as costcenter,
      
      @Semantics.amount.currencyCode: 'currency'
      cast(
            ( cast( ( case when j.GoodsMovementType = '102'
                           then ( j.QuantityInBaseUnit * (-1) )
                           else j.QuantityInBaseUnit end ) as abap.dec( 13, 3 ) ) *
              cast( f.WorkCenterStandardWorkQty as abap.quan( 13, 3 ) ) )
       as abap.dec( 13, 3 ) )                                   as amount1,
       
      i.FiscalYear
}
where
       j.QuantityInBaseUnit  is not initial
  and(
       f.CostCtrActivityType = 'GLGN26'
    or f.CostCtrActivityType = 'GLGN27'
    or f.CostCtrActivityType = 'GLGN28'
  )
  and  e.ProductGroup        = 'Z025'
