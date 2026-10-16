@AbapCatalog.sqlViewName: 'ZISHIPACC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shipping Acc'
define view ZI_ShipAccumulation

  as select from zex_shipbill_lic
{
  licencenumber,
  sum( usageamount ) as ShipUsage
}

group by
  licencenumber
