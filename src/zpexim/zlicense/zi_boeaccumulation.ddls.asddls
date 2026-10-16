@AbapCatalog.sqlViewName: 'ZIBOEACC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOE Accumulation'
define view ZI_BOEAccumulation

  as select from zim_boe_lic
{
  licencenumber,
  sum( usageamount ) as BOEUsage
}

group by
  licencenumber
