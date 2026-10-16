@AbapCatalog.sqlViewName: 'ZCDS_AMT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Amount'
 define view ZCDS_INVAMT 
as select distinct from I_OperationalAcctgDocItem
{
   key CompanyCode,
   key FiscalYear,
   key AccountingDocument,
   key OriginalReferenceDocument,
       sum( AmountInTransactionCurrency ) as Amount,
       TransactionCurrency,
       DocumentDate
    
}
where FinancialAccountType = 'D' and AmountInTransactionCurrency >= 0 and
      ( AccountingDocumentType = 'DR' or AccountingDocumentType = 'DG' or AccountingDocumentType = 'RV' )
group by
AccountingDocument,
FiscalYear,
DocumentDate,
CompanyCode,
TransactionCurrency,
OriginalReferenceDocument
 