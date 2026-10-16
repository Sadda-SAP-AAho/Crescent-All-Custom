@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'TIM Reco Register-Item'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZC_TIMRECOREGIT
  as projection on ZI_TIMRECOREGIT
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label: 'Supplier Ref'
      Suppref,
      @EndUserText.label: 'Invoice No'
      Invno,
      @EndUserText.label: 'Date'
      Invdate,
      @EndUserText.label: 'Amount'
      Amount,
      @EndUserText.label: 'Currency'
      Currency,
      @EndUserText.label: 'Remarks'
      Remarks,
      @EndUserText.label: 'TDS/Other'
      Tdsothr,
      @EndUserText.label: 'Payable Amount'
      Payamount,
      @EndUserText.label: 'Currency'
      Paycurr,
      @EndUserText.label: 'Ref Dr Note No'
      Refdrnoteno,
      @EndUserText.label: 'GST Invoice No'
      Gstinvno,
      /* Associations */
      _Head : redirected to parent ZC_TIMRECOREGHD
}
