@AbapCatalog.sqlViewName: 'ZVVJOURNAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for PR Item'
define view ZV_SERV_journalentry
  as select from I_JournalEntry
{
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
      AccountingDocumentType,
      DocumentDate,
      PostingDate,
      FiscalPeriod,
      AccountingDocumentCreationDate,
      DocumentReferenceID,
      Branch,
      TransactionCurrency
}

where
  AccountingDocumentType = 'DR'
