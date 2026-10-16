@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Input Register_5'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_INPUTREGN_5
  as select from ZR_INPUTREGN_3
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
      SGST * SGSTRatio                                   as SGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      CGST * CGSTRatio                                   as CGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      IGST * IGSTRatio                                   as IGST,
      Rcmstat,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      RCMSGST * SGSTRatio                                as RCMSGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      RCMCGST * CGSTRatio                                as RCMCGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      RCMIGST * IGSTRatio                                as RCMIGST,
      TransactionTypeDetermination,
      ValuationArea,
      DebitCreditCode,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInTransactionCurrency,
      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      (
       cast( AmountInTransactionCurrency as abap.dec( 23,2) )  +
      coalesce( cast(SGST as abap.dec( 23,2) ), 0 ) +
      coalesce( cast(CGST as abap.dec( 23,2) ), 0 ) +
      coalesce( cast(IGST as abap.dec( 23,2) ), 0 ) +
      coalesce( cast(RCMSGST as abap.dec( 23,2) ), 0 ) +
      coalesce( cast(RCMCGST as abap.dec( 23,2) ), 0 ) +
      coalesce( cast(RCMIGST as abap.dec( 23,2) ), 0 ) ) as Totalinvval,
      Invoiceno,
      Invoicenoyr,
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
