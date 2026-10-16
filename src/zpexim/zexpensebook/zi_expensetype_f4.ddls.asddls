@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Expense Type F4 help'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_EXPENSETYPE_F4
  as select from zdt_expensetype
{
  key expansetype     as Expansetype,
      expansetypedesc as Expansetypedesc,
      percontship     as percontship
}
