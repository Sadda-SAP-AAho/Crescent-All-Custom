@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal No Against Mat Doc'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_ACCDOCNO
  as select distinct from ZI_JournalEntryItem_H    as a
    inner join            I_MaterialDocumentItem_2 as b on  a.ReferenceDocument = b.MaterialDocument
                                                        and a.RefDocItem4       = b.MaterialDocumentItem
{
  key b.PurchaseOrder,
  key b.PurchaseOrderItem,
      b.MaterialDocument,
      a.AccountingDocument
}

where
  b.PurchaseOrder is not initial
