@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'TIM Reco Register-Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_TIMRECOREGHD
  provider contract transactional_query
  as projection on ZI_TIMRECOREGHD
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
      @EndUserText.label: 'Remittance Advice No'
      Remadvno,
      @EndUserText.label: 'Date'
      Entrydate,
      @EndUserText.label: 'Remarks'
      Remarks,
      /* Associations */
      _Item : redirected to composition child ZC_TIMRECOREGIT
}
