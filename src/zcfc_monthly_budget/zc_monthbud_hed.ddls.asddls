@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Monthly Budget-Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_MONTHBUD_HED
  provider contract transactional_query
  as projection on ZI_MONTHBUD_HED
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Keyid'
      Keyid,
      @EndUserText.label: 'Creon'
      Creon,
      @EndUserText.label: 'Creby'
      Creby,
      @EndUserText.label: 'Budget Code'
      Budgetcode,
      @EndUserText.label: 'Budget Name'
      Budgetname,
      @EndUserText.label: 'Fiscal Year'
      Fiscalyear,
      @EndUserText.label: 'Currency'
      Currency,
      /* Associations */
      _Item : redirected to composition child ZC_MONTHBUD_ITM

}
