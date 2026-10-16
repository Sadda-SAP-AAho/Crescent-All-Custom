@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GL wise Journal Entry Total Amt Comparison'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_GLWISEJETTLAMT
  provider contract transactional_query
  as projection on ZI_GLWISEJETTLAMT
{
      
      @UI.hidden: true
  key FiscalYear,
      @EndUserText.label: 'JE No'
      @Search.defaultSearchElement: true
  key JE_No,
      @EndUserText.label: 'Posting Date'
      PostingDate,
      @EndUserText.label: 'Set-1 Value'
      Set_1_Val,
      @EndUserText.label: 'Set-2 Value'
      Set_2_Val,
      @EndUserText.label: 'Value Difference'
      Val_Diff
}
