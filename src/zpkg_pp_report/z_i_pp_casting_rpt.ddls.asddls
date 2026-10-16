@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PP CASTING RPT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Z_I_PP_CASTING_RPT 
  provider contract transactional_query
  as projection on i_plancostratetp as ppcast
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
