@EndUserText.label: 'TMG table for Labour Category'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgTableForLabCat
  as select from zdt_labrcatg
  association to parent ZI_TmgTableForLabCat_S as _TmgTableForLabCatAll on $projection.SingletonID = _TmgTableForLabCatAll.SingletonID
{
  key catcode as Catcode,
      catname as Catname,
      @Consumption.hidden: true
      1       as SingletonID,
      _TmgTableForLabCatAll
}
