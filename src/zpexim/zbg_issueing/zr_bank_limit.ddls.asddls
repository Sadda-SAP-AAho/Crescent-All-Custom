@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS for Bank Limit'
define root view entity ZR_BANK_LIMIT
  as select distinct from zexim_lcim_bnk1  as a
    left outer join       ZR_BGUTILIZE_AMT as b on  a.hbkid = b.hbkid
                                                and a.hktid = b.hktid
{

  key a.bukrs                 as Bukrs,
  key a.hbkid                 as Hbkid,
  key a.hktid                 as Hktid,
      a.bglimit               as Bglimit,
      b.bgassignamt           as Bgutilised,
      case when  b.bgassignamt > 0
           then ( a.bglimit  - b.bgassignamt )
           else a.bglimit end as Bgavailable
}
