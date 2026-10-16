@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Reference'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PAYMENT_REF
as select distinct from I_OperationalAcctgDocItem
{
    key AccountingDocument,
    key FiscalYear,
    key CompanyCode,
    ClearingJournalEntry,
    ClearingJournalEntryFiscalYear,
    substring(OriginalReferenceDocument, 1, 10 ) as OriginalReferenceDocument
}
where ( AccountingDocumentType = 'DZ' or AccountingDocumentType = 'RV' )
and ClearingJournalEntry is not initial
