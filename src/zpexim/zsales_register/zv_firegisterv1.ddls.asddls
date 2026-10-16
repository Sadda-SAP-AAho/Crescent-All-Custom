@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FI REGISTER'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZV_FIREGISTERV1

  as select from    I_JournalEntry            as a

    inner join      I_OperationalAcctgDocItem as b  on  b.AccountingDocument = a.AccountingDocument
                                                    and b.FiscalYear         = a.FiscalYear
                                                    and b.CompanyCode        = a.CompanyCode

    inner join      I_Customer                as cc on b.Customer = cc.Customer

    left outer join I_IN_ElectronicDocInvoice as g  on  g.ElectronicDocSourceType = 'FI_INVOICE'
                                                    and g.IN_EDocEInvcExtNmbr     = a.DocumentReferenceID

    left outer join I_RegionText              as ce on  ce.Region   = cc.Region
                                                    and ce.Country  = cc.Country
                                                    and ce.Language = $session.system_language

    inner join      ZV_FIREGISTERV2           as c  on  c.AccountingDocument = a.AccountingDocument
                                                    and c.FiscalYear         = a.FiscalYear
                                                    and c.CompanyCode        = a.CompanyCode

    inner join      ZV_FIREGTBL4              as gg on  gg.AccountingDocument = a.AccountingDocument
                                                    and gg.FiscalYear         = a.FiscalYear
                                                    and gg.CompanyCode        = a.CompanyCode

    left outer join ZV_FIREGISTERV3           as d  on  d.GSTInvoiceNo                 = a.AccountingDocument
                                                    and d.FiscalYear                   = a.FiscalYear
                                                    and d.CompanyCode                  = a.CompanyCode
                                                    and d.TransactionTypeDetermination = 'JOI'

    left outer join ZV_FIREGISTERV3           as e  on  e.GSTInvoiceNo                 = a.AccountingDocument
                                                    and e.FiscalYear                   = a.FiscalYear
                                                    and e.CompanyCode                  = a.CompanyCode
                                                    and e.TransactionTypeDetermination = 'JOS'

    left outer join ZV_FIREGISTERV3           as f  on  f.GSTInvoiceNo                 = a.AccountingDocument
                                                    and f.FiscalYear                   = a.FiscalYear
                                                    and f.CompanyCode                  = a.CompanyCode
                                                    and f.TransactionTypeDetermination = 'JOC'

{

  key a.AccountingDocument                                                                                     as GSTInvoiceNo,
  key a.FiscalYear,
  key a.CompanyCode,
  key b.AccountingDocumentItem,
      a.AccountingDocumentType,
      a.PostingDate,
      a.DocumentReferenceID                                                                                    as CommercialInvoiceNo,
      a.TransactionCurrency,
      a.AbsoluteExchangeRate,
      b.PaymentTerms,
      c.GLAccount,
      c.GLAccountName,
      b.Customer,
      c.IN_HSNOrSACCode,
      gg.Description                                                                                           as DocumentItemText,
      ''                                                                                                       as AssignmentReference,
      cc.CustomerName                                                                                          as BPName,
      cc.TaxNumber3                                                                                            as GSTInNo,
      substring( cc.TaxNumber3, 3, 10 )                                                                        as PANNo,
      ce.RegionName                                                                                            as StateName,
      abs( c.Amount )                                                                                          as AmountinDC,
      abs( case when a.TransactionCurrency <> 'INR' then c.Amount * a.AbsoluteExchangeRate else c.Amount end ) as AmountinLC,
      abs( case when a.TransactionCurrency <> 'INR' then d.Amount * a.AbsoluteExchangeRate else d.Amount end ) as IGST,
      abs( case when a.TransactionCurrency <> 'INR' then e.Amount * a.AbsoluteExchangeRate else e.Amount end ) as SGST,
      abs( case when a.TransactionCurrency <> 'INR' then f.Amount * a.AbsoluteExchangeRate else f.Amount end ) as CGST,
      g.ElectronicDocUUID,
      g.IN_ElectronicDocInvcRefNmbr,
      g.IN_EDocEInvcEWbillNmbr
}

where
  (
        a.AccountingDocumentType = 'DR'
    or  a.AccountingDocumentType = 'DG'
  )

  and   b.Customer               is not initial

  and(
        a.IsReversal             = ''
    and a.IsReversed             = ''
  )
