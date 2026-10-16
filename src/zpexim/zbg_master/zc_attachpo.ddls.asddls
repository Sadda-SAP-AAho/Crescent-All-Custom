@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Consumption View of Attach PO'
define view entity ZC_ATTACHPO
  as projection on zi_ATTACHPO
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item3,
      @EndUserText.label: 'BG Reference Number'
      Zeximbgrefno,
      @EndUserText.label: 'Version'
      Version,
      @EndUserText.label: 'PO Number'
      Ebeln,
      @EndUserText.label: 'Currency'
      Waers,
      @EndUserText.label: 'Net Value'
      Netwr,
      @EndUserText.label: 'Available Amount'
      Availamount,
      @EndUserText.label: 'Appied Amount in this LC'
      Applamtlc,
      @EndUserText.label: 'Appied Amount in other LC'
      Applamtothlc,
      @EndUserText.label: 'Level Amount'
      Amountlevel,
      @EndUserText.label: 'Cancel'
      Cancel,
      @EndUserText.label: 'Unit'
      Meins,
      @EndUserText.label: 'Appied Qty'
      Applqty,
      Locallastchangedat,
      /* Associations */
      _head : redirected to parent zc_bgheader
}
