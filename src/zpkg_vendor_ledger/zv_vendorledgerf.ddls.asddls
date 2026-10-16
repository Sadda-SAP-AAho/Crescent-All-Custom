@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Ledger Final Consumption View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZV_VENDORLEDGERF

  with parameters
    @EndUserText.label: 'From Date'
    p_begda : datum,
    @EndUserText.label: 'To Date'
    p_endda : datum

  as select from ZV_VENDORLEDGER04( p_begda: $parameters.p_begda, p_endda: $parameters.p_endda )
{

          @EndUserText.label: 'Accounting Document No.'
  key     AccountingDocument,
          @EndUserText.label: 'Company Code'
  key     CompanyCode,
          @EndUserText.label: 'Fiscal Year'
  key     FiscalYear,
          @EndUserText.label: 'Accounting Document Item'
  key     AccountingDocumentItem,
          @EndUserText.label: 'Supplier Code'
  key     Supplier,
          @EndUserText.label: 'Sort Code'
  key     SortCode,
          @EndUserText.label: 'Posting Date'
          PostingDate,
          @EndUserText.label: 'Document Date'
          DocumentDate,          
          @EndUserText.label: 'Due Date'
          BaseLineDate,
          @EndUserText.label: 'Supplier Name'
          SupplierName,
          @EndUserText.label: 'Accounting Document Type'
          AccountingDocumentType,
          @EndUserText.label: 'Accounting Document Type Desc.'
          AccountingDocumentTypeName,
          @EndUserText.label: 'Profit Center'
          ProfitCenter,
          @EndUserText.label: 'Special G/L Code'
          SpecialGLCode,
          @EndUserText.label: 'Clearing Accounting Document'
          ClearingAccountingDocument,
          @EndUserText.label: 'Clearing Date'
          ClearingDate,
          @EndUserText.label: 'Clearing Status'
          ClearingStatus,
          @EndUserText.label: 'Reference'
          Reference,
          @EndUserText.label: 'Assignment Reference'
          AssignmentReference,
          @EndUserText.label: 'Document Item Text'
          DocumentItemText,
          @EndUserText.label: 'Purchasing Document'
          PurchasingDocument,
          @EndUserText.label: 'Offsetting Account'
          OffsettingAccount,
          @EndUserText.label: 'Reference Document'
          ReferenceDocument,
          @EndUserText.label: 'Debit/Credit Code'
          DebitCreditCode,
          @EndUserText.label: 'Tax Code'
          TaxCode,
          @EndUserText.label: 'Creation Date'
          CreationDate,
          @EndUserText.label: 'Created By'
          AccountingDocCreatedByUser,
          @EndUserText.label: 'CC Currency'
          CompanyCodeCurrency,
          @EndUserText.label: 'Amount(CC)'
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
          AmountInCompanyCodeCurrency,
          @EndUserText.label: 'Amount(CC)'
          TransactionCurrency,
          @EndUserText.label: 'Amount(DC)'
          @Semantics.amount.currencyCode: 'TransactionCurrency'
          AmountInTransactionCurrency,
          @EndUserText.label: 'Debit Amount(CC)'
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
          DebitAmountInCoCodeCrcy,
          @EndUserText.label: 'Credit Amount(CC)'
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
          abs( CreditAmountInCoCodeCrcy ) as CreditAmountInCoCodeCrcy,
          @EndUserText.label: 'Balance Amount(CC)'
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
          BalanceDueCoCodeCrcy,
          @EndUserText.label: 'Debit Amount(DC)'
          @Semantics.amount.currencyCode: 'TransactionCurrency'
          DebitAmountInTransCrcy,
          @EndUserText.label: 'Credit Amount(DC)'
          @Semantics.amount.currencyCode: 'TransactionCurrency'
          abs( CreditAmountInTransCrcy )  as CreditAmountInTransCrcy,
          @EndUserText.label: 'Balance Amount(DC)'
          @Semantics.amount.currencyCode: 'TransactionCurrency'
          BalanceDueTransCrcy


}
