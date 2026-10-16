@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SERVICE ENTRY SHEET REPORT'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_SERVICEENTRYRPT
  provider contract transactional_query
  as projection on ZI_SERVICEENTRYRPT
{
      @EndUserText.label: 'ServiceEntrySheet'
  key ServiceEntrySheet,
      @EndUserText.label: 'Supplier'
      SupplierName,
      @EndUserText.label: 'Reference Purchase Order'
      PurchaseOrder,
      @UI.hidden: true
      Currency,
      @EndUserText.label: 'Stated Amount Including Input Tax'
      NetPriceAmount,
      @EndUserText.label: 'Stated Amount'
      NetAmount,
      @EndUserText.label: 'Name of Service Entry Sheet'
      ServiceEntrySheetName,
      @EndUserText.label: 'Document Status'
      ApprovalStatus,
      @EndUserText.label: 'Posting Date for Goods Receipt'
      PostingDate,
      @EndUserText.label: 'Purchasing Group'
      PurchasingGroup
}
