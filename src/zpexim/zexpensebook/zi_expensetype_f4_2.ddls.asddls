@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Expense Type F4 help'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_EXPENSETYPE_F4_2
  as select from zdt_expensetype
{
  key expansetype     as Exptyp,
      expansetypedesc as Descr
}
