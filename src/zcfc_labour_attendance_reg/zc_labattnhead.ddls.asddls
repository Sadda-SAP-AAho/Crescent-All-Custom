@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View for Labour Attendance Register-Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_LABATTNHEAD
  provider contract transactional_query
  as projection on ZI_LABATTNHEAD
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
      @EndUserText.label: 'Report Date'
      Reportdate,
      @EndUserText.label: 'Plant Code'
      Plantcode,
      @EndUserText.label: 'Plant Name'
      Plantname,
      /* Associations */
      _Item : redirected to composition child ZC_LABATTNITEM
}
