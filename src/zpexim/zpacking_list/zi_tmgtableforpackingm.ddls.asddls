@EndUserText.label: 'TMG table for Packing Material Type'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_TmgTableForPackingM
  as select from ZDT_PMATTYP_TMG
  association to parent ZI_TmgTableForPackingM_S as _TmgTableForPackiAll on $projection.SingletonID = _TmgTableForPackiAll.SingletonID
{
  key PACKMATTYP as Packmattyp,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgTableForPackiAll
  
}
