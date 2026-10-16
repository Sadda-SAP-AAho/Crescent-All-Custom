@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View of Special Rate Master LM - Head'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_SPLRTMSTHED
  provider contract transactional_query
  as projection on ZI_SPLRTMSTHED
{
    key Id,
    @EndUserText.label: 'Plant Code'
    Plntcd,
    @EndUserText.label: 'Plant Name'
    Plntnm,
    @EndUserText.label: 'LM Code'
    Lmcd,
    @EndUserText.label: 'LM Name'
    Lmnm,
    /* Associations */
    _Item : redirected to composition child ZC_SPLRTMSTITM
}

 