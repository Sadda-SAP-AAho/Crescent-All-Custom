@AbapCatalog.sqlViewName: 'ZCDS_ARINV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for A/R Inv F4'
define view ZCDS_ARINV_F4
  as select distinct from I_OperationalAcctgDocItem
{

      @EndUserText.label: 'A/R Invoice No'
  key OriginalReferenceDocument,
  key AccountingDocument,
  key FiscalYear,
  key DocumentDate,
  key CompanyCode,
  key TransactionCurrency,
  key Customer,
      sum(AmountInTransactionCurrency) as Amount
}
where
       FinancialAccountType        =  'D'
  and  AmountInTransactionCurrency >= 0
  and(
       AccountingDocumentType      =  'DR'
    or AccountingDocumentType      =  'DG'
    or AccountingDocumentType      =  'RV'
    or AccountingDocumentType      =  'UE'
  )
group by
  OriginalReferenceDocument,
  AccountingDocument,
  FiscalYear,
  DocumentDate,
  CompanyCode,
  TransactionCurrency,
  Customer
