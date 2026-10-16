@EndUserText.label: 'Commercial Shipment'
@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZC_EXIMCOMMSHP

  as projection on ZI_EXIMCOMMSHP

{

      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label: 'Final Destination'
      Finaldest,
      @EndUserText.label: 'Incoterms'
      Incoterms,
      @EndUserText.label: 'Incoterms Location'
      Incotermsl,
      @EndUserText.label: 'Port of Loading'
      Portofloading,
      @EndUserText.label: 'Port of Discharge'
      Portofdischarge,
      @EndUserText.label: 'Vessel~Flight'
      Vesselflight,
      @EndUserText.label: 'Insurance'
      Insuranceno,
      @EndUserText.label: 'BL No.'
      Blno,
      @EndUserText.label: 'BL Date'
      Bldate,
      @EndUserText.label: 'Broker'
      Broker,
      @EndUserText.label: 'EGM'
      Egm,
      @EndUserText.label: 'EGM Date'
      Egmdate,
      @EndUserText.label: 'Commission'
      Commission,
      @EndUserText.label: 'Shipping Line'
      Shippingline,
      @EndUserText.label: 'Sailing Date'
      Sailingdate,
      @EndUserText.label: 'Dispatch From'
      Dispatchfrom,
      @EndUserText.label: 'Dispatch To'
      Dispatchto,
      @EndUserText.label: 'Country Origin'
      Countryorigin,
      @EndUserText.label: 'Country Destination'
      Countrydestination,
      @EndUserText.label: 'Terms of Delivery'
      Termsofdelivery,
      @EndUserText.label: 'Actual Date of Arrival'
      Actualdatearrival,
      @EndUserText.label: 'Expected Date of Arrival'
      Expecteddatearrival,
      @EndUserText.label: 'PI No.'
      Pino,
      @EndUserText.label: 'PI Date'
      Pidate,
      @EndUserText.label: 'Dispatch No.'
      Dispatchno,
      @EndUserText.label: 'Dispatch Date'
      Dispatchdate,

      _head : redirected to parent ZC_EXIMCOMMHDR

}
