@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Consumtion View for Commercial'
define root view entity ZC_COMM_HED
  provider contract transactional_query
  as projection on ZI_COMM_HED
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Commercial No'
      @Search.defaultSearchElement: true
  key Commid,
      @EndUserText.label: 'Bank Ref No'
      Bankrefno,
      @EndUserText.label: 'Bill of Lading No'
      Ladingno,
      @EndUserText.label: 'Bill of Lading Date'
      Ladingdt,
      @EndUserText.label: 'Bill Closed Flag '
      Billcloseflag,
      @EndUserText.label: 'Fund Planning Remarks'
      Fundplanremark,
      @EndUserText.label: 'ISF Sent Date'
      Isfsenddt,
      @EndUserText.label: 'LC Bank Address 1'
      Lcbankadd1,
      @EndUserText.label: 'LC Bank Address 2'
      Lcbankadd2,
      @EndUserText.label: 'BOE Date'
      Boeddt,
      @EndUserText.label: 'Document Presented on Bank Date'
      Docpresentbnkdt,
      @EndUserText.label: 'Swift Date'
      Swiftdt,
      @EndUserText.label: 'Scroll No '
      Scrollno,
      @EndUserText.label: 'Vessel Tentative Sailing Date'
      Vesselsaildt,
      @EndUserText.label: 'Intimation Date'
      Initmationdt,
      @EndUserText.label: 'Payment Process'
      Paymentprocess,
      @EndUserText.label: 'Script No'
      Scripno,
      @EndUserText.label: 'Shipping Bill Recd On Date'
      Shbillrecddt,
      @EndUserText.label: 'Correction B/L Sent On Date'
      Correctblsendon,
      @EndUserText.label: 'Draft B/L Confirmed On Date'
      Draftblcnfdt,
      @EndUserText.label: 'B/L Recd On Date'
      Blrcvdt,
      @EndUserText.label: 'Document Sent to Customer Date'
      Docsentcustdt,
      @EndUserText.label: 'ATA Date'
      Atadate,
      @EndUserText.label: 'Draft B/L Received On Date'
      Drftblrcvdt,
      @EndUserText.label: 'Rotation No'
      Rotationno,
      @EndUserText.label: 'T/P No'
      Tpno,
      @EndUserText.label: 'T/P Dt '
      Tpdate,
      //      @EndUserText.label: 'Leo Date'
      //      Leodate,
      @EndUserText.label: 'E BRC NO'
      Ebrcno,
      @EndUserText.label: 'EBRC Recd. Date'
      Ebrcrcvdt,
      @EndUserText.label: 'EBRC Value-FC'
      Waers,
      //      @EndUserText.label: 'Currency'
      Ebrcvalfc,
      @EndUserText.label: 'AWB No.'
      Awbno,
      @EndUserText.label: 'Rcvd.by Consignee Bank Date'
      Rcvconsignbnkdt,
      @EndUserText.label: 'Planning Week'
      Planingweek,
      @EndUserText.label: 'Planning Month'
      Planingmonth,
      @EndUserText.label: 'Customer Reqd.Date for Bank'
      Custrqstdt,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Print'
      Tprint,
      @EndUserText.label: 'CommercialPrint'
      Cprint,
      @EndUserText.label: 'CommercialSplitPrint'
      Csprint,
      @EndUserText.label: 'Final Invoice-FOB'
      Fobprint,
      Flag,
      @EndUserText.label: 'Vessel No'
      Vesselcode,
      @EndUserText.label: 'Invoice Remarks'
      Vesselname,
      @EndUserText.label: 'Document Date'
      Documentdate,
      @EndUserText.label: 'Description Of Goods 1'
      Descgoods1,
      @EndUserText.label: 'Description Of Goods 2'
      Descgoods2,
      createdat,
      @EndUserText.label: 'Customer Code'
      Customercode,
      @EndUserText.label: 'Customer Name'
      Customername,
      Gstinvno,
      Invdate,
      Sono,
      Salesnoteno,
      Itemcode,
      Itemname,
      Indexno,
      Polineno,
      Pono,
      Podate,
      Uom,
      Quantity,
      Sumquantity,
      Stuffingdate,
      Containerno,
      Shippingline,
      Companyname,
      Comadd1,
      Comadd2,
      Creationdate,
      Creationtime,
      @EndUserText.label: 'Update Item'
      updateitem,
      @EndUserText.label: 'Payment Received Bank'
      Payrecvbank,
      @EndUserText.label: 'Payment Recv.Bank Address'
      Payrecvbankadrc,
      @EndUserText.label: 'Remarks 1'
      Remarks1,
      @EndUserText.label: 'Remarks 2'
      Remarks2,
      @EndUserText.label: 'IRM No'
      Irmno,

      /* Associations */
      _item : redirected to composition child ZC_COMPRINTFLD

}
