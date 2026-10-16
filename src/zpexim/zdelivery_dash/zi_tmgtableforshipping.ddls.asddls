@EndUserText.label: 'TMG table for Shipping Line'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_TmgTableForShipping
  as select from zdt_shipline_tmg
  association to parent ZI_TmgTableForShipping_S as _TmgTableForShippAll on $projection.SingletonID = _TmgTableForShippAll.SingletonID
{
  key scode     as Scode,
      sline     as Sline,
      @EndUserText.label: 'Shipping Line Name'
      slinename as Slinename,
      @EndUserText.label: 'Go Track Shipping Line'
      slinegt   as Slinegt,
      @Consumption.hidden: true
      1         as SingletonID,
      _TmgTableForShippAll

}
