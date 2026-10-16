@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Views for Final Packing List Header'
define root view entity zi_finalpack_hdr
  as select from zdt_finlpack_hdr
  composition [0..*] of zi_finalpack_itm as _Item
  composition [0..*] of ZI_FPLPRINTFIELD as _Item1
{
  key id          as Id,
      packinglist as Packinglist,
      comm_inv    as comm_inv,
      salesorg    as Salesorg,
      plant       as Plant,
      createdby   as Createdby,
      createdon   as Createdon,
      createdat   as Createdat,
      changeddby  as Changeddby,
      changedon   as Changedon,
      changedat   as Changedat,
      canind      as Canind,
      cancelby    as Cancelby,
      cancelon    as Cancelon,
      status      as Status,
      cancel      as Cancel,
      prnt        as Prnt,
      dprint      as Dprint,
      'X'         as updateitem,
      remarks     as Remarks,
      custfrght   as Custfrght,
      _Item,
      _Item1
}
