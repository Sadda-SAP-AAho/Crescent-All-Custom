@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Document Report'
@Metadata.ignorePropagatedAnnotations: true
@AbapCatalog.viewEnhancementCategory: [#NONE]
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZC_MATDOCRPT
  provider contract transactional_query
  as projection on ZI_MATDOCRPT
{
      @EndUserText.label: 'Material Document'
  key MaterialDocument,
      @EndUserText.label: 'Material Document Year'
  key MaterialDocumentYear,
      @UI.hidden: true
  key MaterialDocumentItem,
      @EndUserText.label: 'Material'
  key Material,
      @EndUserText.label: 'Description'
      ProductName,
      @EndUserText.label: 'Plant Code'
      Plant,
      @EndUserText.label: 'Plant'
      PlantName,
      @EndUserText.label: 'Storage Location Code'
      StorageLocation,
      @EndUserText.label: 'Storage Location'
      StorageLocationName,
      @EndUserText.label: 'Stock Type Code'
      InventoryStockType,
      @EndUserText.label: 'Stock Type'
      InventoryStockTypeName,
      @EndUserText.label: 'Material Type Code'
      ProductType,
      @EndUserText.label: 'Material Type'
      ProductTypeName,
      @EndUserText.label: 'Material Group Code'
      ProductGroup,
      @EndUserText.label: 'Material Group'
      ProductGroupName,
      @EndUserText.label: 'Cost Center Code'
      CostCenter,
      @EndUserText.label: 'Cost Center'
      CostCenterName,
      @EndUserText.label: 'Profit Center Code'
      ProfitCenter,
      @EndUserText.label: 'Profit Center'
      ProfitCenterName,
      @EndUserText.label: 'G/L Account Code'
      GLAccount,
      @EndUserText.label: 'G/L Account'
      GLAccountName,
      @EndUserText.label: 'Goods Movement Type Code'
      GoodsMovementType,
      @EndUserText.label: 'Goods Movement Type'
      MoveTypText,
      @EndUserText.label: 'Created By Code'
      CreatedByUser,
      @EndUserText.label: 'Created By'
      PersonFullName,
      @EndUserText.label: 'Create Date'
      CreationDate,
      @EndUserText.label: 'Document Date'
      DocumentDate,
      @EndUserText.label: 'Posting Date'
      PostingDate,
      @EndUserText.label: 'Order'
      OrderID,
      @UI.hidden: true
      EntryUnit,
      @Semantics.quantity.unitOfMeasure : 'EntryUnit'
      @EndUserText.label: 'Quantity'
      QuantityInEntryUnit,
      @EndUserText.label: 'Value in Local Currency'
      TotalGoodsMvtAmtInCCCrcy,
      @EndUserText.label: 'Company Code Currency'
      CompanyCodeCurrency,
      @EndUserText.label: 'Document Type Code'
      AccountingDocumentType,
      @EndUserText.label: 'Document Type'
      AccountingDocumentTypeName,
      @EndUserText.label: 'Debit/Credit Indicator Code'
      DebitCreditCode,
      @EndUserText.label: 'Debit/Credit Indicator'
      DebitCreditCodeName
}
