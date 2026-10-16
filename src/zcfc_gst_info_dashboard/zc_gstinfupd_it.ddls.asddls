@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST Information Dashboard Uploader-Item'
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_GSTINFUPD_IT
  as projection on ZI_GSTINFUPD_IT
{
      @EndUserText.label: 'ID'
  key Id,

      @EndUserText.label: 'Fiscal Year'
  key Fisyear,
      
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Journal Entry No'
  key Jeno,

      @EndUserText.label: 'Upload Status'
      Updstatus,
      
      @EndUserText.label: 'criticality Status'
      @UI.hidden: true
      Crcriticalitystatus,
      
      @EndUserText.label: 'Message'
      Msg,
      
      @EndUserText.label: 'Status'
      @UI.hidden: true
      Status,

      @EndUserText.label: 'Posting Date'
      Jedate,

      @EndUserText.label: 'Document Type'
      Documenttype,

      @EndUserText.label: 'Journal Entry Type'
      Journalentrytype,

      @EndUserText.label: 'Document No'
      Documentno,

      @EndUserText.label: 'Vendor Code'
      Vendorcode,

      @EndUserText.label: 'Vendor Name'
      Vendorname,

      @EndUserText.label: 'Invoice/DR No'
      Invoicedrno,

      @EndUserText.label: 'Invoice/DR Date'
      Invoicedrdate,

      @EndUserText.label: 'GST No'
      Gstno,

      @EndUserText.label: 'State'
      State,

      @EndUserText.label: 'Sum of Taxable Value'
      Sumtaxablevalue,

      @EndUserText.label: 'Sum of CGST'
      Sumcgst,

      @EndUserText.label: 'Sum of SGST'
      Sumsgst,

      @EndUserText.label: 'Sum of IGST'
      Sumigst,

      @EndUserText.label: 'Sum of RCM CGST'
      Sumrcmcgst,

      @EndUserText.label: 'Sum of RCM SGST'
      Sumrcmsgst,

      @EndUserText.label: 'Sum of RCM IGST'
      Sumrcmigst,

      @EndUserText.label: 'Sum of Total Inv Value'
      Sumtotalinvvalue,

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

      /* Associations */
      _head : redirected to parent ZC_GSTINFUPD_HD
}
