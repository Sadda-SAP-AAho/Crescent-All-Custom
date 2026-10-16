@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View help for customer invoice'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_CUSTOMERINV
  as select from I_BillingDocument
{
  key BillingDocument,
  key AccountingDocument,
  key FiscalYear
}
union select from I_JournalEntry
{
  key AccountingDocument as BillingDocument,
  key AccountingDocument,
  key FiscalYear
}
where
  AccountingDocumentType = 'UE'
