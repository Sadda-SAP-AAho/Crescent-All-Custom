@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Entry Sales'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_JOURNALENTRY_SALES
  as select from I_JournalEntry
{
  key  CompanyCode,
  key  FiscalYear,
  key  AccountingDocument,
       OriginalReferenceDocument

}

where
      IsReversal             = ''
  and AccountingDocumentType = 'RV'
