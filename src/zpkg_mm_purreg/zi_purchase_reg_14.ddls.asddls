@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register - WBS Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PURCHASE_REG_14 
as select from I_EnterpriseProjectElement as a
{
    a.WBSElementInternalID,
    a.ProjectElement,
    a.ProjectElementDescription
}
group by 
a.WBSElementInternalID,
a.ProjectElement,
a.ProjectElementDescription
