@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Management Dashboard-Open Order'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_MGMTOPNORDR
  provider contract transactional_query
  as projection on ZI_MGMTOPNORDR
{

      @EndUserText.label: 'Plant'
      @Search.defaultSearchElement: true
  key Plant,
      @EndUserText.label: 'Profit Center'
      @Search.defaultSearchElement: true
  key ProfitCenter,
      @EndUserText.label: 'Open Oredr Balance Weight'
      Open_Order_WT,
      @EndUserText.label: 'Open Oredr Balance Value'
      Open_Order_Val
}
