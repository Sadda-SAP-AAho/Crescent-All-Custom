@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TIM Reco-Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_TIMRECORPT
  provider contract transactional_query
  as projection on ZI_TIMRECORPT
{
      @UI.hidden: true
  key Id,
      @UI.hidden: true
  key Item,
      @EndUserText.label: 'Document No.'
      DocumentNo,
      @EndUserText.label: 'Remittance Advice No.'
      RANo,
      @EndUserText.label: 'Date'
      Entrydate,
      @EndUserText.label: 'Header Remarks'
      HeadReamarks,
      @EndUserText.label: 'Type'
      Type,
      @EndUserText.label: 'Supplier Ref. No.'
      Suppref,
      @EndUserText.label: 'Invoice No.'
      Invno,
      @EndUserText.label: 'Invoice Date'
      Invdate,
      @EndUserText.label: 'Currency'
      Currency,
      @EndUserText.label: 'Amount'
      Amount,
      @EndUserText.label: 'Line Remarks'
      LineReamarks,
      @EndUserText.label: 'Payable Currency'
      Paycurr,
      @EndUserText.label: 'Payable Amt.'
      Payamount,
      @EndUserText.label: 'Ref Dr note No.'
      Refdrnoteno,
      @EndUserText.label: 'GST Inv. No.'
      Gstinvno,
      @EndUserText.label: 'Commercial Inv. No.'
      CommInvNo
}
