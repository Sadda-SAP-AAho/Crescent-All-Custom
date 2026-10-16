@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Terms'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PAYMENT_TERMS as select distinct from ZR_ZMAXCASHDSC as a
inner join I_OperationalAcctgDocItem as b on a.AccountingDocument = b.AccountingDocument
and a.CompanyCode = b.CompanyCode
and a.FiscalYear = b.FiscalYear
and a.CASHDISCOUNT1DAYS = b.CashDiscount1Days
{
    key a.AccountingDocument,
    key a.FiscalYear,
    key a.CompanyCode,
    a.CASHDISCOUNT1DAYS,
    b.PaymentTerms
}
where b.PaymentTerms is not initial
