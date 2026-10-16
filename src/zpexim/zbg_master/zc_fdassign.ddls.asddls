@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Consumption View of FD Assign'
define view entity ZC_FDASSIGN
  as projection on zi_Bgfdassign
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label: 'FD Number'
      Fdno,
      @EndUserText.label: 'BG Reference Number'
      Zeximbgrefno,
      @EndUserText.label: 'FD Sub Number'
      Fdsubnumber,
      @EndUserText.label: 'Currency'
      Waers,
      @EndUserText.label: 'Total FD Amount'
      Totalfdamt,
      @EndUserText.label: 'Link Type'
      Linktype,
      @EndUserText.label: 'FD Available Amount'
      Fdavlamt,
      @EndUserText.label: 'FD Link Amount'
      Fdlinkamt,
      Locallastchangedat,
      /* Associations */
      _head : redirected to parent ZC_BGHEADER
}
