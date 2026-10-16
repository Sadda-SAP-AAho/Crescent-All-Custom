@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Daily Production Report of Casting'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_amount_calculation
  as select distinct from
  // zcds_pp_casting_dlts1        as a
  //    inner join            zcds_pp_casting_dlts2        as b on  b.Shpflrno = a.Shpflrno
  //                                                           and b.Material = a.Matnr

                    ZI_CONF_ORD                   as a
    inner join      I_ManufacturingOrderOperation as b on b.ManufacturingOrder = a.Prodord
    inner join      ZI_CONF_HDR                   as c on  c.Id       = a.Id
                                                       and c.Shpflrno = a.Shpflrno
    inner join      ZI_CONF_ITM                   as d on  d.Id       = a.Id
                                                       and d.Item     = a.Item
                                                       and d.Shpflrno = a.Shpflrno
    inner join      I_MaterialDocumentHeader_2    as l on l.MaterialDocumentHeaderText = a.Shpflrno
    inner join      I_MaterialDocumentItem_2      as j on  j.MaterialDocument    = l.MaterialDocument
                                                       and j.Material            = d.Matnr
                                                       and (
                                                          j.GoodsMovementType    = '101'
                                                          or j.GoodsMovementType = '102'
                                                          or j.GoodsMovementType = '321'
                                                        )
                                                       and (
                                                          j.StorageLocation      = 'BASG'
                                                          or j.StorageLocation   = 'SASG'
                                                          or j.StorageLocation   = 'KUSG'
                                                          or j.StorageLocation   = 'BGSG'
                                                          or j.StorageLocation   = 'SAFG'
                                                          or j.StorageLocation   = 'KUFG'
                                                          or j.StorageLocation   = 'BGFG'
                                                          or j.StorageLocation   = 'BAFG'
                                                        )
                                                       and j.OrderID             = b.ManufacturingOrder
  //      left outer join       ZI_CONFPOST_ORD               as j on  j.Prodord  =  a.Prodord
  //                                                               and j.Shpflrno =  a.Shpflrno
  //                                                               and j.Rej      <> 'X'
  //                                                               and j.Ordersta =  'P'
  //  d.Prodord = a.Prodord
    inner join      I_Product                     as e on e.Product = a.Matnr
    left outer join zcds_pp_component_dlts_main   as f on  f.Shpflrno                      = a.Shpflrno
                                                       and f.ManufacturingOrder            = b.ManufacturingOrder
                                                       and f.ManufacturingOrderOperation_2 = b.ManufacturingOrderOperation_2
    inner join      I_CostCenterActivityTypeText  as g on g.CostCtrActivityType = f.CostCtrActivityType
  //+++Added Change - Surajit Ghosh - 05/06/2025
  //    inner join      I_FiscalCalendarDate          as i on  i.CalendarDate      = c.Shpflrdt
    inner join      I_FiscalCalendarDate          as i on  i.CalendarDate      = j.PostingDate
                                                       and i.FiscalYearVariant = 'V3'
    left outer join zcds_get_rate                 as h on  h.ActivityType =       f.CostCtrActivityType

    //                                                       and (
    //                                                          h.ValidityStartFiscalYear     <=      i.FiscalYear
    //                                                          and h.ValidityEndFiscalYear   >=      i.FiscalYear
    //                                                        )
    //                                                       and (
    //                                                          h.ValidityStartFiscalPeriod   <=      i.FiscalPeriod
    //                                                          and h.ValidityEndFiscalPeriod >=      i.FiscalPeriod
    //                                                        )

                                                       and (
                                                          j.PostingDate   between h.Validitystartdate and h.Validityenddate
                                                        )

    //  * Begin of Change - Surajit Ghosh - 05/06/2025
    //                                                       and c.Dept                       = right( h.costcenter, 6 )

                                                       and h.costcenter   =       c.Dept
  //  * End   of Change - Surajit Ghosh - 05/06/2025
  //    left outer join zcds_pp_component_dlts1       as k on  k.Prodord              = b.ManufacturingOrder
  //                                                       and k.WorkCenterInternalID = f.WorkCenterInternalID
{
  key a.Shpflrno,
  key b.ManufacturingOrder,
  key b.ManufacturingOrderOperation_2,
  key l.MaterialDocument,
  key l.MaterialDocumentYear,
  key j.MaterialDocumentItem,
      j.PostingDate                                                                                                as Shpflrdt,
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
      //  d.Goodcast,
      //  j.Alpostqty
      ( case when j.GoodsMovementType = '102' 
             then ( j.QuantityInBaseUnit * (-1) ) 
             else j.QuantityInBaseUnit end ) as Goodcast,
      d.Wtunit,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      e.NetWeight,
      f.CostCtrActivityType,
      i.FiscalPeriod,
      //     @Semantics.quantity.unitOfMeasure: 'MEINS'
      //      f.WorkCenterStandardWorkQty,
      f.WorkCenterStandardWorkQtyUnit1,
      @Semantics.quantity.unitOfMeasure: 'WorkCenterStandardWorkQtyUnit1'

      // Old Logic //
      //cast( k.WorkCenterStandardWorkQty as abap.quan( 13, 3 ) )                         as WorkCenterStandardWorkQty,

      // New Logic //
      cast( f.WorkCenterStandardWorkQty as abap.quan( 13, 3 ) )                                                    as WorkCenterStandardWorkQty,

      g.CostCtrActivityTypeDesc,
      cast( ' ' as abap.cuky )                                                                                     as currency,
      cast( h.CostRateFixedAmount / 100 as abap.dec( 15, 3 ) )                                                     as CostRateFixedAmount,
      h.costcenter                                                                                                 as costcenter,
      @Semantics.amount.currencyCode: 'currency'
      cast(
            ( cast( ( case when j.GoodsMovementType = '102' 
                           then ( j.QuantityInBaseUnit * (-1) ) 
                           else j.QuantityInBaseUnit end ) as abap.dec( 13, 3 ) ) *
              cast( f.WorkCenterStandardWorkQty as abap.quan( 13, 3 ) ) )
       as abap.dec( 13, 3 ) )                                                                                      as amount1,
      i.FiscalYear
}
where
  j.QuantityInBaseUnit is not initial
//  j.Ordersta = 'P' and
//  j.Alpostqty is not initial
