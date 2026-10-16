@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR 2A RECO-REPORT'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_GSTR2ARECO_RPT
  provider contract transactional_query
  as projection on ZI_GSTR2ARECO_RPT
{

      @EndUserText.label: 'Status'
  key Status,
      @EndUserText.label: 'Fiscal Year'
  key FiscalYear,
      @EndUserText.label: 'Company Code'
  key CompanyCode,
      @EndUserText.label: 'GL Account'
      @Search.defaultSearchElement: true
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
      @EndUserText.label: 'JE Ref. No.'
      JERefNo,
      @UI.hidden: true
      DocumentCurrency,
      @EndUserText.label: 'AP Inv. Value'
      APValue,
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
      Quantity,
      @EndUserText.label: '2B Reference No'
      Twobrefno,
      @EndUserText.label: 'GST Remarks'
      Gstremarks,
      @EndUserText.label: 'New GST No'
      Newgstno,
      @EndUserText.label: 'GST Month'
      Gstmonth,
      @EndUserText.label: 'Extra 1'
      Extra1,
      @EndUserText.label: 'Extra 2'
      Extra2,
      @EndUserText.label: 'Supplier GST No.'
      SupplierGSTN,
      @EndUserText.label: 'Phone No'
      PhoneNo,
      @EndUserText.label: 'Email Id'
      Email,
      @EndUserText.label: 'Purchase Block'
      PurchaseBlock,
      @EndUserText.label: 'Payment Block'
      PaymentBlock

}
