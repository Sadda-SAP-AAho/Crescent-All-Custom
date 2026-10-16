@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View for Labour Booking Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_LABBKREGHEAD
  provider contract transactional_query
  as projection on ZI_LABBKREGHEAD
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Fisyear'
      Fisyear,
      @EndUserText.label: 'Old Document No.'
      Docnum,
      @UI.hidden: true
      Keyid,
      @UI.hidden: true
      NewKeyid,
      @EndUserText.label: 'New Document No.'
      NewDocnum,
      @EndUserText.label: 'Creon'
      Creon,
      @EndUserText.label: 'Creby'
      Creby,
      @EndUserText.label: 'Report Date'
      Rptdate,
      @EndUserText.label: 'Plant Code'
      Plantcode,
      @EndUserText.label: 'Plant Name'
      Plantname,
      @EndUserText.label: 'Cost Center Code'
      Costcode,
      @EndUserText.label: 'Cost Center Name'
      Costname,
      @EndUserText.label: 'Contractor Code'
      Contcode,
      @EndUserText.label: 'Contractor Name'
      Contname,
      @EndUserText.label: 'Operation Code'
      Oprcode,
      @EndUserText.label: 'Operation Name'
      Oprname,
      /* Associations */
      _Item : redirected to composition child ZC_LABBKREGITEM
}
