@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forShippingBillLIC'
@ObjectModel.semanticKey: [ 'InternalBoe' ]
@Search.searchable: true
define view entity ZC_BOEITEMTP

  as projection on ZR_BOEITEMTP

{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @EndUserText.label: 'Internal BOE'
  key InternalBoe,
      @EndUserText.label: 'Internal Item BOE'
  key InternalItemBoe,
      @EndUserText.label: 'PO'
      Po,
      @EndUserText.label: 'PO Item'
      Poitem,
      @EndUserText.label: 'Material'
      Material,
      @EndUserText.label: 'Text'
      Makxt,
      @EndUserText.label: 'Curr.'
      Currency,
      @EndUserText.label: 'Curr.'
      DutyCurrency,
      @EndUserText.label: 'PO Value'
      Povalue,
      @EndUserText.label: 'UoM'
      Unit,
      @EndUserText.label: 'PO Quantity'
      Poqty,
      @EndUserText.label: 'Arrived Quantity'
      Arrivedqty,
      @EndUserText.label: 'Assessable Value(INR)'
      Assessablevalue,
      @EndUserText.label: 'Assessable Value(FC)'
      Assessablevaluefc,
      @EndUserText.label: 'Total Duty Saved'
      Totaldutysaved,
      @EndUserText.label: 'Last Changed At'
      locallastchangedat,
      /* Associations */
      _BOE : redirected to parent ZC_BOETP
}
