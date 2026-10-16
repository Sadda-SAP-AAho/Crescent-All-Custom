@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Input Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_INPUTREG9
  as select distinct from I_OperationalAcctgDocItem
{
  key AccountingDocument,
  key CompanyCode,
  key FiscalYear,
  key AccountingDocumentItem as AccountingDocumentItem,
      IN_HSNOrSACCode
}
where
  IN_HSNOrSACCode is not initial
