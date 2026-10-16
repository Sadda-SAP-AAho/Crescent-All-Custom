@AbapCatalog.sqlViewName: 'Z_COSTCENTER_F4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cost Center-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_COSTCENTER_F4
  as select from I_CostCenter     as a
    inner join   I_CostCenterText as b on a.CostCenter = b.CostCenter
{
  key cast( a.CostCenter as abap.char(10) ) as cstcntr,
      b.CostCenterDescription               as cstcntrtxt

}
