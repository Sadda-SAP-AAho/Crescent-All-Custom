@EndUserText.label: 'TMG Table for Selling Expense Master'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgTableForSellingE
  as select from ZDT_SELLEXPMSTR
  association to parent ZI_TmgTableForSellingE_S as _TmgTableForSelliAll on $projection.SingletonID = _TmgTableForSelliAll.SingletonID
{
  key EXPCODE as Expcode,
  EXPNAME as Expname,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgTableForSelliAll
  
}
