@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Reference'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PAYMENT_REF01
as select distinct from ZR_PAYMENT_REF as a
{
 key $session.client as clnt,
    key a.AccountingDocument,
    key a.FiscalYear,
    key a.CompanyCode,
    a.ClearingJournalEntry,
    a.ClearingJournalEntryFiscalYear,
    a.OriginalReferenceDocument
}
where a.AccountingDocument <> a.ClearingJournalEntry
