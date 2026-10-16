@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SERVICE ENTRY SHEET REPORT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SERVICEENTRYRPT

  as select from    I_ServiceEntrySheetAPI01     as a
    inner join      I_ServiceEntrySheetItemAPI01 as b on a.ServiceEntrySheet = b.ServiceEntrySheet
    left outer join I_Supplier                   as c on c.Supplier = a.Supplier

{
  key a.ServiceEntrySheet,
      c.SupplierName,
      b.PurchaseOrder,
      b.Currency,
      @Semantics.amount.currencyCode: 'Currency'
      sum(b.NetPriceAmount) as NetPriceAmount,
      @Semantics.amount.currencyCode: 'Currency'
      sum(b.NetAmount)      as NetAmount,
      a.ServiceEntrySheetName,
      a.ApprovalStatus,
      a.PostingDate,
      b.PurchasingGroup

}

group by
  a.ServiceEntrySheet,
  c.SupplierName,
  b.PurchaseOrder,
  b.Currency,
  a.ServiceEntrySheetName,
  a.ApprovalStatus,
  a.PostingDate,
  b.PurchasingGroup
