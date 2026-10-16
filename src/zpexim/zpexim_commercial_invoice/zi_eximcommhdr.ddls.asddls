@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Commercial Invoice Header'
define root view entity ZI_EXIMCOMMHDR

  as select from zexim_comm_hdr

  composition [0..*] of ZI_EXIMCOMMCUS as _cus

  composition [0..*] of ZI_EXIMCOMMPAY as _pay

  composition [0..*] of ZI_EXIMCOMMSHP as _shp

  composition [0..*] of ZI_EXIMCOMMADD as _add

  composition [0..*] of ZI_EXIMCOMMCNH as _cnh

  composition [0..*] of ZI_EXIMCOMMCNI as _cni

  composition [0..*] of ZI_EXIMCOMMITM as _itm

{

  key id                    as Id,
      invclubnointernal     as Invclubnointernal,
      invclubnoexternal     as Invclubnoexternal,
      invclubnodate         as Invclubnodate,
      invcommdate           as Invcommdate,
      invcommuser           as Invcommuser,
      invcommtime           as Invcommtime,
      dateofdischarge       as Dateofdischarge,
      @Semantics.amount.currencyCode: 'fobcurrency'
      fobamount,
      fobcurrency,
      deleted               as Deleted,
      released              as Released,
      tprint                as Tprint,
      status                as Status,
      local_created_by      as LocalCreatedBy,
      local_created_at      as LocalCreatedAt,
      local_last_changed_by as LocalLastChangedBy,
      local_last_changed_at as LocalLastChangedAt,
      last_changed_at       as LastChangedAt,

      _cus,
      _pay,
      _shp,
      _add,
      _cnh,
      _cni,
      _itm

}
