@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@EndUserText.label: 'F4 for Document Number'
define view entity ZR_DOC_F4 
as select from I_OperationalAcctgDocItem
{
    key CompanyCode,
    key Customer,
    key AccountingDocument,
    key AccountingDocumentItem,
    key FiscalYear,
    key PaymentTerms,
    key AccountingDocumentType,
    key DocumentDate,
    key OriginalReferenceDocument
}
where FinancialAccountType = 'D' and
      ( AccountingDocumentType = 'DR' or AccountingDocumentType = 'RV' ) and
      ClearingJournalEntry is initial and AmountInTransactionCurrency > 0
group by
CompanyCode,
AccountingDocument,
AccountingDocumentItem,
FiscalYear,
PaymentTerms,
Customer,
AccountingDocumentType,
DocumentDate,
OriginalReferenceDocument


