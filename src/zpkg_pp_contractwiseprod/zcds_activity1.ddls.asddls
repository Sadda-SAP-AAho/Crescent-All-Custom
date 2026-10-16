@AbapCatalog.sqlViewName: 'ZV_ACTIVITY2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for activity details'
@Metadata.ignorePropagatedAnnotations: true

define view ZCDS_ACTIVITY1
  as select distinct from ZCDS_ACTIVITY
{
  key plant,
  key matnr,
  
  key opr,
  key cont,
  key dept,

      ActivityType,
      CostCenterActivityTypeFormula,
      Currency,
      CalculatedCost,
      ValidityStartDate,
      ValidityEndDate
}
