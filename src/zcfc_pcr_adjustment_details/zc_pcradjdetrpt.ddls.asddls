@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for PCR Adj. Details Rpt'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_PCRADJDETRPT
  provider contract transactional_query
  as projection on ZI_PCRADJDETRPT
{
    @UI.hidden: true
    key Id,
    @UI.hidden: true
    key Item,
    @EndUserText.label: 'PCR Code'
    @Search.defaultSearchElement: true
    Loanacno,
    @EndUserText.label: 'PCR Date'
    Bookingdt,
    @EndUserText.label: 'Currency'
    Waers,
    @UI.hidden: true
    Currency,
    @EndUserText.label: 'Booking Amount'
    Bookamt,
    @EndUserText.label: 'Balance Amount'
    Balanceamt,
    @EndUserText.label: 'Exchange Rate'
    Exchangerate1,
    @EndUserText.label: 'Bank'
    Bankname,
    @EndUserText.label: 'Adjustment Type'
    Adjustdoctype,
    @EndUserText.label: 'Adjustment Doc. No.'
    Invno,
    @EndUserText.label: 'Adjustment Doc. Date'
    Invdt,
    @EndUserText.label: 'Instruction Date'
    Instructdt,
    @EndUserText.label: 'Adjusted Value'
    Adjamt,
    @EndUserText.label: 'Remarks'
    Othertext
}
