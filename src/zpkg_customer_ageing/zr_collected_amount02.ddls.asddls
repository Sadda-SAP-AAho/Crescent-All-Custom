@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Collected Amount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_COLLECTED_AMOUNT02 as select from ZR_COLLECTED_AMOUNT01
{
    key InvoiceReference,
    key InvoiceReferenceFiscalYear,
    key CompanyCode,
    CompanyCodeCurrency,
    TransactionCurrency,
//    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    sum(AmountInCompanyCodeCurrency ) as AmountInCompanyCodeCurrency ,
//     @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(AmountInTransactionCurrency ) as AmountInTransactionCurrency 
}
group by   InvoiceReference,
     InvoiceReferenceFiscalYear,
     CompanyCode,
    CompanyCodeCurrency,
    TransactionCurrency
