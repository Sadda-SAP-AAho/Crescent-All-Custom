@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Register Short Form Report'
@Search.searchable: true
define view entity ZC_SALESREGSHRT
  //with parameters
  //    SalesOrganization   : vkorg
  //    InvoiceNumber : vbeln,
  //    GSTInvDate    : erdat
  as select distinct from ZI_SALESREGSHRT
  //SalesOrganization:$parameters.SalesOrganization )
  //GSTInvDate: $parameters.GSTInvDate )
{
      @Search.defaultSearchElement: true
      @EndUserText.label: 'GST Invoice Number'
  key GstInvoice,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Billing document Item'
  key BillingDocumentItem,
      @UI.hidden: true
  key SalesOrderItem,
      @EndUserText.label: 'Commercial Invoice Number'
  key CommercialInvNum,
      @UI.hidden: true
  key LedgerName,
      @UI.hidden: true
  key BP,
      @UI.hidden: true
  key MatCode,
      @UI.hidden: true
  key MatName,
      @UI.hidden: true
  key ShpBill,
      @EndUserText.label: 'Sales Oranization'
      SalesOrg,
      @EndUserText.label: 'GST Invoice Date'
      GstInvDate,
      @EndUserText.label: 'Invoice Type'
      InvoiceType,
      @EndUserText.label: 'Commercial Invoice Date'
      CommInvDate,
      @EndUserText.label: 'BP Code'
      BPCode,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Shipment Location'
      ShipmentLocation,
      @EndUserText.label: 'Profit Center'
      ProfitCenter,
      @EndUserText.label: 'Sales Order Number'
      SalesOrderNumber,
      @EndUserText.label: 'Sales Order Item'
      SoItemNo,
      @EndUserText.label: 'Sales Order Date'
      SalesOrderDate,
      @EndUserText.label: 'Our Comm. Del. Date'
      CommittedDeliveryDate,
      @EndUserText.label: 'Sale Note Number'
      SaleNoteRef,
      @EndUserText.label: 'Outbound Delivery Number'
      OutboundDeliveryNo,
      @EndUserText.label: 'PGI Number'
      PGI_No,
      @EndUserText.label: 'PGI Posting Date'
      PGI_Date,
      //@EndUserText.label: 'Container Name'
      //ContaionerName,
      //@EndUserText.label: 'Sales Employee Name'
      //SalesEmpName,
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
      @UI.hidden: true
      TransactionCurrency,
      //@EndUserText.label: 'Discount %'
      //DISC,
      //@EndUserText.label: 'Export Freight'
      //ExportFreight,
      @EndUserText.label: 'Port of Loading'
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
      @EndUserText.label: 'LC number'
      LCNo,
      @EndUserText.label: 'LC Date'
      LCDate,
      @EndUserText.label: 'LC Issuing Bank Name'
      LCIssuBank,
      @EndUserText.label: 'S/BILL NO'
      ShipBill,
      @EndUserText.label: 'S/BILL DATE'
      ShipBillDate,
      //      @EndUserText.label: 'Export Insurance'
      //      EXInsurance,
      @EndUserText.label: 'Port of Discharge'
      PortOfDischarge,
      @EndUserText.label: 'Container Number'
      Container,
      @EndUserText.label: 'Material'
      Material,
      @EndUserText.label: 'Material Group'
      MaterialGrp,
      @UI.hidden: true
      WeightUnit,
      @EndUserText.label: 'Net Weight'
      NetWeight,
      @EndUserText.label: 'Customer PO'
      CustomerPo,
      @EndUserText.label: 'Customer PO Date'
      CustomerPoDate,
      @EndUserText.label: 'Country Of Destination'
      CountOfDest,
      @EndUserText.label: 'Tax Invoice Ref No'
      DocumentReferenceID,
      @EndUserText.label: 'Commercial Invoice Ref No'
      CommInvRef,
      @EndUserText.label: 'Sales Person'
      salesperson
}
