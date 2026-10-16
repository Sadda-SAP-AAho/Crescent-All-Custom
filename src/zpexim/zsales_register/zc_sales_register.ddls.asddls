@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Sales Register'
@Search.searchable: true
define view entity ZC_SALES_REGISTER
  //with parameters
  //    SalesOrganization   : vkorg
  //    InvoiceNumber : vbeln,
  //    GSTInvDate    : erdat
  as select distinct from ZCDS_SALESREGISTER
  //SalesOrganization:$parameters.SalesOrganization )
  //GSTInvDate: $parameters.GSTInvDate )
{
         @Search.defaultSearchElement: true
         @EndUserText.label: 'GST Invoice Number'
  key    GstInvoice,
         @Search.defaultSearchElement: true
         @EndUserText.label: 'Billing document Item'
  key    BillingDocumentItem,
         @EndUserText.label: 'Sales Order Item'
  key    SalesOrderItem,
         @EndUserText.label: 'Commercial Invoice Number'
  key    CommercialInvNum,
         @EndUserText.label: 'Journal Entry No'
  key    LedgerName,
         @EndUserText.label: 'Invoice Type'
         InvoiceType,
         @Search.defaultSearchElement: true
         @EndUserText.label: 'Sales Order Number'
         SalesOrderNumber,
         @EndUserText.label: 'Shipment Location'
         ShipmentLocation,
         @EndUserText.label: 'Sales Order Date'
         SalesOrderDate,
         @EndUserText.label: 'Outbound Delivery Number'
         OutboundDeliveryNo,
         @EndUserText.label: 'GST Invoice Date'
         GstInvDate,
         @EndUserText.label: 'Commercial Invoice Date'
         CommInvDate,
         @EndUserText.label: 'BP Code'
         BPCode,
         @EndUserText.label: 'BP Name'
         BPName,
         @EndUserText.label: 'GSTIN Number'
         GSTInNo,
         @EndUserText.label: 'PAN Number'
         PANNo, //Added by SP on 16.06.25
         @EndUserText.label: 'State Name'
         StateName,
         @EndUserText.label: 'Sale Note Number'
         SaleNoteRef,
         //      @EndUserText.label: 'Container Name'
         //      ContaionerName,
         //      @EndUserText.label: 'Sales Employee Name'
         //      SalesEmpName,
         @EndUserText.label: 'Currency'
         Currency,
         @EndUserText.label: 'Exchange Rate'
         ExchangeRate,
         @EndUserText.label: 'Item Description'
         ItemDescription,
         @EndUserText.label: 'UOM'
         UOM,
         @EndUserText.label: 'Quantity'
         Qty,
         @EndUserText.label: 'Unit Weight'
         unitWeight,
         @EndUserText.label: 'Gross Weight'
         GrossWeight,
         @EndUserText.label: 'HSN Code'
         HSNCODE,
         @EndUserText.label: 'Transaction Currency'
         TransactionCurrency,
         @EndUserText.label: 'VALUE (TAX INV) IN DC'
         ValueInDC,
         @EndUserText.label: 'VALUE (COMMERCIAL INV) IN DC '
         ValueInDcComm,
         //      @EndUserText.label: 'Discount %'
         //      DISC,
         //      @EndUserText.label: 'Export Freight'
         //      ExportFreight,
         @EndUserText.label: 'IGST Amount'
         IGSTAmount,
         @EndUserText.label: 'CGST Amount'
         CGSTAmount,
         @EndUserText.label: 'SGST Amount'
         SGSTAmount,
         @EndUserText.label: 'TCS Amount'
         TCSAmount,
         PortOfLoading,
         @EndUserText.label: 'Final Destination'
         FinalDestination,
         @EndUserText.label: 'Container Size'
         ContainerSize,
         @EndUserText.label: 'Shipping Line'
         ShippingLine,
         @EndUserText.label: 'Shipping Type'
         ShippingType,
         @EndUserText.label: 'Vessel Name'
         VesselName,
         @EndUserText.label: 'B/L No'
         BLNo,
         @EndUserText.label: 'B/L Date'
         BLDate,
         @EndUserText.label: 'Document Sent Date'
         DocumentSentDate,
         @EndUserText.label: 'Document Present Date'
         DocumentPresentDate,
         @EndUserText.label: 'AWB Number'
         AWBNo,
         //      @EndUserText.label: 'ISF Sent Date'
         //      ISFSentDate,
         @EndUserText.label: 'E-BRC NO'
         EBRCNo,
         @EndUserText.label: 'E-BRC Date'
         EBRCDate,
         @EndUserText.label: 'Profit Center'
         ProfitCenter,
         @EndUserText.label: 'LC number'
         LCNo,
         @EndUserText.label: 'LC Date'
         LCDate,
         @EndUserText.label: 'LC Issuing Bank Name'
         LCIssuBank,
         @EndUserText.label: 'IRN NO / ACK NO (FOR E-INVOICE)'
         IRNNo,
         @EndUserText.label: 'E-WAY BILL NO'
         EWAYBILLNo,
         @EndUserText.label: 'S/BILL NO'
         ShipBill,
         @EndUserText.label: 'S/BILL DATE'
         ShipBillDate,
         //   @ObjectModel.mandatory: true
         @EndUserText.label: 'Sales Oranization'
         SalesOrg,
         @EndUserText.label: 'Discount In DC'
         DisInDC,
         //      @EndUserText.label: 'Export Insurance'
         //      EXInsurance,
         @EndUserText.label: 'FREIGHT & INSURANCE IN DC '
         FInsuranceINDc,
         @EndUserText.label: 'Port of Discharge'
         PortOfDischarge,
         @EndUserText.label: 'Container Number'
         Container,
         @EndUserText.label: 'VALUE (TAX INV) IN LC'
         ValueInLC,
         @EndUserText.label: 'VALUE (COMMERCIAL INV) IN LC'
         ValueInLCom,
         @EndUserText.label: 'Discount IN LC'
         DisInLC,
         @EndUserText.label: 'Material'
         Material,
         @EndUserText.label: 'Weight Unit'
         WeightUnit,
         //      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
         @EndUserText.label: 'Net Weight'
         NetWeight,
         @EndUserText.label: 'Customer PO'
         CustomerPo,
         @EndUserText.label: 'Customer PO Date'
         CustomerPoDate,
         @EndUserText.label: 'PO Line No'
         CustomerPOLineNo,
         @EndUserText.label: 'Billing Document Creation Date'
         BillingDocDate,
         @EndUserText.label: 'Country Of Destination'
         CountOfDest,
         @EndUserText.label: 'Freight & Insurance In LC'
         FInsuranceINLC,
         @EndUserText.label: 'GL Account'
         GLAccount,
         @EndUserText.label: 'GL Account Text'
         GLAccountName,
         @EndUserText.label: 'Tax Invoice Ref No'
         DocumentReferenceID,
         @EndUserText.label: 'Commercial Invoice Ref No'
         CommInvRef,
         @EndUserText.label: 'Sales Person'
         salesperson,
         @EndUserText.label: 'ETA Date'
         Etadt,
         @EndUserText.label: 'FOB Invoice'
         AccountingDocument
}
