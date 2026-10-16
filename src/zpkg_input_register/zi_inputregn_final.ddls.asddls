@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Input Register Final'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZI_INPUTREGN_FINAL
  as select distinct from ZR_INPUTREGN_5
{
  key CompanyCode,
  key AccountingDocumentType,
  key FiscalYear,
  key AccountingDocument,
  key AccountingDocumentItem,
  key AccountingDocumentItemType,
  key GLAccount,
      IN_GSTPartner,
      IN_HSNOrSACCode,
      Material,
      IN_GSTPlaceOfSupply,
      Plant,
      Product,
      ProfitCenter,
      PurchasingDocument,
      PurchasingDocumentItem,
      TaxItemAcctgDocItemRef,
      TransactionCurrency,
      CompanyCodeCurrency,
      TaxCode,
      TaxCodeName,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      SGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      CGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      IGST,
      Rcmstat,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      RCMSGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      RCMCGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      RCMIGST,
      TransactionTypeDetermination,
      ValuationArea,
      DebitCreditCode,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInTransactionCurrency,
      (
       cast( AmountInTransactionCurrency as abap.dec( 23,2) )  +
      coalesce( cast(SGST as abap.dec( 23,2) ), 0 ) +
      coalesce( cast(CGST as abap.dec( 23,2) ), 0 ) +
      coalesce( cast(IGST as abap.dec( 23,2) ), 0 ) +
      coalesce( cast(RCMSGST as abap.dec( 23,2) ), 0 ) +
      coalesce( cast(RCMCGST as abap.dec( 23,2) ), 0 ) +
      coalesce( cast(RCMIGST as abap.dec( 23,2) ), 0 ) ) as ttlinvvalue,
      Invoiceno,
      Invoicenoyr,
      DocumentDate as Invoicedate,
      DocumentDate,
      creationdate,
      DocumentReferenceID,
      ProductType,
      PurchaseOrderDate,
      GLAccountLongName,
      SupplierName,
      TaxNumber3,
      RegionName,
      ProductName,
      BusinessPlace,
      BusinessPlaceDescription,
      IN_GSTIdentificationNumber
}
