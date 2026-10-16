@AbapCatalog.sqlViewName: 'ZCDSCOL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Input Register'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_INPUTREG8
  as select from ZCDS_INPUTREG1
{
  key SourceLedger,
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key LedgerGLLineItem,
  key Ledger,
      BusinessArea,
      CompanyCodeName,
      ProfitCenter,
      Segment,
      Plant,
      DocumentDate,
      TransactionCurrency,
      GLAccount,
      GLAccountName,
      AccountingDocumentType,
      State,
      GSTIN,
      TransactionCount,
      Supplier,
      SupplierFullName,
      TaxNumber3,
      RegionName,
      ProductDescription,
      ConsumptionTaxCtrlCode,
      BaseUnit,
      quantity,
      AmountInTransactionCurrency,
      DocumentItemText,
      PostingDate,
      Pos,
      ReferenceQuantityUnit,
      TaxCode,
      CGSTRate,
      SGSTRate,
      IGSTRate,
      case when ProductGroup = 'RM01'
      then '400'
      else '000' end as Cess,
      Taxablevalue,
      ProductGroup
}
where
  State = 'DEL'
