@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_FIREGISTERV5

  as select from I_OperationalAcctgDocItem
{
  key $session.client as clients,
  key CompanyCode,
  key AccountingDocument,
  key FiscalYear,
  key AccountingDocumentItem,
      AssignmentReference
}

where
       Customer               is initial
  and  AssignmentReference    is not initial
  and(
       AccountingDocumentType = 'DG'
    or AccountingDocumentType = 'DR'
  )
