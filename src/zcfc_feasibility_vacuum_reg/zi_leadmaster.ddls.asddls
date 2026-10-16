@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View of Feasibility Vacuum Reg'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L

define root view entity ZI_LEADMASTER
  as select from zdt_leadmaster as a
{
  key a.id          as Id,
      a.leadcode    as Leadcode,
      a.leadname    as Leadname,
      a.salesperson as Salesperson
}
