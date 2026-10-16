@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View of Feasibility VAC Reg'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZC_LEADMASTER
  provider contract transactional_query
  as projection on ZI_LEADMASTER
{
    @UI.hidden: true
    key Id,
    @EndUserText.label: 'Lead Code'
    Leadcode,
    @EndUserText.label: 'Lead Name'
    Leadname,
    @EndUserText.label: 'Sales Person'
    Salesperson
}
