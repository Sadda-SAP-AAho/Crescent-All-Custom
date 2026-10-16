@AbapCatalog.sqlViewName: 'ZISHIPACC1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shipping Accumulation'
define view ZI_SHIPLICACCUMULATION
  //    as select from zdt_shipbill_lic
  as select from zex_shipbill_lic
{
  licencint,
  //  licencint
  sum( usageamount ) as ShipUsage
}

group by
//  licenceint
  licencint
