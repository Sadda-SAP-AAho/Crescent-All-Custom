@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Debtors Report'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZI_FI_DEBTOR_RPT
  as select from    I_OperationalAcctgDocItem    as a

    left outer join I_JournalEntry               as b on  b.CompanyCode        = a.CompanyCode
                                                      and b.FiscalYear         = a.FiscalYear
                                                      and b.AccountingDocument = a.AccountingDocument

    left outer join I_AccountingDocumentTypeText as c on  c.Language               = $session.system_language
                                                      and c.AccountingDocumentType = b.AccountingDocumentType

{
  key a.CompanyCode,
  key a.AccountingDocument,
  key a.FiscalYear,
  key a.AccountingDocumentItem,
      a.AssignmentReference,
      b.DocumentReferenceID,

      case when a.AccountingDocumentType = 'DR' then left(a.OriginalReferenceDocument, 10)
           when a.AccountingDocumentType = 'RV' then a.OriginalReferenceDocument
           when a.AccountingDocumentType = 'UE' then left(a.OriginalReferenceDocument, 10)
           when a.AccountingDocumentType = 'DG' then left(a.OriginalReferenceDocument, 10)
           else '' end                                      as arinv,

      a.DocumentDate,
      a.TransactionCurrency,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast( case when a.TransactionCurrency <> 'JPY' then a.AbsoluteAmountInTransacCrcy
                 else a.AmountInTransactionCurrency * 100 end
      as abap.dec(23,2))                                    as AbsoluteAmountInTransacCrcy,
      a.Customer,
      a.ClearingJournalEntry,
      a.ClearingDate,
      a.NetDueDate,
      a.BusinessPlace,
      cast(a.AmountInCompanyCodeCurrency as abap.dec(23,2)) as AmountInCompanyCodeCurrency,
      cast( case when a.TransactionCurrency <> 'JPY' then a.AmountInTransactionCurrency
                 else a.AmountInTransactionCurrency * 100 end
      as abap.dec(23,2))                                    as AmountInTransactionCurrency,
      b.EffectiveExchangeRate                               as AbsoluteExchangeRate,
      b.AccountingDocumentType,
      c.AccountingDocumentTypeName,
      a.DocumentItemText
}

where
  (
       a.AccountingDocumentType    = 'DR'
    or a.AccountingDocumentType    = 'RV'
    or a.AccountingDocumentType    = 'UE'
    or a.AccountingDocumentType    = 'DG'
  )
  and  a.OriginalReferenceDocument is not initial
  and  a.FinancialAccountType      = 'D'
  and  a.SpecialGLCode             = ''
