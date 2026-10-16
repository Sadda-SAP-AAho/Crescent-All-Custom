@EndUserText.label: 'IMBG Category for TMG'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_ImbgCategoryForTmg
  as select from zdt_imbgcategory
  association to parent ZI_ImbgCategoryForTmg_S as _ImbgCategoryForTAll on $projection.SingletonID = _ImbgCategoryForTAll.SingletonID
{
      @EndUserText.label: 'BG Category'
  key bgcatag as Bgcatag,
      @Consumption.hidden: true
      1       as SingletonID,
      _ImbgCategoryForTAll

}
