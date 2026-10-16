@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZR & DZ Document Exclude'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_ZR_DZ_DOC_EXCLUDE01 as select distinct from I_OperationalAcctgDocItem
{
    key AccountingDocument,
    key FiscalYear,
    key CompanyCode,
    max( InvoiceReference ) as invref
}

where ( AccountingDocumentType = 'ZR' or AccountingDocumentType = 'DZ' or  AccountingDocumentType = 'ZV' )
and FinancialAccountType =  'D'
  and SpecialGLCode        <> 'F'
group by AccountingDocument , CompanyCode , FiscalYear

