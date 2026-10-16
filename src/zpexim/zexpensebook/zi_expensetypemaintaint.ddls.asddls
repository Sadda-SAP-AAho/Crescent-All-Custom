@EndUserText.label: 'ExpenseTypeMaintainTable'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_Expensetypemaintaint
  as select from ZDT_EXPENSE_TYPE
  association to parent ZI_Expensetypemaintait_S as _ExpensetypemaintAll on $projection.SingletonID = _ExpensetypemaintAll.SingletonID
{
  key EXPANSETYPE as Expansetype,
  @Consumption.hidden: true
  1 as SingletonID,
  _ExpensetypemaintAll
  
}
