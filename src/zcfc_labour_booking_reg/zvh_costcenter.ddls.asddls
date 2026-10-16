@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS VIEW FOR VALUE HELP OF COST CENTER'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZVH_COSTCENTER 
  as select from I_CostCenter as a
  association [0..1] to I_CostCenterText as _CostCenterText
    on _CostCenterText.CostCenter = a.CostCenter
    and _CostCenterText.Language = $session.system_language
{
    key a.CostCenter,

    _CostCenterText.CostCenterName as CostCenter_Text
}
