@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forShippingBillLIC'
@ObjectModel.semanticKey: [ 'InternalBoe' ]
@Search.searchable: true
define view entity ZC_BOELICTP

  as projection on ZR_BOELICTP

{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @EndUserText.label: 'Internal BOE'
  key InternalBoe,
      @EndUserText.label: 'Internal Item BOE'
  key InternalItemBoe,

      @EndUserText.label: 'License Number External '
      Licencenumber,
      @EndUserText.label: 'License Internal Number'
      Licencint,      
      @EndUserText.label: 'Usage Amount'
      Usageamount,
      @EndUserText.label: 'Remaining Amount'
      Pendingamount,
      @EndUserText.label: 'Utilized Amount'
      assignamount,      
      @EndUserText.label: 'FOB FC'
      FobFc,
      Locallastchangedat,
      /* Associations */
      _BOE : redirected to parent ZC_BOETP
}
