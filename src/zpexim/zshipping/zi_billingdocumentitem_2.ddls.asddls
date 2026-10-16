@AbapCatalog.sqlViewName: 'ZI_BILLINGDOC2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZI_BillingDocumentItem'
define view ZI_BillingDocumentItem_2

  as select from    ZI_BillingDocumentItem      as a

    inner join      I_BillingDocumentBasic      as b on b.BillingDocument = a.BillingDocument

    inner join      I_BillingDocumentBasicStdVH as c on c.BillingDocument = a.BillingDocument

    left outer join ZI_BillingDPricing_3        as d on  d.BillingDocument     = a.BillingDocument
                                                     and d.BillingDocumentItem = a.BillingDocumentItem

{
  key a.BillingDocument,
  key a.BillingDocumentItem,
      b.BillingDocumentDate,
      a.NetAmount,
      b.TransactionCurrency,
      //////      a.PriceDetnExchangeRate,  " Exchnage rate comes form Header not Item
      b.AccountingExchangeRate                                       as PriceDetnExchangeRate,
      d.ZDTB_R                                                       as DutyDrawbackP,
      cast( d.ZDTB_V * a.PriceDetnExchangeRate as abap.curr(15,2) )  as DutyDrawbackV,
      cast( d.ZDTB_V as abap.curr(15,2) )                            as DutyDrawbackVfc,
      d.ZROD_R                                                       as RoDTEPP,
      cast( d.ZROD_V * a.PriceDetnExchangeRate  as abap.curr(15,2) ) as RoDTEPV,
      cast( d.ZROD_V  as abap.curr(15,2) )                           as RoDTEPVfc,
      'INR'                                                          as LocalCurrency
}
