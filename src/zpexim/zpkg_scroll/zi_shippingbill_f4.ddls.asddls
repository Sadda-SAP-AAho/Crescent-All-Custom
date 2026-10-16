@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shipping Bill F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SHIPPINGBILL_F4

  as select from ZR_ShippingBillTP

{
      @Search.fuzzinessThreshold: 0.90
      @EndUserText.label: 'Internal Shipping Bill'
      @UI.hidden: true
  key InternalShipbill,
      @EndUserText.label: 'Shipping Bill'
      ShippingBill,
      @EndUserText.label: 'Shipping Bill Date'
      ShippingBillDate,
      @EndUserText.label: 'RoDTEP Posted'
      Tpost,
      @EndUserText.label: 'DBK Posted'
      Tpostdbk,
      //      @EndUserText.label: 'Scroll Number'
      //      ScrollNo,
      //      @EndUserText.label: 'Scroll Date'
      //      ScrollDate,
      @EndUserText.label: 'Custom Handling Agent'
      CustomHandlingAgent,
      @EndUserText.label: 'Port Code'
      PortCode,
      @EndUserText.label: 'Posting Date'
      PostingDate,
      @EndUserText.label: 'Bill of Lading'
      BillOfLading,
      @EndUserText.label: 'Bill of Lading Date'
      BillOfLadingDate,
      @EndUserText.label: 'LEO Date'
      LeoDate,
      @EndUserText.label: 'Exchange Rate'
      Exchangerate,
      @EndUserText.label: 'Bill of Lading ~ Country'
      CountryBl,
      @EndUserText.label: 'State of Origin'
      StateOfOrigin,
      @EndUserText.label: 'Destination Country'
      DestinationCountry

}
