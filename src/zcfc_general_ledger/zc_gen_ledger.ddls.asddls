@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for General Ledger'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_GEN_LEDGER
  provider contract transactional_query
  as projection on ZI_GEN_LEDGER
{
      @EndUserText.label: 'Fiscal Year'
  key FiscalYear,
      @UI.hidden: true
  key CompanyCode,
      @EndUserText.label: 'GL Account'
      @Search.defaultSearchElement: true
      @Consumption.filter.mandatory: true
  key GLAccount,
      @EndUserText.label: 'GL Name'
  key GLAccountName,
      @EndUserText.label: 'Journal Entry'
  key AccountingDocument,
      @UI.hidden: true
  key LedgerGLLineItem,
      @EndUserText.label: 'Commercial Inv. No.'
  key CommInvNo,
      @EndUserText.label: 'Product'
  key Product,
      @EndUserText.label: 'Product Description'
  key ProductName,
      @EndUserText.label: 'Product Description(as Per PO)'
      POItemName,
      @EndUserText.label: 'Supplier'
      Supplier,
      @EndUserText.label: 'Customer'
      Customer,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Cost Cneter'
      CostCenter,
      @EndUserText.label: 'Cost Cneter Name'
      CostCenterName,
      @EndUserText.label: 'Profit Center'
      ProfitCenter,
      @EndUserText.label: 'Profit Center Name'
      ProfitCenterName,
      @EndUserText.label: 'Segment'
      Segment,
      @EndUserText.label: 'Posting Date'
      PostingDate,
      @EndUserText.label: 'Journal Entry Type'
      AccountingDocumentType,
      @EndUserText.label: 'Posting Key'
      PostingKey,
      @EndUserText.label: 'Assignment Reference'
      AccountAssignment,
      @EndUserText.label: 'Account Assignment Type'
      AccountAssignmentType,
      //      @EndUserText.label: 'Original Ref. Doc. No.'
      //      SupplInvNo,
      @EndUserText.label: 'Amount'
      Amount,
      @EndUserText.label: 'Company Code Currency'
      CompanyCodeCurrency,
      @EndUserText.label: 'Tax Code'
      TaxCode,
      @EndUserText.label: 'Offsetting Account'
      OffsettingAccount,
      @EndUserText.label: 'Offsetting Account Name'
      OffsettingAccountName,
      @EndUserText.label: 'Outbound Delivery No'
      OutboundDelNo,
      @EndUserText.label: 'Outbound Delivery Qty'
      OutboundDelQty,
      @EndUserText.label: 'Qty. Unit'
      QtyUOM,
      @EndUserText.label: 'PO No.'
      PurchaseOrder,
      @EndUserText.label: 'PO Item Text'
      POItemText,
      @EndUserText.label: 'PR Short Text'
      PRShortText,
      //      @EndUserText.label: 'PR Item Text'
      //      PRItemText,
      @EndUserText.label: 'Journal Entry Item Text'
      DocumentItemText,
      @EndUserText.label: 'Number of Items'
      NumberOfItems,
      @EndUserText.label: 'WBS Element'
      WBSElement,
      @EndUserText.label: 'WBS Element Description'
      WBSDesc,
      @UI.hidden: true
      BaseUnit,
      @EndUserText.label: 'Quantity'
      Quantity

}
