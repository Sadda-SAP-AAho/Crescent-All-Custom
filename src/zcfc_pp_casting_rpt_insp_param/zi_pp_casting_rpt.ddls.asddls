@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Daily Prod Casting Rpt'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_PP_CASTING_RPT
  as select from    ZI_PP_CASTING_RPT_1        as a

    left outer join I_MaterialDocumentHeader_2 as b on  a.MaterialDocumentNo = b.MaterialDocument
                                                    and a.MaterialDocumentYr = b.MaterialDocumentYear

{
  key a.Shpflrno,
  key a.ManufacturingOrder,
  key a.ManufacturingOrderOperation_2,
  key a.MaterialDocument,
  key a.MaterialDocumentItem,

      a.Shpflrdt,
      a.Dept,
      a.Deptname,
      a.Plant,
      a.Cont,
      a.Contname,

      a.MaterialDocumentNo,

      b.PostingDate as MaterialDocDate,

      a.MovementType,
      a.Meins,
      a.Matnr,
      a.Maktx,
      a.InspSetup,

      @Semantics.quantity.unitOfMeasure: 'MEINS'
      a.Goodcast,

      a.Wtunit,

      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      a.NetWeight,

      a.CostCtrActivityType,
      a.FiscalPeriod,

      a.WorkCenterStandardWorkQtyUnit1,

      @Semantics.quantity.unitOfMeasure: 'WorkCenterStandardWorkQtyUnit1'
      a.WorkCenterStandardWorkQty,

      a.CostCtrActivityTypeDesc,
      a.currency,
      a.CostRateFixedAmount,
      a.costcenter,

      cast(
        (
          cast(
            (
              a.Goodcast * a.WorkCenterStandardWorkQty
            ) as abap.dec(12,3)
          )
          * a.CostRateFixedAmount
        ) as abap.dec(12,3)
      )             as amount

}
where
  a.MaterialDocumentNo <> 'X'
