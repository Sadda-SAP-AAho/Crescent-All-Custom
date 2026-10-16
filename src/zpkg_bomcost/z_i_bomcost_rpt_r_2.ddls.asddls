@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Cost Report - Routing'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Z_I_BOMCOST_RPT_R_2
  provider contract transactional_query
  as projection on I_PlanCostRateTP as bomcost
{
  key AccountingCostRateUUID,
      CompanyCode,
      CostCenter,
      ActivityType,
      Currency,
      ControllingArea,
      ValidityStartFiscalYear,
      ValidityStartFiscalPeriod,
      ValidityEndFiscalYear,
      ValidityEndFiscalPeriod,
      ValidityStartDate,
      ValidityEndDate,
      @Semantics.amount.currencyCode: 'Currency'
      CostRateFixedAmount,
      @Semantics.amount.currencyCode: 'Currency'
      CostRateVarblAmount,
      CostRateScaleFactor,
      CostCtrActivityTypeQtyUnit,
      Ledger,
      CostRateIsOverwriteMode
}
