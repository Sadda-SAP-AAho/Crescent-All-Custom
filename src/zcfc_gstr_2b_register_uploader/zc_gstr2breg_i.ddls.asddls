@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR 2B Register Item'
@Metadata.allowExtensions: true
@Search.searchable: true

define view entity ZC_GSTR2BREG_I
  as projection on ZI_GSTR2BREG_I
{
      @EndUserText.label: 'Id'
  key id,
      @EndUserText.label: 'Item'
  key item,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Row No'
  key rowno,
      @EndUserText.label: 'GSTIN of supplier'
      suppgstn,
      @EndUserText.label: 'Trade/Legal name'
      lglname,
      @EndUserText.label: 'Invoice number'
      invno,
      @EndUserText.label: 'Invoice type'
      invtyp,
      @EndUserText.label: 'Invoice Date'
      invdate,
      @EndUserText.label: 'Invoice Value(₹)'
      invval,
      @EndUserText.label: 'Place of supply'
      placesupply,
      @EndUserText.label: 'Supply Attract Reverse Charge'
      revcharge,
      @EndUserText.label: 'Rate %'
      rateperc,
      @EndUserText.label: 'Taxable Value (₹)'
      taxval,
      @EndUserText.label: 'Integrated Tax(₹)'
      intgrtax,
      @EndUserText.label: 'Central Tax(₹)'
      centraltax,
      @EndUserText.label: 'State/UT Tax(₹)'
      stateuttax,
      @EndUserText.label: 'Cess(₹)'
      cess,
      @EndUserText.label: 'GSTR-1/IFF/GSTR-5 Period'
      gstrperiod,
      @EndUserText.label: 'GSTR-1/IFF/GSTR-5 Filing Date'
      gstrfildate,
      @EndUserText.label: 'ITC Availability'
      itcavail,
      @EndUserText.label: 'Reason'
      reason,
      @EndUserText.label: 'Applicable of Tax Rate'
      apptaxrate,

      /* Associations */
      _Head : redirected to parent ZC_GSTR2BREG_H
}
