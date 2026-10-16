@AbapCatalog.sqlViewName: 'ZACT_TYPE'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for activity type F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_ACTTYPE_F4 as 
select distinct from ZCDS_TBLFUNC_VIEW as a
inner join I_CostCenterActivityTypeText as b on a.ActivityType = b.CostCtrActivityType
                                             and b.Language = 'E'
{
      key ltrim(a.CostCenter , '0') as CostCenter,
      key a.ActivityType,
      b.CostCtrActivityTypeDesc
}
group by a.CostCenter,
         a.ActivityType,
         b.CostCtrActivityTypeDesc
