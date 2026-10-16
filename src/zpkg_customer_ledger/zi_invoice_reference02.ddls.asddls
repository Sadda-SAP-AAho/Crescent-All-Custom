@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Reference'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_INVOICE_REFERENCE02 as select from ZI_INVOICE_REFERENCE01
{
    key clnt,
    key AccountingDocument,
    key FiscalYear,
    key CompanyCode,
   
    CompanyCodeCurrency,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    sum(AmountInCompanyCodeCurrency) as amtincocurr,
    FunctionalCurrency,
    @Semantics.amount.currencyCode: 'FunctionalCurrency'
    sum(AmountInFunctionalCurrency) as amtinfuct
}
group by clnt, AccountingDocument,FiscalYear, CompanyCode, CompanyCodeCurrency, FunctionalCurrency
