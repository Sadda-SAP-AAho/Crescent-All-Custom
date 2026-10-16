@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Delivery Monitoring Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_CUSTDELMNTRRPT
  provider contract transactional_query
  as projection on ZI_CUSTDELMNTRRPT
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
      @EndUserText.label: 'GST Invoice Date'
      GstInvDate,
      @EndUserText.label: 'Invoice Type'
      InvoiceType,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Commercial Invoice Date'
      CommInvDate,
      @EndUserText.label: 'BP Code'
      BPCode,
      @EndUserText.label: 'Sales Person'
      salesperson,
      @EndUserText.label: 'Material'
      Material,
      @EndUserText.label: 'Item Description'
      ItemDescription,
      @EndUserText.label: 'Shipment Location'
      ShipmentLocation,
      @EndUserText.label: 'Profit Center'
      ProfitCenter,
      @EndUserText.label: 'Sales Contract Number'
      SalesContract,
      @EndUserText.label: 'Sales Contract Date'
      SalesContractDate,
      @EndUserText.label: 'Sales Order Number'
      SalesOrderNumber,
      @EndUserText.label: 'Sales Order Item'
      SoItemNo,
      @EndUserText.label: 'Sales Order Date'
      SalesOrderDate,
      @EndUserText.label: 'Customer Reqd. Date'
      CustReqDate,
      @EndUserText.label: 'Our Comm. Del. Date'
      CommittedDeliveryDate,
      @EndUserText.label: 'Outbound Delivery Number'
      OutboundDeliveryNo,
      @EndUserText.label: 'PGI Number'
      PGI_No,
      @EndUserText.label: 'PGI Posting Date'
      PGI_Date,
      @EndUserText.label: 'UOM'
      UOM,
      @EndUserText.label: 'Quantity'
      Qty,
      @EndUserText.label: 'Unit Weight'
      unitWeight,
      @EndUserText.label: 'HSN Code'
      HSNCODE,
      @UI.hidden: true
      TransactionCurrency,
      @EndUserText.label: 'Port of Loading'
      PortOfLoading,
      @EndUserText.label: 'Final Destination'
      FinalDestination,
      @EndUserText.label: 'Container Size'
      ContainerSize,
      @EndUserText.label: 'Shipping Line'
      ShippingLine,
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
      @EndUserText.label: 'ETA Date'
      Etadt,
      @EndUserText.label: 'ATA Date'
      Atadt,
      @EndUserText.label: 'S/BILL NO'
      ShipBill,
      @EndUserText.label: 'S/BILL DATE'
      ShipBillDate,
      @EndUserText.label: 'Port of Discharge'
      PortOfDischarge,
      @EndUserText.label: 'Container Number'
      Container,
      @UI.hidden: true
      WeightUnit,
      @EndUserText.label: 'Net Weight'
      NetWeight,
      @EndUserText.label: 'Customer PO'
      CustomerPo,
      @EndUserText.label: 'Customer PO Date'
      CustomerPoDate,
      @EndUserText.label: 'Final SO Date'
      FinalSODt,
      @EndUserText.label: 'PO Entry Mail Recd Dt'
      POEntryMailRecdDt,
      @EndUserText.label: 'SO Transfer Mail Recd Dt'
      SOTrnsMailRcvDt,
      @EndUserText.label: 'Container Despatch from Factory Dt'
      Contdisfact,
      @EndUserText.label: 'Dock In Dt'
      Condockindt,
      @EndUserText.label: 'Delivery-Sales Order Date'
      DelSODate,
      @EndUserText.label: 'B/L-Delivery Date'
      BLDelDate,
      @EndUserText.label: 'ATA-B/L Date'
      ATABLDate,
      @EndUserText.label: 'ATA-Sales Order Date'
      ATASODate
      
}
