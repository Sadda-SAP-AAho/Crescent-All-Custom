@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function for Daily Prod Casting Report Sort Data'
define table function ZTF_PP_CASTING_REPORT_sort

returns
{
  key mandt                          : abap.clnt;
  key Shpflrno                       : abap.char(15);
  key ManufacturingOrder             : abap.char(12);
  key ManufacturingOrderOperation_2  : abap.char(4);
  key MaterialDocument               : mblnr;
  key MaterialDocumentYear           : abap.char(4);
  key MaterialDocumentItem           : abap.char(4);
      Shpflrdt                       : sydate;
      Dept                           : abap.char(10);
      Deptname                       : abap.char(200);
      Plant                          : werks_d;
      Cont                           : abap.char(20);
      Contname                       : abap.char(200);
      GoodsMovementType              : abap.char(3);
      Meins                          : meins;
      Matnr                          : matnr;
      Maktx                          : maktx;
      @Semantics.quantity.unitOfMeasure: 'MEINS'
      Goodcast                       : abap.quan(13,3);
      Wtunit                         : meins;
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      NetWeight                      : ntgew;
      CostCtrActivityType            : lstar;
      FiscalPeriod                   : fins_fiscalperiod;
      WorkCenterStandardWorkQtyUnit1 : meins;
      @Semantics.quantity.unitOfMeasure: 'WorkCenterStandardWorkQtyUnit1'
      WorkCenterStandardWorkQty      : abap.quan( 13, 3 );
      CostCtrActivityTypeDesc        : abap.char(40);
      currency                       : abap.cuky( 5 );
      CostRateFixedAmount            : abap.dec( 15, 3 );
      costcenter                     : abap.char(6);
      amount1                        : abap.dec( 23, 3 );
      @Semantics.amount.currencyCode: 'currency'
      amount                         : abap.dec( 23, 3 );
}
implemented by method
  zcl_pp_casting_report=>sort_data;