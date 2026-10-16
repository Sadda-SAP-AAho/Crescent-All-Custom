@AbapCatalog.sqlViewName: 'ZVDOCITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Document item'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_SERV_DocItem
  as select from I_OperationalAcctgDocItem
{
  key CompanyCode,
  key AccountingDocument,
  key FiscalYear,
  key AccountingDocumentItem,
      Customer,
      TaxItemAcctgDocItemRef,
      DocumentItemText,
      IN_HSNOrSACCode,
      TransactionCurrency,
      AmountInTransactionCurrency,
      AccountingDocumentItemType,
      FinancialAccountType

}
//where Customer is not initial
 