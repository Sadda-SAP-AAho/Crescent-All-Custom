@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 for Department'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DEPT_F4 
as select from I_CostCenter as a
inner join I_CostCenterText as b on b.ControllingArea = a.ControllingArea and b.Language = 'E' and a.CostCenter = b.CostCenter
{
  key a.CostCenter as Kostl,
  key b.CostCenterDescription as Cname
    
}
where a.CostCenterCategory = 'F'
group by
a.CostCenter,
b.CostCenterDescription
