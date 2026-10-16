@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forShippingBillLIC'
@ObjectModel.semanticKey: [ 'InternalShipbillItem' ]
@Search.searchable: true
define view entity ZC_ShippingBillLICTP

  as projection on ZR_ShippingBillILICTP

{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
  key InternalShipbill,
  key InternalShipbillItem,

      @EndUserText.quickInfo: 'License Number'
      @EndUserText.label: 'License Number'
      Licencint,
      
      @EndUserText.quickInfo: 'License Number(Ext)'
      @EndUserText.label: 'License Number(Ext)'
      Licencenumber,

      @EndUserText.quickInfo: 'Usage Amount'
      @EndUserText.label: 'Usage Amount'
      Usageamount,

      @EndUserText.quickInfo: 'Pending Amount'
      @EndUserText.label: 'Pending Amount'
      PendingAmount,

      @EndUserText.quickInfo: 'Currency'
      @EndUserText.label: 'Currency'
      FobFc,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,

      /* Associations */
      _ShippingBill : redirected to parent ZC_ShippingBillTP
}
