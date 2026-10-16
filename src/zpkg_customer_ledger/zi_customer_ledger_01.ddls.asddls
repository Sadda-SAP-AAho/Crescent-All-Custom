@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Ledger'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CUSTOMER_LEDGER_01
  as select from I_OperationalAcctgDocItem as a
{
  key a.CompanyCode,
  key a.AccountingDocument,
  key a.FiscalYear,
  key a.AccountingDocumentItem,
      case when a.AccountingDocumentType = 'DR' then left(a.OriginalReferenceDocument, 10)
           when a.AccountingDocumentType = 'RV' then a.OriginalReferenceDocument
           when a.AccountingDocumentType = 'UE' then left(a.OriginalReferenceDocument, 10)
           when a.AccountingDocumentType = 'DG' then left(a.OriginalReferenceDocument, 10)
           else '' end as arinv
}
