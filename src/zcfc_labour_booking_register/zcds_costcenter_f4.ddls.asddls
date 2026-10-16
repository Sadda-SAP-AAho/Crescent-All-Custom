@AbapCatalog.sqlViewName: 'Z_COSTCENTER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COST CENTER-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_COSTCENTER_F4 
  as select distinct from I_CostCenter as a
  inner join I_CostCenterText as b on a.CostCenter = b.CostCenter
{
    key a.CostCenter as CostCode,
        b.CostCenterName as CostName
}
