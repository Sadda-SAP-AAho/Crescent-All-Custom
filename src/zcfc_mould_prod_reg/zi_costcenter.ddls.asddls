@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View help for Cost Center'
define view entity ZI_COSTCENTER
  as select from I_CostCenter     as a
    inner join   I_CostCenterText as b on a.CostCenter = b.CostCenter
{
  key a.CostCenter as cstcntr,
      b.CostCenterDescription as cstcntrtxt

}
