@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Workcenter'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_workcostcenter
  as select from I_WorkCenterCostCenter
{
  WorkCenterInternalID,
  WorkCenterTypeCode,
  Plant,

  CostCenterActivityTypeFormula,
  CostCtrActivityType,
  CostCenter
}
where
        CostCtrActivityType is not initial
  and(
        ValidityStartDate   <= $session.system_date
    and ValidityEndDate     >= $session.system_date
  )
group by
  WorkCenterInternalID,
  WorkCenterTypeCode,
  Plant,
  CostCenterActivityTypeFormula,
  CostCtrActivityType,
  CostCenter
