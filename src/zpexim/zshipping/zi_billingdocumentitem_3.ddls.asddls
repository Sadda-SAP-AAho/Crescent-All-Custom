@AbapCatalog.sqlViewName: 'ZI_BILLINGDOC3'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZI_BillingDocumentItem_2'
define view ZI_BillingDocumentItem_3
  as select from ZI_BillingDocumentItem_2
{
  key BillingDocument,
      BillingDocumentDate,
      sum( NetAmount )       as NetAmount,
      TransactionCurrency,
      PriceDetnExchangeRate,
      //      DutyDrawbackP,
      sum( DutyDrawbackV )   as DutyDrawbackV,
      sum( DutyDrawbackVfc ) as DutyDrawbackVfc,
      //      RoDTEPP,
      sum( RoDTEPV )         as RoDTEPV,
      sum( RoDTEPVfc )       as RoDTEPVfc,
      LocalCurrency
}

group by
  BillingDocument,
  BillingDocumentDate,
  TransactionCurrency,
  PriceDetnExchangeRate,
  //  DutyDrawbackP,
  //  RoDTEPP,
  LocalCurrency
