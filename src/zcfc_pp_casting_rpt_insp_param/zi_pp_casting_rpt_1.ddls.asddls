@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Daily Prod Casting Rpt-Basic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_PP_CASTING_RPT_1
  as select distinct from zcds_pp_casting_report     as a
    left outer join       I_Productplantqtmanagement as b on  a.Matnr = b.Product
                                                          and a.Plant = b.Plant
    left outer join       ZI_GR_INSP_MATL_DOC        as c on  a.MaterialDocument     = c.GRMatlDocNo
                                                          and a.MaterialDocumentItem = c.GRMatDocItm
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
      //      a.MaterialDocumentNo,
      ( case when b.ProductPlantHasInspectionSetup = 'X' and c.QltyMatlDocNo is not initial then c.QltyMatlDocNo
             when b.ProductPlantHasInspectionSetup = 'X' and c.QltyMatlDocNo is initial then 'X'
             when b.ProductPlantHasInspectionSetup <> 'X' then a.MaterialDocumentNo end )           as MaterialDocumentNo,

      ( case when b.ProductPlantHasInspectionSetup = 'X' and c.QltyMatlDocNo is not initial then c.QltyMatlDocYr
             when b.ProductPlantHasInspectionSetup = 'X' and c.QltyMatlDocNo is initial then 'X'
             when b.ProductPlantHasInspectionSetup <> 'X' then a.MaterialDocumentYear end )         as MaterialDocumentYr,

      //      a.MovementType,
      ( case when b.ProductPlantHasInspectionSetup = 'X' and c.QltyMatlDocNo is not initial then c.QltyMovmntTyp
             when b.ProductPlantHasInspectionSetup = 'X' and c.QltyMatlDocNo is initial then 'X'
             when b.ProductPlantHasInspectionSetup <> 'X' then a.MovementType end )                 as MovementType,
      a.Meins,
      a.Matnr,
      a.Maktx,
      b.ProductPlantHasInspectionSetup                                                              as InspSetup,
      //      @Semantics.quantity.unitOfMeasure: 'MEINS'
      //      a.Goodcast,
      cast( ( case when b.ProductPlantHasInspectionSetup = 'X' and c.QltyMatlDocNo is not initial then c.QltyQty
             when b.ProductPlantHasInspectionSetup = 'X' and c.QltyMatlDocNo is initial then cast( 0 as abap.dec(12,3) )
             when b.ProductPlantHasInspectionSetup <> 'X' then a.Goodcast end ) as abap.dec(12,3) ) as Goodcast,
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
      a.costcenter --,
      //      a.amount1,
      //      @Semantics.amount.currencyCode: 'currency'
      //      a.amount
}
