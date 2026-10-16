@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_23
  as select from ZV_COSTINGPL_22
{
  key AccountingDocument,
  key CompanyCode,
  key FiscalYear,
  key AccountingDocumentItem,
  GLAccount
}
