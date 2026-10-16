@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BG Utilization Amount'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_BGUTILIZE_AMT
  as select from zdt_imbg_hed as a
  //  inner join zexim_lcim_bnk1 as b on a.hbkid = b.hbkid and a.hktid = b.hktid and a.companycode = b.bukrs
  //composition of target_data_source_name as _association_name
{
  key a.companycode,
  key a.hbkid,
  key a.hktid,
      coalesce( cast( sum( bgcleanassign ) as abap.dec( 23, 2) ),0) as bgassignamt
}
where
      bgstat      = 'OPEN'
  and bgcharacter = 'LIMIT BASE'
group by
  companycode,
  hbkid,
  hktid
