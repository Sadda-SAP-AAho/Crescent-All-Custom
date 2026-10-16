@AbapCatalog.sqlViewName: 'ZS_CCPLANT'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD Details Of Plant & Company'
@AbapCatalog.preserveKey: true

define view ZCDS_CCPLANT_SD
  as select from zdt_sd_pc_tmg
{
  key cocode                as Cocode,
  key plant                 as Plant,
      name                  as Name,
      tin                   as Tin,
      cinno                 as Cinno,
      panno                 as Panno,
      gstin                 as Gstin,
      iec                   as Iec,
      plantaddr1            as Plantaddr1,
      plantaddr2            as Plantaddr2,
      plantaddr3            as Plantaddr3,
      cemail                as Cemail,
      cmobile               as Cmobile,
      plantname             as Plantname,
      caddress1             as Caddress1,
      caddress2             as Caddress2,
      caddress3             as Caddress3,
      telnumber1            as Telnumber1,
      telnumber2            as Telnumber2,
      tel_number3           as TelNumber3,
      var6                  as Var6,
      var1                  as Var1,
      var2                  as Var2,
      var3                  as Var3,
      var4                  as Var4,
      configdeprecationcode as Configdeprecationcode,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt
}
