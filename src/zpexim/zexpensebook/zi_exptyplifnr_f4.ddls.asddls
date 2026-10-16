@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor base on Expense Type'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_EXPTYPLIFNR_F4
  as select from ZI_EXPENSECOND
{
  key Expansetype,
      Shipline,
      Forwarder
}
