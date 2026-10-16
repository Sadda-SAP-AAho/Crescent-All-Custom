@Metadata.allowExtensions: true
@EndUserText.label: 'CONSUMPTION VIEW FOR Input Registration'
@Metadata.ignorePropagatedAnnotations: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Analytics.dataCategory: #CUBE
define root view entity zc_exportregister
  provider contract transactional_query
  as projection on zi_exportregister
{
      @EndUserText.label: 'GST Invoice Number'
      @Search.defaultSearchElement: true
  key GSTInvoiceNumber,
      @EndUserText.label: 'Commercial Inv No'
  key    CommercialInvNo,
      @EndUserText.label: 'Location'
      Location,
      @EndUserText.label: 'OutBound Delivery'
      OutBoundDelivery,
       @EndUserText.label: 'GST Reference No'
      DocumentReferenceID,
      @EndUserText.label: 'GST Invoice Date'
      GSTInvoiceDate,
      @EndUserText.label: 'BP Code'
      BPCode,
      @EndUserText.label: 'BP Name'
      BPName,
      @EndUserText.label: 'Sales Person'
      salesperson,
      @EndUserText.label: 'Commercial Inv Date'
      CommercialInvDate,
      @EndUserText.label: 'Sale Note No'
      Salesnoteref,
      @EndUserText.label: 'Currency'
      Currency,
      @EndUserText.label: 'Exchange Rate'
      ExchangeRate,
      @EndUserText.label: 'Value(Commercial Inv) In DC'
      ValueInDC,
      @EndUserText.label: 'VALUE (COMMERCIAL INV) IN LC'
      ValueInLC,
      @EndUserText.label: 'Value(Tax Inv) In DC'
      ValueTaxInvInDC,
      @EndUserText.label: 'Value(Tax Inv) In LC'
      ValueTaxInvInLC,
      @EndUserText.label: 'Discount In DC'
      DiscountInDC,
      @EndUserText.label: 'Discount IN LC'
      DiscountinLC,
      @EndUserText.label: 'FREIGHT & INSURANCE IN DC'
      FreightInDC,
      @EndUserText.label: 'FREIGHT & INSURANCE IN LC'
      FreightInLC,
      @EndUserText.label: 'LC Curr'
      InvoiceValueLcC,
      @EndUserText.label: 'FOB Value in LC'
      @Semantics.amount.currencyCode: 'InvoiceValueLcC'
      Invoice,
      @EndUserText.label: 'INCOTERM'
      IncotermsClassification,
      @EndUserText.label: 'PAYMENT TERM'
      PaymentTerms,
      @EndUserText.label: 'Bank Name'
      BankName,
      @EndUserText.label: 'Port of Loading'
      PortOfLoading,
      @EndUserText.label: 'Port of Discharge'
      PortofDischarge,
      @EndUserText.label: 'Port of Transhipment'
      PortOfTrans,
      @EndUserText.label: 'Final Destination'
      Findes,
      @EndUserText.label: 'Country of Destination'
      CountryofDestination,
      @EndUserText.label: 'Forwarder'
      forwarder,
      @EndUserText.label: 'Shipping Line'
      Shipline,
      @EndUserText.label: 'Booking No.'
      Bookingno,
      @EndUserText.label: 'Container No'
      Contno,
      @EndUserText.label: 'Container Size'
      Consizen,
      @EndUserText.label: 'Carrier Seal no.'
      CarrierSealNo,
      @EndUserText.label: 'Net Weight (KG)'
      netwt,
      @EndUserText.label: 'Gross Weight (KG)'
      growt,
      @EndUserText.label: 'Vessel/Flight No'
      Vesselname,
      @EndUserText.label: 'Document Release to CHA Dt'
      Docrelchadt,
      @EndUserText.label: 'CHA Name'
      CHAName,
      @EndUserText.label: 'Container Pick Up Letter Date'
      ContPickUpLetterDt,
      @EndUserText.label: 'Container Pick Up Validity Dt'
      ContaonerPickUpValDt,
      @EndUserText.label: 'Container Cut Off Dt'
      Concutoffdt,
      @EndUserText.label: 'Container Lifting Date'
      Conliftdt,
      @EndUserText.label: 'Container Factory In Dt'
      Confacindt,
      @EndUserText.label: 'Container Despatch from Factory Dt'
      Vehicleoutdate,
      @EndUserText.label: 'Shipping Bill No.'
      ShippingBill,
      @EndUserText.label: 'Shipping Bill Date'
      ShippingBillDate,
      @EndUserText.label: 'Detail Recd from CHA for SI Date'
      Detrecchadt,
      @EndUserText.label: 'SI Sent Date'
      SISentDate,
      @EndUserText.label: 'Carting Order Applied On'
      Carordappdt,
      @EndUserText.label: 'Carting Order Recd On'
      CartingOrderRecdDate,
      @EndUserText.label: 'Late Carting Ord Recd Remarks'
      Latordrecrem,
      @EndUserText.label: 'Container Dock in Dt'
      Condockindt,
      @EndUserText.label: 'Late Container Dock In Remarks'
      Latcondocrem,
      @EndUserText.label: 'Shipping Bill Recd On'
      Shpbilldt,
      @EndUserText.label: 'Draft B/L Recd. On'
      Drftblrcvdt,
      @EndUserText.label: 'Draft B/L Correction Sent On'
      Correctblsendon,
      @EndUserText.label: 'B/L No'
      BLNo,
      @EndUserText.label: 'B/L Dt'
      BLDt,
      @EndUserText.label: 'B/L Recd On Dt'
      Blrcvdt,
      @EndUserText.label: 'ISF Sent Date'
      Isfsenddt,
      @EndUserText.label: 'Document Sending Dt'
      Docsentcustdt,
      @EndUserText.label: 'Doc Presented on Bank Dt'
      Docpresentbnkdt,
      @EndUserText.label: 'AWB No.'
      Awbno,
      @EndUserText.label: 'LC number'
      LC_Number,
      @EndUserText.label: 'LC Date'
      Lc_Open_Dt,
      @EndUserText.label: 'Goods Description'
      Descgoods,
      @EndUserText.label: 'Vessel Tentative Sailing Dt'
      Vessaildt,
      @EndUserText.label: 'Tentative ETA Dt'
      Etadt,
      @EndUserText.label: 'Actual ATA dt'
      Etddt,
      @EndUserText.label: 'Empty Return Date'
      Empretdt,
      @EndUserText.label: 'Container Freight Remarks'
      Freightremarks,
      @EndUserText.label: 'IsCancelled'
      CommercialInvoiceCancelled,
      @EndUserText.label: 'Draft B/L Confirmed On Date'
      Draftblcnfdt,
      @EndUserText.label: 'Commercial Inv. Due Date'
      netduedate,
     
      @EndUserText.label: 'Container Pickup from'
      ContainerPickUpFrom
}
