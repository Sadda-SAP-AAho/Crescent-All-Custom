@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Input Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_INPUTREG10
  as select distinct from I_JournalEntryItem
{
  key AccountingDocument,
  key FiscalYear,
  key CompanyCode,
  key AccountingDocumentItem,
      ReferenceDocument,
      ReferenceDocumentItem
}
where
      ReferenceDocument is not initial
  and Ledger            = '0L'
  and AccountingDocumentType = 'RE'
