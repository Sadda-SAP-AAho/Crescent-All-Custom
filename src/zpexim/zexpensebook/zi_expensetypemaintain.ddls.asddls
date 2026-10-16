@EndUserText.label: 'Expense Type Maintain'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_ExpenseTypeMaintain
  as select from zdt_expense_type
  association to parent ZI_ExpenseTypeMaintain_S as _ExpenseTypeMaintAll on $projection.SingletonID = _ExpenseTypeMaintAll.SingletonID
{
  key expansetype     as Expansetype,
//      expansetypedesc as Expansetypedesc,
//      percontship     as percontship,
      @Consumption.hidden: true
      1               as SingletonID,
      _ExpenseTypeMaintAll

}
