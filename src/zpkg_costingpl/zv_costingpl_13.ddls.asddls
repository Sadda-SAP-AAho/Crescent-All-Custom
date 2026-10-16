@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_13

  with parameters
    p_begin : begda,
    p_end   : endda

  as select from ZV_COSTINGPL_12( p_begin: $parameters.p_begin, p_end: $parameters.p_end ) as a

{
  key a.BillingDocument,
  key a.BillingDocumentItem,
      a.TransactionCurrency,
      a.BillingDocumentDate,
      a.AccountingDocument,
      a.FiscalYear,
      a.FiscalPeriod,
      a.NetDueDate,
      a.CreditDays,
      cast( a.Amount as abap.dec(15,2) )            as Amount,
      cast( a.InvoiceItemAmount as abap.dec(15,2) ) as InvoiceItemAmount,
      cast( case when a.TransactionCurrency = 'INR'
      then division( 9 * a.CreditDays * a.InvoiceItemAmount, 365, 2 )
      else division( 6 * a.CreditDays * a.InvoiceItemAmount, 365, 2 )
      end as abap.dec(15,5) )                       as CalcInterest
}

where
  ZReturn = ''
