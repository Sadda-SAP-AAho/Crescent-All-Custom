@EndUserText.label: 'Consumption View of Advance Upload Item'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity zc_advanceuploaditm
  as projection on zi_advanceuploaditm
{
  key Id,
  key Item,
      @EndUserText.label: 'Company Code'
      Companycode,
      @EndUserText.label: 'Document Date'
      Documentdate,
      @EndUserText.label: 'Posting Date'
      Postingdate,
      @EndUserText.label: 'Text'
      Text,
      @EndUserText.label: 'Reference'
      Reference,
      @EndUserText.label: 'Currency'
      Currency,
      @EndUserText.label: 'Exchange Rate'
      Exchangerate,
      @EndUserText.label: 'Vendor Code'
      Vendorcode,
      @EndUserText.label: 'Special Indicator'
      Splindicator,
      @EndUserText.label: 'Amount'
      Amount,
      @EndUserText.label: 'G/L Account'
      Glaccount,
      @EndUserText.label: 'Value Date'
      Valuedate,
      @EndUserText.label: 'Profit Center'
      Profitcenter,
      @EndUserText.label: 'Business Place'
      Businessplace,
      @EndUserText.label: 'Session Code'
      Sectioncode,
      /* Associations */
      _head : redirected to parent zc_advanceupload
}
