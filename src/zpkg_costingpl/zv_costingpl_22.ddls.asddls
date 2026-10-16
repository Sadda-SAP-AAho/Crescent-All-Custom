@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_22

  as select from I_OperationalAcctgDocItem as a

{
  key a.AccountingDocument,
  key a.CompanyCode,
  key a.FiscalYear,
  key a.AccountingDocumentItem,
      a.GLAccount
}

where
  a.GLAccount like '%36%'
