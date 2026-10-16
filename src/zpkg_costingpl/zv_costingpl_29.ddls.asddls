@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing PL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_29

  as select from I_BillingDocument        as a

    inner join   I_ServiceEntrySheetAPI01 as b on b.ServiceEntrySheetName = a.BillingDocument

{

  key a.BillingDocument,
  key b.ServiceEntrySheet,
      b.ServiceEntrySheetName,
      b.PurchaseOrder,
      b.MaterialDocument,
      b.MaterialDocumentYear,
      concat( b.MaterialDocument, b.MaterialDocumentYear ) as OriginalReference

}

where
  b.IsDeleted = ''
