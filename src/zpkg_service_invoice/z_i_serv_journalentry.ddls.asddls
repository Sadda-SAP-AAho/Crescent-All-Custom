@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Service Journal Entry'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_SERV_JOURNALENTRY
  as select from ZV_SERV_journalentry
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
