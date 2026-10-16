@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST 2B Final'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_GST_2B_FINAL
  provider contract transactional_query
  as projection on ZI_GST_2B_FINAL
{
      @EndUserText.label: 'Location'
  key Location,
      
      @EndUserText.label: 'GST-Month'
  key GSTMonth,
  
      @EndUserText.label: 'Line No.'
  key rowno,

      @EndUserText.label: 'Type'
      Type,

      @EndUserText.label: 'GSTIN of Supplier'
      suppgstn,

      @EndUserText.label: 'Trade/Legal Name of the Supplier'
      lglname,

      @EndUserText.label: 'Invoice Number'
      invno,

      @EndUserText.label: 'Invoice Type'
      invtyp,

      @EndUserText.label: 'Invoice Date'
      invdate,

      @EndUserText.label: 'Invoice Value'
      invval,

      @EndUserText.label: 'Place of Supply'
      placesupply,

      @EndUserText.label: 'Supply Attract Reverse Charge'
      revcharge,

      @EndUserText.label: 'Rate (%)'
      rateperc,

      @EndUserText.label: 'Taxable Value'
      taxval,

      @EndUserText.label: 'Integrated Tax'
      intgrtax,

      @EndUserText.label: 'Central Tax'
      centraltax,

      @EndUserText.label: 'State/UT Tax'
      stateuttax,

      @EndUserText.label: 'Cess'
      cess,

      @EndUserText.label: 'GSTR-1/IFF/GSTR-5 Period'
      gstrperiod,

      @EndUserText.label: 'GSTR-1/IFF/GSTR-5 Filing Date'
      gstrfildate,

      @EndUserText.label: 'ITC Availability'
      itcavail,

      @EndUserText.label: 'Reason'
      reason,

      @EndUserText.label: 'Applicable Tax Rate'
      apptaxrate,

      @EndUserText.label: 'JE No.'
      JENo,

      @EndUserText.label: 'JE Ref No.'
      JERefNo,

      @EndUserText.label: 'Vendor 2B Ref No.'
      Vendor2BRefNo,
      
      @EndUserText.label: 'Tax Value'
      TaxValue,
      
      @EndUserText.label: 'IGST Amt(INR)'
      IGSTAmt,
      
      @EndUserText.label: 'CGST Amt(INR)'
      CGSTAmt,
      
      @EndUserText.label: 'SGST Amt(INR)'
      SGSTAmt,
      
      @EndUserText.label: 'ISD Amt(INR)'
      ISDAmt,
      
      @EndUserText.label: 'Reverse Amt(INR)'
      ReverseAmt,
      
      @EndUserText.label: 'Difference'
      Difference,
      
      @EndUserText.label: 'Status'
      Status
}
