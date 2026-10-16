@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Daily Production Casting Report-Rej Qty(Baroda)'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE

define root view entity ZC_PP_CAST_REJ_BARODA
  provider contract transactional_query
  as projection on ZI_PP_CAST_REJ_BARODA
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
      @EndUserText.label: 'Unit'
      Meins,
      @EndUserText.label: 'Item Code'
      Matnr,
      @EndUserText.label: 'Item Description'
      Maktx,
      @EndUserText.label: 'Location'
      Plant,
      @EndUserText.label: 'Contractor'
      Cont,
      @EndUserText.label: 'Contractor Name'
      Contname,
      @EndUserText.label: 'Net Weight'
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      NetWeight,
      @EndUserText.label: 'Rejection Qty'
      @Semantics.quantity.unitOfMeasure: 'MEINS'
      Rejcast,
      @EndUserText.label: 'Weight Unit'
      Wtunit,
      @EndUserText.label: 'Component Code'
      CostCtrActivityType,
      @EndUserText.label: 'Fiscal Period'
      @UI.hidden: true
      FiscalPeriod,
      //      @Semantics.quantity.unitOfMeasure: 'MEINS'
      WorkCenterStandardWorkQtyUnit1,
      @Semantics.quantity.unitOfMeasure: 'WorkCenterStandardWorkQtyUnit1'
      @EndUserText.label: 'Routing Activity Units'
      WorkCenterStandardWorkQty,
      @EndUserText.label: 'Component Name'
      CostCtrActivityTypeDesc,
      @UI.hidden: true
      currency,
      @Semantics.amount.currencyCode: 'currency'
      @EndUserText.label: 'Rate'
      CostRateFixedAmount,
      @EndUserText.label: 'Cost Center'
      @UI.hidden: true
      costcenter,
      @EndUserText.label: 'Amount'
      amount,
      @EndUserText.label: 'Material Document No'
      MaterialDocumentNo,
      @EndUserText.label: 'Movement Type'
      MovementType

}
