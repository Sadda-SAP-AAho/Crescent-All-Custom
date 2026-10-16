@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_11

  with parameters
    p_begin : begda,
    p_end   : endda

  as select from    ZV_COSTINGPL_13( p_begin: $parameters.p_begin, p_end: $parameters.p_end ) as a

    left outer join ZV_COSTINGPL_14( p_begin:$parameters.p_begin , p_end: $parameters.p_end ) as b on  b.FiscalPeriod = a.FiscalPeriod
                                                                                                   and b.FiscalYear   = a.FiscalYear

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
      a.Amount,
      a.InvoiceItemAmount,
      a.CalcInterest,
      division( a.Amount * a.CalcInterest, b.CalcInterest, 2 ) as CreditInterest
}
