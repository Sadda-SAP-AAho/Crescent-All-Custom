@AbapCatalog.sqlViewName: 'ZV_REGION'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Details For Region'
define view ZCDS_REGION
  as select from zdt_region_tmg
{
  key region                as Region,
  key regioncode            as Regioncode,
      regionname            as Regionname,
      country               as Country,
      configdeprecationcode as Configdeprecationcode,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt
}
