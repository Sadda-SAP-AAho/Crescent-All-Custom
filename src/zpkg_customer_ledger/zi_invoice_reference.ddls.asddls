@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Reference'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_INVOICE_REFERENCE as select from I_OperationalAcctgDocItem
{
    key $session.client as clnt,
    key AccountingDocument,
    key FiscalYear,
    key CompanyCode,
    InvoiceReference,
    InvoiceReferenceFiscalYear
}
where InvoiceReference is not initial
