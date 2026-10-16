@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reference Document Master Url'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@OData.entitySet.name: 'docSet'
define view entity ZDocument_Master_Url with parameters FiscalYear : gjahr as select distinct from I_JournalEntry as a
{

key     a.AccountingDocument as ReferenceDocument
}where a.CompanyCode = '1000' and a.FiscalYear = $parameters.FiscalYear and 
(
    a.AccountingDocumentType = 'RE' 
    or a.AccountingDocumentType = 'KG'
  );
