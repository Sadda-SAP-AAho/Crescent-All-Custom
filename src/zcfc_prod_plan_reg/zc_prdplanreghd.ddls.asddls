@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View for Production Plan Reg-Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_PRDPLANREGHD
  provider contract transactional_query
  as projection on ZI_PRDPLANREGHD
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Fisyear'
      Fisyear,
      @EndUserText.label: 'Document No.'
      Docnum,
      @EndUserText.label: 'Keyid'
      Keyid,
      @EndUserText.label: 'Creon'
      Creon,
      @EndUserText.label: 'Creby'
      Creby,
      @EndUserText.label: 'Plant Code'
      Plantcode,
      @EndUserText.label: 'Plant Name'
      Plantname,
      @EndUserText.label: 'Product Group Code'
      Matgrpcode,
      @EndUserText.label: 'Product Group Name'
      Matgrpname,
      @EndUserText.label: 'Production Year'
      Prodyear,
      @EndUserText.label: 'Production Month'
      Prodmonth,
      /* Associations */
      _Item : redirected to composition child ZC_PRDPLANREGIT
}
