@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Monitor Purchase Requisition Item-Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_MNTRPRITM
  provider contract transactional_query
  as projection on ZI_MNTRPRITM
{

      @EndUserText.label: 'Purchase Requisition Item'
      @Search.defaultSearchElement: true
  key PurchaseRequisitionItem,
      @EndUserText.label: 'Purchase Requisition'
      PurchaseRequisition,
      @EndUserText.label: 'Requisition Date'
      PurchaseReqnCreationDate,
      @EndUserText.label: 'User Name'
      CreatedByUser,
      @EndUserText.label: 'Requestor'
      RequisitionerName,
      @EndUserText.label: 'Material'
      Material,
      @EndUserText.label: 'Material Description'
      PurchaseRequisitionItemText,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Plant Name'
      PlantName,
      @EndUserText.label: 'Storage Location'
      StorageLocation,
      @EndUserText.label: 'Desired Supplier'
      Supplier,
      @EndUserText.label: 'Desired Supplier Name'
      SupplierName,
      @UI.hidden: true
      BaseUnit,
      @EndUserText.label: 'Quantity'
      RequestedQuantity,
      @UI.hidden: true
      PurReqnItemCurrency,
      @EndUserText.label: 'Valuation Price'
      PurchaseRequisitionPrice,
      @EndUserText.label: 'Total Value'
      ItemNetAmount,
      @EndUserText.label: 'Delivery Date'
      DeliveryDate,
      @EndUserText.label: 'Changed On'
      LastChangedDate,
      @EndUserText.label: 'Account Assignment Category'
      AccountAssignmentCategory,
      @EndUserText.label: 'Account Assignment Category Description'
      AcctAssignmentCategoryName,
      @EndUserText.label: 'Assigned'
      Assigned,
      @EndUserText.label: 'Material Group'
      MaterialGroup,
      @EndUserText.label: 'Material Group Description'
      ProductGroupName,
      @EndUserText.label: 'MRP Controller'
      MRPController,
      @EndUserText.label: 'MRP Controller Name'
      MRPControllerDesc,
      @EndUserText.label: 'Ordered Quantity'
      OrderedQuantity,
      @EndUserText.label: 'Open Quantity'
      OpenQty,
      @UI.hidden: true
      QtyUom,
      @EndUserText.label: 'Open Value'
      OpenValue
      
      
      
}
