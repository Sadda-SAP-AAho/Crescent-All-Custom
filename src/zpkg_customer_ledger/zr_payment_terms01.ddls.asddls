@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Terms'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PAYMENT_TERMS01 as select from ZR_PAYMENT_TERMS
{

    key AccountingDocument,
    key FiscalYear,
    key CompanyCode,
    CASHDISCOUNT1DAYS,
    max(PaymentTerms) as paymentterms
}
group by  AccountingDocument,
    FiscalYear,
    CompanyCode,
    CASHDISCOUNT1DAYS
