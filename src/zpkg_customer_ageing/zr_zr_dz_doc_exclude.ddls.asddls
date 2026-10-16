@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZR & DZ Document Exclude'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_ZR_DZ_DOC_EXCLUDE as select distinct from ZR_ZR_DZ_DOC_EXCLUDE01
{
    key AccountingDocument,
    key FiscalYear,
    key CompanyCode
    
}
where invref is  initial 
union all  select distinct from I_OperationalAcctgDocItem
{
    key AccountingDocument,
    key FiscalYear,
    key CompanyCode
    
}

where  AccountingDocumentType <> 'ZR' 
and AccountingDocumentType <> 'DZ' 
and AccountingDocumentType <> 'ZV'
and FinancialAccountType =  'D'
  and SpecialGLCode        <> 'F'
