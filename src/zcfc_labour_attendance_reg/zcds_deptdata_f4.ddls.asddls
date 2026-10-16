@AbapCatalog.sqlViewName: 'Z_DEPTDATA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Department-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_DEPTDATA_F4 
  as select distinct from I_CostCenter as a
  inner join I_CostCenterText as b on a.CostCenter = b.CostCenter
{
    key a.CostCenter as DeptCode,
        b.CostCenterName as DeptName
}
