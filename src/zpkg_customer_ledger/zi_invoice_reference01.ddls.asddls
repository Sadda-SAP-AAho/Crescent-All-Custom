@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Reference'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_INVOICE_REFERENCE01 as select distinct from ZI_INVOICE_REFERENCE as a
 inner join I_OperationalAcctgDocItem as b on b.AccountingDocument = a.InvoiceReference
 and a.InvoiceReferenceFiscalYear = b.FiscalYear
{
    key a.clnt,
    key a.AccountingDocument,
    key a.FiscalYear,
    key a.CompanyCode,
    a.InvoiceReference as paymentref,
    a.InvoiceReferenceFiscalYear as paymentrefyear,
    b.CompanyCodeCurrency,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    b.AmountInCompanyCodeCurrency,
    b.FunctionalCurrency,
    @Semantics.amount.currencyCode: 'FunctionalCurrency'
    b.AmountInFunctionalCurrency
}
