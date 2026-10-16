@EndUserText.label: 'Expense Type Maintain'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_ExpenseTypeMaintain1
  as select from ZDT_EXPENSETYPE
  association to parent ZI_ExpenseTypeMaintain_S1 as _ExpenseTypeMaintAll on $projection.SingletonID = _ExpenseTypeMaintAll.SingletonID
{
  key EXPANSETYPE as Expansetype,
  EXPANSETYPEDESC as Expansetypedesc,
  PERCONTSHIP as Percontship,
  @Consumption.hidden: true
  1 as SingletonID,
  _ExpenseTypeMaintAll
  
}
