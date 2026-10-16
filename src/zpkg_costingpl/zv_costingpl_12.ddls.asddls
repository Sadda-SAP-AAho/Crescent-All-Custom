@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_12

  with parameters
    p_begin : begda,
    p_end   : endda

  as select from    I_BillingDocument                                                       as a

    inner join      I_BillingDocumentItem                                                   as b  on a.BillingDocument = b.BillingDocument

    inner join      I_FiscalCalendarDate                                                    as zz on  zz.CalendarDate      = a.BillingDocumentDate
                                                                                                  and zz.FiscalYearVariant = 'V3'

    left outer join ZV_COSTINGPL_10                                                         as c  on  c.AccountingDocument = a.AccountingDocument
                                                                                                  and c.FiscalYear         = a.FiscalYear
                                                                                                  and c.CompanyCode        = a.CompanyCode

    inner join      ZV_COSTINGPL_9( p_begin: $parameters.p_begin, p_end: $parameters.p_end) as p  on  p.FiscalPeriod = zz.FiscalPeriod
                                                                                                  and p.FiscalYear   = zz.FiscalYear

    left outer join ZCDS_SALES5                                                             as k  on  k.BillingDocument     = b.BillingDocument
                                                                                                  and k.BillingDocumentItem = b.BillingDocumentItem

    left outer join ZV_COSTINGPL_37                                                         as l  on  l.ReferenceSDDocument     = b.BillingDocument
                                                                                                  and l.ReferenceSDDocumentItem = b.BillingDocumentItem

{

  key a.BillingDocument,
  key b.BillingDocumentItem,
      a.TransactionCurrency,
      a.BillingDocumentDate,
      a.AccountingDocument,
      a.FiscalYear,
      zz.FiscalPeriod,
      c.NetDueDate,
      case when dats_days_between( a.BillingDocumentDate, c.NetDueDate ) < 0 then 0
      else dats_days_between( a.BillingDocumentDate, c.NetDueDate ) end                      as CreditDays,
      p.Amount,
      cast( cast( k.sum_a as abap.dec(23,2) ) * a.AccountingExchangeRate as abap.dec(23,2) ) as InvoiceItemAmount,
      case when l.CustomerReturn is not initial then 'X' else '' end                         as ZReturn
}

where
      a.AccountingDocument  is not initial
  and a.BillingDocumentDate >= $parameters.p_begin
  and a.BillingDocumentDate <= $parameters.p_end
