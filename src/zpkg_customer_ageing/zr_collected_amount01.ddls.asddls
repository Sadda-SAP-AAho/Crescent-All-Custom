@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Collected Amount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_COLLECTED_AMOUNT01 as select from I_OperationalAcctgDocItem
{
    key InvoiceReference,
    key InvoiceReferenceFiscalYear,
    key CompanyCode,
    CompanyCodeCurrency,
    TransactionCurrency,
//    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    cast(AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) ) as AmountInCompanyCodeCurrency,
//     @Semantics.amount.currencyCode: 'TransactionCurrency'
    cast( AmountInTransactionCurrency as abap.dec( 23, 2 ) ) as AmountInTransactionCurrency
}
where     FinancialAccountType =  'D'
  and SpecialGLCode        <> 'F'
  and InvoiceReference is not initial
