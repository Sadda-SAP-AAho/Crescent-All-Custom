@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forShippingBill'
@ObjectModel.semanticKey: [ 'InternalBoe' ]
@Search.searchable: true
define root view entity ZC_BOETP
  provider contract transactional_query
  as projection on ZR_BOETP
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @EndUserText.label: 'Internal BOE'
  key InternalBoe,
      @EndUserText.label: 'BOE Number'
      Boenumber,
      @EndUserText.label: 'BOE Date'
      Boedate,
      @EndUserText.label: 'BL Number'
      Blnumber,
      @EndUserText.label: 'BL Date'
      Bldate,
      @EndUserText.label: 'Exchange Rate'
      Exchangerate,
      @EndUserText.label: 'Supplier'
      Supplier,
      @EndUserText.label: 'Supplier Name'
      suppliername,      
      @EndUserText.label: 'Shipment Mode'
      Shipmentmode,
      @EndUserText.label: 'Unloading Port'
      Loadingport,
      @EndUserText.label: 'Loading Port'
      Unloadingport,
      @EndUserText.label: 'IncoTerms'
      Incoterms,
      assessableamount,
      usageamount,
      Locallastchangedat,
      /* Associations */
      _BOEItem : redirected to composition child ZC_BOEITEMTP,
      _BOELIC  : redirected to composition child ZC_BOELICTP

}
