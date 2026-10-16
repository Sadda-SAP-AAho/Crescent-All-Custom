@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Expense Type F4 help'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_GLCODE_F4
  as select distinct from I_OperationalAcctgDocItem
{
  key GLAccount as Glc2
}
