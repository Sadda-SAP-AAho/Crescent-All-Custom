@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Service Entry Sheet Count'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_SERENTSHTCNT
  as select distinct from I_JournalEntryItem       as a
    left outer join       I_ServiceEntrySheetAPI01 as b on  b.PurchaseOrder = a.PurchasingDocument
                                                        and b.IsDeleted     is initial
{
  key a.GLAccount,
  key a.AccountingDocument,
  key a.LedgerGLLineItem,
      count( distinct b.ServiceEntrySheetName ) as SerEntCnt
}

group by
  a.GLAccount,
  a.AccountingDocument,
  a.LedgerGLLineItem
