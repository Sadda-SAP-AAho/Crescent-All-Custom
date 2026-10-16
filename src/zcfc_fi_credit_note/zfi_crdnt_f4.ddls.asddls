@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 help for credit note'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@OData.entitySet.name: 'docHelpSet'
define view entity ZFI_CRDNT_F4

  with parameters
    FiscalYear : gjahr
  as select distinct from I_JournalEntry as a
{

  key     a.AccountingDocument as ReferenceDocument
}
where
      a.CompanyCode            = '1000'
  and a.FiscalYear             = $parameters.FiscalYear
  and(
      a.AccountingDocumentType = 'DG'
  );
