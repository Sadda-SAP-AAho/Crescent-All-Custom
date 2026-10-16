@EndUserText.label: 'TMG Table Labour Category'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgTableLabourCateg
  as select from ZDT_LABRCATG_N
  association to parent ZI_TmgTableLabourCateg_S as _TmgTableLabourCaAll on $projection.SingletonID = _TmgTableLabourCaAll.SingletonID
{
  key CATCODE as Catcode,
  CATNAME as Catname,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgTableLabourCaAll
  
}
