@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_10

  as select from I_OperationalAcctgDocItem as a

{

  key a.CompanyCode,
  key a.AccountingDocument,
  key a.FiscalYear,
      max( NetDueDate ) as NetDueDate
}

where
  (
       AccountingDocumentType = 'DG'
    or AccountingDocumentType = 'DR'
    or AccountingDocumentType = 'RV'
  )

group by
  a.CompanyCode,
  a.AccountingDocument,
  a.FiscalYear
