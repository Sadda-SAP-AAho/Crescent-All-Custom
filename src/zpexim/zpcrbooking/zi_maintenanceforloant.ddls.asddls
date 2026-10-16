@EndUserText.label: 'Maintenance for loan type'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_MaintenanceForLoanT
  as select from ZDT_LTYPE
  association to parent ZI_MaintenanceForLoanT_S as _MaintenanceForLoAll on $projection.SingletonID = _MaintenanceForLoAll.SingletonID
{
  key LOANTYPE as Loantype,
  key DOCUMENTTYPE as Documenttype,
  @Consumption.hidden: true
  1 as SingletonID,
  _MaintenanceForLoAll
  
}
