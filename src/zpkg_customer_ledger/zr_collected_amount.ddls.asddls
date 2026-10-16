@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Collected Amount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_COLLECTED_AMOUNT as select distinct from I_OperationalAcctgDocItem
{
    key AccountingDocument,
    key FiscalYear,
    key CompanyCode,
    CompanyCodeCurrency,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    AmountInCompanyCodeCurrency
}
where GLAccount like '001%' and ( AccountingDocumentType = 'ZR' or AccountingDocumentType = 'DZ' )
and FinancialAccountType = 'D'
and DebitCreditCode = 'H'
and InvoiceReference is not initial
