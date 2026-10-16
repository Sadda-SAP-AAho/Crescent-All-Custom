@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View for Spl Price for Misc Work Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_SPPRMSWRKHDR
  provider contract transactional_query
  as projection on ZI_SPPRMSWRKHDR
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Plant Code'
      Plantcode,
      @EndUserText.label: 'Plant Name'
      Plantname,
      @EndUserText.label: 'Work Code'
      Workcode,
      @EndUserText.label: 'Work Name'
      Workname,
      /* Associations */
      _Item : redirected to composition child ZC_SPPRMSWRKITM
}
