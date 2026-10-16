@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Ledger'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_VENDORLEDGER07
  as select distinct from I_JournalEntryItem
{
  key AccountingDocument,
  key FiscalYear,
  key CompanyCode,
  key PurchasingDocument

}
where
  PurchasingDocument is not initial
