@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View PO-Item Basic'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_POITEM_BASIC
  provider contract transactional_query
  as projection on ZI_POITEM_BASIC
{
      @EndUserText.label: 'Purchase Order'
      @Search.defaultSearchElement: true
  key PurchaseOrder,
      @EndUserText.label: 'Item'
      @Search.defaultSearchElement: true
  key PurchaseOrderItem,
      @EndUserText.label: 'Material'
      @Search.defaultSearchElement: true
      Material,
      @EndUserText.label: 'Material Name'
      PurchaseOrderItemText,
      @EndUserText.label: 'Supplier Code'
      Supplier,
      @EndUserText.label: 'Supplier Name'
      SupplierName,
      @UI.hidden: true
      PurchaseOrderQuantityUnit,
      @EndUserText.label: 'Order Quantity'
      OrderQuantity,
      @EndUserText.label: 'Order Quantity Unit'
      ordunit,
      @UI.hidden: true
      DocumentCurrency,
      @EndUserText.label: 'Net Order Value'
      netordval,
      @EndUserText.label: 'Account Assignment Category'
      AccountAssignmentCategory,
      @EndUserText.label: 'Creation Date'
      CreationDate,
      @UI.hidden: true
      MaterialBaseUnit,
      @EndUserText.label: 'Delivered Quantity'
      delqty,
      @EndUserText.label: 'Tax Code'
      TaxCodeName,
      @UI.hidden: true
      CompanyCodeCurrency,
      @EndUserText.label: 'Delivered Value'
      delval,
      @EndUserText.label: 'Invoiced Quantity'
      InvQty,
      @EndUserText.label: 'Invoiced Value'
      InvVal,
      @EndUserText.label: 'Last PO Price'
      lastPOprice,
      @EndUserText.label: 'Material Group'
      MaterialGroup,
      @EndUserText.label: 'Material Group Description'
      ProductGroupText,
      @EndUserText.label: 'Net Order Price'
      NetPriceAmount,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Purchase Requisition'
      PurchaseRequisition,
      @EndUserText.label: 'Purchase Requisition Date'
      PurchaseReqnCreationDate,
      @EndUserText.label: 'Storage Location'
      StorageLocation
}
