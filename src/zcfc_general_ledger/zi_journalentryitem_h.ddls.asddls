@AbapCatalog.sqlViewName: 'ZJRNITEMH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Entry Item Helper'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_JournalEntryItem_H
  as select from I_JournalEntryItem
{
  ReferenceDocument,
  substring( ReferenceDocumentItem, 3,4) as RefDocItem4,
  GLAccount,
  AccountingDocument,
  FiscalYear
}
