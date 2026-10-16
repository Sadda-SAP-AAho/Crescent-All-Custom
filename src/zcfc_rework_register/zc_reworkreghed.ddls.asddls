@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View of Rework Register- Head'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZC_REWORKREGHED
   provider contract transactional_query
  as projection on ZI_REWORKREGHED
{
@EndUserText.label: 'ID'
    key id,
    @EndUserText.label: 'Plant Code'
    plntcd,
    @EndUserText.label: 'Plant Name'
    plntnm,
    @EndUserText.label: 'Operation Code'
    oprcode,
    @EndUserText.label: 'Operation Name'
    oprname,
    @EndUserText.label: 'Report Year'
    reportyear,
    @EndUserText.label: 'Report Month'
    reportmonth,
    /* Associations */
    _Item: redirected to composition child ZC_REWORKREGITM
}

