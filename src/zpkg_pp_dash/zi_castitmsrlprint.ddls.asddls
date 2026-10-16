@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'INTERFACE VIEW FOR CASTED ITEM PRINT'
define root view entity ZI_CASTITMSRLPRINT
  as select from ZI_CONF_ORD
{
  key Shpflrno,
  key Plant,
  key Matnr,
  key Serial,
  _Head.Shpflrdt,
      cast('' as abap.char(1)) as printflag1,
      cast('' as abap.char(1)) as flag

}
