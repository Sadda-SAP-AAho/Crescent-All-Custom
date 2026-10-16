@AbapCatalog.sqlViewName: 'ZIBOEACC1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOE Accumulation'
define view ZI_BOELICACCUMULATION
  as select from zdt_boe_lic
{
  licenceint,

  sum( usageamount ) as BOEUsage
}

group by
  licenceint
