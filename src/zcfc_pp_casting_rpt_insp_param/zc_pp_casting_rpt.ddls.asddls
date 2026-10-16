@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Consumption View for Daily Production Casting Report'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZC_PP_CASTING_RPT
  as select from ZI_PP_CASTING_RPT
{
      @EndUserText.label: 'ShopFloor Number'
  key Shpflrno,

      @EndUserText.label: 'Production Order Number'
  key ManufacturingOrder,

      @EndUserText.label: 'Production Order Operation Number'
  key ManufacturingOrderOperation_2,

      @EndUserText.label: 'Material Document'
      @UI.hidden: true
  key MaterialDocument,

      @UI.hidden: true
  key MaterialDocumentItem,

      @EndUserText.label: 'Document Date'
      Shpflrdt,

      @EndUserText.label: 'Department Code'
      Dept,

      @EndUserText.label: 'Department Name'
      Deptname,

      @EndUserText.label: 'Plant'
      Plant,

      @EndUserText.label: 'Contractor'
      Cont,

      @EndUserText.label: 'Contractor Name'
      Contname,

      @EndUserText.label: 'Unit'
      Meins,

      @EndUserText.label: 'Item Code'
      Matnr,

      @EndUserText.label: 'Item Description'
      Maktx,

      @EndUserText.label: 'Inspection Setup'
      InspSetup,

      @EndUserText.label: 'Confirmed Quantity - Good Cast'
      @Semantics.quantity.unitOfMeasure: 'Meins'
      Goodcast,

      @EndUserText.label: 'Weight Unit'
      Wtunit,

      @EndUserText.label: 'Net Weight'
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      NetWeight,

      @EndUserText.label: 'Component Code'
      CostCtrActivityType,

      @EndUserText.label: 'Fiscal Period'
      @UI.hidden: true
      FiscalPeriod,

      @EndUserText.label: 'Routing Activity Unit'
      WorkCenterStandardWorkQtyUnit1,

      @EndUserText.label: 'Routing Activity Units'
      @Semantics.quantity.unitOfMeasure: 'WorkCenterStandardWorkQtyUnit1'
      WorkCenterStandardWorkQty,

      @EndUserText.label: 'Component Name'
      CostCtrActivityTypeDesc,

      @UI.hidden: true
      currency,

      @EndUserText.label: 'Rate'
      @Semantics.amount.currencyCode: 'currency'
      CostRateFixedAmount,

      @EndUserText.label: 'Cost Center'
      @UI.hidden: true
      costcenter,

      @EndUserText.label: 'Amount'
      @Semantics.amount.currencyCode: 'currency'
      amount,

      //      @EndUserText.label: 'Amount 1'
      //      @Semantics.amount.currencyCode: 'currency'
      //      amount1,

      @EndUserText.label: 'Material Document No'
      MaterialDocumentNo,

      @EndUserText.label: 'Material Document Date'
      MaterialDocDate,

      @EndUserText.label: 'Movement Type'
      MovementType
}
