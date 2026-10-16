@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for FOREX Adj. Details Rpt'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_FOREXADJDETRPT
  provider contract transactional_query
  as projection on ZI_FOREXADJDETRPT
{
  @UI.hidden: true
  key Id,
  @UI.hidden: true
  key Item,
  @EndUserText.label: 'Forward Contract Date'
  Contractdate,
  @EndUserText.label: 'Forward Contract Number'
  @Search.defaultSearchElement: true
  Contnoext,
  @EndUserText.label: 'Booking Date'
  Bookdate,
  @EndUserText.label: 'Option Period Open Date'
  Opendate,
  @EndUserText.label: 'Maturity Date'
  Maturitydate,
  @EndUserText.label: 'Currency'
  Waers,
  @EndUserText.label: 'Contract Booking Amount'
  Contamt,
  @EndUserText.label: 'Balance Value'
  Balanceval,
  @EndUserText.label: 'Exchange Rate'
  Exchangerate,
  @EndUserText.label: 'Bank'
  Bankname,
  @EndUserText.label: 'Adjusted Doc. Type'
  Adjustdoctype,
  @EndUserText.label: 'Sales Order'
  Salesorder,
  @EndUserText.label: 'Sales Order Date'
  Salesdate,
  @UI.hidden: true
  Salecurr,
  @EndUserText.label: 'Sales Order Value'
  Salesamt,
  @EndUserText.label: 'Remarks'
  Remarks,
  @EndUserText.label: 'Instruction Date'
  Instructdate,
  @EndUserText.label: 'Adjusted Value'
  Adjustval,
  @EndUserText.label: 'Customer Reference'
  Custref
}
