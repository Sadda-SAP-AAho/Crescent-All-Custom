@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View for Spl Price for Misc Work Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_SPPRMSWRKITM
  as projection on ZI_SPPRMSWRKITM
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label: 'Date From'
      Datefrom,
      @EndUserText.label: 'Date To'
      Dateto,
      @EndUserText.label: 'UoM'
      Uom,
      @EndUserText.label: 'Currency'
      Currency,
      @EndUserText.label: 'Rate'
      Rate,
      /* Associations */
      _Head : redirected to parent ZC_SPPRMSWRKHDR
}
