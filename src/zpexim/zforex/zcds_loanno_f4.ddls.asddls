@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Tax Loan No'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_LOANNO_F4 as select 
distinct from ZI_PCRHDR
{
    key Loanacno,
    key Bookingdt,
    key Waers
}
where Loanacno is not initial
