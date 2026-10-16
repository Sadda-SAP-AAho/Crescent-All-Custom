@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View help for Cost Center'
define view entity ZCDS_COSTCENTER 
as select from I_CostCenter as a
inner join I_CostCenterText as b on a.CostCenter = b.CostCenter
{
  key a.CostCenter,
  key b.CostCenterDescription,
  key a.CompanyCode
}
where a.CompanyCode = '1000' and b.Language = 'E' 
