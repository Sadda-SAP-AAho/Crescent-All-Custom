@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'GSTR 2B Register-Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_GSTR2BREG_IT 
  as projection on ZI_GSTR2BREG_IT
{
    @EndUserText.label: 'ID'
    key Id,
    @EndUserText.label: 'Item'
    key Item,
    @EndUserText.label: 'GSTIN of supplier'
    Suppgstn,
    @EndUserText.label: 'Trade/Legal name'
    Lglname,
    @EndUserText.label: 'Invoice number'
    Invno,
    @EndUserText.label: 'Invoice type'
    Invtyp,
    @EndUserText.label: 'Invoice Date'
    Invdate,
    @EndUserText.label: 'Invoice Value(₹)'
    Invval,
    @EndUserText.label: 'Place of supply'
    Placesupply,
    @EndUserText.label: 'Supply Attract Reverse Charge'
    Revcharge,
    @EndUserText.label: 'Rate %'
    Rateperc,
    @EndUserText.label: 'Taxable Value (₹)'
    Taxval,
    @EndUserText.label: 'Integrated Tax(₹)'
    Intgrtax,
    @EndUserText.label: 'Central Tax(₹)'
    Centraltax,
    @EndUserText.label: 'State/UT Tax(₹)'
    Stateuttax,
    @EndUserText.label: 'Cess(₹)'
    Cess,
    @EndUserText.label: 'GSTR-1/IFF/GSTR-5 Period'
    Gstrperiod,
    @EndUserText.label: 'GSTR-1/IFF/GSTR-5 Filing Date'
    Gstrfildate,
    @EndUserText.label: 'ITC Availability'
    Itcavail,
    @EndUserText.label: 'Reason'
    Reason,
    @EndUserText.label: 'Applicable of Tax Rate'
    Apptaxrate,
    /* Associations */
    _Head : redirected to parent ZC_GSTR2BREG_HD
}
