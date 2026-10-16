@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Shipping Expense Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_SHPEXPRPT
  provider contract transactional_query
  as projection on ZI_SHPEXPRPT
{
            @EndUserText.label: 'Commercial Invoice No'
            @Search.defaultSearchElement: true
  key       Commid,
            @UI.hidden: true
  key       SlNo,
            @EndUserText.label: 'Type'
  key       Type,
            @UI.hidden: true
  key       Item,
            @UI.hidden: true
  key       CC,
            @EndUserText.label: 'Commercial Invoice Date'
  key       Commdate,
            @EndUserText.label: 'Profit Center Code'
  key       Profitcenter,
            @EndUserText.label: 'Profit Center'
  key       ProfitCenterName,
            @EndUserText.label: 'Expense Type'
  key       Expansetype,
            @EndUserText.label: 'Per Container/Per Shipment'
  key       Percontship,
            @EndUserText.label: 'Vendor Code'
  key       Forwarder,
            @EndUserText.label: 'Vendor Name'
  key       SupplierName,
            @EndUserText.label: 'Supplier Invoice'
  key       SupplierInvoice,
            @EndUserText.label: 'Service Entry Sheet'
  key       ReferenceDocument,
            @EndUserText.label: 'Supplier Material No'
  key       SupplierMaterialNumber,
            @EndUserText.label: 'No of Container/Shipment'
            countcontship,
            @EndUserText.label: 'Value'
            Amount,
            @EndUserText.label: 'Currency'
            Currency,
            @EndUserText.label: 'Exchange Rate'
            Exchangerate,
            @EndUserText.label: 'Bill in INR'
            Amountinr,
            @EndUserText.label: 'Service PO'
            Servicepo,
            @EndUserText.label: 'Service PO Line'
            Servicepoline,
            @EndUserText.label: 'Service PO Value'
            POAmt,
            @EndUserText.label: 'Service PO Currency'
            POCurr,
            @EndUserText.label: 'Supplier Invoice Item Amount'
            InvAmt,
            @EndUserText.label: 'Supplier Invoice Currency'
            DocumentCurrency,
            @EndUserText.label: 'Material Group'
            MaterialGroup,
            @EndUserText.label: 'PO Item Text'
            PurchaseOrderItemText,
//            @EndUserText.label: 'Document Date'
//            DocumentDate,
            @EndUserText.label: 'Posting Date'
            PostingDate,
            @EndUserText.label: 'Created By'
            CreatedByUser,
            @EndUserText.label: 'Last Changed By'
            LastChangedByUser,
//            @EndUserText.label: 'Destination'
//            SupplierPostingLineItemText,
            @EndUserText.label: 'Cost Center Code'
            CostCenterCode,
            @EndUserText.label: 'Cost Center Name'
            CostCenter,
            @EndUserText.label: 'GL Code'
            GLCode,
            @EndUserText.label: 'GL Name'
            GLName
}
